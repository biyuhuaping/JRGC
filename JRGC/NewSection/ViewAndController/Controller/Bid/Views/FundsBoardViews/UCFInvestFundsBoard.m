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
@property(nonatomic, weak)UCFBidViewModel *myVM;
/**
 倒计时
 */
@property(nonatomic, strong)MinuteCountDownView *minuteCountDownView;
/**
 可用金额
 */
@property(nonatomic, strong)MyRelativeLayout      *totalMoneyBoard;
@property(nonatomic, strong)UILabel               *keYongTipLabel;
@property(nonatomic, strong)UILabel               *KeYongMoneyLabel;
@property(nonatomic, strong)UILabel               *totalKeYongTipLabel;

/**
 我的余额
 */
@property(nonatomic, strong)MyRelativeLayout      *balanceBoard;
@property(nonatomic, strong)UILabel               *mybalanceNumLab;

/**
 工豆账户
 */
@property(nonatomic, strong)MyRelativeLayout      *beansBoard;
@property(nonatomic, strong)UILabel               *beanNumLab;
@property(nonatomic, strong)UIButton              *beanSwitch;

/**
 金额输入框
 */
@property(nonatomic, strong)MyRelativeLayout      *inputMoenyBoard;
@property(nonatomic, strong)UITextField           *investMoneyTextfield;
@property(nonatomic, strong)UILabel               *interestNumLab;
@property(nonatomic, strong)UILabel               *riskTypeLab;
///**
// 预期利息
// */
//@property(nonatomic, strong)MyRelativeLayout      *calculatorBoard;



@end

@implementation UCFInvestFundsBoard
- (void)dealloc
{
    NSLog(@"111");
}
- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"totalFunds",@"myFundsNum",@"myBeansNum",@"expectedInterestNum",@"inputViewPlaceStr",@"allMoneyInputNum",@"isCompanyAgent",@"riskDes"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"myFundsNum"]) {
            NSString *funds = [change objectSafeForKey:NSKeyValueChangeNewKey];
            selfWeak.mybalanceNumLab.text = funds;
            [selfWeak.mybalanceNumLab sizeToFit];
        } else if ([keyPath isEqualToString:@"totalFunds"]) {
            NSString *totalFunds = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (totalFunds.length > 0) {
                selfWeak.KeYongMoneyLabel.text = totalFunds;
                [selfWeak.KeYongMoneyLabel sizeToFit];
            }

        } else if ([keyPath isEqualToString:@"myBeansNum"]) {
            NSString *myBeansNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            selfWeak.beanNumLab.text = myBeansNum;
            [selfWeak.beanNumLab sizeToFit];
            NSString *num = [myBeansNum stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            if ([num doubleValue] >= 0.01) {
                selfWeak.beanSwitch.selected = YES;
                selfWeak.beanSwitch.userInteractionEnabled = YES;
            } else {
                selfWeak.beanSwitch.selected = NO;
                selfWeak.beanSwitch.userInteractionEnabled = NO;
            }
            [selfWeak changeSwitchStatue:selfWeak.beanSwitch];
        } else if ([keyPath isEqualToString:@"inputViewPlaceStr"]) {
            NSString *inputViewPlaceStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            selfWeak.investMoneyTextfield.placeholder = inputViewPlaceStr;
            [selfWeak.investMoneyTextfield sizeToFit];
        } else if ([keyPath isEqualToString:@"expectedInterestNum"]) {
            NSString *inputViewPlaceStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            selfWeak.interestNumLab.text = [inputViewPlaceStr isEqualToString:@""] ? @"¥0.00" : inputViewPlaceStr;
            [selfWeak.interestNumLab sizeToFit];
        } else if ([keyPath isEqualToString:@"allMoneyInputNum"]) {
            NSString *allMoneyInputNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (allMoneyInputNum.length > 0) {
                selfWeak.investMoneyTextfield.text = allMoneyInputNum;
                [selfWeak textfieldLength:selfWeak.investMoneyTextfield];
            }
        } else if ([keyPath isEqualToString:@"isCompanyAgent"]) {
            BOOL isCompanyAgent = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (isCompanyAgent) {
                selfWeak.beansBoard.myVisibility = MyVisibility_Gone;
                selfWeak.totalKeYongTipLabel.text = @"";
            } else {
                selfWeak.beansBoard.myVisibility = MyVisibility_Visible;
            }
        } else if ([keyPath isEqualToString:@"riskDes"]) {
            NSString *riskDes = [change objectForKey:NSKeyValueChangeNewKey];
            if (riskDes.length > 0) {
                selfWeak.riskTypeLab.text = riskDes;
                [selfWeak.riskTypeLab sizeToFit];
            } else {
                selfWeak.riskTypeLab.text = @"";
            }
        }
    }];
}


