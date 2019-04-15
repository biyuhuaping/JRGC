//
//  UCFMicroBankONewpenAccountGetOpenAccountInfoAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankONewpenAccountGetOpenAccountInfoAPI : BaseRequest

- (id)initWithRealName :(NSString *)realName
                 bankNo:(NSString *)bankNo;

//- (id)initWithRealName :(NSString *)realName
//           bankPhoneNum:(NSString *)bankPhoneNum
//                 bankNo:(NSString *)bankNo;

//{@"realName":realName,             //真实姓名
//    @"bankPhoneNum":_bankPhoneNum,   //银行预留手机号
//    @"bankNo":_bankId,                //银行id
//}
@end

NS_ASSUME_NONNULL_END
