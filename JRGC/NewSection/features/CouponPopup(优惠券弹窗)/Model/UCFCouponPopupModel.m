//
//  UCFCouponPopupModel.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/13.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponPopupModel.h"

@implementation UCFCouponPopupModel


@end

@implementation UCFCouponPopupData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"couponList" : [UCFCouponPopupCouponlist class]};
}


@end


@implementation UCFCouponPopupCouponlist


@end



