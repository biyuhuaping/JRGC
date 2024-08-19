//
//  UCFCashGoldTipview.m
//  JRGC
//
//  Created by njw on 2017/8/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCashGoldTipview.h"

@implementation UCFCashGoldTipview

- (IBAction)close:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cashGoldTipViewDidClickedCloseButton:)]) {
        [self.delegate cashGoldTipViewDidClickedCloseButton:sender];
    }
}


@end
