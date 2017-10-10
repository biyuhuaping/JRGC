//
//  UCFNewUserCell.m
//  JRGC
//
//  Created by njw on 2017/9/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFNewUserCell.h"
#import "UCFHomeListCellPresenter.h"
#import "NZLabel.h"

@interface UCFNewUserCell ()
@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *desc1Label;
@property (weak, nonatomic) IBOutlet UILabel *desc2Label;
@property (weak, nonatomic) IBOutlet UILabel *desc3Label;

@property (weak, nonatomic) IBOutlet NZLabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *backModeLabel;
@end

@implementation UCFNewUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.okButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
    self.rateLabel.textColor = UIColorWithRGB(0xfd4d4c);
    self.limitLabel.textColor = UIColorWithRGB(0x555555);
    self.backModeLabel.textColor = UIColorWithRGB(0x555555);
    self.desc1Label.textColor = UIColorWithRGB(0x999999);
    self.desc2Label.textColor = UIColorWithRGB(0x999999);
    self.desc3Label.textColor = UIColorWithRGB(0x999999);
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(newUserCell:didClickedRegisterButton:withModel:)]) {
        [self.delegate newUserCell:self didClickedRegisterButton:sender withModel:self.presenter.item];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSegLine.hidden = YES;
        self.upSegLine.hidden = NO;
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

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    self.rateLabel.text = presenter.annualRate;
    if (presenter.holdTime.length > 0) {
        self.limitLabel.text = [NSString stringWithFormat:@"%@~%@", presenter.holdTime, presenter.repayPeriodtext];
    }
    else {
        self.limitLabel.text = [NSString stringWithFormat:@"%@", presenter.repayPeriodtext];
    }
    self.backModeLabel.text = presenter.repayModeText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.rateLabel setFont:[UIFont boldSystemFontOfSize:15] string:@"%"];
}

@end
