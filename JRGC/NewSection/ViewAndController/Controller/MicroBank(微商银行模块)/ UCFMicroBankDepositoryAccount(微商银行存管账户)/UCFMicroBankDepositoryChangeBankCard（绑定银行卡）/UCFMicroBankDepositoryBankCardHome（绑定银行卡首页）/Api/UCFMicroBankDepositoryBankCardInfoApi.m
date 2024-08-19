//
//  UCFMicroBankDepositoryBankCardInfoApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/5/6.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryBankCardInfoApi.h"

@implementation UCFMicroBankDepositoryBankCardInfoApi
{
    SelectAccoutType _accoutType;
}
- (id)initWithType:(SelectAccoutType )accoutType
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
    return ShowBankCardMessURL;
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
             @"fromSite":[NSString stringWithFormat:@"%zd",_accoutType]
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankDepositoryBankCardInfoModel";
}
@end
