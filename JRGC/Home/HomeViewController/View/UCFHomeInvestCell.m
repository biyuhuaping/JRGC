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
@property (weak, nonatomic) IBOutlet NZLabel *addedTransLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCetnerSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCenterSpace;

@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

@end

@implementation UCFHomeInvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.reserveButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
    self.anurateLabel.textColor = UIColorWithRGB(0xfd4d4c);
    self.leftCetnerSpace.constant = -(ScreenWidth / 5);
    self.rightCenterSpace.constant = ScreenWidth / 4;
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{ 
    _presenter = presenter;
    if (presenter.platformSubsidyExpense.length > 0) {
        self.anurateLabel.text = [NSString stringWithFormat:@"%@~%@%%",presenter.annualRate, presenter.platformSubsidyExpense];
    }
    else {
        self.anurateLabel.text = [NSString stringWithFormat:@"%@",presenter.annualRate];
    }
    
    self.limitLabel.text = [NSString stringWithFormat:@"%@", presenter.appointPeriod];
    self.addedTransLabel.text = [NSString stringWithFormat:@"累计交易%@", presenter.completeLoan];
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
    if (microModel.platformSubsidyExpense.length > 0) {
        self.anurateLabel.text = [NSString stringWithFormat:@"%@%%~%@%%",microModel.annualRate, microModel.platformSubsidyExpense];
    }
    else {
        self.anurateLabel.text = microModel.annualRate ? [NSString stringWithFormat:@"%@%%",microModel.annualRate] : @"0.0%";
    }
    
    self.limitLabel.text = [NSString stringWithFormat:@"%@", microModel.appointPeriod];
    self.addedTransLabel.text = [NSString stringWithFormat:@"累计交易%@亿元", microModel.totleBookAmt];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.presenter.platformSubsidyExpense.length > 0 || self.microModel) {
        [self.anurateLabel setFont:[UIFont boldSystemFontOfSize:15] string:@"%~"];
    }
    [self.anurateLabel setFont:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(self.anurateLabel.text.length - 1, 1)];
    
    [self.addedTransLabel setFontColor:UIColorWithRGB(0x555555) string:@"累计交易"];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSegLine.hidden = NO;
        self.upSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 25;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 25;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 25;
        self.downLineLeftSpace.constant = 25;
    }
}

@end
