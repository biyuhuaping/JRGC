//
//  CalculatorView.m
//  JRGC
//
//  Created by 金融工场 on 15/5/18.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "CalculatorView.h"
#import "Common.h"
#import "InvestmentItemInfo.h"
#import "UCFToolsMehod.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
@implementation CalculatorView
{
    UILabel     *jrgcProfitLab;
    UILabel     *bankProfitLab;
    UIView      *jrgcProfitView;
    UIView      *bankProfitView;
    UIButton    *calculatorBtn;
    NSString    *normalBidID;
    NSString    *preInvestMoney;  // 上次的投标金额
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
        [self addGestureRecognizer:frade];
        [self makeView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
#endif
    }
    return self;
}
#pragma ----
/**
 *  键盘抬起和消失，调整收益框位置
 *
 *  @param notification 键盘通知包体
 */
- (void)calculatorKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)calculatorKeyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}
/**
 *  调整收益框位置
 *
 *  @param height 键盘高度
 *  @param time   键盘弹起动画时间
 */
-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)time
{
    UIView *baseView = [self viewWithTag:999];
    if (height == 0) {
        baseView.center = self.center;
    } else {
        CGFloat bottomEdgeSpace = ScreenHeight - CGRectGetMaxY(baseView.frame);
        if (bottomEdgeSpace < height) {
            //计算器视图不可以完全显示
            baseView.frame = CGRectMake(CGRectGetMinX(baseView.frame), CGRectGetMinY(baseView.frame) - (height - bottomEdgeSpace) , CGRectGetWidth(baseView.frame), CGRectGetHeight(baseView.frame));
        } else {
            //计算器视图可以完全显示
        }
    }
        
}
/**
 *  收起键盘
 */
- (void)fadeKeyboard
{
    [moneyTextField resignFirstResponder];
}
/**
 *  布局
 */
- (void)makeView
{
    CGFloat verSpace = [Common calculateNewSizeBaseMachine:10.0f];
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(25, 0, ScreenWidth - 50, [Common calculateNewSizeBaseMachine:234]);
    baseView.center = self.center;
    baseView.tag = 999;
    baseView.layer.cornerRadius = 5.0f;
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    
    UIView *blueHeadView = [[UIView alloc]init];
    blueHeadView.backgroundColor = UIColorWithRGBA(92, 106, 145, 1);
    blueHeadView.tag = 3894;
    blueHeadView.frame = CGRectMake(0, 0, CGRectGetWidth(baseView.frame), [Common calculateNewSizeBaseMachine:133]);
    blueHeadView.layer.cornerRadius = 5.0f;
    [baseView addSubview:blueHeadView];
    
    UILabel *headTipLabel = [[UILabel alloc] init];
    headTipLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15.5f]];
    headTipLabel.textAlignment = NSTextAlignmentCenter;
    headTipLabel.textColor = [UIColor whiteColor];
    headTipLabel.backgroundColor = [UIColor clearColor];
    headTipLabel.frame = CGRectMake(0, verSpace, CGRectGetWidth(baseView.frame), [Common calculateNewSizeBaseMachine:16.0f]);
    headTipLabel.text = @"计算器";
    [blueHeadView addSubview:headTipLabel];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame  = CGRectMake(CGRectGetWidth(blueHeadView.frame) - [Common calculateNewSizeBaseMachine:40],[Common calculateNewSizeBaseMachine:5], [Common calculateNewSizeBaseMachine:30], [Common calculateNewSizeBaseMachine:30]);
    closeBtn.layer.cornerRadius = 2.0f;
    closeBtn.tag = 1002;
    [closeBtn setImage:[UIImage imageNamed:@"calculator_close"] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [closeBtn addTarget:self action:@selector(removeBtn) forControlEvents:UIControlEventTouchUpInside];
    [blueHeadView addSubview:closeBtn];
    
    UIView *lineView1 = [Common addSepateViewWithRect:CGRectMake(15, CGRectGetMaxY(headTipLabel.frame) + [Common calculateNewSizeBaseMachine:12], CGRectGetWidth(blueHeadView.frame) - 30 , 1) WithColor:UIColorWithRGBA(101, 115, 152, 1)];
    [blueHeadView addSubview:lineView1];
    
    jrgcProfitLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView1.frame) + [Common calculateNewSizeBaseMachine:20], CGRectGetWidth(blueHeadView.frame) - 30, [Common calculateNewSizeBaseMachine:12])];
    jrgcProfitLab.text = @"预期收益(元)";
    jrgcProfitLab.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:10.8]];
    jrgcProfitLab.textColor = [UIColor whiteColor];
    jrgcProfitLab.backgroundColor = [UIColor clearColor];
    jrgcProfitLab.textAlignment = NSTextAlignmentLeft;
    [blueHeadView addSubview:jrgcProfitLab];
    
    preGetMoneyLabel = [[UILabel alloc] init];
    preGetMoneyLabel.frame = CGRectMake(15, CGRectGetMaxY(jrgcProfitLab.frame) + [Common calculateNewSizeBaseMachine:8] , CGRectGetWidth(blueHeadView.frame) - 30, [Common calculateNewSizeBaseMachine:28]);
    preGetMoneyLabel.textColor = [UIColor whiteColor];
    preGetMoneyLabel.text = @"0.00";
    preGetMoneyLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:26.0f]];
    preGetMoneyLabel.textAlignment = NSTextAlignmentLeft;
    preGetMoneyLabel.backgroundColor = [UIColor clearColor];
    [blueHeadView addSubview:preGetMoneyLabel];
    
    UIView *bottomBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(blueHeadView.frame) - [Common calculateNewSizeBaseMachine:10], CGRectGetWidth(blueHeadView.frame), [Common calculateNewSizeBaseMachine:10] )];
