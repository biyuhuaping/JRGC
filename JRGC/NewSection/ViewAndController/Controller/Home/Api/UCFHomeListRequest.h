//
//  UCFHomeListRequest.h
//  JRGC
//
//  Created by zrc on 2019/1/16.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFHomeListRequest : BaseRequest
- (id)initWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
