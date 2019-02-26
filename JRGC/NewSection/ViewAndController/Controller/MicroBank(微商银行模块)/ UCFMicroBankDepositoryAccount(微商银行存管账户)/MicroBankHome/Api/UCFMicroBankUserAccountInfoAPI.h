//
//  UCFMicroBankUserAccountInfoAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankUserAccountInfoAPI : BaseRequest

- (id)initWithAccoutType:(SelectAccoutType )accoutType;

@end

NS_ASSUME_NONNULL_END
