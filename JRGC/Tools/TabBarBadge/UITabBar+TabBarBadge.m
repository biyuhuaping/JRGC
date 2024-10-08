//
//  UITabBar+TabBarBadge.m
//  JRGC
//
//  Created by 金融工场 on 15/11/4.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UITabBar+TabBarBadge.h"
#define TabbarItemNums 5.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (TabBarBadge)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5.100f;//圆形
    badgeView.backgroundColor = UIColorWithRGB(0xf43531);//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index + 0.62) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.06 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10.0, 10.0);//圆形大小为10
    [self addSubview:badgeView];
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
