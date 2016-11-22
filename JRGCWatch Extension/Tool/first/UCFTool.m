//
//  UCFTool.m
//  Test01
//
//  Created by NJW on 16/10/19.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFTool.h"
#import "NetworkSetting.h"
#import "CommonSetting.h"
#import "CommonCrypto/CommonDigest.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "UCFAccount.h"
#import "UCFAccountTool.h"

@implementation UCFTool

+ (NSString *) getSinatureWithPar:(NSString *) par
{
    UCFAccount *account = [UCFAccountTool account];
    NSString *lastStr = [NSString stringWithFormat:@"%@%@",par,account.signature];
    //    NSString *stttt  = [[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP];
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
    
    return [self md5:str88];
}

+ (NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSString *)AESWithKey2:(NSString *)key WithDic:(NSDictionary *)dic
{
    NSString *pwdKey = [self customMd5:key];
    NSString *jsonStr = [self dictionaryToJson:dic];
    NSData *cipherData = [[jsonStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pwdKey];
    NSString *base64Text = [cipherData base64EncodedString];
    
    return base64Text;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
    totalStr = [self md5_v:totalStr];
    //    totalStr = [totalStr substringToIndex:16];
    return totalStr;
}

+ (NSString *)md5_v:(NSString *)str
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

+ (NSString *)getDocumentsPath
{
    //获取Documents路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
//    NSLog(@"path:%@", path);
    return path;
}
@end
