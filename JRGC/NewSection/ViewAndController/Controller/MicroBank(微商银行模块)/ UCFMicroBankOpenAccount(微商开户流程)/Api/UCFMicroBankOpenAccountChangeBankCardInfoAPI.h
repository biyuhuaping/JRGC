//
//  UCFMicroBankOpenAccountChangeBankCardInfoAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
//更改绑定银行卡信息
@interface UCFMicroBankOpenAccountChangeBankCardInfoAPI : BaseRequest

- (id)initWithBankCard :(NSString *)bankCard
                 bankId:(NSString *)bankId
                 validateCode:(NSString *)validateCode
             openStatus:(NSString *)openStatus
             AccoutType:(SelectAccoutType )accoutType;
//@"bankCard":bankCard,              //银行卡号
//@"bankId":_bankId,                 //银行id
//@"openStatus":_openStatus,         //获取到的用户信息的状态，对应接口getOpenAccountInfo
//@"validateCode":_textField4.text,  //手机验证码
@end

NS_ASSUME_NONNULL_END
