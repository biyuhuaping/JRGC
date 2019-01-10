//
//  Common.m
//  JRGC
//
//  Created by 张瑞超 on 14-11-13.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "Common.h"
#import <AdSupport/AdSupport.h>
#import "sys/utsname.h"
#import "ASIHTTPRequest.h"
#import "UCFToolsMehod.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import <CommonCrypto/CommonDigest.h>
#import "SFHFKeychainUtils.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/cdefs.h>
#include <CommonCrypto/CommonCryptoError.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#import "SDImageCache.h"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#import "AppDelegate.h"
#import "SDWebImageManager.h"
@implementation Common

+ (CGFloat)calculateNewSizeBaseMachine:(CGFloat)inputFloat
{
    CGFloat newSize = inputFloat;
    if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        newSize = inputFloat * 1.171875;
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        newSize = inputFloat * 1.29375;
    }
    return newSize;
}

+ (BOOL)writeToTmpFileWithFileName:(NSString *)fileName
{
    return YES;
}

+ (void)deleteCookies {
    //cookie清除
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    //缓存  清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    [self addTestCookies];
}
+ (void)addWebViewCookie:(NSString *)value WithYUArr:(NSArray *)arr
{
    for (int i = 0; i < arr.count; i++) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:@"jg_nyscclnjsygjr" forKey:NSHTTPCookieName];
        [cookieProperties setObject:value forKey:NSHTTPCookieValue];//dic[@"jg_ckie"]
        [cookieProperties setObject:arr[i] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:@"true" forKey:@"HttpOnly"];
        //zrc fixed
        [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:60*60*24*365]forKey:NSHTTPCookieExpires];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    }
}
+ (void)setHTMLCookies:(NSString *)value
{
    if(value == nil || [value isEqualToString:@""])
    {
        return;
    }
    
    NSArray *arr = [NSArray arrayWithObjects:@".9888.cn",@"m.dougemall.com",@".9888keji.com",@".gongchangp2p.cn",@".gongchangzx.com",@".gongchangp2p.com",@"coin.9888keji.com", nil];
    [self addWebViewCookie:value WithYUArr:arr];
}
+ (void)addTestCookies
{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//     && [[[NSUserDefaults standardUserDefaults] valueForKey:UUID] isEqualToString:@"108027"]
    if (EnvironmentConfiguration == 2 || (app.isSubmitAppStoreTestTime ))
    {
        NSDictionary * cookieInfo =  [NSDictionary dictionaryWithObject:@"1" forKey:@"jrgc_umark"];
        
        NSHTTPCookie * userCookie = [NSHTTPCookie cookieWithProperties:cookieInfo];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:userCookie];
        
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:@"jrgc_umark" forKey:NSHTTPCookieName];
        [cookieProperties setObject:@"1" forKey:NSHTTPCookieValue];
        [cookieProperties setObject:@".9888.cn" forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        //[cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:60*60*24*7]forKey:NSHTTPCookieExpires];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    }
}
+ (NSString*)machineName
{
    NSString *deviceType = nil;
    if (ScreenWidth == 320.0f && ScreenHeight == 480.0f) {
        deviceType = @"4";
    } else if (ScreenWidth == 320.0f && ScreenHeight == 568.0f) {
        deviceType = @"5";
    } else if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        deviceType = @"6";
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        deviceType = @"6Plus";
    } else if (ScreenHeight == 812) {
        deviceType = @"8";
    }
    return deviceType;
}

+ (NSString *) macAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return nil;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return nil;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return nil;
        
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}
+ (NSString *)getKeychain
{
    NSString *uniqueStr = [SFHFKeychainUtils getPasswordForUsername:@"JRGC" andServiceName:SERVER_IP error:nil];
    if (uniqueStr) {
        return uniqueStr;
    }else{
        [self saveUUIDToKeyChain];
        return [self getUUID];
    }
}
+ (BOOL)saveUUIDToKeyChain
{
    return [SFHFKeychainUtils storeUsername:@"JRGC" andPassword:[self getUUID] forServiceName:SERVER_IP updateExisting:YES error:nil];
}
+ (NSString *)getUUID
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

