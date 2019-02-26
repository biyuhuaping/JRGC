//
//  UCFBidDetailRequest.m
//  JRGC
//
//  Created by zrc on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBidDetailRequest.h"
@interface UCFBidDetailRequest()
@property(nonatomic, copy)NSString *projectId;
@property(nonatomic, copy)NSString *statue;

@end
@implementation UCFBidDetailRequest

- (id)initWithProjectId:(NSString *)projectId bidState:(NSString *)statue
{
    if (self = [super init]) {
        self.projectId = projectId;
        self.statue = statue;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"api/prdClaims/v2/getPrdBaseDetail.json";
}
- (id)requestArgument {
    return @{@"prdClaimsId":_projectId,@"status":_statue};
}
- (NSString *)modelClass
{
    return @"UCFBidDetailModel";
}
@end
