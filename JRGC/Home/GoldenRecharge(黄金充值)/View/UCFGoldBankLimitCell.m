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
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

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

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.upLine.hidden = NO;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upLine.hidden = NO;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 15;
    }
}

@end
