//
//  UCFCashViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//  提现页面

#import "UCFCashViewController.h"
#import "SharedSingleton.h"
#import "UCFToolsMehod.h"
#import "ToolSingleTon.h"
#import "NZLabel.h"
#import "NSString+CJString.h"
#import "UCFChoseBankViewController.h"
#import "UCFWithdrawCashResultWebView.h"
#import "MjAlertView.h"
#import "UCFCashRecordListViewController.h"
#import "FullWebViewController.h"
@interface UCFCashViewController ()<UCFChoseBankViewControllerDelegate,MjAlertViewDelegate>
{
    CGFloat orinalHeight;
    BOOL isSendSMS;
    NSDictionary *_requestDataDic;
    NSString *_type;
    NSString *_withdrawToken;//提现Token
    BOOL _isSpecial;//是否是特殊用户
    BOOL _isHoliday;//是否是假期
    NSString *_doTime;//大额交易 非交易时间点
    NSString *_fee;//提现手续费 百分数
    NSString *_workingDay;//提现到账天数
    NSString *_criticalValueStr;//大额提现临界值
}
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *bankIcon;
@property (strong, nonatomic) IBOutlet UILabel *bankName;
@property (strong, nonatomic) IBOutlet UILabel *bankNum;
@property (strong, nonatomic) IBOutlet NZLabel *phoneLabel;//联系客服
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstPayImage;
@property (weak, nonatomic) IBOutlet UITextField *crachTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *getMoneyBtn;
@property (weak, nonatomic) IBOutlet UILabel *warnSendLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankBrachLabel;
@property (strong, nonatomic) IBOutlet UILabel *pleasechooseLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height5;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height6;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bankBranchViewHeight1;//开户行view的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *codeViewHeight;//验证码和获取验证按钮背景view的高度
@property (strong, nonatomic) IBOutlet UIButton *modifyWithdrawalMoneyBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *cashBankNo;
@property (assign, nonatomic) NSInteger counter;
@property (assign,nonatomic) BOOL isShowGetCodeBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bankBranchViewHeight2;
@property (strong, nonatomic) IBOutlet NZLabel *withdrawDescriptionLab;

- (IBAction)getMobileCheckCode:(id)sender;
- (IBAction)sumitBtnClick:(id)sender;
- (IBAction)clickChooseBankbranchVC:(UIButton *)sender;

- (IBAction)clickModifyWithdrawCashBtn:(UIButton *)sender;
@end

@implementation UCFCashViewController


