//
//  UCFUserAllStatueRequest.m
//  JRGC
//
//  Created by zrc on 2019/2/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFUserAllStatueRequest.h"
@interface UCFUserAllStatueRequest()

@end


@implementation UCFUserAllStatueRequest
- (instancetype)initWithUserId:(NSString *)userId
{
    self  = [super init];
    if (self) {
        
    }
    return self;
}
//- (NSString *)modelClass
//{
//    return @"UCFLoginData";
//}
- (id)requestArgument {
    return @{};
}
- (NSString *)requestUrl
{
    return @"/api/homePage/v2/statusInfoForCache.json";
}
@end
