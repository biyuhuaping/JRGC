//
//  UCFMineGetWithdrawInfoApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMineGetWithdrawInfoApi : BaseRequest
- (id)initWithPageType:(SelectAccoutType )accoutType;
@end

NS_ASSUME_NONNULL_END
