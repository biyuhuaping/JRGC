//
//  UCFRegisterUserBaseMessVerifCodeApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterUserBaseMessVerifCodeApi.h"

@implementation UCFRegisterUserBaseMessVerifCodeApi
{
    NSString* _phoneNo;
    NSString* _validateCode;
}

- (id)initWithDestPhoneNo:(NSString* )phoneNo andValidateCode:(NSString *)validateCode{
    self = [super init];
    if (self) {
        
        _phoneNo= phoneNo;
        _validateCode = validateCode;
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
    return UserBaseMessVerifCodeApiURL;
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
             @"phoneNo":_phoneNo,
             @"validateCode":_validateCode,
             };
}

- (NSString *)modelClass
{
    return @"UCFRegisterUserBaseMessVerifCodeModel";
}
@end
