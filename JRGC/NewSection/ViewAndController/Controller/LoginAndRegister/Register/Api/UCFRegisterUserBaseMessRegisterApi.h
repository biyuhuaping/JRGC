//
//  UCFRegisterUserBaseMessRegisterApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFRegisterUserBaseMessRegisterApi : BaseRequest
- (id)initWithFactoryCode:(NSString *)factoryCode
               andPhoneNo:(NSString* )phoneNo
                   andPwd:(NSString *)pwd
          andRegistTicket:(NSString *)registTicket
              andToken_id:(NSString *)token_id;

//新注册接口 factoryCode 工场码 phoneNo 注册手机号  pwd 密码    channelCode  渠道号(AppStore)  registTicket 验证token sourceType  注册来源 fromSite 平台标识(1)


@end

NS_ASSUME_NONNULL_END
