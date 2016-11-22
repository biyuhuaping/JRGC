//
//  DeviceInfo.h
//  

#import <Foundation/Foundation.h>

#define WIFI @"WiFi"
#define WWAN @"WWAN"

@interface DeviceInfo : NSObject

+ (long long)freeDiskSpaceInBytes;

+ (NSString *)getNetConnectionState;

@end
