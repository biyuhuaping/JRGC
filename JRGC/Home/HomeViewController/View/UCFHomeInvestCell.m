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

@interface UCFHomeInvestCell ()
@property (weak, nonatomic) IBOutlet NZLabel *anurateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayPeroid;

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
    if ([self.delegate respondsToSelector:@selector(homeInvestCell:didClickedInvestButtonAtIndexPath:)]) {
        [self.delegate homeInvestCell:self didClickedInvestButtonAtIndexPath:self.indexPath];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.anurateLabel setFont:[UIFont systemFontOfSize:12] string:@"%"];
}

@end
