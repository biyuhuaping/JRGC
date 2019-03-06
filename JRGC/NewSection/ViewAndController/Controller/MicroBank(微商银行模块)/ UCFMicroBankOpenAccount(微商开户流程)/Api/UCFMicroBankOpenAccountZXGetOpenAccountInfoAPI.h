//
//  UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
//尊享 徽商绑定银行卡
@interface UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI : BaseRequest

- (id)initWithRealName :(NSString *)realName
                     idCardNo:(NSString *)idCardNo
                     bankCardNo:(NSString *)bankCardNo
                      bankNo:(NSString *)bankNo
                      openStatus:(NSString *)openStatus
                      validateCode:(NSString *)validateCode
                AccoutType:(SelectAccoutType )accoutType;

//@"realName":realName,             //真实姓名
//@"idCardNo":idCardNo,             //身份证号
//@"bankCardNo":bankCard,           //银行卡号
//@"bankNo":_bankId,                //银行id
//@"openStatus":_openStatus,        //获取到的用户信息的状态，对应接口getOpenAccountInfo
//@"validateCode":_textField4.text, //手机验证码
@end

NS_ASSUME_NONNULL_END
