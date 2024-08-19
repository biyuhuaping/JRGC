//
//  UCFUserAllStatueRequest.h
//  JRGC
//
//  Created by zrc on 2019/2/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFUserAllStatueRequest : BaseRequest

/**
 获取用户状态接口

 @param userId 用户ID 可省略 因为基类对已登录用户，默认添加用户id接口
 @return 用户状态
 */
- (instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
