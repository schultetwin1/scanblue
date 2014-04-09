//
//  SPQRAppDelegate.h
//  Blue Scan
//
//  Created by Matt Schulte on 4/5/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#import "SPQRCMCtrl.h"

@interface SPQRAppDelegate : NSObject <NSApplicationDelegate, SPQRCMCtrlDelegate, NSTableViewDataSource, NSTableViewDelegate, NSURLConnectionDelegate>

@property BOOL isScanning;
@property BOOL isLocating;

@property (strong) SPQRCMCtrl* ctrl;
@property (nonatomic,strong) CLLocationManager *cLLM;

@property (strong) NSMutableArray* periphs;

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTableView *scanData;
@property (weak) IBOutlet NSTextField *btleStatusLabel;
@property (weak) IBOutlet NSButton *scanBtn;
@property (weak) IBOutlet NSTextField *longText;
@property (weak) IBOutlet NSTextField *latText;
@property (weak) IBOutlet NSButton *locBtn;
@property (weak) IBOutlet NSPopUpButton *ownerPullDown;
@property (weak) IBOutlet NSSegmentedControl *sitePick;

- (IBAction)scan:(id)sender;

@end
