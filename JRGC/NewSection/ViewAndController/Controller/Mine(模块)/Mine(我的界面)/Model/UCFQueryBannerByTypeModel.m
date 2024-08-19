//
//  UCFQueryBannerByTypeModel.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFQueryBannerByTypeModel.h"

@implementation UCFQueryBannerByTypeModel


@end

@implementation UCFQueryBannerByTypeData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"bannerList" : [UCFhomeMallbannerlist class]};
}


@end



