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
@property(nonatomic, strong)UISwitch              *beanSwitch;

/**
 金额输入框
 */
@property(nonatomic, strong)MyRelativeLayout      *inputMoenyBoard;
@property(nonatomic, strong)UITextField           *investMoneyTextfield;
@property(nonatomic, strong)UILabel               *interestNumLab;
///**
// 预期利息
// */
//@property(nonatomic, strong)MyRelativeLayout      *calculatorBoard;



@end

@implementation UCFInvestFundsBoard
- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    [self.KVOController observe:viewModel keyPaths:@[@"totalFunds",@"myFundsNum",@"myBeansNum",@"expectedInterestNum",@"inputViewPlaceStr"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"myFundsNum"]) {
            NSString *funds = [change objectSafeForKey:NSKeyValueChangeNewKey];
            _mybalanceNumLab.text = funds;
            [_mybalanceNumLab sizeToFit];
        } else if ([keyPath isEqualToString:@"totalFunds"]) {
            NSString *totalFunds = [change objectSafeForKey:NSKeyValueChangeNewKey];
            _KeYongMoneyLabel.text = totalFunds;
            [_KeYongMoneyLabel sizeToFit];
        } else if ([keyPath isEqualToString:@"myBeansNum"]) {
            NSString *myBeansNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            _beanNumLab.text = myBeansNum;
            [_beanNumLab sizeToFit];
        } else if ([keyPath isEqualToString:@"inputViewPlaceStr"]) {
            NSString *inputViewPlaceStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            _investMoneyTextfield.placeholder = inputViewPlaceStr;
            [_investMoneyTextfield sizeToFit];
        } else if ([keyPath isEqualToString:@"expectedInterestNum"]) {
            NSString *inputViewPlaceStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            _interestNumLab.text = [inputViewPlaceStr isEqualToString:@""] ? @"¥0.00" : inputViewPlaceStr;
            [_interestNumLab sizeToFit];
        }
    }];
}


