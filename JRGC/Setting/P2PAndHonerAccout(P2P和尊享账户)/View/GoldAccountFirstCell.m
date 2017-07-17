//
//  GoldAccountFirstCell.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "GoldAccountFirstCell.h"

@interface GoldAccountFirstCell ()
@property (weak, nonatomic) IBOutlet UILabel *availableMoenyLab;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneySpace;

@end

@implementation GoldAccountFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneySpace.constant = (ScreenWidth/320.0f) * 98.0f;
    self.availableMoenyLab.textColor = UIColorWithRGB(0x555555);

}
- (void)updateaVailableMoenyLab:(NSString *)availableMoeny
{
    self.availableMoenyLab.text = [NSString stringWithFormat:@"￥%@",availableMoeny];
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
