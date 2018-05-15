//
//  Encryption.m
//  SDKDemo
//
//  Created by 张瑞超 on 2017/12/25.
//  Copyright © 2017年 zhangruichao. All rights reserved.
//

#import "Encryption.h"
#import "NSString+MD5.h"
#import "CommonCrypto/CommonDigest.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "SFHFKeychainUtils.h"
//static NSString *SERVER_IP =  @"https://app.9888.cn/";
@implementation Encryption

+ (NSString *)AESWithKey:(NSString *)key WithDic:(NSDictionary *)dic
{
    NSString *pwdKey = [self customMd5:key];
    NSString *jsonStr = [self dictionaryToJson:dic];
    NSData *cipherData = [[jsonStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pwdKey];
    NSString *base64Text = [cipherData base64EncodedString];
    NSString *finishStr = [NSString stringWithFormat:@"%@",base64Text];
    return finishStr;
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
    totalStr = [totalStr gcmd5];
    return totalStr;
}
+ (NSString*)dictionaryToJson:(id)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSString *)dictTransToString:(NSDictionary *)dic
{
    NSArray *keyArr = [dic allKeys];
    NSString *severiceStr = @"";
    for (int i = 0; i< keyArr.count; i++) {
        NSString *key = keyArr[i];
        NSString *value = dic[key];
        if (i == keyArr.count - 1) {
            severiceStr = [severiceStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        } else {
            severiceStr = [severiceStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]];
        }
    }
    return severiceStr;
}
+ (NSString *)getKeychain
{
        //正式
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

+ (NSString *) getSinatureWithPar:(NSString *) par
{
    NSString *lastStr = [NSString stringWithFormat:@"%@%@",par,[[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP]];
    //    NSString *stttt  = [[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP];
    //遍历字符串中的每一个字符
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[lastStr length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [lastStr substringWithRange:NSMakeRange(i, 1)];
        [array addObject:[NSString stringWithString:s]];
    }
    NSArray *lastArray =[array sortedArrayUsingSelector:@selector(compare:)];
    NSString * str55 = [lastArray componentsJoinedByString:@","];
    NSString *str66 = @"[";
    NSString *str77 = @"]";
    NSString *str88 = [[str66 stringByAppendingString:str55] stringByAppendingString:str77];
    
    return [str88 gcmd5];
}

@end
