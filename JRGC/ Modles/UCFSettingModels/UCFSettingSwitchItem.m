//
//  UCFSettingSwitchItem.m
//  JRGC
//
//  Created by NJW on 15/4/20.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingSwitchItem.h"

@implementation UCFSettingSwitchItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title withSwitchType:(NSInteger)switchType
{
    UCFSettingSwitchItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.switchType = switchType;
    return item;
}

@end
