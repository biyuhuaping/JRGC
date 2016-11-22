//
//  GFWaterView.m
//  PulsingHaloDemo
//
//  Created by 秦 on 16/8/18.
//  Copyright © 2016年 Shuichi Tsutsumi. All rights reserved.
//

#import "GFWaterView.h"

@implementation GFWaterView

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // 半径
    CGFloat rabius = self.rabiuS;
    // 开始角
    CGFloat startAngle = 0;
    
    // 中心点
    CGPoint point = self.centerPoint;  // 中心店我手动写的,你看看怎么弄合适 自己在搞一下
    
    // 结束角
    CGFloat endAngle = 2*M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;       // 添加路径 下面三个同理
    layer.lineWidth = 3;
    layer.strokeColor = UIColorWithRGB(0x00c6ff).CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    
    [self.layer addSublayer:layer];
    
}
//-(void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    [[UIColor grayColor] setFill];
//    UIRectFill(rect);
//    NSInteger pulsingCount = 5;
//    double animationDuration = 3;
//    CALayer * animationLayer = [CALayer layer];
//    for (int i = 0; i < pulsingCount; i++) {
//        CALayer * pulsingLayer = [CALayer layer];
//        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
//        pulsingLayer.borderColor = [UIColor whiteColor].CGColor;
//        pulsingLayer.borderWidth = 1;
//        pulsingLayer.cornerRadius = rect.size.height / 2;
//        
//        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//        
//        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
//        animationGroup.fillMode = kCAFillModeBackwards;
//        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
//        animationGroup.duration = animationDuration;
//        animationGroup.repeatCount = HUGE;
//        animationGroup.timingFunction = defaultCurve;
//        
//        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        scaleAnimation.fromValue = @1.4;
//        scaleAnimation.toValue = @2.2;
//        
//        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
//        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
//        
//        animationGroup.animations = @[scaleAnimation, opacityAnimation];
//        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
//        [animationLayer addSublayer:pulsingLayer];
//    }
//    [self.layer addSublayer:animationLayer];
//}

@end