//
//  UCFGoldMoneyBoadCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldMoneyBoadCell.h"

@interface UCFGoldMoneyBoadCell()

@property (weak, nonatomic) IBOutlet UIButton *GoldCalculatorView;
@property (weak, nonatomic) IBOutlet UISwitch *goldSwitch;
- (IBAction)clickGoldRechargeButton:(id)sender;
- (IBAction)clickAllInvestmentBtn:(id)sender;
- (IBAction)clickGoldSwitch:(UISwitch *)sender;


- (IBAction)showGoldCalculatorView:(id)sender;
@end
@implementation UCFGoldMoneyBoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickGoldRechargeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoGoldRechargeVC)]) {
        [self.delegate gotoGoldRechargeVC];
    }
}

- (IBAction)clickAllInvestmentBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAllInvestmentBtn)]) {
        [self.delegate clickAllInvestmentBtn];
    }
}

- (IBAction)clickGoldSwitch:(UISwitch *)sender{
}

- (IBAction)showGoldCalculatorView:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showGoldCalculatorView)]) {
        [self.delegate showGoldCalculatorView];
    }
    
}
@end