- (void)addSubSectionViews
{
//    [self addCountDownView];
    [self addMoneyBoardSection1];
    [self addMoneyBoardSection2];
    [self addMoneyBoardSection3];
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
    
//    NSString *stopStatusStr = [_dic objectSafeForKey:@"stopStatus"];// 0投标中,1满标
//    _minuteCountDownView.isStopStatus = stopStatusStr;
//    if ([stopStatusStr intValue] == 0) {
//        _minuteCountDownView.timeInterval= [[_dic objectSafeForKey:@"intervalMilli"]  integerValue];
//        //        _minuteCountDownView.timeInterval= timeSp;
//        [_minuteCountDownView startTimer];
//        _minuteCountDownView.tipLabel.text = @"距结束";//
//    }else{
//        NSString *startTimeStr = [_dic objectSafeForKey:@"startTime"];
//        NSString *endTimeStr = [_dic objectSafeForKey:@"fullTime"];
//        if (_type == PROJECTDETAILTYPEBONDSRRANSFER){//债权转让
//            startTimeStr = [_dic objectSafeForKey:@"putawaytime"];
//            endTimeStr = [_dic objectSafeForKey:@"soldOutTime"];
//            _minuteCountDownView.tipLabel.text = [NSString stringWithFormat:@"转让期: %@ 至 %@",startTimeStr,endTimeStr];
//        }else{
//            _minuteCountDownView.tipLabel.text = [NSString stringWithFormat:@"筹标期: %@ 至 %@",startTimeStr,endTimeStr];
//        }
//    }
    
}
#pragma mark view two
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
    topLineView.myTop = 0;
    topLineView.myHorzMargin = 0;
    topLineView.heightSize.equalTo(@0.5);
    [_totalMoneyBoard addSubview:topLineView];
    
    _keYongTipLabel = [[UILabel alloc] init];
    _keYongTipLabel.font = [UIFont systemFontOfSize:12.0f];
    _keYongTipLabel.text = @"可用金额";
    _keYongTipLabel.backgroundColor = [UIColor clearColor];
    _keYongTipLabel.textColor = UIColorWithRGB(0x333333);
    _keYongTipLabel.centerYPos.equalTo(_totalMoneyBoard.centerYPos);
    _keYongTipLabel.myLeft = 15;
    [_keYongTipLabel sizeToFit];
    [_totalMoneyBoard addSubview:_keYongTipLabel];
    
    _KeYongMoneyLabel = [[UILabel alloc] init];
    _KeYongMoneyLabel.backgroundColor = [UIColor clearColor];
    _KeYongMoneyLabel.textColor = UIColorWithRGB(0xfd4d4c);
    _KeYongMoneyLabel.text = @"¥10000";
    _KeYongMoneyLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _KeYongMoneyLabel.leftPos.equalTo(_keYongTipLabel.rightPos).offset(10);
    _KeYongMoneyLabel.myCenterY = _keYongTipLabel.myCenterY;
    [_KeYongMoneyLabel sizeToFit];
    [_totalMoneyBoard addSubview:_KeYongMoneyLabel];
    
    _totalKeYongTipLabel = [[UILabel alloc] init];
    _totalKeYongTipLabel.font = [UIFont systemFontOfSize:10.0f];
    _totalKeYongTipLabel.textColor = UIColorWithRGB(0x999999);
    _totalKeYongTipLabel.text = [UserInfoSingle sharedManager].isShowCouple ? @"(我的余额+我的工豆)"  : @"";
    [_totalKeYongTipLabel sizeToFit];
    _totalKeYongTipLabel.leadingPos.equalTo(_KeYongMoneyLabel.rightPos).offset(10);
    _totalKeYongTipLabel.myCenterY = _KeYongMoneyLabel.myCenterY + 2.5;
    _totalKeYongTipLabel.backgroundColor = [UIColor clearColor];
    [_totalMoneyBoard addSubview:_totalKeYongTipLabel];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myLeft = 15;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [_totalMoneyBoard addSubview:endLineView];
}
#pragma mark view three
- (void)addMoneyBoardSection2
{
    _balanceBoard = [MyRelativeLayout new];
    _balanceBoard.myTop = 0;
    _balanceBoard.widthSize.equalTo(self.widthSize);
    _balanceBoard.heightSize.equalTo(@44);
    _balanceBoard.backgroundColor = [UIColor whiteColor];
    [self addSubview:_balanceBoard];
    
    UILabel *myBalanceTip = [[UILabel alloc] init];
    myBalanceTip.font = [UIFont systemFontOfSize:14.0f];
    myBalanceTip.text = @"我的金额";
    myBalanceTip.backgroundColor = [UIColor clearColor];
    myBalanceTip.textColor = UIColorWithRGB(0x333333);
    myBalanceTip.centerYPos.equalTo(_balanceBoard.centerYPos);
    myBalanceTip.myLeft = 15;
    [myBalanceTip sizeToFit];
    [_balanceBoard addSubview:myBalanceTip];
    
    _mybalanceNumLab = [[UILabel alloc] init];
    _mybalanceNumLab.backgroundColor = [UIColor clearColor];
    _mybalanceNumLab.textColor = UIColorWithRGB(0x333333);
    _mybalanceNumLab.text = @"¥10000";
    _mybalanceNumLab.font = [UIFont boldSystemFontOfSize:14.0f];
    _mybalanceNumLab.leftPos.equalTo(myBalanceTip.rightPos).offset(10);
    _mybalanceNumLab.centerYPos.equalTo(_balanceBoard.centerYPos);
    [_mybalanceNumLab sizeToFit];
    [_balanceBoard addSubview:_mybalanceNumLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"充值" forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    button.rightPos.equalTo(_balanceBoard.rightPos).offset(15);
    button.myWidth = 60;
    button.myVertMargin = 0;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -33)];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(goToRecharge:) forControlEvents:UIControlEventTouchUpInside];
    [_balanceBoard addSubview: button];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myRight = 0;
    endLineView.myLeft = 15;
