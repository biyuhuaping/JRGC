//
//  CoustomLab.m
//  JRGC
//
//  Created by 张瑞超 on 2017/8/25.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "CoustomLab.h"

@implementation CoustomLab
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.center = CGPointMake(self.superview.center.x, self.center.y);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
