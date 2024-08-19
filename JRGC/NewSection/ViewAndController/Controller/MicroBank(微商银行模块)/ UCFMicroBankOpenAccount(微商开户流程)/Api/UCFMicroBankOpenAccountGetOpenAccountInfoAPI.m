//
//  UCFMicroBankOpenAccountGetOpenAccountInfoAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountGetOpenAccountInfoAPI.h"

@implementation UCFMicroBankOpenAccountGetOpenAccountInfoAPI
{
    SelectAccoutType _accoutType;
}

- (id)initWithAccoutType:(SelectAccoutType )accoutType
{
    self = [super init];
    if (self) {
        
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
    return GetOpenAccountInfoApiURL;
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
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankOpenAccountGetOpenAccountInfoModel";
}
@end
