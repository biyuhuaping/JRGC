//
//  UCFSettingArrowItem.m
//  JRGC
//
//  Created by NJW on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingArrowItem.h"

@implementation UCFSettingArrowItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    UCFSettingArrowItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destStoryBoardStr:(NSString *)mainStoryBoard storyIdStr:(NSString *)storyIdStr
{
    UCFSettingArrowItem *item = [self itemWithIcon:icon title:title];
    item.mainStoryBoardStr = mainStoryBoard;
    item.storyId = storyIdStr;
    return item;
}

@end
