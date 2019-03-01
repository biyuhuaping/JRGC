//
//  UCFMicroBankDepositoryGetHSAccountInfoBillApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankDepositoryGetHSAccountInfoBillApi : BaseRequest

- (id)initWithPage:(NSUInteger )page pageSize:(NSUInteger )pageSize accoutType:(SelectAccoutType)accoutType;

@end

NS_ASSUME_NONNULL_END
