//
//  UCFGoldCashButtonCell.m
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashButtonCell.h"

@implementation UCFGoldCashButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)cashGold:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goldCashcell:didClickCashGoldButton:)]) {
        [self.delegate goldCashcell:self didClickCashGoldButton:sender];
    }
}

@end
