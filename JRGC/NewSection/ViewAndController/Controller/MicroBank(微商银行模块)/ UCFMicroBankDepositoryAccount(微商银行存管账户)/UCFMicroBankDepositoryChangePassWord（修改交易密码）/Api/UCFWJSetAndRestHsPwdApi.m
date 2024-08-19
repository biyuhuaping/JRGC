//
//  UCFWJSetAndRestHsPwdApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFWJSetAndRestHsPwdApi.h"

@implementation UCFWJSetAndRestHsPwdApi

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
    return WJSetAndRestHsPwdApiURL;
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
             @"fromSite":[NSString stringWithFormat:@"%zd",SelectAccoutTypeP2P],
             };
}

- (NSString *)modelClass
{
    return @"UCFWJSetAndRestHsPwdModel";
}
@end
