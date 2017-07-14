//
//  UCFGoldRechargeCell.m
//  JRGC
//
//  Created by njw on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeCell.h"
#import "UCFGoldRechargeModel.h"

@interface UCFGoldRechargeCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipStringLeftSpace;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *blackDot;

@end

@implementation UCFGoldRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(UCFGoldRechargeModel *)model
{
    _model = model;
    if (model.isShowBlackDot) {
        self.tipStringLeftSpace.constant = 25;
        self.blackDot.hidden = NO;
    }
    else {
        self.blackDot.hidden = YES;
        self.tipStringLeftSpace.constant = 15;
    }
    self.tipLabel.text = model.tipString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