- (void)leftClicked:(UIButton *)button
{
    [_timer invalidate];
    self.timer = nil;
    _crachTextField.text = @"";
    _codeTextField.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
    [_crachTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    [_crachTextField addTarget:self action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMyBindCardMessage];
    //_warnSendLabel.hidden = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    _counter = 60;
    _height1.constant = 0.5;
    _height2.constant = 0.5;
    _height3.constant = 0.5;
    _height4.constant = 0.5;
    _height5.constant = 0.5;
    _height6.constant = 0.5;
    
    _bankBranchViewHeight1.constant = 0;
    _bankBranchViewHeight2.constant = 0;
    _codeViewHeight.constant = 0;
    
    _codeTextField.hidden = YES;
    _getCodeBtn.hidden = YES;
//    _getCodeBtn.userInteractionEnabled = NO;
    _bankBrachLabel.hidden = YES;
    _pleasechooseLabel.hidden  = YES;
    
    isSendSMS = NO;
    self.getMoneyBtn.tag = 1010; //设置当前按钮tag 为 1010
    
    self.isShowGetCodeBtn = NO;
    
    baseTitleLabel.text = @"提现";
    [self addLeftButton];
    [self addRightButtonWithName:@"提现记录"];
    _crachTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _getCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);
//    [_getCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
//    [_getCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [_getMoneyBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_getMoneyBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [_crachTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    [_crachTextField addTarget:self action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fradeTextField)];
    [_baseScrollView addGestureRecognizer:tap];
    self.view.backgroundColor = UIColorWithRGBA(230, 230, 234, 1);
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)];
    [_phoneLabel addGestureRecognizer:tap1];
    [_phoneLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"400-0322-988"];
    //[_warnSendLabel setHidden:YES];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(soudLabelClick:)];
    [_warnSendLabel addGestureRecognizer:tapGes];
    _warnSendLabel.userInteractionEnabled = YES;
    _warnSendLabel.text = @"";
}
- (void)addRightButtonWithName:(NSString *)rightButtonName;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 65, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)clickRightBtn
{
    UCFCashRecordListViewController *viewController = [[UCFCashRecordListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}
//点击语音验证码
- (void)soudLabelClick:(UITapGestureRecognizer *)tap
{
    if (_counter > 0 && _counter < 60) {
        [AuxiliaryFunc showToastMessage:_getCodeBtn.titleLabel.text withView:self.view];
        return;
    } else {
        [self sendVerifyCode:@"VMS"];
    }
    
}

- (void)openURL{
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4000322988"]];
}

- (void)fradeTextField
{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.getMoneyBtn.userInteractionEnabled = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_crachTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}
#pragma ----
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0f withDuration:animationDuration];
}
-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)time
{
    if (height==0)
    {
        if (ScreenHeight == 480) {
            _baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 50);
            _baseScrollView.contentOffset = CGPointMake(0, 0);
        }
    }
    else
    {
        if (ScreenHeight == 480 ) {
            _baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 230);
            [UIView animateWithDuration:0.6 animations:^{
                _baseScrollView.contentOffset = CGPointMake(0, 100);
            }];
        }

    }
}

#pragma mark - UITextField
// 当输入框获得焦点时，执行
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (ScreenHeight < 568) {
//        if (textField == _crachTextField) {
//            [UIView animateWithDuration:0.25 animations:^{
//                self.view.frame = CGRectMake(0, -20, ScreenWidth, ScreenHeight);
//            }];
//        }else{
//            [UIView animateWithDuration:0.25 animations:^{
//                self.view.frame = CGRectMake(0, -84, ScreenWidth, ScreenHeight);
//            }];
//        }
//    }
//}

// 文本框失去焦点时，执行
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    }];
//}