- (void)addSubSectionViews
{
//    [self addCountDownView];
    [self addMoneyBoardSection1];
    [self addMoneyBoardSection2];
    if ([UserInfoSingle sharedManager].isShowCouple) {
        [self addMoneyBoardSection3];
    }
    [self addMoneyBoardSection4];
}



#pragma mark viewInit
#pragma mark view one
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
#pragma mark view two
- (void)addMoneyBoardSection1
{
    _totalMoneyBoard = [MyRelativeLayout new];
    _totalMoneyBoard.myTop = 0;
    _totalMoneyBoard.widthSize.equalTo(self.widthSize);
    _totalMoneyBoard.heightSize.equalTo(@50);
    _totalMoneyBoard.backgroundColor = [Color color:PGColorOptionThemeWhite];
    [self addSubview:_totalMoneyBoard];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    topLineView.myTop = 0;
    topLineView.myHorzMargin = 0;
    topLineView.hidden = YES;
    topLineView.heightSize.equalTo(@0.5);
    [_totalMoneyBoard addSubview:topLineView];
    
    _keYongTipLabel = [[UILabel alloc] init];
    _keYongTipLabel.font = [UIFont systemFontOfSize:16.0f];
    _keYongTipLabel.text = @"可用金额";
    _keYongTipLabel.backgroundColor = [UIColor clearColor];
    _keYongTipLabel.textColor = [Color color:PGColorOptionTitleBlack];
    _keYongTipLabel.centerYPos.equalTo(_totalMoneyBoard.centerYPos);
    _keYongTipLabel.myLeft = 15;
    [_keYongTipLabel sizeToFit];
    [_totalMoneyBoard addSubview:_keYongTipLabel];
    
    _KeYongMoneyLabel = [[UILabel alloc] init];
    _KeYongMoneyLabel.backgroundColor = [UIColor clearColor];
    _KeYongMoneyLabel.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
    _KeYongMoneyLabel.text = @"¥10000";
    _KeYongMoneyLabel.font = [Color gc_ANC_font:20];
    _KeYongMoneyLabel.leftPos.equalTo(_keYongTipLabel.rightPos).offset(10);
    _KeYongMoneyLabel.centerYPos.equalTo(_keYongTipLabel.centerYPos);
//    _KeYongMoneyLabel.myCenterY = _keYongTipLabel.myCenterY;
    [_KeYongMoneyLabel sizeToFit];
    [_totalMoneyBoard addSubview:_KeYongMoneyLabel];
    
    _totalKeYongTipLabel = [[UILabel alloc] init];
    _totalKeYongTipLabel.font = [UIFont systemFontOfSize:11.0f];
    _totalKeYongTipLabel.textColor = [Color color:PGColorOptionTitleGray];
    _totalKeYongTipLabel.text = [UserInfoSingle sharedManager].isShowCouple ? @"(我的余额+我的工豆)"  : @"";
    [_totalKeYongTipLabel sizeToFit];
    _totalKeYongTipLabel.leadingPos.equalTo(_KeYongMoneyLabel.rightPos).offset(10);
    _totalKeYongTipLabel.centerYPos.equalTo(_KeYongMoneyLabel.centerYPos).offset(2.5);
//    _totalKeYongTipLabel.myCenterY = _KeYongMoneyLabel.myCenterY + 2.5;
    _totalKeYongTipLabel.backgroundColor = [UIColor clearColor];
    [_totalMoneyBoard addSubview:_totalKeYongTipLabel];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    endLineView.bottomPos.equalTo(@0);
    endLineView.leftPos.equalTo(@15);
    endLineView.rightPos.equalTo(@0);
    endLineView.heightSize.equalTo(@0.7);
    [_totalMoneyBoard addSubview:endLineView];
}
#pragma mark view three
- (void)addMoneyBoardSection2
{
    _balanceBoard = [MyRelativeLayout new];
    _balanceBoard.myTop = 0;
    _balanceBoard.widthSize.equalTo(self.widthSize);
    _balanceBoard.heightSize.equalTo(@50);
    _balanceBoard.backgroundColor = [UIColor whiteColor];
    [self addSubview:_balanceBoard];
    
    UILabel *myBalanceTip = [[UILabel alloc] init];
    myBalanceTip.font = [UIFont systemFontOfSize:14.0f];
    myBalanceTip.text = @"我的金额";
    myBalanceTip.backgroundColor = [UIColor clearColor];
    myBalanceTip.textColor = [Color color:PGColorOptionTitleBlack];
//    myBalanceTip.centerYPos.equalTo(_balanceBoard.centerYPos);
    myBalanceTip.myLeft = 15;
    myBalanceTip.myBottom = 10;
    [myBalanceTip sizeToFit];
    [_balanceBoard addSubview:myBalanceTip];
    
    _mybalanceNumLab = [[UILabel alloc] init];
    _mybalanceNumLab.backgroundColor = [UIColor clearColor];
    _mybalanceNumLab.textColor = [Color color:PGColorOptionTitleBlack];
    _mybalanceNumLab.text = @"¥10000";
    _mybalanceNumLab.font = [Color gc_ANC_font:18];
    _mybalanceNumLab.leftPos.equalTo(myBalanceTip.rightPos).offset(18);
//    _mybalanceNumLab.centerYPos.equalTo(_balanceBoard.centerYPos);
    _mybalanceNumLab.bottomPos.equalTo(myBalanceTip.bottomPos).offset(-4.5);
    [_mybalanceNumLab sizeToFit];
    [_balanceBoard addSubview:_mybalanceNumLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"充值" forState:UIControlStateNormal];
    [button setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
    button.rightPos.equalTo(_balanceBoard.rightPos).offset(15);
    button.myWidth = 60;
    button.myVertMargin = 0;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(17, 0, 0, -33)];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(goToRecharge:) forControlEvents:UIControlEventTouchUpInside];
    [_balanceBoard addSubview: button];
    if (![UserInfoSingle sharedManager].isShowCouple) {
        UIView *endLineView = [[UIView alloc] init];
        endLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        endLineView.bottomPos.equalTo(@0);
        endLineView.leftPos.equalTo(@15);
        endLineView.rightPos.equalTo(@0);
        endLineView.heightSize.equalTo(@0.7);
        [_balanceBoard addSubview:endLineView];
    }

}
- (void)goToRecharge:(UIButton *)button
{
    [self.delegate investFundsBoard:self withRechargeButtonClick:button];
}
#pragma mark view four
- (void)addMoneyBoardSection3
{
    _beansBoard = [MyRelativeLayout new];
    _beansBoard.myTop = 0;
    _beansBoard.widthSize.equalTo(self.widthSize);
    _beansBoard.heightSize.equalTo(@52);
    _beansBoard.backgroundColor = [UIColor whiteColor];
    [self addSubview:_beansBoard];
    
    UILabel *myBeansTip = [[UILabel alloc] init];
    myBeansTip.font = [UIFont systemFontOfSize:14.0f];
    myBeansTip.text = @"我的工豆";
    myBeansTip.backgroundColor = [UIColor clearColor];
    myBeansTip.textColor = [Color color:PGColorOptionTitleBlack];
//    myBeansTip.centerYPos.equalTo(_balanceBoard.centerYPos);
    myBeansTip.myLeft = 15;
    myBeansTip.myTop = 10;
    [myBeansTip sizeToFit];
    [_beansBoard addSubview:myBeansTip];
    
    _beanNumLab = [[UILabel alloc] init];
    _beanNumLab.backgroundColor = [UIColor clearColor];
    _beanNumLab.textColor = [Color color:PGColorOptionTitleBlack];
    _beanNumLab.text = @"¥50.00";
    _beanNumLab.font = [Color gc_ANC_font:18];
    _beanNumLab.leftPos.equalTo(myBeansTip.rightPos).offset(18);
//    _beanNumLab.centerYPos.equalTo(_balanceBoard.centerYPos);
    _beanNumLab.bottomPos.equalTo(myBeansTip.bottomPos).offset(-4.5);;
    [_beanNumLab sizeToFit];
    [_beansBoard addSubview:_beanNumLab];
    
    _beanSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    _beanSwitch.rightPos.equalTo(_beansBoard.rightPos).offset(18);
    _beanSwitch.myTop = 0;
    _beanSwitch.myBottom = 0;
    _beanSwitch.myWidth = 60;
    [_beanSwitch setImage:[UIImage imageNamed:@"invest_btn_unselected"] forState:UIControlStateNormal];
    [_beanSwitch setImage:[UIImage imageNamed:@"invest_btn_selected_slices"] forState:UIControlStateSelected];
    [_beanSwitch addTarget:self action:@selector(changeBtnStatue:) forControlEvents:UIControlEventTouchUpInside];
    [_beansBoard addSubview:_beanSwitch];
    _beanSwitch.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -37);
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    endLineView.bottomPos.equalTo(@0);
    endLineView.leftPos.equalTo(@0);
    endLineView.rightPos.equalTo(@0);
    endLineView.heightSize.equalTo(@0.7);
    [_beansBoard addSubview:endLineView];
}
- (void)changeBtnStatue:(UIButton *)button
{
    button.selected = !button.selected;
    [self changeSwitchStatue:button];
}
- (void)changeSwitchStatue:(UIButton *)switchView
{
    [self.myVM dealMyfundsNumWithBeansSwitch:switchView];
}
#pragma mark view five
- (void)addMoneyBoardSection4 {
    _inputMoenyBoard = [MyRelativeLayout new];
    _inputMoenyBoard.myTop = 0;
    _inputMoenyBoard.widthSize.equalTo(self.widthSize);
    _inputMoenyBoard.heightSize.equalTo(@125);
    _inputMoenyBoard.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputMoenyBoard];
    
    UIView *midLineView = [[UIView alloc] init];
    midLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    midLineView.topPos.equalTo(@80);
    midLineView.leftPos.equalTo(@15);
    midLineView.rightPos.equalTo(@0);
    midLineView.heightSize.equalTo(@0.5);
    [_inputMoenyBoard addSubview:midLineView];

    UILabel *RMBtipLab = [[UILabel alloc] init];
    RMBtipLab.text = @"¥";
    RMBtipLab.myLeft = 20;
    RMBtipLab.myTop = 42;
    RMBtipLab.font = [Color gc_Font:24];
    RMBtipLab.bottomPos.equalTo(midLineView.bottomPos).offset(20);
    [RMBtipLab sizeToFit];
    RMBtipLab.textColor = [Color color:PGColorOptionTitleBlack];
    [_inputMoenyBoard addSubview:RMBtipLab];
    
    _investMoneyTextfield = [[UITextField alloc] init];
    _investMoneyTextfield.leftPos.equalTo(RMBtipLab.rightPos).offset(10);
    _investMoneyTextfield.centerYPos.equalTo(RMBtipLab.centerYPos);
    _investMoneyTextfield.rightPos.equalTo(_inputMoenyBoard.rightPos).offset(100);
    _investMoneyTextfield.myHeight = 30;
    _investMoneyTextfield.font = [Color gc_Font:30.0f];
    _investMoneyTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_investMoneyTextfield addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    _investMoneyTextfield.textColor = [Color color:PGColorOptionTitleBlack];
    _investMoneyTextfield.placeholder = @"100元起投";
    [_inputMoenyBoard addSubview:_investMoneyTextfield];
    [_investMoneyTextfield setValue:[Color color:PGColorOptionTitleGray] forKeyPath:@"_placeholderLabel.textColor"];
    [_investMoneyTextfield setValue:[Color gc_Font:19] forKeyPath:@"_placeholderLabel.font"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"全投" forState:UIControlStateNormal];
    [button setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
    button.rightPos.equalTo(_inputMoenyBoard.rightPos).offset(15);
    button.myWidth = 60;
    button.myHeight = 50;
    button.centerYPos.equalTo(_investMoneyTextfield.centerYPos);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -33)];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(allInvestClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputMoenyBoard addSubview: button];
    
    UILabel *expectedInterestLab = [[UILabel alloc] init];
    expectedInterestLab.text = @"预期利息";
    expectedInterestLab.textColor = [Color color:PGColorOptionTitleBlack];
    expectedInterestLab.leftPos.equalTo(@15);
    expectedInterestLab.font = [Color gc_Font:14];
    expectedInterestLab.topPos.equalTo(midLineView.bottomPos).offset(15);
    expectedInterestLab.bottomPos.equalTo(_inputMoenyBoard.bottomPos).offset(15);

    [expectedInterestLab sizeToFit];
    [_inputMoenyBoard addSubview: expectedInterestLab];

    _interestNumLab = [[UILabel alloc] init];
    _interestNumLab.backgroundColor = [UIColor clearColor];
    _interestNumLab.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
    _interestNumLab.text = @"¥0.00";
    _interestNumLab.leftPos.equalTo(expectedInterestLab.rightPos).offset(17);
    _interestNumLab.centerYPos.equalTo(expectedInterestLab.centerYPos);
    _interestNumLab.font = [Color gc_ANC_font:18];
    _interestNumLab.heightSize.equalTo(expectedInterestLab.heightSize);
    [_interestNumLab sizeToFit];
    [_inputMoenyBoard addSubview:_interestNumLab];
    
    
    _riskTypeLab = [[UILabel alloc] init];
    _riskTypeLab.backgroundColor = [UIColor clearColor];
    _riskTypeLab.textColor = [Color color:PGColorOptionTitleGray];
    _riskTypeLab.text = @"谨慎型及以上可投";
    _riskTypeLab.rightPos.equalTo(_inputMoenyBoard.rightPos).offset(15);
    _riskTypeLab.centerYPos.equalTo(expectedInterestLab.centerYPos);
    _riskTypeLab.font = [Color gc_Font:14];
    [_riskTypeLab sizeToFit];
    [_inputMoenyBoard addSubview:_riskTypeLab];
    

    
}
- (void)textfieldLength:(UITextField *)textField
{
    NSString *currentInputText = textField.text;
    [self.myVM calculate:currentInputText];
}
- (void)allInvestClick:(UIButton *)button
{
    [self.myVM calculateTotalMoney];
}
#pragma ---------------------------------------------
@end
