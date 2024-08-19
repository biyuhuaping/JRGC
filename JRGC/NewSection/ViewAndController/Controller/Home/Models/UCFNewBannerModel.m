//
//  UCFNewBannerModel.m
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBannerModel.h"

@implementation UCFNewBannerModel




@end


@implementation Data

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"giftBanner" : [Giftbanner class], @"banner" : [Banner class], @"recommendBanner" : [RecommendBanner class],@"coinBanner":[CoinBanner class]};
}


@end


@implementation Sitenoticemap


@end


@implementation Giftbanner


@end


@implementation Banner


@end

@implementation RecommendBanner



@end

@implementation CoinBanner



@end