//    bottomBaseView.backgroundColor = UIColorWithRGBA(78, 92, 129, 1);
    bottomBaseView.backgroundColor = [UIColor whiteColor];
    [blueHeadView addSubview:bottomBaseView];
    
    UILabel *moneyTextTip = [[UILabel alloc] init];
    moneyTextTip.frame  =CGRectMake([Common calculateNewSizeBaseMachine:15.0f], CGRectGetMaxY(blueHeadView.frame) + [Common calculateNewSizeBaseMachine:14], [Common getStrWitdth:@"投资金额" TextFont:[UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:14.0f]]].width, [Common calculateNewSizeBaseMachine:14.0f]);
    moneyTextTip.text = @"投资金额";
    moneyTextTip.textColor = UIColorWithRGB(0x333333);
    moneyTextTip.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:14.0f]];
    [baseView addSubview:moneyTextTip];
    
    UIView *textBaseView = [[UIView alloc] init];
    textBaseView.frame =  CGRectMake(CGRectGetMaxX(moneyTextTip.frame) + [Common calculateNewSizeBaseMachine:6], CGRectGetMinY(moneyTextTip.frame) - [Common calculateNewSizeBaseMachine:9], CGRectGetWidth(baseView.frame) - CGRectGetMaxX(moneyTextTip.frame) - [Common calculateNewSizeBaseMachine:6] - [Common calculateNewSizeBaseMachine:15],CGRectGetHeight(moneyTextTip.frame) + [Common calculateNewSizeBaseMachine:18]);
    textBaseView.backgroundColor = UIColorWithRGBA(242, 242, 242, 1);
    textBaseView.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    textBaseView.layer.borderWidth = 0.5f;
    textBaseView.layer.cornerRadius = 3.0f;
    [baseView addSubview:textBaseView];
    
    moneyTextField = [[UITextField alloc] init];
    moneyTextField.delegate = self;
    moneyTextField.frame = CGRectMake([Common calculateNewSizeBaseMachine:9],[Common calculateNewSizeBaseMachine:5],[Common calculateNewSizeBaseMachine: CGRectGetWidth(textBaseView.frame) - 10],CGRectGetHeight(textBaseView.frame) - [Common calculateNewSizeBaseMachine: 10]);
    moneyTextField.placeholder = @"100起投";
    [moneyTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTextField.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15.0f]];
    moneyTextField.textColor = UIColorWithRGB(0x333333);
    [textBaseView addSubview:moneyTextField];
    
    calculatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calculatorBtn.frame  = CGRectMake([Common calculateNewSizeBaseMachine:15], CGRectGetHeight(baseView.frame) - [Common calculateNewSizeBaseMachine:33 + 15], CGRectGetWidth(baseView.frame) - [Common calculateNewSizeBaseMachine:30], [Common calculateNewSizeBaseMachine:33]);
    calculatorBtn.backgroundColor =  UIColorWithRGB(0xfd4d4c);
    calculatorBtn.layer.cornerRadius = 2.0f;
    calculatorBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [calculatorBtn setTitle:@"计算预期收益" forState:UIControlStateNormal];
    [calculatorBtn addTarget:self action:@selector(calculateBegin:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:calculatorBtn];
}
/**
 *  计算收益按钮触发事件
 *
 *  @param button 触发按钮
 */
