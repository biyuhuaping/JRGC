//
//  UCFNewFindPassWordRetrievePwdApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewFindPassWordRetrievePwdApi : BaseRequest
- (id)initWithPhoneNum:(NSString* )phoneNum andValidateCode:(NSString* )validateCode andPwd:(NSString* )pwd;

@end

NS_ASSUME_NONNULL_END
