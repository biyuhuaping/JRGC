//
//  UCFBatchBidRequest.h
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFBatchBidRequest : BaseModel
- (id)initWithProjectId:(NSString *)projectId bidState:(NSString *)statue;
@end

NS_ASSUME_NONNULL_END
