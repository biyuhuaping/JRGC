//
//  BankTraIntroduceTableViewCell.m
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BankTraIntroduceTableViewCell.h"

@interface BankTraIntroduceTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;

@end

@implementation BankTraIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lab1.textColor = _lab2.textColor =_lab3.textColor = UIColorWithRGB(0x999999);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
