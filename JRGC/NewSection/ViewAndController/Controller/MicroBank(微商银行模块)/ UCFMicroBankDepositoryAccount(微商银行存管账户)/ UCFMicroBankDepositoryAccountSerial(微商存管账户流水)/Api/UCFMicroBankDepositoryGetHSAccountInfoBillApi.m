//
//  UCFMicroBankDepositoryGetHSAccountInfoBillApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryGetHSAccountInfoBillApi.h"

@implementation UCFMicroBankDepositoryGetHSAccountInfoBillApi
{
    NSString* _page;
    NSString* _pageSize;
    SelectAccoutType _accoutType;
    
}
- (id)initWithPage:(NSUInteger )page pageSize:(NSUInteger )pageSize accoutType:(SelectAccoutType)accoutType
{
    self = [super init];
    if (self) {
        
        _page = [NSString stringWithFormat:@"%ld",page];
        _pageSize = [NSString stringWithFormat:@"%ld",pageSize];
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
    return GetHSAccountInfoBillApiURL;
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
             @"page":_page,
             @"pageSize":_pageSize,
             @"fromSite":[NSString stringWithFormat:@"%zd",_accoutType]
             };
}

- (NSString *)modelClass
{
    return @"UCFMicroBankDepositoryGetHSAccountInfoBillModel";
}
@end