- (void)calculateBegin:(UIButton *)button
{
//    calculatorBtn.enabled = NO;
    if (_isTransid) {
        NSString *annualRate = [[self.tranBidDataDict objectForKey:@"data"] objectForKey:@"transfereeYearRate"];
        NSString *repayMode = [[self.tranBidDataDict objectForKey:@"data"] objectForKey:@"repayMode"];
        NSString *repayPeriod = [[self.tranBidDataDict objectForKey:@"data"] objectForKey:@"lastDays"];
        double minInvest = [[[self.tranBidDataDict objectForKey:@"data"] objectForKey:@"investAmt"] doubleValue];
        double nowMoney = [moneyTextField.text doubleValue];
        moneyTextField.text =  [NSString stringWithFormat:@"%.2f",minInvest > nowMoney ? minInvest : nowMoney];
        NSString *investAmt = moneyTextField.text;
        if (investAmt.length == 0 || [investAmt isEqualToString:@"0"] || [investAmt isEqualToString:@"0.0"] || [investAmt isEqualToString:@"0.00"]) {
            [MBProgressHUD displayHudError:@"请输入投资金额"];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self animated:YES];
         NSString *parmStr = [NSString stringWithFormat:@"annualRate=%@&repayMode=%@&repayPeriod=%@&investAmt=%@",annualRate,repayMode,repayPeriod,investAmt];
        [[NetworkModule sharedNetworkModule] postReq:parmStr tag:kSXTagPrdClaimsComputeIntrest owner:self];
    } else {
        
        if ([preInvestMoney isEqualToString:[UCFToolsMehod  isNullOrNilWithString:moneyTextField.text]]) {
            return;
        }
        preInvestMoney = [NSString stringWithFormat:@"%@",moneyTextField.text];
        double nowMoney = [moneyTextField.text doubleValue];
        moneyTextField.text =  [NSString stringWithFormat:@"%.2f",_normalMinInvest > nowMoney ? _normalMinInvest : nowMoney];
        NSString *investAmt = moneyTextField.text;
        NSString *parmStr = [NSString stringWithFormat:@"id=%@&investAmt=%@",normalBidID,investAmt];
        [[NetworkModule sharedNetworkModule] postReq:parmStr tag:kSXTagNormalBidComputeIntrest owner:self];
    }
}
-(void)beginPost:(kSXTag)tag
{
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    if (tag.integerValue ==  kSXTagNormalBidComputeIntrest) {
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"status"];
        if ([rstcode isEqualToString:@"1"]) {
            NSString *taotalIntrest = [NSString stringWithFormat:@"%@",dic[@"taotalIntrest"]];
//            NSString *bankIntrest = [NSString stringWithFormat:@"%@",dic[@"bankBaseIntrest"]];
            preGetMoneyLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:taotalIntrest]];
//            bankGetMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod isNullOrNilWithString:bankIntrest]];
        }
    } else {
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"status"];
        if ([rstcode isEqualToString:@"1"]) {
            NSString *taotalIntrest = [NSString stringWithFormat:@"%@",dic[@"taotalIntrest"]];
//            NSString *bankIntrest = [NSString stringWithFormat:@"%@",dic[@"bankBaseIntrest"]];
            preGetMoneyLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:taotalIntrest]];
//            bankGetMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:bankIntrest]];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    calculatorBtn.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}
/**
 *  限制输入框位数和格式
 *
 *  @param textField 注册该事件的输入框
 *
 *  @return 限制文本框后的输入框
 */
- (UITextField *)textfieldLength:(UITextField *)textField
{
    
    NSString *str = textField.text;
    NSArray *array = [str componentsSeparatedByString:@"."];
    
    NSString *jeLength = [array firstObject];
    if (jeLength.length > 9) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if (array.count == 1) {
        if (jeLength != nil&& jeLength.length > 0) {
            NSString *firstStr = [jeLength substringToIndex:1];
            if ([firstStr isEqualToString:@"0"]) {
                textField.text = @"0";
            }
        }
        
    }
    
    if(array.count > 2)
    {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if(array.count == 2)
    {
        
        str = [array objectAtIndex:1];
        
        if(str.length > 2)
        {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
        NSString *firStr = [array objectAtIndex:0];
        if (firStr == nil || firStr.length == 0) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    if (textField.text.length == 0) {
        totalMoneyLabel.text = [NSString stringWithFormat:@"¥0.00"];
    } else {
        NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
        totalMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:totalMoney]];
    }
//    [self getMoney:textField.text];
    return textField;
}
/**
 *  获取收益值
 *
 *  @param money 本金
 */
- (void)getMoney:(NSString *)money
{
    double money1 = [money doubleValue];
    double money2 = money1;
    double liLv = [self.annleRate doubleValue]/100.0f;
    double qiXian = [self.repayPeriodDay doubleValue];
    money1 = ((money1 * liLv)/360.0f) * qiXian;
    NSString *yuqiMoney = [NSString stringWithFormat:@"%.3lf",money1];
    NSString *b = [yuqiMoney substringFromIndex:yuqiMoney.length - 1];
    if ([b isEqualToString:@"5"]) {
        yuqiMoney =[yuqiMoney substringToIndex:yuqiMoney.length - 1];
    } else {
        yuqiMoney = [NSString stringWithFormat:@"%.2lf",money1];
    }
    preGetMoneyLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod AddComma:yuqiMoney]];
    double bankLilv = [self.bankBaseRate doubleValue]/100.0f;
    money2 = ((money2 * bankLilv)/360.0f) * qiXian;
    bankGetMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",money2]]];
}
/**
 *  从债券转让投标页收益入口
 *
 *  @param dataDict     源数据（投资页数据源）
 *  @param currentMoney 本金
 *  @param preMoney     金融工场收益
 *  @param bankMoney    银行收益
 */
