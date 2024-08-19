//
//  UCFNewCouponList.m
//  JRGC
//
//  Created by zrc on 2019/3/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCouponList.h"
@interface UCFNewCouponList()

@property(nonatomic, copy)NSString *couponType;
@property(nonatomic, copy)NSString *page;
@property(nonatomic, copy)NSString *pageSize;
@property(nonatomic, copy)NSString *statue;

@end

@implementation UCFNewCouponList


- (instancetype)initWithCouponType:(NSString *)couponType CurrentPage:(NSInteger)page PageSize:(NSInteger)pageSize Statue:(NSString *)statue
{
    if (self = [super init]) {
        self.couponType = couponType;
        self.page = [NSString stringWithFormat:@"%ld",page];
        self.pageSize = [NSString stringWithFormat:@"%ld",pageSize];
        self.statue = statue;
    }
    return self;
}
- (NSString *)requestUrl
{
    return @"api/discountCoupon/v2/returnCouponList.json";
}
- (id)requestArgument {
    return @{@"couponType":self.couponType,@"page":self.page,@"pageSize":self.pageSize,@"status":self.statue};
}
- (NSString *)modelClass
{
    return @"UCFCouponListModel";
}
@end
