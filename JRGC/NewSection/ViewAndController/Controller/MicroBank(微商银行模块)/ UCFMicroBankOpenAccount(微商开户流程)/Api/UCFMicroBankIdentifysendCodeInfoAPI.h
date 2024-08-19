//
//  UCFMicroBankIdentifysendCodeInfoAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
 //发送验证码
@interface UCFMicroBankIdentifysendCodeInfoAPI : BaseRequest
- (id)initWithDestPhoneNo :(NSString *)destPhoneNo
                     isVms:(NSString *)isVms
                      type:(NSString *)type
                AccoutType:(SelectAccoutType )accoutType;


//destPhoneNo    目标手机号    string
//imei    imei号    string
//isVms    短信类型    string    SMS："普通短信渠道"；VMS："验证码语音渠道"
//type 1：提现；3：修改绑定银行卡；4：修改注册手机号5：设置交易密码；6：开户；7：换卡；9：修改银行预留手机号；10：验证注册手机号 11：资产证明验证码
@end

NS_ASSUME_NONNULL_END
