//
//  UCFCheckCouponApi.m
//  JRGC
//
//  Created by zrc on 2019/2/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCheckCouponApi.h"

@interface UCFCheckCouponApi ()
@property(nonatomic, copy)NSString *prdclaimid;
@property(nonatomic, copy)NSString *investAmt;
@property(nonatomic, copy)NSString *couponType;
@end

@implementation UCFCheckCouponApi
- (id)initWithPrdclaimid:(NSString *)prdclaimid investAmt:(NSString *)investAmt couponType:(NSString *)couponType type:(SelectAccoutType)type
{
    if (self = [super init]) {
        self.prdclaimid = prdclaimid;
        self.investAmt = investAmt;
        self.couponType = couponType;
        self.apiType = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/api/discountCoupon/v2/queryInvestCouponList.json";
}
- (id)requestArgument {
    return @{@"prdclaimid":self.prdclaimid,@"fromSite":(self.apiType == SelectAccoutTypeP2P ? @"1" : @"2"),@"investAmt":self.investAmt,@"couponType":self.couponType};
}
- (NSString *)modelClass
{
    return @"UCFInvestmentCouponModel";
}
@end
