//
//  UCFMallProductApi.h
//  JRGC
//
//  Created by zrc on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "UCFHomeMallDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFMallProductApi : BaseRequest

/**
 商城接口

 @param pageType home:个人中心  index:首页
 @return 商城接口
 */
- (instancetype)initWithPageType:(NSString *)pageType;
@end

NS_ASSUME_NONNULL_END
