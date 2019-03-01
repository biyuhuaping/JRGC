//
//  UCFMicroBankGetHSAccountInfoAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankGetHSAccountInfoAPI.h"

@implementation UCFMicroBankGetHSAccountInfoAPI
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
    return GetHSAccountInfoApiURL;
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
    //    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",_accoutType],@"fromSite", nil];
}

- (NSString *)modelClass
{
    return @"UCFMicroBankGetHSAccountInfoModel";
}
@end
