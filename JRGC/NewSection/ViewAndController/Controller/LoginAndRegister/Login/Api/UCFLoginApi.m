//
//  UCFLoginApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/31.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFLoginApi.h"
#import "MD5Util.h"
@implementation UCFLoginApi
{
    NSString* _username;
    NSString* _pwd;
    NSString* _isCompany;
}

- (id)initWithUsername:(NSString* )username andPwd:(NSString* )pwd andIsCompany:(NSString* )isCompany
{
    self = [super init];
    if (self) {
        
        _username= username;
        _pwd= pwd;
        _isCompany= isCompany;
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
    return loginApiURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    NSString *token_id = [UserInfoSingle didReceiveDeviceBlackBox];
    NSString *isCompanyBool;
    
    if ([_isCompany isEqualToString:@"个人"]) {
        isCompanyBool = @"false";
    }
    else
    {
        isCompanyBool = @"true";
    }
    NSString *newPwd = [MD5Util MD5Pwd:_pwd];
    return @{
             @"username":_username,
             @"pwd":newPwd,
             @"isCompany":isCompanyBool,
             @"token_id":token_id
             };
}

- (NSString *)modelClass
{
    return @"UCFLoginModel";
}
@end