//    endLineView.myHorzMargin = 0;
    endLineView.heightSize.equalTo(@0.5);
    [_balanceBoard addSubview:endLineView];
}
- (void)goToRecharge:(UIButton *)button
{
    
}
#pragma mark view four
- (void)addMoneyBoardSection3
{
    _beansBoard = [MyRelativeLayout new];
    _beansBoard.myTop = 0;
    _beansBoard.widthSize.equalTo(self.widthSize);
    _beansBoard.heightSize.equalTo(@44);
    _beansBoard.backgroundColor = [UIColor whiteColor];
    [self addSubview:_beansBoard];
    
    UILabel *myBeansTip = [[UILabel alloc] init];
    myBeansTip.font = [UIFont systemFontOfSize:14.0f];
    myBeansTip.text = @"工豆账户";
    myBeansTip.backgroundColor = [UIColor clearColor];
    myBeansTip.textColor = UIColorWithRGB(0x333333);
    myBeansTip.centerYPos.equalTo(_balanceBoard.centerYPos);
    myBeansTip.myLeft = 15;
    [myBeansTip sizeToFit];
    [_beansBoard addSubview:myBeansTip];
    
    _beanNumLab = [[UILabel alloc] init];
    _beanNumLab.backgroundColor = [UIColor clearColor];
    _beanNumLab.textColor = UIColorWithRGB(0x333333);
    _beanNumLab.text = @"¥50.00";
    _beanNumLab.font = [UIFont boldSystemFontOfSize:14.0f];
    _beanNumLab.leftPos.equalTo(myBeansTip.rightPos).offset(10);
    _beanNumLab.centerYPos.equalTo(_balanceBoard.centerYPos);
    [_beanNumLab sizeToFit];
    [_beansBoard addSubview:_beanNumLab];
    
    _beanSwitch = [[UISwitch alloc] init];
    _beanSwitch.rightPos.equalTo(_beansBoard.rightPos).offset(15);
    _beanSwitch.onTintColor = UIColorWithRGB(0xfd4d4c);
    _beanSwitch.centerYPos.equalTo(_beansBoard.centerYPos);
    _beanSwitch.on = YES;
    [_beanSwitch addTarget:self action:@selector(changeSwitchStatue:) forControlEvents:UIControlEventValueChanged];
    [_beansBoard addSubview:_beanSwitch];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myRight = 0;
    endLineView.myLeft = 15;
//    endLineView.myHorzMargin = 0;
    endLineView.heightSize.equalTo(@0.5);
    [_beansBoard addSubview:endLineView];
}
- (void)changeSwitchStatue:(UISwitch *)switchView
{
    [self.myVM dealMyfundsNumWithBeansSwitch:switchView];
}
#pragma mark view five
- (void)addMoneyBoardSection4 {
    _inputMoenyBoard = [MyRelativeLayout new];
    _inputMoenyBoard.myTop = 0;
    _inputMoenyBoard.widthSize.equalTo(self.widthSize);
    _inputMoenyBoard.heightSize.equalTo(@86);
    _inputMoenyBoard.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputMoenyBoard];
    
    UIView *midLineView = [[UIView alloc] init];
    midLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    midLineView.backgroundColor = [UIColor redColor];
    midLineView.topPos.equalTo(@50);
    midLineView.leftPos.equalTo(@15);
    midLineView.rightPos.equalTo(@0);
    midLineView.heightSize.equalTo(@0.5);
    [_inputMoenyBoard addSubview:midLineView];

    UILabel *RMBtipLab = [[UILabel alloc] init];
    RMBtipLab.text = @"¥";
    RMBtipLab.myLeft = 15;
    RMBtipLab.myTop = 20;
    RMBtipLab.bottomPos.equalTo(midLineView.bottomPos).offset(20);
    [RMBtipLab sizeToFit];
    RMBtipLab.textColor = UIColorWithRGB(0x555555);
    [_inputMoenyBoard addSubview:RMBtipLab];
    
    _investMoneyTextfield = [[UITextField alloc] init];
    _investMoneyTextfield.leftPos.equalTo(RMBtipLab.rightPos).offset(10);
    _investMoneyTextfield.centerYPos.equalTo(RMBtipLab.centerYPos);
    _investMoneyTextfield.rightPos.equalTo(_inputMoenyBoard.rightPos).offset(100);
    _investMoneyTextfield.myHeight = 30;
//    _investMoneyTextfield.delegate = self;
    _investMoneyTextfield.font = [UIFont systemFontOfSize:16.0f];
    _investMoneyTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_investMoneyTextfield addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    _investMoneyTextfield.textColor = UIColorWithRGB(0x333333);
    _investMoneyTextfield.placeholder = @"100元起投";
    [_inputMoenyBoard addSubview:_investMoneyTextfield];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"全投" forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    button.rightPos.equalTo(_inputMoenyBoard.rightPos).offset(15);
    button.myWidth = 60;
    button.myHeight = 50;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -33)];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(allInvestClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputMoenyBoard addSubview: button];
    
    UILabel *expectedInterestLab = [[UILabel alloc] init];
//    expectedInterestLab.backgroundColor = [UIColor redColor];
    expectedInterestLab.text = @"预计利息";
    expectedInterestLab.textColor = UIColorWithRGB(0x555555);
    expectedInterestLab.leftPos.equalTo(@15);
    expectedInterestLab.font = [UIFont systemFontOfSize:12.0f];
    expectedInterestLab.topPos.equalTo(midLineView.bottomPos).offset(12);
    expectedInterestLab.bottomPos.equalTo(_inputMoenyBoard.bottomPos).offset(12);

    [expectedInterestLab sizeToFit];
    [_inputMoenyBoard addSubview: expectedInterestLab];

    _interestNumLab = [[UILabel alloc] init];
    _interestNumLab.backgroundColor = [UIColor clearColor];
    _interestNumLab.textColor = UIColorWithRGB(0xfd4d4c);
    _interestNumLab.text = @"¥0.00";
    _interestNumLab.leftPos.equalTo(expectedInterestLab.rightPos).offset(10);
    _interestNumLab.centerYPos.equalTo(expectedInterestLab.centerYPos);
    _interestNumLab.font = [UIFont systemFontOfSize:12];
    _interestNumLab.heightSize.equalTo(expectedInterestLab.heightSize);
    [_interestNumLab sizeToFit];
    [_inputMoenyBoard addSubview:_interestNumLab];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myHorzMargin = 0;
    endLineView.heightSize.equalTo(@0.5);
    [_inputMoenyBoard addSubview:endLineView];
    
}
- (void)textfieldLength:(UITextField *)textField
{
    NSString *currentInputText = textField.text;
    [self.myVM calculate:currentInputText];
}
- (void)allInvestClick:(UIButton *)button
{
    
}
#pragma ---------------------------------------------
@end
