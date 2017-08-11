//
//  UCFGoldBankLimitCell.m
//  JRGC
//
//  Created by njw on 2017/8/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldBankLimitCell.h"
#import "UCFGoldLimitedBankModel.h"
#import "UIImageView+WebCache.h"

@interface UCFGoldBankLimitCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankOneLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankDayAddedLimitLabel;

@end

@implementation UCFGoldBankLimitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:self.bankModel.bankLogoUrl]];
    self.bankNameLabel.text = self.bankModel.bankName;
    self.bankOneLimitLabel.text = self.bankModel.bankOneLimt;
    self.bankDayAddedLimitLabel.text = self.bankModel.bankDayLimit;
}

@end
