//
//  UCFAveragePriceDetailView.m
//  JRGC
//
//  Created by njw on 2017/8/25.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFAveragePriceDetailView.h"

@implementation UCFAveragePriceDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)close:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(averageDetaiViewTipViewDidClickedCloseButton:)]) {
        [self.delegate averageDetaiViewTipViewDidClickedCloseButton:sender];
    }
}

@end
