//
//  UCFGoldRechargeBankCell.m
//  JRGC
//
//  Created by njw on 2017/8/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeBankCell.h"
#import "UCFGoldBankModel.h"
#import "UIImageView+WebCache.h"

@interface UCFGoldRechargeBankCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitPerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitPerlistLabel;

@end

@implementation UCFGoldRechargeBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorWithRGB(0xebebee);
    self.bankNameLabel.textColor = UIColorWithRGB(0x333333);
    self.userNameLabel.textColor = UIColorWithRGB(0x333333);
    self.bankNoLabel.textColor = UIColorWithRGB(0x333333);
    self.limitPerDayLabel.textColor = UIColorWithRGB(0x555555);
    self.limitPerlistLabel.textColor = UIColorWithRGB(0x555555);

}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.goldBankModel.bankLogoUrl.length > 0) {
        [self.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:self.goldBankModel.bankLogoUrl]];
    }
    self.bankNameLabel.text = self.goldBankModel.bankName;
    self.userNameLabel.text = self.goldBankModel.userBankName;
    self.bankNoLabel.text = self.goldBankModel.userBankCard;
    self.limitPerDayLabel.text = self.goldBankModel.bankDayLimit;
    self.limitPerlistLabel.text = self.goldBankModel.bankOneLimt;
}

@end
