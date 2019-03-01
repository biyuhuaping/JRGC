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
    return @{@"mallDiscounts" : [UCFHomeMalldiscounts class], @"mallRecommends" : [UCFHomeMallrecommends class], @"mallBannerList" : [UCFhomeMallbannerlist class]};
}


@end


@implementation UCFHomeMalldiscounts


@end


@implementation UCFHomeMallrecommends


@end


@implementation UCFhomeMallbannerlist


@end
