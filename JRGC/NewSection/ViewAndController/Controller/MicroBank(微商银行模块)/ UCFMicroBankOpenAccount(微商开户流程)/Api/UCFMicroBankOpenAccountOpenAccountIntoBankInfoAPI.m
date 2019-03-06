//
//  UCFMicroBankOpenAccountOpenAccountIntoBankInfoAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountOpenAccountIntoBankInfoAPI.h"

@implementation UCFMicroBankOpenAccountOpenAccountIntoBankInfoAPI
{
    SelectAccoutType _accoutType;
    NSString *_realName;
    NSString *_idCardNo;
    NSString *_bankNo;
    NSString *_openStatus;
}

- (id)initWithRealName :(NSString *)realName
               idCardNo:(NSString *)idCardNo
                 bankNo:(NSString *)bankNo
             openStatus:(NSString *)openStatus
             AccoutType:(SelectAccoutType )accoutType
{
    self = [super init];
    if (self) {
        _realName = realName;
        _idCardNo = idCardNo;
        _bankNo = bankNo;
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
    return OpenAccountIntoBankApiURL;
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
             @"bankNo" : _bankNo,
             @"openStatus" : _openStatus,
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankOpenAccountOpenAccountIntoBankInfoModel";
}
@end
