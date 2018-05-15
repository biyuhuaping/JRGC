//
//  NSString+MD5.m
//  SDKDemo
//
//  Created by 张瑞超 on 2017/12/25.
//  Copyright © 2017年 zhangruichao. All rights reserved.
//

#import "NSString+MD5.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (MD5)
#pragma mark -md5加密
- (NSString *) gcmd5{
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;

}


@end
