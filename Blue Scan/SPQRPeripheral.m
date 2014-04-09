//
//  SPQRPeripheral.m
//  Blue Scan
//
//  Created by Matt Schulte on 4/8/14.
//  Copyright (c) 2014 SPQR. All rights reserved.
//

#import "SPQRPeripheral.h"

@implementation SPQRPeripheral {
    BOOL _isUploaded;
}

- (id)init {
    self = [super init];
    if (self) {
        _isUploaded = NO;
    }
    return self;
}

- (BOOL) isUploaded {
    return _isUploaded;
}

- (SPQRPeripheral*) didUpload {
    _isUploaded = YES;
    return self;
}

@end
