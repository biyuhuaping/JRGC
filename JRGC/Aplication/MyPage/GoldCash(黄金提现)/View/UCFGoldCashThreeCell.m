//
//  UCFGoldCashThreeCell.m
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashThreeCell.h"

@implementation UCFGoldCashThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)cashButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goldCashcell:didClickCashButton:)]) {
        [self.delegate goldCashcell:self didClickCashButton:sender];
    }
}

@end
