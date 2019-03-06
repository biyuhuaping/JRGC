//
//  UCFMicroBankOpenAccountGetOpenAccountInfoAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
//获取徽商开户页面信息
@interface UCFMicroBankOpenAccountGetOpenAccountInfoAPI : BaseRequest
- (id)initWithAccoutType:(SelectAccoutType )accoutType;
@end

NS_ASSUME_NONNULL_END
