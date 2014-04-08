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
    self.scanData = [[NSTableView alloc] init];
    [self.scanData setDelegate:self];
    [self.scanData setDataSource:self];
    
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
    
    NSLog(@"HERE");
    // Get an existing cell with the MyView identifier if it exists
    NSTextField *result = [tableView makeViewWithIdentifier:@"NameCell" owner:self];
    
    // There is no existing cell to reuse so create a new one
    if (result == nil) {
        
        // Create the new NSTextField with a frame of the {0,0} with the width of the table.
        // Note that the height of the frame is not really relevant, because the row height will modify the height.
        result = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        
        // The identifier of the NSTextField instance is set to MyView.
        // This allows the cell to be reused.
        result.identifier = @"NameCell";
    }
    
    // result is now guaranteed to be valid, either as a reused cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    result.stringValue = [self.periphs objectAtIndex:row];
    
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