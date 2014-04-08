//
//  SPQRAppDelegate.h
//  Blue Scan
//
//  Created by Matt Schulte on 4/5/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

#import "SPQRCMCtrl.h"

@interface SPQRAppDelegate : NSObject <NSApplicationDelegate, SPQRCMCtrlDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (strong) SPQRCMCtrl* ctrl;
@property (nonatomic,strong) CBCentralManager *cBCM;
@property (assign) IBOutlet NSWindow *window;
@property (strong) NSMutableArray* periphs;
@property (strong) IBOutlet NSTableView *scanData;

- (IBAction)scan:(id)sender;

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;


@end
