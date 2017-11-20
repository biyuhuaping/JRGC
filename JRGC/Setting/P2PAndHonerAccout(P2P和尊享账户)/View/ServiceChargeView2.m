//
//  ServiceChargeView2.m
//  JRGC
//
//  Created by 张瑞超 on 2017/11/16.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "ServiceChargeView2.h"
@interface ServiceChargeView2()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;


@end

@implementation ServiceChargeView2
- (void) awakeFromNib
{
    [super awakeFromNib];
    
//    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), ScreenWidth, 37);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.width.constant = ScreenWidth;
}
@end
