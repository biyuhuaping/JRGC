//
//  UCFMicroBankOpenAccountOptionView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountOptionView.h"
#import "NZLabel.h"

@interface UCFMicroBankOpenAccountOptionView()
@property (nonatomic, strong) UIImageView *firstStepImageView;

@property (nonatomic, strong) NZLabel     *firstStepLabel;

@property (nonatomic, strong) UIImageView *cuttingLineImageView;

@property (nonatomic, strong) UIImageView *secondStepImageView;

@property (nonatomic, strong) NZLabel     *secondStepLabel;

@end
@implementation UCFMicroBankOpenAccountOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:self.firstStepImageView];
        [self.rootLayout addSubview:self.firstStepLabel];
        [self.rootLayout addSubview:self.cuttingLineImageView];
        [self.rootLayout addSubview:self.secondStepImageView];
        [self.rootLayout addSubview:self.secondStepLabel];
    }
    return self;
}
//- (UIImageView *)firstStepImageView
//{
//    if (nil == _firstStepImageView) {
//        _firstStepImageView = [[UIImageView alloc] init];
//        _firstStepImageView.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
//        _firstStepImageView.rightPos.equalTo(@15);
//        _firstStepImageView.myWidth = 8;
//        _firstStepImageView.myHeight = 13;
//        _firstStepImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
//    }
//    return _firstStepImageView;
//}
//- (UIImageView *)arrowImageView
//{
//    if (nil == _arrowImageView) {
//        _arrowImageView = [[UIImageView alloc] init];
//        _arrowImageView.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
//        _arrowImageView.rightPos.equalTo(@15);
//        _arrowImageView.myWidth = 8;
//        _arrowImageView.myHeight = 13;
//        _arrowImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
//    }
//    return _arrowImageView;
//}
//
//- (NZLabel *)topUpWithdrawalLabel
//{
//    if (nil == _topUpWithdrawalLabel) {
//        _topUpWithdrawalLabel = [NZLabel new];
//        _topUpWithdrawalLabel.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
//        _topUpWithdrawalLabel.rightPos.equalTo(self.arrowImageView.leftPos).offset(6);
//        _topUpWithdrawalLabel.textAlignment = NSTextAlignmentLeft;
//        _topUpWithdrawalLabel.font = [Color gc_Font:12.0];
//        _topUpWithdrawalLabel.textColor = [Color color:PGColorOptionTitleGray];
//        _topUpWithdrawalLabel.text = @"充值与提现";
//        [_topUpWithdrawalLabel sizeToFit];
//        
//    }
//    return _topUpWithdrawalLabel;
//}
//- (UIImageView *)arrowImageView
//{
//    if (nil == _arrowImageView) {
//        _arrowImageView = [[UIImageView alloc] init];
//        _arrowImageView.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
//        _arrowImageView.rightPos.equalTo(@15);
//        _arrowImageView.myWidth = 8;
//        _arrowImageView.myHeight = 13;
//        _arrowImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
//    }
//    return _arrowImageView;
//}
//- (NZLabel *)topUpWithdrawalLabel
//{
//    if (nil == _topUpWithdrawalLabel) {
//        _topUpWithdrawalLabel = [NZLabel new];
//        _topUpWithdrawalLabel.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
//        _topUpWithdrawalLabel.rightPos.equalTo(self.arrowImageView.leftPos).offset(6);
//        _topUpWithdrawalLabel.textAlignment = NSTextAlignmentLeft;
//        _topUpWithdrawalLabel.font = [Color gc_Font:12.0];
//        _topUpWithdrawalLabel.textColor = [Color color:PGColorOptionTitleGray];
//        _topUpWithdrawalLabel.text = @"充值与提现";
//        [_topUpWithdrawalLabel sizeToFit];
//        
//    }
//    return _topUpWithdrawalLabel;
//}
@end
