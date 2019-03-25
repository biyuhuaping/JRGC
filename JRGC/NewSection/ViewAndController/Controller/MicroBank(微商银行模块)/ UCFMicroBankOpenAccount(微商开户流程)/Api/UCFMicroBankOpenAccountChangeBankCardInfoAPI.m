//
//  UCFMicroBankOpenAccountChangeBankCardInfoAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountChangeBankCardInfoAPI.h"

@implementation UCFMicroBankOpenAccountChangeBankCardInfoAPI
{
    SelectAccoutType _accoutType;
    NSString *_bankCard;
    NSString *_bankId;
    NSString *_validateCode;
    NSString *_openStatus;
}

- (id)initWithBankCard :(NSString *)bankCard
                 bankId:(NSString *)bankId
           validateCode:(NSString *)validateCode
             openStatus:(NSString *)openStatus
             AccoutType:(SelectAccoutType )accoutType
{
    self = [super init];
    if (self) {
        _bankCard = bankCard;
        _bankId = bankId;
        _validateCode = validateCode;
        _openStatus = openStatus;
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
    return ChangeBankCardApiURL;
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
             @"fromSite":[NSString stringWithFormat:@"%zd",_accoutType],
             @"bankCard": _bankCard,
             @"bankId" : _bankId,
             @"bvalidateCode" : _validateCode,
             @"openStatus" : _openStatus,
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankOpenAccountChangeBankCardInfoModel";
}

@end

