//
//  UCFMallProductApi.m
//  JRGC
//
//  Created by zrc on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMallProductApi.h"
@interface UCFMallProductApi()
@property(nonatomic, copy)NSString *pageType;
@end
@implementation UCFMallProductApi

- (instancetype)initWithPageType:(NSString *)pageType
{
    if (self = [super init]) {
        self.pageType = pageType;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"api/publicMsg/v2/mallProductShow.json";
}
- (id)requestArgument {
    return @{@"pageType":self.pageType};
}
- (NSString *)modelClass
{
    return @"UCFHomeMallDataModel";
}
@end
