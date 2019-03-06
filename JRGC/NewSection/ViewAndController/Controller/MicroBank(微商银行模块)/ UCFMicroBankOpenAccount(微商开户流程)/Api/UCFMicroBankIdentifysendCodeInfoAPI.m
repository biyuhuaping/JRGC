//
//  UCFMicroBankIdentifysendCodeInfoAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankIdentifysendCodeInfoAPI.h"

@implementation UCFMicroBankIdentifysendCodeInfoAPI
{
    SelectAccoutType _accoutType;
    NSString *_destPhoneNo;
    NSString *_isVms;
    NSString *_type;
}

- (id)initWithDestPhoneNo :(NSString *)destPhoneNo
                     isVms:(NSString *)isVms
                      type:(NSString *)type
                AccoutType:(SelectAccoutType )accoutType
{
    self = [super init];
    if (self) {
        _destPhoneNo = destPhoneNo;
        _isVms = isVms;
        _type = type;
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
    return identifysendCodeApiURL;
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
             @"destPhoneNo": _destPhoneNo,
             @"isVms" : _isVms,
             @"type" : _type
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankIdentifysendCodeInfoModel";
}
@end
