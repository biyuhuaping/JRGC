//
//  UCFAccountCenterAlreadyProfitApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAccountCenterAlreadyProfitApi.h"

@implementation UCFAccountCenterAlreadyProfitApi
{
    
}
- (id)initWithpageIndex:(int)pageIndex pageSize:(int )pageSize
{
    self = [super init];
    if (self) {
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
    return AccountCenterAlreadyProfitApiURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    return @{};
}

- (NSString *)modelClass
{
    return @"UCFAccountCenterAlreadyProfitModel";
}
@end
