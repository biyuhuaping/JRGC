//
//  UCFRegisterGetRegisterInfoApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFRegisterGetRegisterInfoApi : BaseRequest
- (id)initWithphoneNum:(NSString* )phoneNo;
@end

NS_ASSUME_NONNULL_END
