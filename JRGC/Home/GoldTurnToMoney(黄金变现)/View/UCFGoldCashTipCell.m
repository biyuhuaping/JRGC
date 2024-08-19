//
//  UCFGoldCashTipCell.m
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashTipCell.h"
#import "UCFGoldCashModel.h"
#import "NZLabel.h"

@interface UCFGoldCashTipCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;
@property (weak, nonatomic) IBOutlet NZLabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLeftSpace;

@end

@implementation UCFGoldCashTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.dotImageView.hidden = !self.goldCashModel.isShowBlackDot;
    self.tipLeftSpace.constant = self.goldCashModel.isShowBlackDot ? 25 : 15;
    self.tipLabel.text = self.goldCashModel.tipString;
    if (self.goldCashModel.changeColorStrs.count > 0) {
        for (NSString *str in self.goldCashModel.changeColorStrs) {
            [self.tipLabel setFontColor:UIColorWithRGB(0xfc8f0e) string:str];
        }
    }
}

@end
