//
//  UCFRegisterUserBaseMessVerifCodeApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFRegisterUserBaseMessVerifCodeApi : BaseRequest
- (id)initWithDestPhoneNo:(NSString* )phoneNo andValidateCode:(NSString *)validateCode;
// 注册验证手机验证码  phoneNo 注册手机号   validateCode 验证码

@end

NS_ASSUME_NONNULL_END
