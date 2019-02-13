//
//  UCFCheckCouponApi.h
//  JRGC
//
//  Created by zrc on 2019/2/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFCheckCouponApi : BaseRequest

/**
 查询标可用的优惠券列表接口

 @param prdclaimid 标ID
 @param investAmt 投资金额 大于0
 @param couponType 0：返现券  1：返息券
 @param type P2P 或者 尊享
 @return 查询接口
 */
- (id)initWithPrdclaimid:(NSString *)prdclaimid investAmt:(NSString *)investAmt couponType:(NSString *)couponType type:(SelectAccoutType)type;
@end

NS_ASSUME_NONNULL_END
