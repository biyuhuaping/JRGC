//
//  UCFNewCollectionChildBidListRequest.h
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewCollectionChildBidListRequest : BaseRequest
- (instancetype)initWithColPrdClaimId:(NSString *)colPrdClaimId Page:(NSInteger)page PrdClaimsOrder:(NSString *)prdClaimsOrder Statue:(NSString *)statue;
@end

NS_ASSUME_NONNULL_END
