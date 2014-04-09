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
    self.ctrl.delegate = self;
    
    // This should suck battery life :)
    self.cLLM = [[CLLocationManager alloc] init];
    [self.cLLM setDelegate:self.ctrl];
    [self.cLLM setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.cLLM setDistanceFilter:kCLDistanceFilterNone];
    [self.cLLM startUpdatingLocation];
    self.isLocating = YES;
    [self.locBtn setTitle:@"Stop Locate"];
    
    // Set up our dataview
    [self.scanData setDelegate:self];
    [self.scanData setDataSource:self];
}

- (void)sendPeripheral:(SPQRPeripheral *)peripheral {
    if ([peripheral isUploaded]) {
        return;
    }
    NSString *bodyData = [
                          NSString stringWithFormat:@"timestamp=%d&MAC=%@&rand_mac=%@&name=%@&latitude=%f&longitude=%f&device=%@&passcode=%@",
                          (int)round(peripheral.timestamp),
                          @"00:00:00:00:00:00",
                          @"1",
                          self.ownerPullDown.titleOfSelectedItem,
                          peripheral.location.coordinate.latitude,
                          peripheral.location.coordinate.longitude,
                          @"computer",
                          self.sitePick.selectedSegment ? @"eecs588isalright": @"test_site"
                        ];
    
    NSString* url;
    
    if (self.sitePick.selectedSegment) {
        url = @"https://track.schultetwins.com/api/v1.0/spot";
    } else {
        url = @"https://track-dev.schultetwins.com/api/v1.0/spot";
    }
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [postRequest setHTTPMethod:@"POST"];
    
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil) {
            [peripheral didUpload];
        } else if ([data length] == 0 && error == nil) {
            NSLog(@"ERRORL EMPTY REPLY");
        } else if (error != nil) {
            NSLog(@"Error On POST: %@", error);
        }
    }];
}

- (IBAction)scan:(id)sender {
    if (!self.isScanning) {
        NSLog(@"BLE Scanning");
        [self.ctrl scan];
        self.isScanning = YES;
        [self.scanBtn setTitle:@"Stop Scan"];
    } else {
        [self.ctrl.cBCM stopScan];
        self.isScanning = NO;
        [self.scanBtn setTitle:@"Scan"];
    }
}

- (IBAction)upload:(id)sender {
    for (SPQRPeripheral* periph in self.periphs) {
        if (periph.serialNumber) {
            [self sendPeripheral:periph];
        }
    }
    [self.scanData reloadData];
}

- (IBAction)locate:(id)sender {
    if (self.isLocating) {
        [self.cLLM stopUpdatingLocation];
        self.isLocating = NO;
        [self.locBtn setTitle:@"Locate"];
    } else {
        [self.cLLM startUpdatingLocation];
        self.isLocating = YES;
        [self.locBtn setTitle:@"Stop Locate"];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.periphs count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    SPQRPeripheral* periph = [self.periphs objectAtIndex:row];
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    if ([tableColumn.identifier  isEqual: @"NameCell"]) {
        // result is now guaranteed to be valid, either as a reused cell
        // or as a new cell, so set the stringValue of the cell to the
        // nameArray value at row
        NSString* name = [periph name];
        if (!name) {
            name = @"- None -";
        }
        [result.textField setStringValue:name];
    } else if ([tableColumn.identifier isEqual:@"RSSICell"]) {
        // result is now guaranteed to be valid, either as a reused cell
        // or as a new cell, so set the stringValue of the cell to the
        // nameArray value at row
        NSString* rssi =[NSString stringWithFormat:@"%@", [periph rssi]];
        [result.textField setStringValue: rssi];
    } else if ([tableColumn.identifier isEqual:@"UploadedCell"]) {
        NSString* uploaded = [periph isUploaded] ? @"YES" : @"NO";
        [result.textField setStringValue:uploaded];
    } else if ([tableColumn.identifier isEqual:@"SerialNumberCell"]) {
        NSString* serialNumber = [NSString stringWithFormat:@"%d", (int)periph.serialNumber];
        if (!periph.serialNumber) {
            serialNumber = @"N/A";
        }
        [result.textField setStringValue:serialNumber];
    }
    return result;
    
}


// CMCtrl delegate code
- (void) didFindPeripheral:(SPQRPeripheral *)p {
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