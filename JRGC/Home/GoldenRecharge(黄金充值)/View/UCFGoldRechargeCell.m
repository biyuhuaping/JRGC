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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blackDotW;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation UCFGoldRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(UCFGoldRechargeModel *)model
{
    _model = model;
    if (model.isShowBlackDot) {
        self.blackDotW.constant = 10;
    }
    else {
        self.blackDotW.constant = 0;
    }
    self.tipLabel.text = model.tipString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
