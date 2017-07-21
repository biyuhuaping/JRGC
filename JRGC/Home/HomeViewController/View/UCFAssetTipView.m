//
//  UCFAssetTipView.m
//  JRGC
//
//  Created by njw on 2017/7/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFAssetTipView.h"

@implementation UCFAssetTipView

- (IBAction)close:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(assetTipViewDidClickedCloseButton:)]) {
        [self.delegate assetTipViewDidClickedCloseButton:sender];
    }
}

@end
