//
//  UCFColdChargeThirdCell.m
//  JRGC
//
//  Created by njw on 2017/8/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFColdChargeThirdCell.h"

@implementation UCFColdChargeThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorWithRGB(0xebebee);
}

- (IBAction)recharge:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goldRechargeCell:didClickRechargeButton:)]) {
        [self.delegate goldRechargeCell:self didClickRechargeButton:sender];
    }
}

@end
