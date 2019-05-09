//
//  UCFCalendarDetailHeaderView.m
//  TestCalenar
//
//  Created by njw on 2017/7/2.
//  Copyright © 2017年 njw. All rights reserved.
//

#import "UCFCalendarDetailHeaderView.h"
#import "UCFCalendarGroup.h"
#import "UCFNoDataView.h"

@interface UCFCalendarDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *moveLine;

@property (strong, nonatomic)  UCFNoDataView *nodataview;
@property (weak, nonatomic) UIView *upLine;
@property (weak, nonatomic) IBOutlet UIButton *weijinButton;
@property (weak, nonatomic) IBOutlet UIButton *zxButton;
@property (weak, nonatomic) UIView *downLine;
@end

@implementation UCFCalendarDetailHeaderView
- (IBAction)segementButtonClick:(UIButton *)sender {
    
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"微金回款"]) {
        _weijinButton.selected = YES;
        _zxButton.selected = NO;
    } else if ([title isEqualToString:@"尊享回款"]) {
        _weijinButton.selected = NO;
        _zxButton.selected = YES;
    }
    [UIView animateWithDuration:0.25 animations:^{
        //没有此句可能没有动画效果
        CGPoint center = _moveLine.center;
        center.x = sender.center.x;
        _moveLine.center = center;
    }];
    _moveLine.backgroundColor = [Color color:PGColorOptionTitlerRead];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarDetailHeaderView:didClicked:)]) {
        [self.delegate calendarDetailHeaderView:self didClicked:sender];
    }
    
}
- (void)setSelectButtonIndex:(NSInteger)index
{
    if (index == 0) {
        [self segementButtonClick:_weijinButton];
    } else {
        [self segementButtonClick:_zxButton];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) errorTitle:@"本日无回款项目"];
//    [self addSubview:noDataView];
//    self.nodataview = noDataView;
//    
//    UIView *upLine = [[UIView alloc] initWithFrame:CGRectZero];
//    upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    [self addSubview:upLine];
//    self.upLine = upLine;
//    
//    UIView *downLine = [[UIView alloc] initWithFrame:CGRectZero];
//    [downLine setBackgroundColor:UIColorWithRGB(0xe9eaee)];
//    [self addSubview:downLine];
//    self.downLine = downLine;
}

- (IBAction)button:(UIButton *)sender {
    // 1.修改组模型的标记(状态取反)
//    self.group.opened = !self.group.isOpened;
//    
//    // 2.刷新表格
//    if ([self.delegate respondsToSelector:@selector(calendarDetailHeaderView:didClicked:)]) {
//        [self.delegate calendarDetailHeaderView:self didClicked:sender];
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.upLine.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
//    self.downLine.frame = CGRectMake(0, self.bottom-0.5, ScreenWidth, 0.5);
//    
//    if (nil == self.group) {
//        self.nodataview.hidden = NO;
//        self.nodataview.backgroundColor = UIColorWithRGB(0xebebee);
//        self.proNameLabel.hidden = YES;
//        self.totalMoneyLabel.hidden = YES;
//        self.timeLabel.hidden = YES;
//        self.statusILabel.hidden = YES;
//        self.statusIILabel.hidden = YES;
//        self.arrowImage.hidden = YES;
//        self.upLine.hidden = YES;
//    }
//    else {
//        if (self.group.opened) {
//            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
//            self.downLine.backgroundColor = UIColorWithRGB(0xe9eaee);
//        } else {
//            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
//            self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        }
//        self.nodataview.hidden = YES;
//        self.proNameLabel.hidden = NO;
//        self.totalMoneyLabel.hidden = NO;
//        self.timeLabel.hidden = NO;
//        self.statusILabel.hidden = NO;
//        self.statusIILabel.hidden = NO;
//        self.arrowImage.hidden = NO;
//        self.upLine.hidden = NO;
//        if ([self.group.status intValue] == 0) {
//            self.statusIILabel.hidden = YES;
//            self.statusILabel.text = @"待回款";
//            self.statusILabel.textColor = UIColorWithRGB(0xfd4d4c);
//        }
//        else if ([self.group.status intValue] == 1) {
//            self.statusILabel.textColor = UIColorWithRGB(0x4aa1f9);
//            if ([self.group.isAdvance intValue] == 0) {
//                self.statusIILabel.hidden = YES;
//                self.statusILabel.text = @"已回款";
//            }
//            else {
//                self.statusIILabel.hidden = NO;
//                self.statusILabel.text = @"提前回款";
//                if (self.group.repayPerDate.length>0) {
//                    NSString *day = [NSString stringWithFormat:@"%@日", [self.group.repayPerDate stringByReplacingOccurrencesOfString:@"-" withString:@"月"]];
//                    self.statusIILabel.text = [NSString stringWithFormat:@"计划回款日%@", day];
//                }
//            }
//        }
//    }
}

- (void)setGroup:(UCFCalendarGroup *)group
{
//    _group = group;
//    _proNameLabel.text = group.proName;
//    _totalMoneyLabel.text = group.totalMoney;
//    _timeLabel.text = [NSString stringWithFormat:@"第%@期/共%@期", group.repayPerNo, group.count];
}

@end
