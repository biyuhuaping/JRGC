//
//  UCFHomeInvestCell.m
//  JRGC
//
//  Created by njw on 2017/7/31.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeInvestCell.h"
#import "UCFHomeListCellPresenter.h"
#import "NZLabel.h"
#import "UCFMicroMoneyModel.h"

@interface UCFHomeInvestCell ()
@property (weak, nonatomic) IBOutlet NZLabel *anurateLabel;
@property (weak, nonatomic) IBOutlet NZLabel *repayPeroid;

@end

@implementation UCFHomeInvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    self.anurateLabel.text = presenter.annualRate;
    self.repayPeroid.text = presenter.repayPeriod;
}

- (IBAction)reserveForSomeone:(UIButton *)sender {
    if ([NSStringFromClass([self.delegate class]) isEqualToString:@"UCFMicroMoneyViewController"]) {
        if ([self.delegate respondsToSelector:@selector(microMoneyListCell:didClickedInvestButtonWithModel:)]) {
            [self.delegate microMoneyListCell:self didClickedInvestButtonWithModel:self.microModel];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(homeInvestCell:didClickedInvestButtonAtIndexPath:)]) {
            [self.delegate homeInvestCell:self didClickedInvestButtonAtIndexPath:self.indexPath];
        }
    }
}

- (void)setMicroModel:(UCFMicroMoneyModel *)microModel
{
    _microModel = microModel;
    self.anurateLabel.text = microModel.annualRate ? [NSString stringWithFormat:@"%@%%",microModel.annualRate] : @"0.0%";
    self.repayPeroid.text = microModel.repayPeriodtext;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.anurateLabel setFont:[UIFont systemFontOfSize:12] string:@"%"];
    [self.repayPeroid setFont:[UIFont systemFontOfSize:12] string:@"天"];
}

@end
