//
//  SPQRCMCtrl.h
//  Blue Scan
//
//  Created by Matt Schulte on 4/5/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@protocol SPQRCMCtrlDelegate <NSObject>

@required
- (void) didFindPeripheral:(CBPeripheral *)p;
- (void) didBTLEStatusUpdate;
- (void) didLocationUpdate:(CLLocation *)l;
- (void) didLocationStatusUpdate;

@end

@interface SPQRCMCtrl : NSObject <CBCentralManagerDelegate, CLLocationManagerDelegate>

@property BOOL cBReady;
@property BOOL cLLocAllowed;
@property (nonatomic,assign) id delegate;

@end
