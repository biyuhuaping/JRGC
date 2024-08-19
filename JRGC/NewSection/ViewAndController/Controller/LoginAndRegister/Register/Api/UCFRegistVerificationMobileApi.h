//
//  UCFRegistVerificationMobileApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFRegistVerificationMobileApi : BaseRequest
- (id)initWithphoneNum:(NSString* )phoneNum;
@end

NS_ASSUME_NONNULL_END
