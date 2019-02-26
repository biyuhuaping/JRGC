//
//  UCFBidDetailRequest.h
//  JRGC
//
//  Created by zrc on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFBidDetailRequest : BaseRequest
- (id)initWithProjectId:(NSString *)projectId bidState:(NSString *)statue;
@end

NS_ASSUME_NONNULL_END
