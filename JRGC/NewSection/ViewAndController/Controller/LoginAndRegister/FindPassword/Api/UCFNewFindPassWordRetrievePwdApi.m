//
//  UCFNewFindPassWordRetrievePwdApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewFindPassWordRetrievePwdApi.h"

@implementation UCFNewFindPassWordRetrievePwdApi
{
    NSString* _phoneNum;
    NSString* _validateCode;
    NSString* _pwd;
}

- (id)initWithPhoneNum:(NSString* )phoneNum andValidateCode:(NSString* )validateCode andPwd:(NSString* )pwd;
{
    self = [super init];
    if (self) {
        
        _phoneNum= phoneNum;
        _validateCode = validateCode;
        _pwd = pwd;
    }
    return self;
}
/**
 *  @author KZ, 17-09-11 20:09:12
 *
 *  请求的借口
 *
 *  @return 返回需要请求的借口的URI
 */
- (NSString *)requestUrl {
    return RetrievePwdApiURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    return @{
             @"phoneNum":_phoneNum,
             @"validateCode":_validateCode,
             @"pwd":_pwd,
             @"userId":@"1",
             };
}

- (NSString *)modelClass
{
    return @"UCFNewFindPassWordRetrievePwdModel";
}
@end
