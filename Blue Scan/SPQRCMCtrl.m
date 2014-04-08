//
//  SPQRCMCtrl.m
//  Blue Scan
//
//  Created by Matt Schulte on 4/5/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import "SPQRCMCtrl.h"

@implementation SPQRCMCtrl

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
}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Discoved peripheral. peripheral: %@, rssi: %@, Advertisment Data %@", peripheral, RSSI, advertisementData);
    [self.delegate foundPeripheral:peripheral];
}

@end
