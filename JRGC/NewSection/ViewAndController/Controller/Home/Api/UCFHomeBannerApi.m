//
//  UCFHomeBannerApi.m
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHomeBannerApi.h"
#import "UCFNewBannerModel.h"
@implementation UCFHomeBannerApi
- (NSString *)requestUrl
{
    return @"/api/homePage/v2/bannerAndNoice.json";
}
- (id)requestArgument {
    return nil;
}
- (NSString *)modelClass
{
    return NSStringFromClass([UCFNewBannerModel class]);
//    return [UCFBannerViewModel class];
}
@end
