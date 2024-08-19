//
//  UCFMyBatchInvestDetailRequest.m
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMyBatchInvestDetailRequest.h"
@interface UCFMyBatchInvestDetailRequest()
@property(nonatomic, copy)NSString  *colPrdClaimsId;
@property(nonatomic, copy)NSString  *batchOrderId;


@end

@implementation UCFMyBatchInvestDetailRequest
- (instancetype)initWithColPrdClaimsId:(NSString *)colPrdClaimsId BatchOrderId:(NSString *)batchOrderId
{
    if (self = [super init]) {
        self.colPrdClaimsId = colPrdClaimsId;
        self.batchOrderId = batchOrderId;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"api/myInvest/v2/myBatchInvestDetail.json";
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:self.colPrdClaimsId, @"colPrdClaimsId", self.batchOrderId, @"batchOrderId",@"1",@"page", @"20", @"pageSize",nil];
    return strParameters;
}

- (NSString *)modelClass
{
    return @"UCFMyBtachBidRoot";
}
@end
