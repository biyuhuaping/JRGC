//
//  UCFRegisterGetRegisterInfoApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterGetRegisterInfoApi.h"

@implementation UCFRegisterGetRegisterInfoApi
{
    NSString* _phoneNo;
}

- (id)initWithphoneNum:(NSString* )phoneNo
{
    self = [super init];
    if (self) {
        
        _phoneNo= phoneNo;
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
    return GetRegisterInfoApiURL;
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
             @"userId":@"1"
             };
}

- (NSString *)modelClass
{
    return @"UCFRegisterGetRegisterInfoModel";
}
@end