+ (NSString *)getIOSVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
+ (NSString *)getDeviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machine;
}
+ (NSString *) platformString{
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
//判断设备时候拥有touchID，如有新设备手动添加
+ (BOOL)deveiceIsHaveTouchId
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return NO;  //@"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return NO;  //@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return NO;  //@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return NO;  //@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return NO;  //@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return NO;  //@"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return NO;  //@"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return NO;  //@"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return NO;  //@"iPhone 5 (GSM+CDMA)"
    if ([platform isEqualToString:@"iPhone5,3"])    return NO;  //@"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"])    return NO;  //@"iPhone 5c (A1507/A1516/A1526/A1529)";
    
    if ([platform rangeOfString:@"iPhone"].location != NSNotFound) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8) {
            return YES;
        }
        return NO;
    }
    return NO;
}
+(NSString *)deleteStrSpace:(NSString *)str
{
    return  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(NSString *)deleteAllStrSpace:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
}

//字典数组转json字符串
+ (NSString *)toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:0
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    }else{
        return @"";
    }

}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (void)checkAppUpdateVersionWithAppId:(NSString *)appid
{
    __block NSString * itunUrl = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSString *URL = APP_UPDATE_URL;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"POST"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];
            NSArray *infoArray = dic[@"results"];
            if ([infoArray count]) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                itunUrl  =[NSString stringWithFormat:@"%@", [releaseInfo objectForKey:@"trackViewUrl"]];
                if (![lastVersion isEqualToString:currentVersion]) {
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag =102;
                    [alert show];
                    [alert release];
                }
            }
        });
    });

}
//去除首尾空格
+ (NSString *)deleteStrHeadAndTailSpace:(NSString *)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}
//获取字符串的高度
+ (CGSize)getStrHeightWithStr:(NSString *)str AndStrFont:(CGFloat)font AndWidth:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGSize nameSize = [str boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return nameSize;
}
//获取字符串 添加段落 字号的高度
+ (CGSize)getStrHeightWithStr:(NSString *)str AndStrFont:(CGFloat)font AndWidth:(CGFloat)width AndlineSpacing:(CGFloat)lineSpacing
{
    NSDictionary *attrsDic = [Common getParagraphStyleDictWithStrFont:font WithlineSpacing:lineSpacing];
    CGSize nameSize = [str boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading  attributes:attrsDic context:nil].size;
    return nameSize;
}
//获取 添加段落 字号的 字典
+(NSDictionary *)getParagraphStyleDictWithStrFont:(CGFloat)font WithlineSpacing:(CGFloat )lineSpacing{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineSpacing = lineSpacing;
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:font],/*(字体)*/
                          NSParagraphStyleAttributeName:paragraph,/*(段落)*/
                          };
    return dic;
}

+ (CGSize)getStrWitdth:(NSString *)str TextFont:(UIFont *)font {
    return [str sizeWithAttributes:@{NSFontAttributeName :font}];
}
+ (CGSize)getStrWitdth:(NSString *)str Font:(CGFloat )font {
        return [str sizeWithAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:font]}];
}
+ (NSString *)checkNullStr:(NSString *)nullStr
{
    if ([nullStr isKindOfClass:[NSNull class]]|| nullStr==nil) {
        return @"";
    }else{
        return nullStr;
    }
}
+ (BOOL)writeToTmpFileWithFileName:(NSString *)fileName WithData:(NSMutableArray *)array;
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString  *filePath  = [NSString stringWithFormat:@"%@,%@",NSTemporaryDirectory(),fileName];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    } else {

    }
    return YES;
}

+ (NSString *)getBBS
{
    return @"56f1507762eab56f1507762eb0403931";
}


+ (NSString *)customMd5:(NSString *)uniqueIEM
{
    NSString * totalStr = @"JINRONGGONGCHANGAPPMD520141224INJINYUDASHAJINHONGDONGPRODUCT";
    NSString * pwd = [uniqueIEM uppercaseString];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"0" withString:@"~"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"1" withString:@"$"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"2" withString:@"!"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"3" withString:@"@"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"4" withString:@":"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"5" withString:@"]"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"6" withString:@"["];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"7" withString:@"{"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"8" withString:@"}"];
    pwd =  [pwd stringByReplacingOccurrencesOfString:@"9" withString:@"`"];
    totalStr = [totalStr substringToIndex:totalStr.length - pwd.length];
    totalStr = [totalStr stringByAppendingString:pwd];
    totalStr = [self md5:totalStr];
