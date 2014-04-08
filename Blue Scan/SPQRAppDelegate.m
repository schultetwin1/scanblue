//
//  SPQRAppDelegate.m
//  Blue Scan
//
//  Created by Matt Schulte on 4/5/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import "SPQRAppDelegate.h"
#import "SPQRCMCtrl.h"

@implementation SPQRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.periphs = [[NSMutableArray alloc] init];
    
    self.isScanning = NO;
    self.isLocating = NO;
    
    self.ctrl = [[SPQRCMCtrl alloc] init];
    if (self.ctrl) {
        self.cBCM = [[[CBCentralManager alloc] init] initWithDelegate:self.ctrl queue:nil];
        self.ctrl.delegate = self;
    }
    
    // This should suck battery life :)
    self.cLLM = [[CLLocationManager alloc] init];
    [self.cLLM setDelegate:self.ctrl];
    [self.cLLM setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.cLLM setDistanceFilter:kCLDistanceFilterNone];
    [self.cLLM startUpdatingLocation];
    self.isLocating = YES;
    [self.locBtn setStringValue:@"Stop Locate"];
    
    // Set up our dataview
    [self.scanData setDelegate:self];
    [self.scanData setDataSource:self];
    
}

- (IBAction)scan:(id)sender {
    if (!self.isScanning) {
        if (self.ctrl.cBReady) {
            NSLog(@"BLE Scanning");
            [self.cBCM scanForPeripheralsWithServices:nil options:nil];
            self.isScanning = YES;
            [self.scanBtn setStringValue:@"Stop Scan"];
        }
    } else {
        [self.cBCM stopScan];
        self.isScanning = NO;
        [self.scanBtn setStringValue:@"Scan"];
    }
}
- (IBAction)locate:(id)sender {
    if (self.isLocating) {
        [self.cLLM stopUpdatingLocation];
        self.isLocating = NO;
        [self.locBtn setStringValue:@"Locate"];
    } else {
        [self.cLLM startUpdatingLocation];
        self.isLocating = YES;
        [self.locBtn setStringValue:@"Stop Locate"];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.periphs count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if ([tableColumn.identifier  isEqual: @"NameCell"]) {
    
        // Get an existing cell with the MyView identifier if it exists
        NSTableCellView *result = [tableView makeViewWithIdentifier:@"NameCell" owner:self];
    
        // result is now guaranteed to be valid, either as a reused cell
        // or as a new cell, so set the stringValue of the cell to the
        // nameArray value at row
        [result.textField setStringValue:[self.periphs objectAtIndex:row]];
    
        // Return the result
        return result;
    } else if ([tableColumn.identifier isEqual:@"RSSICell"]) {
        // Get an existing cell with the MyView identifier if it exists
        NSTableCellView *result = [tableView makeViewWithIdentifier:@"RSSICell" owner:self];
        
        // result is now guaranteed to be valid, either as a reused cell
        // or as a new cell, so set the stringValue of the cell to the
        // nameArray value at row
        [result.textField setStringValue:[self.periphs objectAtIndex:row]];
        
        // Return the result
        return result;
    } else {
        return nil;
    }
}

- (void) didFindPeripheral:(CBPeripheral *)p {
    [self.periphs addObject:p];
    [self.scanData reloadData];
}

- (void) didBTLEStatusUpdate {
    if (self.ctrl.cBReady) {
        [self.scanBtn setEnabled:YES];
        [self.btleStatusLabel setStringValue:@"BTLE Enabled"];
    } else {
        [self.scanBtn setEnabled:NO];
        [self.btleStatusLabel setStringValue:@"BTLE Disabled"];
        self.isScanning = NO;
    }
}

- (void) didLocationUpdate:(CLLocation *)l {
    [self.latText setStringValue:[NSString stringWithFormat:@"%f", l.coordinate.latitude]];
    [self.longText setStringValue:[NSString stringWithFormat:@"%f", l.coordinate.longitude]];
}

- (void) didLocationStatusUpdate {
    if (self.ctrl.cLLocAllowed) {
        [self.locBtn setEnabled:YES];
    } else {
        [self.locBtn setEnabled:NO];
        self.isLocating = NO;
    }
}

@end