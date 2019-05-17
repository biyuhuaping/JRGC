//
//  UCFCouponExchangeToFriendTableViewCell.m
//  JRGC
//
//  Created by 狂战之巅 on 16/11/8.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFCouponExchangeToFriendTableViewCell.h"

@implementation UCFCouponExchangeToFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [Color color:PGColorOptionThemeWhite];
    self.nameLabel.textColor = [Color color:PGColorOptionTitleBlack];
    self.phoneNumber.textColor = [Color color:PGColorOptionTitleGray];
    self.blueBtn.textColor = [Color color:PGColorOptionCellContentBlue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
