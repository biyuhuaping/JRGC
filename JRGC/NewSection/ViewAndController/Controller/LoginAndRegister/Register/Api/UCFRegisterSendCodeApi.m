//
//  UCFRegisterSendCodeApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterSendCodeApi.h"

@implementation UCFRegisterSendCodeApi
{
    NSString* _destPhoneNo;
    NSString* _isVms;
    NSString* _type;
}

- (id)initWithDestPhoneNo:(NSString* )destPhoneNo andIsVms:(NSString *)isVms  andType:(NSString *)type;
{
    self = [super init];
    if (self) {
        
        _destPhoneNo= destPhoneNo;
        _isVms = isVms;
        _type = type;
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
    return RegisterSendCodeApiURL;
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
             @"destPhoneNo":_destPhoneNo,
             @"userId":@"1",
             @"type":_type,
             @"isVms":_isVms,
             };
}

- (NSString *)modelClass
{
    return @"UCFRegisterSendCodeModel";
}
@end
