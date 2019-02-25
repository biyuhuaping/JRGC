//
//  UCFTransMoneyBoardView.m
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransMoneyBoardView.h"
#import "UCFPureTransPageViewModel.h"
@interface UCFTransMoneyBoardView()

@property(nonatomic, weak)UCFPureTransPageViewModel *myVM;

@property(nonatomic, strong)MyRelativeLayout *totalMoneyBoard;
@property(nonatomic, strong)UILabel          *keYongTipLabel;
@property(nonatomic, strong)UILabel          *KeYongMoneyLabel;


@property(nonatomic, strong)MyRelativeLayout *inputMoenyBoard;
@property(nonatomic, strong)UITextField      *investMoneyTextfield;
@property(nonatomic, strong)UILabel          *interestNumLab;
@end


@implementation UCFTransMoneyBoardView

- (void)showTransView:(BaseViewModel *)viewModel
{
    self.myVM = (UCFPureTransPageViewModel *)viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"myMoneyNum",@"inputViewPlaceStr",@"expectedInterestStr",@"allMoneyInputNum"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"myMoneyNum"]) {
            NSString *funds = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (funds.length > 0) {
                selfWeak.KeYongMoneyLabel.text = funds;
                [selfWeak.KeYongMoneyLabel sizeToFit];
            }
        }
        else if ([keyPath isEqualToString:@"inputViewPlaceStr"]) {
            NSString *inputViewPlaceStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (inputViewPlaceStr.length > 0) {
                selfWeak.investMoneyTextfield.placeholder = inputViewPlaceStr;
                [selfWeak.investMoneyTextfield sizeToFit];
            }
        }
        else if ([keyPath isEqualToString:@"expectedInterestStr"]) {
            NSString *expectedInterestStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (expectedInterestStr.length > 0) {
                selfWeak.interestNumLab.text = expectedInterestStr;
                [selfWeak.interestNumLab sizeToFit];
            }
        }
        else if ([keyPath isEqualToString:@"allMoneyInputNum"]) {
            NSString *allMoneyInputNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (allMoneyInputNum.length > 0) {
                selfWeak.investMoneyTextfield.text = allMoneyInputNum;
            }
        }
        
//        } else if ([keyPath isEqualToString:@"myBeansNum"]) {
//            NSString *myBeansNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
//            selfWeak.beanNumLab.text = myBeansNum;
//            [selfWeak.beanNumLab sizeToFit];
//            NSString *num = [myBeansNum stringByReplacingOccurrencesOfString:@"¥" withString:@""];
//            if ([num doubleValue] >= 0.01) {
//                selfWeak.beanSwitch.selected = YES;
//                selfWeak.beanSwitch.userInteractionEnabled = YES;
//            } else {
//                selfWeak.beanSwitch.selected = NO;
//                selfWeak.beanSwitch.userInteractionEnabled = NO;
//            }
//            [selfWeak changeSwitchStatue:selfWeak.beanSwitch];
//        } else if ([keyPath isEqualToString:@"inputViewPlaceStr"]) {
//            NSString *inputViewPlaceStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
//            selfWeak.investMoneyTextfield.placeholder = inputViewPlaceStr;
//            [selfWeak.investMoneyTextfield sizeToFit];
//        } else if ([keyPath isEqualToString:@"expectedInterestNum"]) {
//            NSString *inputViewPlaceStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
//            selfWeak.interestNumLab.text = [inputViewPlaceStr isEqualToString:@""] ? @"¥0.00" : inputViewPlaceStr;
//            [selfWeak.interestNumLab sizeToFit];
//        } else if ([keyPath isEqualToString:@"allMoneyInputNum"]) {
//            NSString *allMoneyInputNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
//            if (allMoneyInputNum.length > 0) {
//                selfWeak.investMoneyTextfield.text = allMoneyInputNum;
//                [selfWeak textfieldLength:selfWeak.investMoneyTextfield];
//            }
//        } else if ([keyPath isEqualToString:@"isCompanyAgent"]) {
//            BOOL isCompanyAgent = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
//            if (isCompanyAgent) {
//                selfWeak.beansBoard.myVisibility = MyVisibility_Gone;
//                selfWeak.totalKeYongTipLabel.text = @"";
//            } else {
//                selfWeak.beansBoard.myVisibility = MyVisibility_Visible;
//            }
//        }
    }];
}



- (void)addSubSectionViews
{
    [self addMoneyBoardSection1];
    [self addMoneyBoardSection2];
}
- (void)addMoneyBoardSection1
{
    _totalMoneyBoard = [MyRelativeLayout new];
    _totalMoneyBoard.myTop = 0;
    _totalMoneyBoard.widthSize.equalTo(self.widthSize);
    _totalMoneyBoard.heightSize.equalTo(@60);
    _totalMoneyBoard.backgroundColor = [Color color:PGColorOptionThemeWhite];
    [self addSubview:_totalMoneyBoard];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    topLineView.myTop = 0;
    topLineView.myHorzMargin = 0;
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

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"充值" forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    button.rightPos.equalTo(_totalMoneyBoard.rightPos).offset(15);
    button.myWidth = 60;
    button.myHeight = 60;
    button.centerYPos.equalTo(_keYongTipLabel.centerYPos);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -33)];
    [button addTarget:self action:@selector(goToRecharge:) forControlEvents:UIControlEventTouchUpInside];
   [_totalMoneyBoard addSubview: button];

    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myLeft = 15;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [_totalMoneyBoard addSubview:endLineView];
}
- (void)addMoneyBoardSection2 {
    _inputMoenyBoard = [MyRelativeLayout new];
    _inputMoenyBoard.myTop = 0;
    _inputMoenyBoard.widthSize.equalTo(self.widthSize);
    _inputMoenyBoard.heightSize.equalTo(@125);
    _inputMoenyBoard.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputMoenyBoard];
    
    UIView *midLineView = [[UIView alloc] init];
    midLineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    //    midLineView.backgroundColor = [UIColor redColor];
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
    _investMoneyTextfield.placeholder = @"";
    [_inputMoenyBoard addSubview:_investMoneyTextfield];
    [_investMoneyTextfield setValue:[Color color:PGColorOptionTitleGray] forKeyPath:@"_placeholderLabel.textColor"];
    [_investMoneyTextfield setValue:[Color gc_Font:19] forKeyPath:@"_placeholderLabel.font"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"全投" forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    button.rightPos.equalTo(_inputMoenyBoard.rightPos).offset(15);
    button.myWidth = 60;
    button.myHeight = 50;
    button.centerYPos.equalTo(_investMoneyTextfield.centerYPos);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
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
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    endLineView.myBottom = 0;
    endLineView.myHorzMargin = 0;
    endLineView.heightSize.equalTo(@0.5);
    [_inputMoenyBoard addSubview:endLineView];
    
}
- (void)goToRecharge:(UIButton *)button
{
    if (self.delegate) {
        [self.delegate investTransFundsBoard:self withRechargeButtonClick:button];
    }
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
