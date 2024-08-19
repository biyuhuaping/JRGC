//
//  UCFNewCollectionChildBidListRequest.m
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCollectionChildBidListRequest.h"
@interface UCFNewCollectionChildBidListRequest()
@property(nonatomic, copy)NSString *colPrdClaimId;
@property(nonatomic, copy)NSString *page;
@property(nonatomic, copy)NSString *pageSize;
@property(nonatomic, copy)NSString *prdClaimsOrder;
@property(nonatomic, copy)NSString *statue;
@end

@implementation UCFNewCollectionChildBidListRequest
- (instancetype)initWithColPrdClaimId:(NSString *)colPrdClaimId Page:(NSInteger)page PrdClaimsOrder:(NSString *)prdClaimsOrder Statue:(NSString *)statue
{
    if (self = [super init]) {
        self.colPrdClaimId = colPrdClaimId;
        self.page = [NSString stringWithFormat:@"%ld",page];
        self.pageSize = @"20";
        self.prdClaimsOrder = prdClaimsOrder;
        self.statue = statue;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"api/prdClaims/v2/childPrdclaimsList.json";
}
- (id)requestArgument {
    return @{@"colPrdClaimId":self.colPrdClaimId,@"page":self.page,@"pageSize":self.pageSize,@"prdClaimsOrder":self.prdClaimsOrder,@"status":self.statue,@"fromSite":@"1"};
}
- (NSString *)modelClass
{
    return @"UCFCollectionRootModel";
}

@end
