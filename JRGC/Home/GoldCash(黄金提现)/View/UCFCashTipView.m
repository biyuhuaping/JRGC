//
//  UCFCashTipView.m
//  JRGC
//
//  Created by njw on 2017/7/26.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCashTipView.h"

@implementation UCFCashTipView



- (IBAction)okButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cashTipView:didClickedButton:)]) {
        [self.delegate cashTipView:self didClickedButton:sender];
    }
}

- (IBAction)closeButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cashTipView:didClickedButton:)]) {
        [self.delegate cashTipView:self didClickedButton:sender];
    }
}
@end
