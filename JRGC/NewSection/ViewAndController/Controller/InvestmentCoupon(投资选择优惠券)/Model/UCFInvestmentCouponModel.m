//
//  UCFInvestmentCouponModel.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFInvestmentCouponModel.h"

@implementation UCFInvestmentCouponModel

@end
@implementation InvestmentCouponData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"couponList" : [InvestmentCouponCouponlist class]};
}


@end


@implementation InvestmentCouponCouponlist


@end
