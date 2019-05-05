//
//  InvestPageInfoApi.m
//  JRGC
//
//  Created by zrc on 2019/2/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "InvestPageInfoApi.h"

@interface InvestPageInfoApi ()
@property(copy, nonatomic)NSString  *projectId;
@property(copy, nonatomic)NSString  *statue;
@end

@implementation InvestPageInfoApi
- (id)initWithProjectId:(NSString *)projectId bidStatue:(NSString *)statue type:(SelectAccoutType)type;
{
    if (self = [super init]) {
        self.projectId = projectId;
        self.apiType = type;
        self.statue = statue;
    }
    return self;
}
- (id)initWithProjectId:(NSString *)projectId type:(SelectAccoutType)type;
{
    if (self = [super init]) {
        self.projectId = projectId;
        self.apiType = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/api/prdClaims/v2/dealBid.json";
}
- (id)requestArgument {
    if (self.statue) {
        return @{@"status":self.statue,@"id":_projectId,@"fromSite":(self.apiType == SelectAccoutTypeP2P ? @"1" : @"2")};

    } else {
        return @{@"id":_projectId,@"fromSite":(self.apiType == SelectAccoutTypeP2P ? @"1" : @"2")};

    }
}
- (NSString *)modelClass
{
    return @"UCFBidModel";
}
@end
