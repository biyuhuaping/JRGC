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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;
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

@end

@implementation UCFCalendarDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    _middleLineView.hidden = NO;
    if ([self.group.status intValue] == 0) {
        _middleLineView.hidden = YES;
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
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        self.downLine.backgroundColor = UIColorWithRGB(0xe9eaee);
    } else {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
    }
    self.value1.text = self.group.principal;
    self.value2.text = self.group.interest;
    self.value3.text = self.group.prepaymentPenalty;


}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
//    _indexPath = indexPath;
//    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
//    if (totalRows == 1) { // 这组只有1行
//        self.downLine.hidden = NO;
//        self.upLine.hidden = NO;
//        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        self.upLineLeftSpace.constant = 0;
//        self.downLineLeftSpace.constant = 0;
//    } else if (indexPath.row == 0) { // 这组的首行(第0行)
//        self.upLine.hidden = NO;
//        self.downLine.hidden = NO;
//        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.upLineLeftSpace.constant = 0;
//        self.downLineLeftSpace.constant = 15;
//    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
//        self.upLine.hidden = YES;
//        self.downLine.hidden = NO;
//        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        self.upLineLeftSpace.constant = 15;
//        self.downLineLeftSpace.constant = 0;
//    } else {
//        self.upLine.hidden = YES;
//        self.downLine.hidden = NO;
//        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.upLineLeftSpace.constant = 15;
//        self.downLineLeftSpace.constant = 15;
//    }
}

@end
