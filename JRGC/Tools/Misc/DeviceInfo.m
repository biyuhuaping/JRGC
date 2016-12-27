//
//  DeviceInfo.m
//  

#import "DeviceInfo.h"
#include <sys/param.h>
#include <sys/mount.h>

#import "Reachability.h"


@implementation DeviceInfo

+ (long long)freeDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = -1;
    if (statfs("/var", &buf) >= 0) {
        freespace = (long long)(buf.f_bsize * buf.f_bfree) - (200 * 1024*1024);//减去200M安全区域
    }
    return freespace;
}

+ (NSString *)getNetConnectionState
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus state = [reach currentReachabilityStatus];
    NSString *str = @"";
    if (state == ReachableViaWiFi) {
        str = WIFI;
    } else if (state == ReachableViaWWAN) {
        str = WWAN;
    } else {
        str = @"无网络";
    }
    return str;
}

@end
