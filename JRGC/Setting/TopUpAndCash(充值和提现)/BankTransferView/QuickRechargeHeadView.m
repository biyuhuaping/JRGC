//
//  QuickRechargeHeadView.m
//  JRGC
//
//  Created by zrc on 2018/11/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "QuickRechargeHeadView.h"

@interface QuickRechargeHeadView ()
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@end

@implementation QuickRechargeHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    _rechargeButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
}

- (IBAction)changeBankBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate quickRechargeHeadView:self fixButtonClick:sender];
    }
}
- (IBAction)rechargeButtonClick:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate quickRechargeHeadView:self rechargeButtonClick:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
