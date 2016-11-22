//
//  FMDeviceManager.h
//  FMDeviceManager
//
//  Copyright (c) 2015年 Fraudmetrix.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if_dl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <resolv.h>
#import <sys/stat.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <sys/types.h>

@protocol FMDeviceManagerDelegate <NSObject>

- (void) didReceiveDeviceBlackBox: (NSString *) blackBox;

@end

typedef struct _void {
    void (*initWithOptions)(NSDictionary *);
    void (*setEnvironment)(NSString *);
    NSString *(*getDeviceInfoSync)(NSDictionary *);
    BOOL (*getDeviceInfoAsync)(NSDictionary *, id<FMDeviceManagerDelegate>);
} FMDeviceManager_t;

@interface FMDeviceManager : NSObject

+ (FMDeviceManager_t *) sharedManager;
+ (void) destroy;

@end

