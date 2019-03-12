//
//  UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/8.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi : BaseRequest
- (id)initWithIdCardNo:(NSString *)idCardNo
          validateCode:(NSString *)validateCode
            AccoutType:(SelectAccoutType )accoutType;
@end

NS_ASSUME_NONNULL_END
