//
//  SPQRCMCtrl.m
//  Blue Scan
//
//  Created by Matt Schulte on 4/5/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import "SPQRCMCtrl.h"

@implementation SPQRCMCtrl

- (id) init {
    self = [super init];
    if (self) {
        self.cBCM = [[[CBCentralManager alloc] init] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void) scan {
    [self.cBCM scanForPeripheralsWithServices:nil options:nil];
}

- (void) cleanup {
    if (self.connectedPeriperhal.state != CBPeripheralStateDisconnected) {
        [self.cBCM cancelPeripheralConnection:self.connectedPeriperhal];
    }
    self.connectedPeriperhal = nil;
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    self.cBReady = NO;
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
            
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE Hardware is powered on and ready");
            self.cBReady = YES;
            break;
            
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware state is unsupported");
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
            
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state unknown");
            break;
            
        default:
            break;
    }
    [self.delegate didBTLEStatusUpdate];
}

-(void) connectToDevice {
    [self.cBCM connectPeripheral:self.connectedPeriperhal options:nil];
}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Peripheral Discovered");
    if (self.connectedPeriperhal) return;
    self.connectedPeriperhal = peripheral;
    [self.cBCM stopScan];
    
    self.spqrPeripheral = [[SPQRPeripheral alloc] init];
    self.spqrPeripheral.rssi = RSSI;
    self.spqrPeripheral.location = self.currLocation;
    self.spqrPeripheral.timestamp = [[NSDate date] timeIntervalSince1970];
    
    [self connectToDevice];
    [self.delegate didFindPeripheral:self.spqrPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    
    NSLog(@"Peripheral Connected");
    
    [peripheral discoverServices:nil];
}

/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.connectedPeriperhal = nil;
    
    // We're disconnected, so start scanning again
    [self scan];
}

/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    self.connectedPeriperhal = nil;
    [self scan];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Service UUID: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if (characteristic.properties == CBCharacteristicPropertyRead) {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // If we can get the serial number
    if (characteristic.UUID == [CBUUID UUIDWithString:@"2A25"]) {
        self.spqrPeripheral.name = peripheral.name;
        [characteristic.value getBytes: self.spqrPeripheral.serialNumber length: sizeof(self.spqrPeripheral.serialNumber)];
    }

    NSLog(@"Characteristic: %@ = %@", characteristic.UUID, stringFromData);
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currLocation = locations[0];
    [self.delegate didLocationUpdate:locations[0]];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusAuthorized) {
        self.cLLocAllowed = NO;
    } else {
        self.cLLocAllowed = YES;
    }
    [self.delegate didLocationStatusUpdate];
}

@end
