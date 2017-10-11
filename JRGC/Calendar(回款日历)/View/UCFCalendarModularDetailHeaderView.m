//
//  UCFCalendarModularDetailHeaderView.m
//  JRGC
//
//  Created by 张瑞超 on 2017/10/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCalendarModularDetailHeaderView.h"
#import "UCFCalendarGroup.h"
#import "UCFNoDataView.h"
@interface UCFCalendarModularDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UILabel *proNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusILabel;
@property (weak, nonatomic) IBOutlet UILabel *statusIILabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (strong, nonatomic)  UCFNoDataView *nodataview;
@property (weak, nonatomic) UIView *upLine;
@property (weak, nonatomic) UIView *downLine;
@end
@implementation UCFCalendarModularDetailHeaderView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) errorTitle:@"本日无回款项目"];
    [self addSubview:noDataView];
    self.nodataview = noDataView;
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectZero];
    upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self addSubview:upLine];
    self.upLine = upLine;
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectZero];
    [downLine setBackgroundColor:UIColorWithRGB(0xe9eaee)];
    [self addSubview:downLine];
    self.downLine = downLine;
}

- (IBAction)button:(UIButton *)sender {
    // 1.修改组模型的标记(状态取反)
    self.group.isOpened = !self.group.isOpened;
    
    // 2.刷新表格
    if ([self.delegate respondsToSelector:@selector(calendarDetailHeaderView:didClicked:)]) {
        [self.delegate calendarDetailHeaderView:self didClicked:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.upLine.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
    self.downLine.frame = CGRectMake(0, self.bottom-0.5, ScreenWidth, 0.5);
    
    if (nil == self.group) {
        self.nodataview.hidden = NO;
        self.nodataview.backgroundColor = UIColorWithRGB(0xebebee);
        self.proNameLabel.hidden = YES;
        self.totalMoneyLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.statusILabel.hidden = YES;
        self.statusIILabel.hidden = YES;
        self.arrowImage.hidden = YES;
        self.upLine.hidden = YES;
    }
    else {
        if (self.group.isOpened) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            self.downLine.backgroundColor = UIColorWithRGB(0xe9eaee);
        } else {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        }
        self.nodataview.hidden = YES;
        self.proNameLabel.hidden = NO;
        self.totalMoneyLabel.hidden = NO;
        self.timeLabel.hidden = NO;
        self.statusILabel.hidden = NO;
        self.statusIILabel.hidden = NO;
        self.arrowImage.hidden = NO;
        self.upLine.hidden = NO;
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
}

- (void)setGroup:(UCFCalendarGroup *)group
{
    _group = group;
    _proNameLabel.text = group.proName;
    _totalMoneyLabel.text = group.totalMoney;
    _timeLabel.text = [NSString stringWithFormat:@"第%@期/共%@期", group.repayPerNo, group.count];
}
@end
