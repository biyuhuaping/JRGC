//
//  InvestPageInfoApi.h
//  JRGC
//
//  Created by zrc on 2019/2/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvestPageInfoApi : BaseRequest
- (id)initWithProjectId:(NSString *)projectId type:(SelectAccoutType)type;
@end

NS_ASSUME_NONNULL_END
