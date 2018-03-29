//
//  UcfNetworkInspector.h
//  UcfPaySDK
//
//  Created by vinn on 6/3/14.
//  Copyright (c) 2014 UCF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UcfReachability.h"

#define kMPNetworkStatusChangedNotification   @"kNetworkStatusChanged"

@interface UcfNetworkInspector : NSObject

//@property(nonatomic, assign) NetworkStatus status;

+ (BOOL)isNetworkAvaliable;

@end
