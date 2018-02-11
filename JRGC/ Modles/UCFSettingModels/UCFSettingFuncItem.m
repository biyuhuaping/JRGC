//
//  UCFSettingFuncItem.m
//  JRGC
//
//  Created by njw on 2018/2/2.
//  Copyright © 2018年 qinwei. All rights reserved.
//

#import "UCFSettingFuncItem.h"

@implementation UCFSettingFuncItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    UCFSettingFuncItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}

@end