- (void)reloadViewWithData:(NSDictionary *)dataDict AndNowMoney:(NSString *)currentMoney AndPreMoney:(NSString *)preMoney BankMoney:(NSString *)bankMoney
{
    self.tranBidDataDict = dataDict;
    self.annleRate = [[dataDict objectForKey:@"data"] objectForKey:@"annualRate"];
    self.repayPeriodDay = [[dataDict objectForKey:@"data"] objectForKey:@"lastDays"];
    moneyTextField.placeholder = [NSString stringWithFormat:@"%@元起投",[[dataDict objectForKey:@"data"] objectForKey:@"investAmt"]];
    moneyTextField.text = [NSString stringWithFormat:@"%.2f",[currentMoney doubleValue]];
    preGetMoneyLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod AddComma:preMoney]];
    bankGetMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:bankMoney]];
}
/**
 *  普通标收益入口
 *
 *  @param dataDict     源数据（投资页数据源）
 *  @param currentMoney 本金
 */
- (void)reloadViewWithData:(NSDictionary *)dataDict AndNowMoney:(NSString *)currentMoney
{
    self.annleRate = [[dataDict objectForKey:@"data"] objectForKey:@"annualRate"];
    normalBidID = [NSString stringWithFormat:@"%@",[[dataDict objectForKey:@"data"] objectForKey:@"id"]] ;
    self.repayPeriodDay = [[dataDict objectForKey:@"data"] objectForKey:@"repayPeriodDay"];
    moneyTextField.placeholder = [NSString stringWithFormat:@"%@元起投",[[dataDict objectForKey:@"data"] objectForKey:@"minInvest"]];
    moneyTextField.text = [NSString stringWithFormat:@"%.2f",[currentMoney doubleValue]];
    _normalMinInvest = [[[dataDict objectForKey:@"data"] objectForKey:@"minInvest"] doubleValue];
//    [self getMoney:currentMoney];
    [self calculateBegin:nil];
}
/**
 *  批量投资标收益入口
 *
 *  @param dataDict     源数据（投资页数据源）
 *  @param currentMoney 本金
 *  @param childPrdClaimId 子标id
 */

- (void)reloadViewWithData:(NSDictionary *)dataDict AndNowMoney:(NSString *)currentMoney AndChildPrdClaimId:(NSString *)childPrdClaimId;
{
    self.annleRate = [[dataDict objectForKey:@"colPrdClaimDetail"] objectForKey:@"colRate"];
    normalBidID = childPrdClaimId;
    self.repayPeriodDay = [[dataDict objectForKey:@"colPrdClaimDetail"] objectForKey:@"repayPeriodDay"];
    moneyTextField.placeholder = [NSString stringWithFormat:@"%@元起投",[[dataDict objectForKey:@"colPrdClaimDetail"] objectForKey:@"colMinInvest"]];
    moneyTextField.text = [NSString stringWithFormat:@"%.2f",[currentMoney doubleValue]];
    _normalMinInvest = [[[dataDict objectForKey:@"colPrdClaimDetail"] objectForKey:@"colMinInvest"] doubleValue];
    //    [self getMoney:currentMoney];
    [self calculateBegin:nil];
}



- (void)updateValue:(id)sender
{
    NSString *currentMoney = nil;
    if (slider.value == slider.maximumValue) {
        currentMoney = tempFloatValue;
    } else {
        currentMoney = [NSString stringWithFormat:@"%.2f",slider.value];
    }
    totalMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:currentMoney]];
    moneyTextField.text = [NSString stringWithFormat:@"%@",currentMoney];
    [self getMoney:currentMoney];
}
- (void)removeBtn{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
