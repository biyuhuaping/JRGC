//
//  UCFCalendarGroup.m
//  JRGC
//
//  Created by njw on 2017/7/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCalendarGroup.h"

@implementation UCFCalendarGroup
+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
