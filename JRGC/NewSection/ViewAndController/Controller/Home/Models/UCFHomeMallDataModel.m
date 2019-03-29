//
//  UCFHomeMallDataModel.m
//  JRGC
//
//  Created by zrc on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHomeMallDataModel.h"

@implementation UCFHomeMallDataModel


@end

@implementation UCFMallDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"mallSale" : [UCFHomeMallsale class], @"mallRecommends" : [UCFHomeMallrecommends class], @"mallBannerList" : [UCFhomeMallbannerlist class],@"mallSelected":[UCFHomeMallsale class],@"mallDiscounts":[UCFHomeMallrecommends class]};
}


@end


@implementation UCFHomeMallsale


@end


@implementation UCFHomeMallrecommends


@end


@implementation UCFhomeMallbannerlist


@end
