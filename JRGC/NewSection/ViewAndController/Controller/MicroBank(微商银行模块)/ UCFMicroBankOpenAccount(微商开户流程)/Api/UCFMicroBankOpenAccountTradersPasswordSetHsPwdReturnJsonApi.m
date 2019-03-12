//
//  UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/8.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi.h"

@implementation UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi
{
    SelectAccoutType _accoutType;
    NSString *_idCardNo;
    NSString *_validateCode;
}

- (id)initWithIdCardNo:(NSString *)idCardNo
                 validateCode:(NSString *)validateCode
             AccoutType:(SelectAccoutType )accoutType
{
    self = [super init];
    if (self) {
        _idCardNo = idCardNo;
        _validateCode = validateCode;
        _accoutType= accoutType;
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
    return SetHsPwdReturnJsonApiURL;
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
             @"fromSite":[NSString stringWithFormat:@"%ld",(long)_accoutType],
             @"validateCode": _validateCode,
             @"idCardNo" : _idCardNo,
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonModel";
}
@end
