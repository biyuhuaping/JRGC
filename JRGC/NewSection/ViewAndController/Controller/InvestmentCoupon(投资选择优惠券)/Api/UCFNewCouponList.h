//
//  UCFNewCouponList.h
//  JRGC
//
//  Created by zrc on 2019/3/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "UCFCouponListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewCouponList : BaseRequest


- (instancetype)initWithCouponType:(NSString *)couponType CurrentPage:(NSInteger)page PageSize:(NSInteger)pageSize Statue:(NSString *)statue;

@end

NS_ASSUME_NONNULL_END
