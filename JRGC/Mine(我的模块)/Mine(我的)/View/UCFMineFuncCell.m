//
//  UCFMineFuncCell.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineFuncCell.h"

@implementation UCFMineFuncCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)calendar:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineFuncCell:didClickedCalendarButton:)]) {
        [self.delegate mineFuncCell:self didClickedCalendarButton:sender];
    }
}

- (IBAction)myReserved:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineFuncCell:didClickedMyReservedButton:)]) {
        [self.delegate mineFuncCell:self didClickedMyReservedButton:sender];
    }
}


@end
