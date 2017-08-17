//
//  UCFSettingItem.m
//  JRGC
//
//  Created by NJW on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingItem.h"

@implementation UCFSettingItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    UCFSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}


+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}
+ (instancetype)itemWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle{
    UCFSettingItem *item = [[self alloc] init];
    item.subtitle = subtitle;
    item.title = title;
    return item;
}
+ (instancetype)itemWithIcon:(NSString *)icon WithTitle:(NSString *)title withSubtitle:(NSString *)subtitle{
    UCFSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.subtitle = subtitle;
    item.title = title;
    return item;
}
@end
