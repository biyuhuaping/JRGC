//
//  UCFHomeListRequest.m
//  JRGC
//
//  Created by zrc on 2019/1/16.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHomeListRequest.h"

@interface UCFHomeListRequest ()
@property(nonatomic, copy)NSString  *userID;
@end

@implementation UCFHomeListRequest

- (id)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
    }
    return self;
}
- (NSString *)requestUrl {
    return @"api/publicMsg/v2/indexPage.json";
}
- (id)requestArgument {
    return @{};
}
- (NSString *)modelClass
{
    return @"UCFNewHomeListModel";
}
@end
