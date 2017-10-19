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
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedTransLabel;

@end

@implementation UCFHomeInvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.reserveButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    self.anurateLabel.text = presenter.annualRate;
    if (presenter.holdTime.length > 0) {
        self.limitLabel.text = [NSString stringWithFormat:@"期限%@~%@", presenter.holdTime, presenter.repayPeriodtext];
    }
    else {
        self.limitLabel.text = [NSString stringWithFormat:@"期限%@", presenter.repayPeriodtext];
    }
    self.addedTransLabel.text = [NSString stringWithFormat:@"%@", presenter.completeLoan];
    self.minLabel.text = [NSString stringWithFormat:@"%@", presenter.minInvest];
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
    if (microModel.holdTime.length > 0) {
        self.limitLabel.text = [NSString stringWithFormat:@"期限%@~%@", microModel.holdTime, microModel.repayPeriodtext];
    }
    else {
        self.limitLabel.text = [NSString stringWithFormat:@"期限%@", microModel.repayPeriodtext];
    }
    self.addedTransLabel.text = [NSString stringWithFormat:@"%@亿元", microModel.totleBookAmt];
    self.minLabel.text = [NSString stringWithFormat:@"%@元起", microModel.minInvest];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.anurateLabel setFont:[UIFont boldSystemFontOfSize:15] string:@"%"];
}

@end
