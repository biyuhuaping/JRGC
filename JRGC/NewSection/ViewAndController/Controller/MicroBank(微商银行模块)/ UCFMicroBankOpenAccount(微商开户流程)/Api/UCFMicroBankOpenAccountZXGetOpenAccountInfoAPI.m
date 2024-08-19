//
//  UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI.h"

@implementation UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI

{
    SelectAccoutType _accoutType;
    NSString *_realName;
    NSString *_idCardNo;
    NSString *_bankCardNo;
    NSString *_bankNo;
    NSString *_openStatus;
    NSString *_validateCode;
}

- (id)initWithRealName :(NSString *)realName
               idCardNo:(NSString *)idCardNo
             bankCardNo:(NSString *)bankCardNo
                 bankNo:(NSString *)bankNo
             openStatus:(NSString *)openStatus
           validateCode:(NSString *)validateCode
             AccoutType:(SelectAccoutType )accoutType
{
    self = [super init];
    if (self) {
        _realName = realName;
        _idCardNo = idCardNo;
        _bankCardNo = bankCardNo;
        _bankNo = bankNo;
        _openStatus = openStatus;
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
    return OpenAccountApiURL;
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
             @"fromSite":[NSString stringWithFormat:@"%d",_accoutType],
             @"realName": _realName,
             @"idCardNo" : _idCardNo,
             @"bankCardNo" : _bankCardNo,
             @"bankNo" : _bankNo,
             @"validateCode" : _validateCode,
             @"openStatus" : _openStatus,
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankOpenAccountZXGetOpenAccountInfoModel";
}


@end
