//
//  UCFUserInfoListItem.m
//  JRGC
//
//  Created by njw on 2017/5/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInfoListItem.h"

@implementation UCFUserInfoListItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    UCFUserInfoListItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}
@end
