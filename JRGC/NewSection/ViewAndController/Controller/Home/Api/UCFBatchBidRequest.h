//
//  UCFBatchBidRequest.h
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "UCFBatchRootModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFBatchBidRequest :BaseRequest
- (id)initWithProjectId:(NSString *)projectId bidState:(NSString *)statue;
- (id)initWithProjectId:(NSString *)projectId;
@end

NS_ASSUME_NONNULL_END
