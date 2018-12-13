//
//  UCFInvestFundsBoard.m
//  JRGC
//
//  Created by zrc on 2018/12/13.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFInvestFundsBoard.h"
#import "MinuteCountDownView.h"

@interface UCFInvestFundsBoard ()

/**
 倒计时
 */
@property(nonatomic, strong)MinuteCountDownView *minuteCountDownView;
/**
 可用金额
 */
@property(nonatomic, strong)MyRelativeLayout      *totalMoneyBoard;

/**
 我的余额
 */
@property(nonatomic, strong)MyLinearLayout      *balanceBoard;

/**
 工豆账户
 */
@property(nonatomic, strong)MyLinearLayout      *beansBoard;
/**
 金额输入框
 */
@property(nonatomic, strong)MyLinearLayout      *inputMoenyBoard;
/**
 预期利息
 */
@property(nonatomic, strong)MyLinearLayout      *calculatorBoard;
@end

@implementation UCFInvestFundsBoard


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)addSubSectionViews
{
    [self addCountDownView];
    [self addMoneyBoardSection1];
   
}

- (void)addCountDownView
{
    _minuteCountDownView = [[[NSBundle mainBundle] loadNibNamed:@"MinuteCountDownView" owner:nil options:nil] firstObject];
    _minuteCountDownView.topPos.equalTo(@0);
    _minuteCountDownView.myHorzMargin = 0;
    _minuteCountDownView.heightSize.equalTo(@37);
    _minuteCountDownView.isStopStatus = @"0";
    [_minuteCountDownView startTimer];
    _minuteCountDownView.sourceVC = @"UCFPurchaseBidVC";//投资页面
    [self addSubview:self.minuteCountDownView];
}
- (void)addMoneyBoardSection1
{
    _totalMoneyBoard = [MyRelativeLayout new];
    _totalMoneyBoard.myTop = 0;
    _totalMoneyBoard.widthSize.equalTo(self.widthSize);
    _totalMoneyBoard.heightSize.equalTo(@38);
    _totalMoneyBoard.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self addSubview:_totalMoneyBoard];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    topLineView.backgroundColor = [UIColor redColor];
    topLineView.myTop = 0;
    topLineView.myHorzMargin = 0;
    topLineView.heightSize.equalTo(@1);
    
    [_totalMoneyBoard addSubview:topLineView];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.backgroundColor = [UIColor blueColor];
    endLineView.myBottom = 0;
    endLineView.myHorzMargin = 0;
    endLineView.heightSize.equalTo(@1);
    [_totalMoneyBoard addSubview:endLineView];
}
- (void)addMoneyBoardSection2
{
    
}
- (void)addMoneyBoardSection3
{
    
}


#pragma mark viewInit

- (MyLinearLayout *)totalMoneyBoard
{
    if (_totalMoneyBoard) {

    }
    return _totalMoneyBoard;
}
- (MyLinearLayout *)balanceBoard
{
    if (_balanceBoard) {
        _balanceBoard = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    }
    return _balanceBoard;
}
- (MyLinearLayout *)beansBoard
{
    if (_beansBoard) {
        _beansBoard = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    }
    return _beansBoard;
}
- (MyLinearLayout *)inputMoenyBoard
{
    if (_inputMoenyBoard) {
        _inputMoenyBoard = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    }
    return _inputMoenyBoard;
}
- (MyLinearLayout *)calculatorBoard
{
    if (_calculatorBoard) {
        _calculatorBoard = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    }
    return _calculatorBoard;
}
#pragma ---------------------------------------------
@end