//    totalStr = [totalStr substringToIndex:16];
    return totalStr;
}
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+ (NSString *)aesJiami:(NSString *)count WithKey:(NSString *)key
{
    NSData *cipherData = [[count dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
    NSString *base64Text = [cipherData base64EncodedString];
    return base64Text;
    
}

+ (NSString *)AESWithKey:(NSString *)key WithData:(NSString *)data
{
    NSString *pwdKey = [self customMd5:key];
    NSString *jsonStr = [self getJSonStr:data];
    NSData *cipherData = [[jsonStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pwdKey];
    NSString *base64Text = [cipherData base64EncodedString];
    NSString *finishStr = [NSString stringWithFormat:@"%@",base64Text];
    finishStr =  [finishStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return finishStr;
}


+ (NSString *)AESWithKeyWithNoTranscode:(NSString *)key WithData:(NSString *)data
{
    NSString *pwdKey = [self customMd5:key];
    NSString *jsonStr = [self getJSonStr:data];
    NSData *cipherData = [[jsonStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pwdKey];
    NSString *base64Text = [cipherData base64EncodedString];
    NSString *finishStr = [NSString stringWithFormat:@"%@",base64Text];
    return finishStr;
}

+ (NSString *)AESWithKeyWithNoTranscode2:(NSString *)key WithData:(NSDictionary *)dic
{
    NSString *pwdKey = [self customMd5:key];
    NSString *jsonStr = [self dictionaryToJson:dic];
    NSData *cipherData = [[jsonStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pwdKey];
    NSString *base64Text = [cipherData base64EncodedString];
    NSString *finishStr = [NSString stringWithFormat:@"%@",base64Text];
    return finishStr;
}
+ (NSString *)AESWithKey2:(NSString *)key WithDic:(NSDictionary *)dic
{
    NSString *pwdKey = [self customMd5:key];
    NSString *jsonStr = [self dictionaryToJson:dic];
    NSData *cipherData = [[jsonStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pwdKey];
    NSString *base64Text = [cipherData base64EncodedString];
    NSString *finishStr = [NSString stringWithFormat:@"%@",base64Text];
    finishStr =  [finishStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return finishStr;
}
+ (NSString *)JieAESWith:(NSString *)key WithData:(NSString *)data
{
    NSString *pwdKey = [self customMd5:key];
    NSString *base64Text = [data stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
    NSData * tmpData = [base64Text base64DecodedData];
    NSData *cipherData = [tmpData AES256DecryptWithKey:pwdKey];
    NSString *plainText  = [[NSString alloc] initWithData:cipherData encoding:NSUTF8StringEncoding];
    return [plainText autorelease];

}

+ (NSString *) getJSonStr:(NSString *) str
{
    NSArray * array = [str componentsSeparatedByString:@"&"];
    if(array.count == 1)
    {
        NSArray * lastArray = [[array objectAtIndex:0] componentsSeparatedByString:@"="];
        if (lastArray.count == 2) {
            NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:[lastArray objectAtIndex:1] forKey:[lastArray objectAtIndex:0]];
            return [self dictionaryToJson:jsonDict];
        }else{
            return nil;
        }
    }
    else
    {
        NSString *lastStr = @"";
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithCapacity:1];
        
        for(NSString * str in array)
        {
            NSArray *array = [str componentsSeparatedByString:@"="];
            if (array.count > 0) {
                [jsonDict setObject:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
                if (array.count > 2) {
                    NSString *tempstr = [NSString stringWithFormat:@"%@=",[array objectAtIndex:1]];
                    [jsonDict setObject:tempstr forKey:[array objectAtIndex:0]];
                }
            }
        }
        lastStr = [self dictionaryToJson:jsonDict];
        return lastStr;
    }
}

+ (BOOL)isContinSpecialCharacterWithOrginalString:(NSString *)orginalString
{
//<<<<<<< .mine
//    NSRange urgentRange = [orginalString rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @" 《》【】¨「」『』《》*"]];
//=======
    //只过滤首位的
//    NSString *tmpString = [NSString stringWithString:orginalString];
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）￥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"!"];
//    tmpString = [tmpString stringByTrimmingCharactersInSet:set];
//    if ([tmpString isEqualToString:orginalString]) {
//        return NO;
//    }
//    return YES;
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
//    NSRange urgentRange = [orginalString rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @" ~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    NSRange urgentRange = [orginalString rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @" *"]];

    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
+ (BOOL)stringIsIncludeChineseWord:(NSString *)orginalStr
{
    NSString *str = orginalStr;
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

//+ (NSString *)getIPAddress
//{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:@"curWanIp"];
//}


+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return YES;
    }
    return NO;
}
+ (CGFloat)pixelConvertIntoPound:(CGFloat)pixel
{
    CGFloat font = (pixel/96)*72;
    return font;
}
+ (NSString *)getUserAgent
{
    NSString *UA = [ASIHTTPRequest defaultUserAgentString];
    const char *c = [UA cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString * newTraStr = [[[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding] autorelease];
    newTraStr = [newTraStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newTraStr ;

}

+ (NSMutableAttributedString *)oneSectionOfLabelShowDifferentColor:(UIColor *)diffColor WithSectionText:(NSString *)sectionText WithTotalString:(NSString *)lastStr
{
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:lastStr];
    [attributeText addAttribute:NSForegroundColorAttributeName value:diffColor range:[lastStr rangeOfString:sectionText]];
    return [attributeText autorelease];

}


+ (NSMutableAttributedString *)twoSectionOfLabelShowDifferentColor:(NSArray *)colors WithSectionText:(NSArray *)sectionTexts WithTotalString:(NSString *)lastStr
{
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:lastStr];
    for (int i = 0; i< colors.count; i++) {
        UIColor *color = [colors objectAtIndex:i];
        NSString *text = [sectionTexts objectAtIndex:i];
        [attributeText addAttribute:NSForegroundColorAttributeName value:color range:[lastStr rangeOfString:text]];
    }
    return [attributeText autorelease];
}

+ (NSMutableAttributedString *)twoSectionOfLabelShowDifferentColor:(NSArray *)colors WithTextLocations:(NSArray *)rangeArray WithTotalString:(NSString *)lastStr
{

    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:lastStr];
    for (int i = 0; i< colors.count; i++) {
        UIColor *color = [colors objectAtIndex:i];
        NSValue *location = [rangeArray objectAtIndex:i];
        NSRange range;
        [location getValue:&range];
        [attributeText addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return [attributeText autorelease];
}
+ (NSMutableAttributedString *)twoSectionOfLabelShowDifferentAttribute:(NSArray *)attributeArr WithTextLocations:(NSArray *)rangeArray WithTotalString:(NSString *)totalStr
{
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (int i = 0; i< attributeArr.count; i++) {
        NSDictionary *dict = [attributeArr objectAtIndex:i];
        NSValue *location = [rangeArray objectAtIndex:i];
        NSRange range;
        [location getValue:&range];
        [attributeText setAttributes:dict range:range];
    }
    return [attributeText autorelease];
}
//个人信息存储路径
+ (NSString *)filePathWithFileName:(NSString *)fileName
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [filePath stringByAppendingPathComponent:fileName];
}

+ (void)addLineViewColor:(UIColor *)color With:(UIView *)view isTop:(BOOL)top
{
    CGFloat height = 0.0f;
    if (!top) {
        height = CGRectGetHeight(view.frame);
    }
    UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, CGRectGetWidth(view.frame), 0.5)] autorelease];
    lineView.backgroundColor = color;
    [view addSubview:lineView];
}
+ (void)addLineViewColor:(UIColor *)color WithView:(UIView *)view isTop:(BOOL)top
{
    CGFloat height = 0.0f;
    if (!top) {
        height = CGRectGetHeight(view.frame);
    }
    UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, ScreenWidth, 0.5)] autorelease];
    lineView.backgroundColor = color;
    [view addSubview:lineView];
}
+ (UIView *)addSepateViewWithRect:(CGRect)rect WithColor:(UIColor *)color
{
    UIView *view = [[[UIView alloc] initWithFrame:rect] autorelease];
    view.backgroundColor = color;
    return view ;
}

//验证身份证号
+ (BOOL)isIdentityCard: (NSString *)identityCard {
    if (identityCard.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//判断只包含中英文、数字，1~30位
+(BOOL)isEnglishAndNumbers:(NSString *)string
{
    NSString *regex = @"(^[A-Za-z0-9]{1,30}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

+ (int)stringA:(NSString *) a_String ComparedStringB:(NSString *)b_String
{
    NSComparisonResult comparResult = [a_String compare:b_String options:NSNumericSearch];
    if (comparResult == NSOrderedDescending) {
        return 1;
    }else if (comparResult == NSOrderedAscending) {
        return -1;
    }else {
        return 0;
    }
    return 0;
}

//是否是纯数字
+ (BOOL)isOnlyNumber:(NSString *)string {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//判断是否是纯汉字
+ (BOOL)isChinese:(NSString *)string {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

//银行卡校验
+ (BOOL)isValidCardNumber:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *regex = @"(^[0-9]{16,19}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(1[0-9])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark -
//当图片有更新 清除所有的缓存
+ (void)checkCachePicIsNeedsClear:(NSString *)updateTime PicType:(PicType)type
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"BannerUpDateTimeDict"];
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSString *keyStr = @"";
    if (type == BannerInvestSuccess) {
        keyStr = @"investSuccessPic";
    } else if (type == BannerMorePic) {
        keyStr = @"morePic";
    } else if (type == BannerRegistPic) {
        keyStr = @"registPic";
    } else if (type == BannerRegistShowPic) {
        keyStr = @"registShowPic";
    }
    NSString *prePicStr = [mutabDict objectForKey:keyStr];
    if (prePicStr == nil) {
        [mutabDict setValue:updateTime forKey:keyStr];
    } else {
        if (![prePicStr isEqualToString:updateTime]) {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [mutabDict setValue:updateTime forKey:keyStr];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:mutabDict forKey:@"BannerUpDateTimeDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//+ (BOOL)isPureNumandCharacters:(NSString *)string
//{
//    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
//    if(string.length > 0)
//    {
//        return NO;
//    }
//    return YES;
//}

#pragma mark NSDate 转化为 NSString
/**
 @return 获取时间戳
 */
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];//时间戳的值
    return dateString;
}
+ (NSString *)stringFromDate//获取当前系统时间戳
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] *1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
    return timeString;
}

//获取当前系统时间戳
-(NSString*)cutDate:(id)_date
{
    NSString*timeYouGet = [NSString stringWithFormat:@"%@",_date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDate *updatetimestamp = nil;
    if([timeYouGet length]==13){//时间戳有10位和13位的分开判断
        updatetimestamp = [NSDate dateWithTimeIntervalSince1970:[timeYouGet doubleValue] / 1000];
    }else{
        updatetimestamp = [NSDate dateWithTimeIntervalSince1970:[timeYouGet doubleValue]];
    }
    
    
    NSString *confromTimespStr = [formatter stringFromDate:updatetimestamp];
    NSString *strByCut = [confromTimespStr substringToIndex:10];
    return strByCut;
}
/**
 *  获取当前展示的viewController
 *
 *  @return 当前展示的ViewController
 */
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
    
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

+ (NSString *) getSinatureWithPar:(NSString *) par
{
    NSString *lastStr = [NSString stringWithFormat:@"%@%@",par,@"activity"];
    //遍历字符串中的每一个字符
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[lastStr length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [lastStr substringWithRange:NSMakeRange(i, 1)];
        [array addObject:[NSString stringWithFormat:@"%@",s]];
    }
    NSArray *lastArray =[array sortedArrayUsingSelector:@selector(compare:)];
    NSString * str55 = [lastArray componentsJoinedByString:@","];
    NSString *str66 = @"[";
    NSString *str77 = @"]";
    NSString *str88 = [[str66 stringByAppendingString:str55] stringByAppendingString:str77];
    
    return [UCFToolsMehod md5:str88];
}
+ (NSString *) getParStr:(NSString *) str
{
    NSArray * array = [str componentsSeparatedByString:@"&"];
    if(array.count == 1)
    {
        NSArray * lastArray = [[array objectAtIndex:0] componentsSeparatedByString:@"="];
        return [lastArray objectAtIndex:1];
    }
    else
    {
        NSString *lastStr = @"";
        for(NSString * str in array)
        {
            if (str.length > 0) {
                if ([str rangeOfString:@"="].location !=NSNotFound) {
                    NSRange range = [str rangeOfString:@"="];
                    str = [str substringWithRange:NSMakeRange(range.location + 1, str.length-range.location-1)];
                    lastStr =[lastStr stringByAppendingString:str];
                }
            }
            //            NSArray *array = [str componentsSeparatedByString:@"="];
            //
            //            NSString * str = nil;
            //            if (array.count > 1) {
            //                str = [array objectAtIndex:1];
            //            }
            //            if(str.length > 0)
            //            {
            //                lastStr =[lastStr stringByAppendingString:str];
            //            }
        }
        
        return lastStr;
    }
}
//判断用户是否开启推送开关 是否允许推送消息设置
+(BOOL)isAllowedNotification
{
    //iOS8 check if user allow notification
    if(kIS_IOS8) {// system is iOS8
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            if(UIUserNotificationTypeNone != setting.types) {
        return  YES;
                }
        }
    else
    {//iOS7
       UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            
    return YES;
    }
    return  NO;
}

+ (UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(BOOL)isNullValue:(id)value
{
    
    if ([value isKindOfClass:[NSNull class]] || [value isEqualToString:@""] || nil == value || [value isEqual:[NSNull null]] || [self isNbsp:value]) {
        return YES;
    }
    else {
        return NO;
    }
}

+(BOOL)isNbsp:(id)value
{
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value rangeOfString:@"nbsp"].location != NSNotFound)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

#pragma mark -
//UIImage:去色功能的实现（图片灰色显示）
+ (UIImage *)grayImage:(UIImage *)sourceImage {
#pragma mark - Grayscale
    
//    - (UIImage *)grayscaleImageForImage:(UIImage *)image {
        // Adapted from this thread: http://stackoverflow.com/questions/1298867/convert-image-to-grayscale
        const int RED = 1;
        const int GREEN = 2;
        const int BLUE = 3;
        
        // Create image rectangle with current image width/height
        CGRect imageRect = CGRectMake(0, 0, sourceImage.size.width * sourceImage.scale, sourceImage.size.height * sourceImage.scale);
        
        int width = imageRect.size.width;
        int height = imageRect.size.height;
        
        // the pixels will be painted to this array
        uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
        
        // clear the pixels so any transparency is preserved
        memset(pixels, 0, width * height * sizeof(uint32_t));
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // create a context with RGBA pixels
        CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                     kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
        
        // paint the bitmap to our context which will fill in the pixels array
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), [sourceImage CGImage]);
        
        for(int y = 0; y < height; y++) {
            for(int x = 0; x < width; x++) {
                uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
                
                // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                
                // set the pixels to gray
                rgbaPixel[RED] = gray;
                rgbaPixel[GREEN] = gray;
                rgbaPixel[BLUE] = gray;
            }
        }
        
        // create a new CGImageRef from our context with the modified pixels
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // we're done with the context, color space, and pixels
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        free(pixels);
        
        // make a new UIImage to return
        UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef
                                                     scale:sourceImage.scale
                                               orientation:UIImageOrientationUp];
        
        // we're done with image now too
        CGImageRelease(imageRef);
        
        return resultUIImage;
    
}
+ (NSString *)getParameterByDictionary:(NSDictionary *)dic
{
    NSArray *keyArr = [dic allKeys];
    if (!dic || !keyArr.count) {
        return @"";
    } else {
        NSString *tmpParameter = @"";
        if (keyArr.count == 1) {
            NSString *key = [keyArr objectAtIndex:0];
            NSString *value = [dic valueForKey:key];
            tmpParameter = [NSString stringWithFormat:@"%@=%@",key,value];
        } else {
            for (int i = 0; i < keyArr.count; i++) {
                NSString *key = [keyArr objectAtIndex:i];
                NSString *value = [dic valueForKey:key];
                if (i == 0) {
                    tmpParameter = [NSString stringWithFormat:@"%@=%@",key,value];
                } else {
                    tmpParameter = [tmpParameter stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
                }
            }
        }
        return tmpParameter;
    }
}
+ (UIImage *)getTheLaunchImage
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    NSString *viewOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        viewOrientation = @"Portrait";
    } else {
        viewOrientation = @"Landscape";
    }
    
    
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:launchImage];
    
}
//创建工场二维码图片
+(NSData *)createImageCode:(NSString *)gcmStr{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSString *dataString = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/orderuser/toRegister.shtml?gcm=%@",gcmStr];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
//   根据CIImage生成指定大小的UIImage
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:85.0];
    DDLogDebug(@"NSData-->>>%@",UIImagePNGRepresentation(image));
    return UIImagePNGRepresentation(image);
}

