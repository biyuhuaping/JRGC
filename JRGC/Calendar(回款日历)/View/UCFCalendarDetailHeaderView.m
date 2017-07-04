//
//  UCFCalendarDetailHeaderView.m
//  TestCalenar
//
//  Created by njw on 2017/7/2.
//  Copyright © 2017年 njw. All rights reserved.
//

#import "UCFCalendarDetailHeaderView.h"
#import "UCFCalendarGroup.h"

@interface UCFCalendarDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UILabel *proNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusILabel;
@property (weak, nonatomic) IBOutlet UILabel *statusIILabel;


@end

@implementation UCFCalendarDetailHeaderView

- (IBAction)button:(UIButton *)sender {
    // 1.修改组模型的标记(状态取反)
    self.group.opened = !self.group.isOpened;
    
    // 2.刷新表格
    if ([self.delegate respondsToSelector:@selector(calendarDetailHeaderView:didClicked:)]) {
        [self.delegate calendarDetailHeaderView:self didClicked:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.group.opened) {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
    } else {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
}

- (void)setGroup:(UCFCalendarGroup *)group
{
    _group = group;
    self.proNameLabel.text = self.group.proName;
    self.totalMoneyLabel.text = self.group.totalMoney;
    self.timeLabel.text = [NSString stringWithFormat:@"第%@期/共%@期", self.group.repayPerNo, self.group.count];
    if ([self.group.status intValue] == 0) {
        self.statusIILabel.hidden = YES;
        self.statusILabel.text = @"待回款";
        self.statusILabel.textColor = UIColorWithRGB(0xfd4d4c);
    }
    else if ([self.group.status intValue] == 1) {
        self.statusILabel.textColor = UIColorWithRGB(0x4aa1f9);
        if ([self.group.isAdvance intValue] == 0) {
            self.statusIILabel.hidden = YES;
            self.statusILabel.text = @"已回款";
        }
        else {
            self.statusIILabel.hidden = NO;
            self.statusILabel.text = @"提前回款";
            if (self.group.repayPerDate.length>0) {
                NSString *day = [NSString stringWithFormat:@"%@日", [self.group.repayPerDate stringByReplacingOccurrencesOfString:@"-" withString:@"月"]];
                self.statusIILabel.text = [NSString stringWithFormat:@"计划回款日%@", day];
            }
        }
    }
}

@end
