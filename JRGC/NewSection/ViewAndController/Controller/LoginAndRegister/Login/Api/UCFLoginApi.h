//
//  UCFLoginApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/31.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFLoginApi : BaseRequest
- (id)initWithUsername:(NSString* )username andPwd:(NSString* )pwd andIsCompany:(NSString* )isCompany;//个人登录还是企业登录
@end

NS_ASSUME_NONNULL_END
