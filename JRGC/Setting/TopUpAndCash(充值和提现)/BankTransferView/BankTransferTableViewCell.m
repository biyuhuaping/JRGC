//
//  BankTransferTableViewCell.m
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BankTransferTableViewCell.h"
#import "UILabel+Misc.h"
@interface BankTransferTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;

@end

@implementation BankTransferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_firstLab setLineSpace:5 string:_firstLab.text];
    [_secondLab setLineSpace:5 string:_secondLab.text];
    [_secondLab setFontColor:[UIColor blueColor] string:@"尾号(0000)的建设银行"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
