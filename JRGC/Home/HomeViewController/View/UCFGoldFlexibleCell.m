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
#import "UCFProjectLabel.h"

@interface UCFGoldFlexibleCell ()
@property (weak, nonatomic) IBOutlet NZLabel *goldFlexibleRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *minInvestLabel;
@property (weak, nonatomic) IBOutlet NZLabel *completeLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *proSignLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyButtonW;
@property (weak, nonatomic) IBOutlet UIView *proSignBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proSignBackViewW;

@end

@implementation UCFGoldFlexibleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.proSignBackView.backgroundColor = UIColorWithRGB(0xffecc5);
    self.proSignLabel.textColor = UIColorWithRGB(0xffa550);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.goldFlexibleRateLabel setFont:[UIFont boldSystemFontOfSize:15] string:@"%"];
    [self.completeLabel setFontColor:UIColorWithRGB(0x555555) string:@"已售"];
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    self.goldFlexibleRateLabel.text = presenter.annualRate;
    self.minInvestLabel.text = presenter.minInvest;
    self.completeLabel.text = presenter.completeLoan;
    
    if (presenter.status == 1) {
        self.buyButton.enabled = YES;
        self.buyButtonW.constant = 60;
        [self.buyButton setBackgroundColor:UIColorWithRGB(0xffc027)];
    }
    else {
        self.buyButton.enabled = NO;
        self.buyButtonW.constant = 100;
        [self.buyButton setBackgroundColor:UIColorWithRGB(0xcccccc)];
    }
    
    if (presenter.item.prdLabelsList.count > 0) {
        UCFProjectLabel *projectLabel = [presenter.item.prdLabelsList firstObject];
        if ([projectLabel.labelPriority integerValue] == 1) {
            self.proSignBackView.hidden = NO;
            self.proSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            CGSize size = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
            self.proSignBackViewW.constant = size.width + 11;
        }
        else {
            self.proSignBackView.hidden = YES;
            self.proSignBackViewW.constant = 0;
        }
    }
    else {
        self.proSignBackView.hidden = YES;
        self.proSignBackViewW.constant = 0;
    }
}

- (void)setGoldmodel:(UCFGoldModel *)goldmodel
{
    _goldmodel = goldmodel;
    self.goldFlexibleRateLabel.text = [NSString stringWithFormat:@"%.2lf%%", [goldmodel.annualRate doubleValue]];
    [self.goldFlexibleRateLabel setFont:[UIFont boldSystemFontOfSize:12] string:@"%"];
    self.minInvestLabel.text = [NSString stringWithFormat:@"%.3f克起购", [goldmodel.minPurchaseAmount doubleValue]];
    self.completeLabel.text = [NSString stringWithFormat:@"已售%@克", goldmodel.totalAmount];
    if (goldmodel.status.intValue == 1) {
        self.buyButton.enabled = YES;
        self.buyButtonW.constant = 60;
        [self.buyButton setBackgroundColor:UIColorWithRGB(0xffc027)];
    }
    else {
        self.buyButton.enabled = NO;
        self.buyButtonW.constant = 100;
        [self.buyButton setBackgroundColor:UIColorWithRGB(0xcccccc)];
    }
    if (goldmodel.prdLabelsList.count > 0) {
        UCFProjectLabel *projectLabel = [goldmodel.prdLabelsList firstObject];
        if ([projectLabel.labelPriority integerValue] == 1) {
            self.proSignBackView.hidden = NO;
            self.proSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            CGSize size = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
            self.proSignBackViewW.constant = size.width + 11;
        }
        else {
            self.proSignBackView.hidden = YES;
            self.proSignBackViewW.constant = 0;
        }
    }
    else {
        self.proSignBackView.hidden = YES;
        self.proSignBackViewW.constant = 0;
    }
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
