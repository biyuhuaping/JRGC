//
//  UCFMyBatchBidListRequest.h
//  JRGC
//
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMyBatchBidListRequest : BaseRequest
- (instancetype)initWithPageIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
