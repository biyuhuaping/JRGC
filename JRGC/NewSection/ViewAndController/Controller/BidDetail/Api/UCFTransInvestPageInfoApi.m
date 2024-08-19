//
//  UCFTransInvestPageInfoApi.m
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransInvestPageInfoApi.h"
@interface UCFTransInvestPageInfoApi ()
@property(nonatomic, copy)NSString *projectId;
@end
@implementation UCFTransInvestPageInfoApi
- (id)initWithProjectId:(NSString *)projectId type:(SelectAccoutType)type
{
    if (self = [super init]) {
        self.projectId = projectId;
        self.apiType = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"newprdTransfer/dealTransferBidTwo";
}
- (id)requestArgument {
    return @{@"id":_projectId,@"fromSite":(self.apiType == SelectAccoutTypeP2P ? @"1" : @"2")};
}
- (NSString *)modelClass
{
    return @"UCFPureTransBidRootModel";
}
@end
