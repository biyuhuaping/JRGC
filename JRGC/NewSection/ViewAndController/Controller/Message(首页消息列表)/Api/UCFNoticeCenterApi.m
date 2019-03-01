//
//  UCFNoticeCenterApi.m
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNoticeCenterApi.h"
@interface UCFNoticeCenterApi()
@property(nonatomic, copy)NSString *pageSize;
@property(nonatomic, copy)NSString *pageIndex;
@end


@implementation UCFNoticeCenterApi
- (instancetype)initWithPageSize:(NSString *)pageSize PageIndex:(NSString *)index
{
    if (self = [super init]) {
        self.pageSize = pageSize;
        self.pageIndex = index;
    }
    return self;
}
- (NSString *)requestUrl
{
    return @"api/publicMsg/v2/noviceCenter.json";
}
- (id)requestArgument {
    return @{@"page":self.pageIndex,@"pageSize":self.pageSize};
}
- (NSString *)modelClass
{
    return NSStringFromClass([NoticeCenterModel class]);
}
@end
