//
//  RotationButton.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/25.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "RotationButton.h"
#import "HWWeakTimer.h"
@interface RotationButton ()
@property (nonatomic, strong)NSTimer *fixTelNumTimer;
@property (nonatomic, assign)CGFloat angle;
@end

@implementation RotationButton
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initTimer];
////    self.layer.anchorPoint = self.center;
//    self.backgroundColor = [UIColor redColor];
}

- (void)initTimer
{
    _fixTelNumTimer = [HWWeakTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(telNumTimerFired) userInfo:nil repeats:YES];
    [_fixTelNumTimer setFireDate:[NSDate distantFuture]];
}
- (void)telNumTimerFired
{
    _angle = _angle + 0.01;//angle旋转的角度,随着NSTimer增大
    self.transform = CGAffineTransformMakeRotation(_angle);
}
- (void)buttonBeginTransform{
    _angle = 0.0f;
    _fixTelNumTimer.fireDate = [NSDate distantPast];
}
- (void)buttonEndTransform
{
    _fixTelNumTimer.fireDate = [NSDate distantFuture];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
