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
@end
