//
//  GoldAccountFirstCell.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "GoldAccountFirstCell.h"
#import "UCFToolsMehod.h"
@interface GoldAccountFirstCell ()
@property (weak, nonatomic) IBOutlet UILabel *availableMoenyLab;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsBtn;

@end

@implementation GoldAccountFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.availableMoenyLab.textColor = UIColorWithRGB(0x555555);
}
- (void)updateaVailableMoenyLab:(NSString *)availableMoeny
{
    NSString *showStr = [NSString stringWithFormat:@"%@",[Common checkNullStr:availableMoeny]];
    showStr = [showStr isEqualToString:@""] ? @"0.00" : showStr;
    self.availableMoenyLab.text = [NSString stringWithFormat:@"%@元",[UCFToolsMehod AddComma:showStr]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)recharge:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goldAccountFirstCell:didClickedRechargeButton:)]) {
        [self.delegate goldAccountFirstCell:self didClickedRechargeButton:sender];
    }
}
    
- (IBAction)cash:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goldAccountFirstCell:didClickedCashButton:)]) {
        [self.delegate goldAccountFirstCell:self didClickedCashButton:sender];
    }
}
    @end
