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

#import "SPQRPeripheral.h"

@protocol SPQRCMCtrlDelegate <NSObject>

@required
- (void) didFindPeripheral:(SPQRPeripheral *)p;
- (void) didBTLEStatusUpdate;
- (void) didLocationUpdate:(CLLocation *)l;
- (void) didLocationStatusUpdate;

@end

@interface SPQRCMCtrl : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate>

@property BOOL cBReady;
@property BOOL cLLocAllowed;
@property CLLocation* currLocation;
@property (nonatomic,assign) id delegate;

@property (nonatomic,strong) CBCentralManager *cBCM;
@property (strong) CBPeripheral* connectedPeriperhal;
@property (strong) SPQRPeripheral* spqrPeripheral;

- (id) init;
- (void) scan;

@end
