//
//  SPQRCMCtrl.h
//  Blue Scan
//
//  Created by Matt Schulte on 4/5/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

@protocol SPQRCMCtrlDelegate <NSObject>

@required
- (void) foundPeripheral:(CBPeripheral *)p;

@end

@interface SPQRCMCtrl : NSObject <CBCentralManagerDelegate>

@property BOOL cBReady;
@property (nonatomic,assign) id delegate;

@end
