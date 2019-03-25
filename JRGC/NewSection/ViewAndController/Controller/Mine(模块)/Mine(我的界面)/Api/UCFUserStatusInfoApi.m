//
//  UCFUserStatusInfoApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFUserStatusInfoApi.h"

@implementation UCFUserStatusInfoApi


- (id)init
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
    return UserStatusInfoForCacheApiURL;
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
    //    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",_accoutType],@"fromSite", nil];
}

- (NSString *)modelClass
{
    return @"UCFUserStatusInfoModel";
}
@end
