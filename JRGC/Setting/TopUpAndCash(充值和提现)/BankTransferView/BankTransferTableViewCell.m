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
  
}
- (void)setSecondLabelText:(NSString *)str
{
    _secondLab.text = str;
    [_secondLab setFontColor:UIColorWithRGB(0x4aa1f9) string:[UserInfoSingle sharedManager].bankNumTip];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
