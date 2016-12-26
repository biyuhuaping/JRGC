//
//  CWFinishedView.m
//  CloudWalkFaceForDev
//
//  Created by DengWuPing on 15/7/17.
//  Copyright (c) 2015年 dengwuping. All rights reserved.
//

#import "CWFinishedView.h"

@implementation CWFinishedView

#pragma mark
#pragma mark-----------   awakeFromNib
//全屏显示
- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].bounds;
}

#pragma mark
#pragma mark-----------   showAnimation //画圆
/**
 *  @brief 画圆
 *
 *  @param color 圆的颜色
 
-(void)showAnimation:(UIColor *)color
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_errorView.frame.size.width/2,_errorView.frame.size.width/2) radius:60 startAngle:0 endAngle:2*M_PI clockwise:NO];
    CAShapeLayer * arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor= color.CGColor;
    arcLayer.lineWidth=3;
    arcLayer.frame=self.frame;
    [_errorView.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];
}
*/
#pragma mark
#pragma mark-----------   drawLineAnimation //画圆的动画
/**
 *  @brief 画圆的动画
 *
 *  @param layer 动画layer添加
 */
- (void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 0.6;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
