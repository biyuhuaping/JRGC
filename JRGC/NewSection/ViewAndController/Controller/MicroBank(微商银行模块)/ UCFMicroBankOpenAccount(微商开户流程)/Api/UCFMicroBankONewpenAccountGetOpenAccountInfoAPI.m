//
//  UCFMicroBankONewpenAccountGetOpenAccountInfoAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankONewpenAccountGetOpenAccountInfoAPI.h"

@implementation UCFMicroBankONewpenAccountGetOpenAccountInfoAPI
{
    SelectAccoutType _accoutType;
    NSString *_realName;
//    NSString *_bankPhoneNum;
    NSString *_bankNo;
}

- (id)initWithRealName :(NSString *)realName
                 bankNo:(NSString *)bankNo
{
    self = [super init];
    if (self) {
        _realName = realName;
//        _bankPhoneNum = bankPhoneNum;
        _bankNo = bankNo;
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
    return OpenAccountCenterApiURL;
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
             @"realName": _realName,
             @"bankNo" : _bankNo,
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankOpenAccountOpenAccountIntoBankInfoModel";
}
@end
