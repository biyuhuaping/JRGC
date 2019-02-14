//
//  UCFRegisterSendCodeApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFRegisterSendCodeApi : BaseRequest
- (id)initWithDestPhoneNo:(NSString* )destPhoneNo andIsVms:(NSString *)isVms;//语音@"VMS";短信 @"SMS"
@end

NS_ASSUME_NONNULL_END
