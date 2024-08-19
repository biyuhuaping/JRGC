//
//  UCFCouponListModel.m
//  JRGC
//
//  Created by zrc on 2019/3/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCouponListModel.h"

@implementation UCFCouponListModel


@end

@implementation UCFCouponListDataModel


@end


@implementation UCFCouponPagedataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"result" : [UCFCouponListResult class]};
}


@end


@implementation UCFcouponListPagination


@end


@implementation UCFCouponListResult


@end

