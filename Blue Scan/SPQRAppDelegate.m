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
    NSLog(@"Initializing BLE");
    self.periphs = [[NSMutableArray alloc] init];
    self.ctrl = [[SPQRCMCtrl alloc] init];
    if (self.ctrl) {
        self.cBCM = [[[CBCentralManager alloc] init] initWithDelegate:self.ctrl queue:nil];
        self.ctrl.delegate = self;
    }
    [self.scanData setDelegate:self];
    [self.scanData setDataSource:self];
    [self.scanData reloadData];
    
}

- (IBAction)scan:(id)sender {
    if (self.ctrl.cBReady) {
        NSLog(@"BLE Scanning");
        [self.cBCM scanForPeripheralsWithServices:nil options:nil];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%lu", (unsigned long)[self.periphs count]);
    return [self.periphs count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get an existing cell with the MyView identifier if it exists
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"NameCell" owner:self];
    
    // result is now guaranteed to be valid, either as a reused cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    [result.textField setStringValue:[self.periphs objectAtIndex:row]];
    
    // Return the result
    return result;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSLog(@"objectValue");
    return [self.periphs objectAtIndex:row];
}


- (void) foundPeripheral:(CBPeripheral *)p {
    [self.periphs addObject:p];
    [self.scanData reloadData];
}
@end