//
//  UCFMyBatchInvestDetailRequest.h
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "UCFMyBtachBidRoot.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFMyBatchInvestDetailRequest : BaseRequest
- (instancetype)initWithColPrdClaimsId:(NSString *)colPrdClaimsId BatchOrderId:(NSString *)batchOrderId;
@end

NS_ASSUME_NONNULL_END
