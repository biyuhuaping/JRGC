//
//  UITabBar+TabBarBadge.h
//  JRGC
//
//  Created by 金融工场 on 15/11/4.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (TabBarBadge)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
