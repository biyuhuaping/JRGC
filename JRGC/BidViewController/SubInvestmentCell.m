//
//  SubInvestmentCell.m
//  JRGC
//
//  Created by 金融工场 on 15/6/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "SubInvestmentCell.h"

@implementation SubInvestmentCell

- (IBAction)checkUserRate:(id)sender {
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
//    self.progressLab.textColor = UIColorWithRGB(0x333333);
//    self.progressLab.frame = CGRectMake(CGRectGetMinX(self.progressLab.frame), CGRectGetMinY(self.repayPeriodLab.frame), CGRectGetWidth(self.progressLab.frame), CGRectGetHeight(self.repayPeriodLab.frame));
//    self.progressLab.font = [UIFont systemFontOfSize:13.0f];
    self.remainingLab.font = [UIFont boldSystemFontOfSize:12.0f];
    if (self.accoutType == SelectAccoutTypeHoner) {
        self.minInvestLab.text =  self.repayModeLab.text;
        self.repayModeLab.hidden = YES;
    }else{
        self.repayModeLab.hidden = NO;
    }
}
@end
