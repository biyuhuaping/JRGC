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
@end

@implementation RotationButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    RotationButton *rotationButton = [super buttonWithType:buttonType];
    if (rotationButton) {
        [rotationButton initTimer];
    }
    return rotationButton;
}
- (void)initTimer
{
    _fixTelNumTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(telNumTimerFired) userInfo:nil repeats:YES];
    [_fixTelNumTimer setFireDate:[NSDate distantFuture]];
}
- (void)telNumTimerFired
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