//创建工场二维码图片
+(UIImage *)createImageCode:(NSString *)gcmStr withWith:(CGFloat)width {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSString *dataString = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/orderuser/toRegister.shtml?gcm=%@",gcmStr];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //   根据CIImage生成指定大小的UIImage
//    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:width * 2];
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:width * 2];
    // 开启绘图, 获取图片 上下文<图片大小>
    UIGraphicsBeginImageContext(image.size);
    // 将二维码图片画上去
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 将小图片画上去
    UIImage *smallImage = [UIImage imageNamed:@"gong_logo.png"];
    float  smallImageWight =  width*0.2 *2;
    [smallImage drawInRect:CGRectMake((image.size.width - smallImageWight) / 2 , (image.size.width - smallImageWight) / 2 , smallImageWight, smallImageWight)];
    // 获取最终的图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return finalImage;
}
//合成图片
+ (UIImage *)composeImageCodeWithBackgroungImage:(UIImage *)backgroundImage withCodeImage:(UIImage *)codeImage {
    //要绘制的实际image
    UIImage *mergeImage = backgroundImage;
    UIGraphicsBeginImageContext(mergeImage.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
    /*
     *背景image绘制到上下文中
     */
    [mergeImage drawInRect:(CGRect){0, 0, mergeImage.size.width, mergeImage.size.height}];
    
    UIImage *drawImage = codeImage;
    CGFloat x = (mergeImage.size.width - drawImage.size.width) * 0.5;
    CGFloat y = mergeImage.size.height * 0.91 - drawImage.size.height;
    [drawImage drawInRect:(CGRect){x, y, drawImage.size.width, drawImage.size.height}];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+(UIImage *) getImageFromURL:(NSString *)fileURL{
    
    ASIFormDataRequest * innerRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fileURL]];
    [innerRequest setRequestMethod:@"GET"];
    [innerRequest setValidatesSecureCertificate:NO];
    [innerRequest setDelegate:self];
    [innerRequest setTimeOutSeconds:20.0];
    // 开始同步请求
    [innerRequest startSynchronous];
    NSError *error = [innerRequest error];
    UIImage * result;
    if (!error)
    {
        NSData *data=[innerRequest responseData];
        result = [UIImage imageWithData:data];
    }
    return result;
    
}
+ (void)storeImage:(NSURL *)imagePath2
{
    //覆盖方法，指哪打哪，这个方法是下载imagePath2的时候响应
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imagePath2 options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        DDLogDebug(@"当前%ld 总共 %ld",receivedSize,expectedSize);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        DDLogDebug(@"下载完成");
        SDImageCache *cache = [[[SDImageCache alloc] init] autorelease];
        [cache storeImage:image forKey:imagePath2.absoluteString];
    }];
}
+ (UIImage *)batchImageSelectedState:(CGRect)rect
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor redColor] CGColor];
    
    UIImageView *leftDownView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.frame) - 28 , CGRectGetHeight(view.frame) -25, 28, 25)];
    leftDownView.image = [UIImage imageNamed:@"investment_selected"];
    leftDownView.backgroundColor = [UIColor clearColor];
    [view addSubview:leftDownView];
    return [self getImageFromView:view];
}
+ (UIImage *)batchImageNormalState:(CGRect)rect
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.8;
    view.layer.borderColor = [UIColorWithRGB(0xd8d8d8) CGColor];
    return [self getImageFromView:view];
}
+ (UIImage *)getImageFromView:(UIView *)theView
{
    //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//四舍五入方法
+(NSString *)notRounding:(double)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
+ (NSMutableAttributedString*) changeLabelWithAllStr:(NSString *)allStr Text:(NSString*)needText Font:(CGFloat)font
{
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:needText].location, [[noteStr string] rangeOfString:needText].length);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:redRangeTwo];
    return noteStr;
}

+ (NSString *) paramValueOfUrl:(NSString *)url withParam:(NSString *) param{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}
//银行卡号每四位 添加空格
+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum;
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
//        for (int i = 0 ; i < mutableStr.length; i ++) {
//            if (i>2&&i<mutableStr.length - 3) {
//                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
//            }
//        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return bankNum;
}

+(NSString*)getBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}
@end
