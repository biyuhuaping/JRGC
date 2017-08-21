//
//  UCFGoldFlexibleCell.m
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldFlexibleCell.h"
#import "UCFHomeListCellPresenter.h"
#import "NZLabel.h"
#import "UCFGoldModel.h"

@interface UCFGoldFlexibleCell ()
@property (weak, nonatomic) IBOutlet NZLabel *goldFlexibleRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *minInvestLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;

@end

@implementation UCFGoldFlexibleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    self.goldFlexibleRateLabel.text = presenter.annualRate;
    self.minInvestLabel.text = presenter.minInvest;
    self.completeLabel.text = presenter.completeLoan;
}

- (void)setGoldmodel:(UCFGoldModel *)goldmodel
{
    _goldmodel = goldmodel;
    self.goldFlexibleRateLabel.text = [NSString stringWithFormat:@"%@克/100克", goldmodel.annualRate];
    self.minInvestLabel.text = [NSString stringWithFormat:@"%.3f克起", [goldmodel.minPurchaseAmount doubleValue]];
    self.completeLabel.text = [NSString stringWithFormat:@"已售%@克", goldmodel.totalAmount];
}

- (IBAction)goldBuy:(UIButton *)sender {
    if ([NSStringFromClass([self.delegate class]) isEqualToString:@"UCFGoldenViewController"]) {
        if ([self.delegate respondsToSelector:@selector(goldList:didClickedBuyFilexGoldWithModel:)]) {
            [self.delegate goldList:self didClickedBuyFilexGoldWithModel:self.goldmodel];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(homelistCell:didClickedBuyButtonWithModel:)]) {
            [self.delegate homelistCell:self didClickedBuyButtonWithModel:self.presenter.item];
        }
    }
}
@end
