//
//  BankLogoSectionTableViewCell.m
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BankLogoSectionTableViewCell.h"

@implementation BankLogoSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate bankLogoSectionTableViewCell:self withClickbutton:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