//文本框长度
- (UITextField *)textfieldLength:(UITextField *)textField {
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
    
    if(array.count > 2) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if(array.count == 2) {
        str = [array objectAtIndex:1];
        if(str.length > 2) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
        NSString *firStr = [array objectAtIndex:0];
        if (firStr == nil || firStr.length == 0) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    
    return textField;
}
-(void)textFieldEditingDidEnd:(UITextField *)textField{
    double withdrawalMoney = [textField.text doubleValue];
    if (![SharedSingleton isValidateMsg:_crachTextField.text]) {
        return;
    }
    self.isShowGetCodeBtn = YES;
    _crachTextField.userInteractionEnabled = NO;
    if ([UserInfoSingle sharedManager].openStatus == 5 ) {//特殊用户不允许修改提现金额
        _modifyWithdrawalMoneyBtn.hidden = YES;
    }else{
         _modifyWithdrawalMoneyBtn.hidden = NO;
    }
    _codeTextField.hidden = NO;
    _getCodeBtn.hidden = NO;
    double criticalValue = [[self.cashInfoDic[@"data"] objectForKey:@"criticalValue"] doubleValue];
    if (withdrawalMoney /10000.00 > criticalValue || _isCompanyAgent || _isSpecial) { //临界值判断 10万
        _bankBrachLabel.hidden = NO;
        _pleasechooseLabel.hidden  = NO;
        [UIView animateWithDuration:0.8 animations:^{
            _bankBranchViewHeight1.constant = 44;
            _bankBranchViewHeight2.constant = 44;
            _height4.constant = 0;
            _height5.constant = 0.5;
            _codeViewHeight.constant = 47;
        }];
        _baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 130);
    }else{
        
        _bankBrachLabel.hidden = YES;
        _pleasechooseLabel.hidden  = YES;
        
        [UIView animateWithDuration:0.8 animations:^{
            _bankBranchViewHeight1.constant = 0;
            _bankBranchViewHeight2.constant = 0;
            _codeViewHeight.constant = 47;
            _height4.constant = 0.5;
        }];
        _baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 90);

       
    }
}
- (void)timerFired
{
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_counter] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _getCodeBtn.backgroundColor = UIColorWithRGB(0xd4d4d4);
    _counter--;
    if (_counter == 0) {
        [self resetGetCodeButtonStuats];
        NSMutableAttributedString *str = [SharedSingleton getAcolorfulStringWithText1:[NSString stringWithFormat:@"%@",@"收不到短信？点击获取 语音验证码"] Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", @"语音验证码"] Color2:UIColorWithRGB(0x4aa1f9) AllText:[NSString stringWithFormat:@"%@",@"收不到短信？点击获取 语音验证码"]];
        _warnSendLabel.attributedText = str;

    }
}
#pragma mark 重置获取验证码的状态
-(void)resetGetCodeButtonStuats{
    [_timer  setFireDate:[NSDate distantFuture]];
    _counter = 60;
     isSendSMS = NO;
    _warnSendLabel.text = @"";
    _getCodeBtn.userInteractionEnabled = YES;
    _getCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
}
#pragma mark 初始化数据
- (void)getMyBindCardMessage
{
    NSDictionary *dataDic= [_cashInfoDic objectForKey:@"data"];
    
    NSDictionary *bankInfoDic = [dataDic objectSafeDictionaryForKey:@"bankInfo"];
    
    if ([dataDic isEqual:[NSNull null]]) {
        return;
    }
    if ([bankInfoDic objectForKey:@"supportQPass"]) {
        _firstPayImage.hidden = NO;
    } else {
        _firstPayImage.hidden = YES;
    }
    NSString *bankUrl = [bankInfoDic objectForKey:@"bankLogo"];
    if (![bankUrl isEqual:[NSNull null]]) {
        [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:bankUrl]];
    }
    if (![[bankInfoDic objectForKey:@"bankName"] isEqual:[NSNull null]]) {
        _bankName.text = [bankInfoDic objectForKey:@"bankName"];
    }
    
    _bankNum.text = [bankInfoDic objectForKey:@"bankCardNo"];
    NSString *keTiXianMoney = [NSString stringWithFormat:@"%.2f",[dataDic[@"accountAmount"] doubleValue]];
    _availableLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod AddComma:keTiXianMoney]];
    NSString *bankBranchNameStr = [bankInfoDic objectSafeForKey:@"bankBranchName"];
    if([bankBranchNameStr isEqualToString:@""]){
         _bankBrachLabel.text = @"开户支行";
         _cashBankNo  = @"" ;
    }else{
        _bankBrachLabel.text = bankBranchNameStr;
        _cashBankNo = [bankInfoDic objectSafeForKey:@"bankCardNo"];
    }
    _withdrawToken = [dataDic objectSafeForKey:@"withdrawToken"];
    _isSpecial = [[bankInfoDic objectSafeForKey:@"isSpecial"] boolValue];
    _isCompanyAgent = [[bankInfoDic objectSafeForKey:@"isCompanyAgent"] boolValue];
    _doTime = [dataDic objectSafeForKey:@"doTime"];
    _fee = [dataDic objectSafeForKey:@"fee"];
    _workingDay = [dataDic objectSafeForKey:@"workingDay"];
    _criticalValueStr =  [dataDic objectSafeForKey:@"criticalValue"];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineSpacing = 1;
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:13],/*(字体)*/
                          NSParagraphStyleAttributeName:paragraph,/*(段落)*/
                          };
    NSString *withdrawDescriptionStr = [NSString stringWithFormat: @"•对首次充值后无投资的提现，平台收取%@%%的手续费。\n•%@万及以下提现，7*24小时实时到账； %@万以上提现，工作日%@，最快30分钟内到账，实际到账时间以发卡行为准，其它时间或节假日发起的提现，不予受理；中国银行和南京银行，单笔仅支持5万及以下金额提现。\n• 单笔提现金额不低于%@元。\n• 填写的提现信息不正确导致提现失败，由此产生的提现费用不予退还。",_fee,_criticalValueStr,_criticalValueStr,_doTime,[dataDic  objectForKey:@"minAmt"]];
    _withdrawDescriptionLab.attributedText =  [NSString getNSAttributedString:withdrawDescriptionStr labelDict:dic];
}
#pragma mark --- 点击修改提现金额按钮
- (IBAction)clickModifyWithdrawCashBtn:(UIButton *)sender{
    _crachTextField.userInteractionEnabled = YES;
    [_crachTextField becomeFirstResponder];
    _modifyWithdrawalMoneyBtn.hidden = YES;
    _bankBrachLabel.hidden = YES;
    _pleasechooseLabel.hidden  = YES;
    _codeTextField.hidden = YES;
    _getCodeBtn.hidden = YES;
    [UIView animateWithDuration:0.8 animations:^{
        _bankBranchViewHeight1.constant = 0;
        _bankBranchViewHeight2.constant = 0;
        _height4.constant = 0.5;
        _codeViewHeight.constant = 0;
    }];
    //修改提现金额，重新设置发送验证码按钮的状态
    [self resetGetCodeButtonStuats];
    self.codeTextField.text = @"";
    self.isShowGetCodeBtn = NO;
}
-(void)setIsShowGetCodeBtn:(BOOL)isShowGetCodeBtn{
    _isShowGetCodeBtn = isShowGetCodeBtn;
    if (isShowGetCodeBtn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.28* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.getMoneyBtn setTitle:@"提现" forState:UIControlStateNormal];
        });
    }else{
        [self.getMoneyBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}
#pragma mark - 请求网络
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _getCodeBtn.userInteractionEnabled = YES;
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}

