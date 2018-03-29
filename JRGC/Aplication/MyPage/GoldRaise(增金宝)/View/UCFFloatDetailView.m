//
//  UCFFloatDetailView.m
//  JRGC
//
//  Created by njw on 2017/8/25.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFFloatDetailView.h"

@implementation UCFFloatDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)close:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(curentViewTipViewDidClickedCloseButton:)]) {
        [self.delegate curentViewTipViewDidClickedCloseButton:sender];
    }
}

@end
