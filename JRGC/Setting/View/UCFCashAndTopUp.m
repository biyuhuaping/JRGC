//
//  UCFCashAndTopUp.m
//  JRGC
//
//  Created by NJW on 16/4/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFCashAndTopUp.h"

@interface UCFCashAndTopUp ()
@property (weak, nonatomic) IBOutlet UIButton *cash;
@property (weak, nonatomic) IBOutlet UIButton *topUp;

@end

@implementation UCFCashAndTopUp

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置提现和充值的按钮
    UIImage *normalImageForCash = [[UIImage imageNamed:@"btn_bule_v"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
    UIImage *highlightImageForCash = [[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
    [self.cash setBackgroundImage:normalImageForCash forState:UIControlStateNormal];
    [self.cash setBackgroundImage:highlightImageForCash forState:UIControlStateHighlighted];
    
    UIImage *normalImageForTopUp = [[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
    UIImage *highlightImageForTopUp = [[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
    [self.topUp setBackgroundImage:normalImageForTopUp forState:UIControlStateNormal];
    [self.topUp setBackgroundImage:highlightImageForTopUp forState:UIControlStateHighlighted];
}

- (IBAction)cash:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cashAndTopUp:didClickedCashButton:)]) {
        [self.delegate cashAndTopUp:self didClickedCashButton:self.cash];
    }
}

- (IBAction)topUp:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cashAndTopUp:didClickedTopUpButton:)]) {
        [self.delegate cashAndTopUp:self didClickedTopUpButton:sender];
    }
}

@end
