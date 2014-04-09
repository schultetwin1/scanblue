//
//  SPQRPeripheral.h
//  Blue Scan
//
//  Created by Matt Schulte on 4/8/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SPQRPeripheral : NSObject

@property NSString* name;
@property NSNumber* rssi;
@property CLLocation* location;
@property NSTimeInterval timestamp;
@property NSInteger* serialNumber;

- (id) init;
- (SPQRPeripheral*) didUpload;
- (BOOL) isUploaded;


@end
