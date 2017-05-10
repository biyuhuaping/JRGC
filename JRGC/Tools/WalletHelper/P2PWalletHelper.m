//
//  P2PWalletHelper.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "P2PWalletHelper.h"
#import "UcfWalletSDK.h"
@implementation P2PWalletHelper

+ (UIViewController *)getUCFWalletTargetController
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
    [params setValue:@"MT10000000" forKey:@"merchantId"];
    [params setValue:@"402462" forKey:@"userId"];
//    [params setValue:@"张三" forKey:@"realName"];
//    [params setValue:@"112233444444402418" forKey:@"cardNo"];
//    [params setValue:@"18401255051" forKey:@"mobileNo"];
//    [params setValue:@"01" forKey:@"cardType"]; // 证件类型 01身份证，写死即可
    [params setValue:@"f156dc284e32b654860891a1e480d8f0" forKey:@"sign"];

   return [UcfWalletSDK wallet:params retHandler:self retSelector:@selector(walletCallBack) navTitle:@"生活"];
}
+ (void)walletCallBack
{
    
}
+ (NSString *)getSign
{
    NSString  *data = @"merchantId=MT10000000&userId=402462&key=hmYB5Ue6OPoHsW2YX5VlaQ";
    data = data.lowercaseString;
    NSString *sign = [Common md5:data];
    return sign;
}
@end
