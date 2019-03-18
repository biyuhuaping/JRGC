//
//  UCFRegisterUserBaseMessRegisterApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterUserBaseMessRegisterApi.h"

@implementation UCFRegisterUserBaseMessRegisterApi
{
    NSString* _factoryCode;
     NSString* _phoneNo;
     NSString* _pwd;
    NSString* _registTicket;
    NSString* _token_id;
}

- (id)initWithFactoryCode:(NSString *)factoryCode
                   andPhoneNo:(NSString* )phoneNo
                       andPwd:(NSString *)pwd
              andRegistTicket:(NSString *)registTicket
              andToken_id:(NSString *)token_id
{
    self = [super init];
    if (self) {
        
        _factoryCode= factoryCode;
        _phoneNo= phoneNo;
        _pwd= pwd;
        _registTicket = registTicket;
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
    return UserBaseMessRegisterApiURL;
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
             @"factoryCode":_factoryCode,
             @"phoneNo":_phoneNo,
             @"pwd":_pwd,
             @"registTicket":_registTicket,
             @"channelCode":@"AppStore",
             @"fromSite":@"1",
             @"userId":@"1",
             @"token_id":_token_id,
             };
}

- (NSString *)modelClass
{
    return @"UCFRegisterUserBaseMessRegisterModel";
}


@end
