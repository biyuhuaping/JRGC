//
//  UCFRegistVerificationMobileApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegistVerificationMobileApi.h"

@implementation UCFRegistVerificationMobileApi
{
    NSString* _phoneNum;
}

- (id)initWithphoneNum:(NSString* )phoneNum
{
    self = [super init];
    if (self) {
        
        _phoneNum= phoneNum;
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
    return VerificationMobileApiURL;
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
             @"phoneNum":_phoneNum
             };
}

- (NSString *)modelClass
{
    return @"UCFRegistVerificationMobileModel";
}
@end
