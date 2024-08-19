//
//  UCFMicroBankOpenAccountOpenAccountIntoBankInfoAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
//***微金 徽商绑定银行卡接口
@interface UCFMicroBankOpenAccountOpenAccountIntoBankInfoAPI : BaseRequest

- (id)initWithRealName :(NSString *)realName
               idCardNo:(NSString *)idCardNo
                 bankNo:(NSString *)bankNo
             openStatus:(NSString *)openStatus
             AccoutType:(SelectAccoutType )accoutType;
//{@"realName":realName,             //真实姓名
//    @"idCardNo":idCardNo,             //身份证号
//    @"bankNo":_bankId,                //银行id
//    @"openStatus":_openStatus,        //获取到的用户信息的状态，对应接口
//    @"userId":userId,                 //用户id
//}
@end

NS_ASSUME_NONNULL_END
