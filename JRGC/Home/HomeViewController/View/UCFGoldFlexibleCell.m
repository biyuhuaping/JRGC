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

- (IBAction)goldBuy:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homelistCell:didClickedBuyButtonWithModel:)]) {
        [self.delegate homelistCell:self didClickedBuyButtonWithModel:self.presenter.item];
    }
}
@end
