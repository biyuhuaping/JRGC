//
//  UCFCalendarDayCell.m
//  JRGC
//
//  Created by njw on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCalendarDayCell.h"
#import "UCFCalendarGroup.h"

@interface UCFCalendarDayCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;


@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTopView;

@property (weak, nonatomic) IBOutlet UILabel *bidNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *payBackMoeny;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *payBackStyle;
@property (weak, nonatomic) IBOutlet UILabel *planPayBackDate;
@property (weak, nonatomic) IBOutlet UILabel *value1;
@property (weak, nonatomic) IBOutlet UILabel *value2;
@property (weak, nonatomic) IBOutlet UILabel *value3;
@property (weak, nonatomic) IBOutlet UIView *middleLineView;
@property (weak, nonatomic) IBOutlet UIView *whiteBaseView;


@end

@implementation UCFCalendarDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
//    self.backgroundColor = [Color color:PGColorOptionTitleLoginRead];
    _whiteBaseView.layer.cornerRadius = 10.0f;
    _whiteBaseView.clipsToBounds = YES;
    _currentDataLab.textColor = [Color color:PGColorOptionTitleGray];
}
- (IBAction)openDetailPayBack:(UIButton *)sender {
    self.group.isOpen = !self.group.isOpen;
    [_tableview reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];    
    _bidNameLab.text = _group.proName;
    _payBackMoeny.text = _group.totalMoney;
    _numLab.text = [NSString stringWithFormat:@"第%@期/共%@期",_group.repayPerNo,_group.count];
    if ([self.group.status intValue] == 0) {
        self.planPayBackDate.hidden = YES;
        self.payBackStyle.text = @"待回款";
        self.payBackStyle.textColor = UIColorWithRGB(0xfd4d4c);
    }
    else if ([self.group.status intValue] == 1) {
        self.payBackStyle.textColor = UIColorWithRGB(0x4aa1f9);
        if ([self.group.isAdvance intValue] == 0) {
            self.planPayBackDate.hidden = YES;
            self.payBackStyle.text = @"已回款";
        }
        else {
            self.planPayBackDate.hidden = NO;
            self.payBackStyle.text = @"提前回款";
            if (self.group.repayPerDate.length>0) {
                NSString *day = [NSString stringWithFormat:@"%@日", [self.group.repayPerDate stringByReplacingOccurrencesOfString:@"-" withString:@"月"]];
                self.planPayBackDate.text = [NSString stringWithFormat:@"计划回款日%@", day];
            }
        }
    }
    if (self.group.isOpen) {
        _middleLineView.hidden = NO;
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        _middleLineView.hidden = YES;
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
    }
    self.value1.text = self.group.principal;
    self.value2.text = self.group.interest;
    self.value3.text = self.group.prepaymentPenalty;


}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _cellTopView.constant = 33;
    } else {
        _cellTopView.constant = 15;
    }
}

@end
