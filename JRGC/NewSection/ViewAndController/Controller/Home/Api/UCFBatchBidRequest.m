//
//  UCFBatchBidRequest.m
//  JRGC
//  批量标详情接口
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBatchBidRequest.h"
@interface UCFBatchBidRequest()

@property(nonatomic, copy)NSString *projectId;
@property(nonatomic, copy)NSString *statue;

@end
@implementation UCFBatchBidRequest
- (NSString *)requestUrl {
    return @"api/prdClaims/v2/colPrdclaimsDetail.json";
}
- (id)initWithProjectId:(NSString *)projectId bidState:(NSString *)statue
{
    if (self = [super init]) {
        self.projectId = projectId;
        self.statue = statue;
    }
    return self;
}
- (id)requestArgument {
    return @{@"prdClaimsId":_projectId,@"status":_statue};
}
//- (NSString *)modelClass
//{
//    return @"UCFBidDetailModel";
//}

@end
