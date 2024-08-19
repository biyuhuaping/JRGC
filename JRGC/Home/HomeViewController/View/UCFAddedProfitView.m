//
//  UCFAddedProfitView.m
//  JRGC
//
//  Created by njw on 2017/8/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFAddedProfitView.h"

@implementation UCFAddedProfitView
- (IBAction)closeProfitClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addedProfitTipViewDidClickedCloseButton:)]) {
        [self.delegate addedProfitTipViewDidClickedCloseButton:sender];
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
