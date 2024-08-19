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
- (void)setButtonStyle
{
    [self.rechargeButton setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    //切割超出圆角范围的子视图
    self.rechargeButton.layer.masksToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
