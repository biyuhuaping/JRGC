//
//  UCFNoticeCenterApi.h
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "NoticeCenterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNoticeCenterApi : BaseRequest
- (instancetype)initWithPageSize:(NSString *)pageSize PageIndex:(NSString *)index;
@end

NS_ASSUME_NONNULL_END
