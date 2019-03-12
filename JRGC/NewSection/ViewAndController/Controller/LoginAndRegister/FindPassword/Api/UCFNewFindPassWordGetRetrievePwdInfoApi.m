//
//  UCFNewFindPassWordGetRetrievePwdInfoApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewFindPassWordGetRetrievePwdInfoApi.h"

@implementation UCFNewFindPassWordGetRetrievePwdInfoApi
{
    NSString* _phoneNum;
}

- (id)initWithPhoneNum:(NSString* )phoneNum
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
    return GetRetrievePwdInfoApiURL;
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
    return @"UCFNewFindPassWordGetRetrievePwdInfoModel";
}
@end