- (void)beginPost:(kSXTag)tag
{
   
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (tag.intValue == kSXTagCashAdvance) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([dic[@"status"] isEqualToString:@"1"]) {
            _cashInfoDic = dic;
            if ([dic[@"cjflag"] isEqualToString:@"1"]) {
                _firstPayImage.hidden = NO;
            } else {
                _firstPayImage.hidden = YES;
            }
            NSString *bankUrl = dic[@"url"];
            [_bankIcon sd_setImageWithURL:[NSURL URLWithString:bankUrl]];
            _bankName.text = dic[@"bankName"];
            _bankNum.text = dic[@"bankCard"];
            NSString *keTiXianMoney = [NSString stringWithFormat:@"%.2f",[dic[@"available_balance"] doubleValue]];
            _availableLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod AddComma:keTiXianMoney]];
        } else {
            [MBProgressHUD displayHudError:dic[@"statusdes"]];
        }
    } else if (tag.intValue == kSXTagActWithdrawApply){
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"status"];
        if([rstcode intValue] == 1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
            [MBProgressHUD displayHudError:@"提现申请成功"];
            self.getMoneyBtn.userInteractionEnabled = YES;
            [_timer  setFireDate:[NSDate distantFuture]];
            _counter = 60;
            _getCodeBtn.userInteractionEnabled = YES;
            [_getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
            _getCodeBtn.backgroundColor = UIColorWithRGBA(111, 131, 159, 1);
            _crachTextField.text = @"";
            _codeTextField.text = @"";
            //_warnSendLabel.hidden = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            if ([rstcode intValue] == 6) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
                [alert show];
            } else {
                [MBProgressHUD displayHudError:dic[@"statusdes"]];
  
            }
            self.getMoneyBtn.userInteractionEnabled = YES;
        }

    } else if (tag.intValue == kSXTagIdentifyCode) {
//        {"ret":true,"code":10000,"message":"获取成功","ver":1,"data":null}
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        if([rstcode intValue] == 1)
        {
            [MBProgressHUD displayHudError:@"已发送，请等待接收，60秒后可再次获取。"];
            
//            if (_warnSendLabel.hidden == NO) {
//                _warnSendLabel.hidden = YES;
//            }
            _getCodeBtn.userInteractionEnabled = NO;
            [_timer setFireDate:[NSDate distantPast]];
            [_getCodeBtn setBackgroundColor:UIColorWithRGB(0xd4d4d4)];
            NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:PHONENUM];
            NSString *tempText = [NSString stringWithFormat:@"已向您绑定的手机号码%@发送短信验证码",mobile];
            if (!isSendSMS) {
                _warnSendLabel.text = tempText;
            }
            isSendSMS = YES;
            _warnSendLabel.font = [UIFont systemFontOfSize:12.0f];
            //_warnSendLabel.hidden = NO;
        } else {
            _getCodeBtn.userInteractionEnabled = YES;
            [MBProgressHUD displayHudError:dic[@"message"]];
        }
        if (dic == nil) {
            _getCodeBtn.userInteractionEnabled = YES;
            [MBProgressHUD displayHudError:@"系统繁忙,请稍候再试!"];
        }
    }
    else if (tag.intValue == kSXTagWithdrawSub){
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        if([rstcode intValue] == 1)
        {
            NSDictionary  *dataDict = dic[@"data"][@"tradeReq"];
            NSString *urlStr = dic[@"data"][@"url"];
            UCFWithdrawCashResultWebView *webVC = [[UCFWithdrawCashResultWebView alloc]initWithNibName:@"UCFWithdrawCashResultWebView" bundle:nil];
            webVC.webDataDic = dataDict;
            webVC.navTitle = @"即将跳转";
            webVC.url = urlStr;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else{
            self.getMoneyBtn.userInteractionEnabled = YES;
            NSString *messageStr = [dic objectSafeForKey:@"message"];
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
        }
    } else if (tag.intValue == kSXTagWithdrawMoneyValidate){ //提现金额是否超过限制
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        if([rstcode intValue] == 1)
        {
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userId",@"",@"destPhoneNo", _type,@"isVms",@"1",@"type",nil];
            [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagIdentifyCode owner:self signature:YES];
        }
        else{
            _getCodeBtn.userInteractionEnabled = YES;
            NSString *message =  [dic objectSafeForKey:@"message"];
            if(![message isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

- (IBAction)getMobileCheckCode:(id)sender {
    [self sendVerifyCode:@"SMS"];
}

- (void)sendVerifyCode:(NSString*)type
{
    if(!self.isShowGetCodeBtn){ //
        return;
    }
    _type = type;
    if (![SharedSingleton isValidateMsg:_crachTextField.text]) {
        [MBProgressHUD displayHudError:@"请输入提现金额"];
        return;
    }
    NSString *getMoney = [NSString stringWithFormat:@"%.2f",[_crachTextField.text doubleValue]];
    NSString *leastAmount = [NSString stringWithFormat:@"%@",[self.cashInfoDic[@"data"]  objectForKey:@"minAmt"]];
    leastAmount = [NSString stringWithFormat:@"%.0f",[leastAmount doubleValue]];
    if ([Common stringA:getMoney ComparedStringB:leastAmount] == -1) {
        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"单笔提现金额不低于%@元",leastAmount]];
        return;
    }
    NSString *maxAmount = [NSString stringWithFormat:@"%.2f",[[self.cashInfoDic[@"data"] objectForKey:@"accountAmount"] doubleValue]];
    if ([Common stringA:getMoney ComparedStringB:maxAmount] == 1) {
        [MBProgressHUD displayHudError:@"可提现余额不足"];
        return;
    }
    double withdrawalMoney = [_crachTextField.text doubleValue];
    double criticalValue = [[self.cashInfoDic[@"data"] objectForKey:@"criticalValue"] doubleValue];
    if (withdrawalMoney /10000.00 > criticalValue || _isCompanyAgent || _isSpecial) {
        if ([self isWorkTimeCash] ||_isHoliday) {
            NSString *str = [NSString stringWithFormat:@"%@万以上提现，仅在工作日%@间处理",[self.cashInfoDic[@"data"] objectForKey:@"criticalValue"],_doTime];
            [MBProgressHUD displayHudError:str];
            return;
        }
        //临界值判断10万  大额提现时判断联行号是否为空
        if ( [self.bankBrachLabel.text  isEqualToString: @"开户支行"] || [_cashBankNo isEqualToString: @""] || _cashBankNo == nil ) {
            [MBProgressHUD displayHudError:@"请选择开户支行"];
             return;
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _getCodeBtn.userInteractionEnabled = NO;
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userId",_crachTextField.text,@"reflectAmount",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagWithdrawMoneyValidate owner:self signature:YES];
}

- (IBAction)sumitBtnClick:(UIButton *)sender {
    
    [_crachTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    if (![SharedSingleton isValidateMsg:_crachTextField.text]) {
        [MBProgressHUD displayHudError:@"请输入提现金额"];
        return;
    }
    double withdrawalMoney = [_crachTextField.text doubleValue];
    double maxAmount =  [[self.cashInfoDic[@"data"] objectForKey:@"accountAmount"] doubleValue];
    if (withdrawalMoney <10.00) {
        [MBProgressHUD displayHudError:@"单笔提现金额不低于10元"];
        return;
    }
    if (withdrawalMoney > maxAmount ) {
        [MBProgressHUD displayHudError:@"可提现余额不足"];
        return;
    }
    if ([self.getMoneyBtn.currentTitle isEqualToString:@"下一步"]) {
        return;
    }
    if (![SharedSingleton isValidateMsg:_codeTextField.text]) {
        [MBProgressHUD displayHudError:@"请输入验证码"];
        return;
    }
    NSString *getMoney = [NSString stringWithFormat:@"%.2f",[_crachTextField.text doubleValue]];
    NSString *leastAmount = [NSString stringWithFormat:@"%@",[self.cashInfoDic[@"data"] objectForKey:@"minAmt"]];
    leastAmount = [NSString stringWithFormat:@"%.0f",[leastAmount doubleValue]];
    if ([Common stringA:getMoney ComparedStringB:leastAmount] == -1) {
        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"单笔提现金额不低于%@元",leastAmount]];
        return;
    }
    NSString *maxAmountStr = [NSString stringWithFormat:@"%.2f",[[self.cashInfoDic[@"data"] objectForKey:@"accountAmount"] doubleValue]];
//    NSString *maxAmount = [NSString stringWithFormat:@"%.2f",[[self.cashInfoDic[@"data"] objectForKey:@"accountAmount"] doubleValue]];
    if ([Common stringA:getMoney ComparedStringB:maxAmountStr] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"可转出余额不足，多多投资吧" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *isFeeEnableStr = [NSString stringWithFormat:@"%@",[self.cashInfoDic[@"data"] objectSafeForKey:@"isFeeEnable"]];
    BOOL isFeeEnable = [isFeeEnableStr boolValue];
    if (isFeeEnable) {
        double cashMoney = [_crachTextField.text doubleValue];
        double feeMoney = cashMoney * [_fee doubleValue] *0.01;
        double actualMoney = cashMoney - feeMoney;
        NSString *cashMoneyStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",cashMoney]];
        NSString *feeMoneyStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",feeMoney]];
        NSString *actualMoneyStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",actualMoney]];
        NSString *cashMoneyStr1 = [NSString stringWithFormat:@"¥%@",cashMoneyStr];
        NSString *feeMoneyStr1 = [NSString stringWithFormat:@"¥%@",feeMoneyStr];
        NSString *actualMoneyStr1 = [NSString stringWithFormat:@"¥%@",actualMoneyStr];
        MjAlertView *alertView =[[MjAlertView alloc] initCashAlertViewWithCashMoney:cashMoneyStr1 ActualAccount:actualMoneyStr1 FeeMoney:feeMoneyStr1 delegate:self cancelButtonTitle:@"取消" withOtherButtonTitle:@"确定"];
        [alertView show];
        return;
    }
    sender.userInteractionEnabled = NO;
    //同盾
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    manager->getDeviceInfoAsync(nil, self);
}
-(BOOL)isWorkTimeCash{
    // 时间字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 手机当前时间
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr = [fmt stringFromDate:nowDate];
    NSString *nowDateStartStr = [NSString stringWithFormat:@"%@0%@:00",[nowDateStr substringToIndex:11],[_doTime substringToIndex:4]];
    NSString *nowDateEndStr = [NSString stringWithFormat:@"%@%@:00",[nowDateStr substringToIndex:11],[_doTime substringWithRange:NSMakeRange(5, 5)]];
    NSDateFormatter *fmt1 = [[NSDateFormatter alloc] init];
    fmt1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate = [fmt1 dateFromString:nowDateStartStr];
    NSDateFormatter *fmt2 = [[NSDateFormatter alloc] init];
    fmt2.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *endDate = [fmt2 dateFromString:nowDateEndStr];
    
    DLog(@"nowDateStr --->>>>> %@",nowDateStr);
     DLog(@"startDate --->>>>> %@",startDate);
     DLog(@"endDate --->>>>> %@",endDate);
    
    /**
     NSComparisonResult的取值
     NSOrderedAscending = -1L, // 升序, 越往右边越大
     NSOrderedSame,  // 相等
     NSOrderedDescending // 降序, 越往右边越小
     */
    // 获得比较结果(谁大谁小)
    NSComparisonResult startResult = [nowDate compare:startDate];
    NSComparisonResult endResult   = [nowDate compare:endDate];
    
    if (startResult == NSOrderedDescending  && endResult == NSOrderedDescending) { // 降序, 越往右边越小
         return YES;
    }else if(startResult == NSOrderedAscending  && endResult == NSOrderedAscending){// 升序, 越往右边越大
         return YES;
    }else{
        return NO;
    }
}
#pragma mark -选择开户支行
- (IBAction)clickChooseBankbranchVC:(UIButton *)sender {
    
    
    UCFChoseBankViewController *choseBankVC = [[UCFChoseBankViewController alloc]initWithNibName:@"UCFChoseBankViewController" bundle:nil];
    choseBankVC.delegate = self;
    choseBankVC.bankName = _bankName.text;
    choseBankVC.title = @"选择开户支行";
    [self.navigationController pushViewController:choseBankVC  animated:YES];
}
#pragma mark -选择开户支行支行回调函数
-(void)chosenBranchBank:(NSDictionary*)_dicBranchBank{
    self.bankBrachLabel.text = _dicBranchBank[@"bankName"];
    self.cashBankNo = _dicBranchBank[@"bankNo"];
}
#pragma mark - 同盾
- (void) didReceiveDeviceBlackBox: (NSString *) blackBox {
    NSString *wanip = [[NSUserDefaults standardUserDefaults] valueForKey:@"curWanIp"];
    double  criticalValue = [[self.cashInfoDic[@"data"] objectForKey:@"criticalValue"] doubleValue] ;
    NSDictionary *dataDic = @{};
    if([_crachTextField.text doubleValue] / 10000.00 > criticalValue  ||  _isSpecial ||_isCompanyAgent ){//提现金额大于或等于10万 特殊用户  机构用户 都走这个大额流程
        dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",_crachTextField.text,@"reflectAmount",_cashBankNo,@"bankNo",_codeTextField.text,@"validateCode",_withdrawToken,@"withdrawTicket",blackBox, @"token_id",wanip,@"ip",nil];
    }else{
        dataDic= [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",_crachTextField.text,@"reflectAmount",@"",@"bankNo",_codeTextField.text,@"validateCode",_withdrawToken,@"withdrawTicket",blackBox, @"token_id",wanip,@"ip",nil];
    }
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagWithdrawSub owner:self signature:YES];
}
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    
    if (index == 1) {
        //同盾
        // 获取设备管理器实例
        FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
        manager->getDeviceInfoAsync(nil, self);
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
