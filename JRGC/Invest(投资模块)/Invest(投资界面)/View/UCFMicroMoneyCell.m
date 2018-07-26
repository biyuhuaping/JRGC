//
//  UCFMicroMoneyCell.m
//  JRGC
//
//  Created by hanqiyuan on 2018/7/25.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFMicroMoneyCell.h"

@implementation UCFMicroMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMicroModel:(UCFMicroMoneyModel *)microModel
{
    _microModel = microModel;
    if (microModel.platformSubsidyExpense.length > 0 && [microModel.platformSubsidyExpense floatValue] != 0)
    {
        self.anurateLabel.text = [NSString stringWithFormat:@"%@%%~%@%%",microModel.annualRate, microModel.platformSubsidyExpense];
    }
    else {
        self.anurateLabel.text = microModel.annualRate ? [NSString stringWithFormat:@"%@%%",microModel.annualRate] : @"0.0%";
    }
    self.limitLabel.text = [NSString stringWithFormat:@"%@", microModel.repayPeriodtext];
    [self.anurateLabel setFont:[UIFont systemFontOfSize:16] string:@"%"];
    self.prdNameLabel.text = microModel.prdName;
    NSUInteger type = [microModel.type integerValue];
    switch (type) {
        case 0://预约
        {
             [self.reserveButton setTitle:@"一键出借" forState:UIControlStateNormal];
        }
            break;
        case 3://智存宝用3
        {
             [self.reserveButton setTitle:@"一键出借" forState:UIControlStateNormal];
        }
            break;
        case 14://批量出借
        {
            [self.reserveButton setTitle:@"批量出借" forState:UIControlStateNormal];
            
        }
            break;
            
        default:
            break;
    }
}
@end
