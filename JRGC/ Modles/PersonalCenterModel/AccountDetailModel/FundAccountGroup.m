//
//  FundAccountGroup.m
//  SectionDemo
//
//  Created by NJW on 15/4/23.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import "FundAccountGroup.h"
#import "FundAccountItem.h"

@implementation FundAccountGroup
+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理friends属性
        NSMutableArray *fundList = [NSMutableArray array];
        for (NSDictionary *dict in self.fundlist) {
            FundAccountItem *funditem = [FundAccountItem fundWithDict:dict];
            [fundList addObject:funditem];
        }
        self.fundlist = fundList;
    }
    return self;
}
@end
