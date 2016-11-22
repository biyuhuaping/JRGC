//
//  MD5Util.m
//  JRGC
//  加密方式：首先appPwdKey + pwd 进行base64加密，然后base64密文，MD5加密 ，加密后MD5密文，拼接pwd 再Md5 加密
//  Created by 金融工场 on 16/8/10.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "MD5Util.h"
#import "NSData+Base64.h"
#import "UCFToolsMehod.h"
#define appPwdKey @"AEXJIEJSIFKELFDILEKFDI"
@implementation MD5Util
+ (NSString *)MD5Pwd:(NSString *)originalPwd
{
    if (!originalPwd) {
        return @"";
    }
    NSString *tmpPwd = [appPwdKey stringByAppendingString:originalPwd];
    NSData *pwdData = [tmpPwd dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Pwd = [pwdData base64EncodedString];
    NSString *resultString = [self MD5Encode:base64Pwd];
    return resultString;
}
//双层MD5 加密 
+ (NSString *)MD5Encode:(NSString *)origin
{
    NSString *resultString = origin;
    NSString *md5Str = [UCFToolsMehod md5:resultString];
    md5Str = [md5Str stringByAppendingString:appPwdKey];
    resultString = [UCFToolsMehod md5:md5Str];
    DLog(@"%@",md5Str);
    return resultString;
}

@end
