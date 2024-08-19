//
//  UCFQueryBannerByTypeAPI.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFQueryBannerByTypeAPI : BaseRequest
- (id)initWithBannerType:(NSInteger )type;//17：个人中心banner 8:首页banner 9:首页工贝banner 16:首页推荐banner
@end

NS_ASSUME_NONNULL_END
