//
//  UCFBidDetailRequest.h
//  JRGC
//
//  Created by zrc on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFBidDetailRequest : BaseRequest

/**
首页标详情请求接口

 @param projectId 标ID
 @param statue 标状态
 @return 接口
 */
- (id)initWithProjectId:(NSString *)projectId bidState:(NSString *)statue;


/**
 集合标子标详情

 @param projectId 标ID
 @return 接口
 */
- (id)initWithProjectId:(NSString *)projectId;
@end

NS_ASSUME_NONNULL_END
