//
//  UIView+RoundingCorners.m
//  JRGC
//
//  Created by zrc on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UIView+RoundingCorners.h"

@implementation UIView (RoundingCorners)

- (void)rc_bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
