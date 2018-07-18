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
#import "UCFCashTableViewCell.h"
#import "UCFSettingItem.h"
#import "UCFRedBagViewController.h"

#define CASHWAYCELLHIGHT  73.0 //提现方式cell 的高度
@interface UCFCashViewController ()<UCFChoseBankViewControllerDelegate,MjAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>
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
    NSString *_accountAmountStr;//可提现金额
    NSString *_perDayAmountLimit;//单日最大提现金额
    NSString *_perDayRealTimeAmountLimit;//单日最大实时提现金额
    NSArray  *_cashWayArray;//提现方式数组
    NSString *_perDayRealTimeTipStr;//单日提现子标题提示信息
    NSString *_noticeTxt;//显不显示那行字;
    BOOL _hasCoupon;//hasCoupon为1时进入已领取页,为0时进入领券页
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
@property (strong, nonatomic) IBOutlet UIView *honerCashTipView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *honerCashTipViewHight;//开户行view
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *honerCashTipViewLeft;//开户行view
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *honerCashTipViewRight;//开户行view
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cashWayTableViewHeigt;//实时提现View的高度
@property (strong, nonatomic) IBOutlet UITableView *cashWayTableView;
@property (strong, nonatomic) IBOutlet UIButton *allCashMoneyBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *cashBankNo;
@property (assign, nonatomic) NSInteger counter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bankBranchViewHeight2;
@property (strong, nonatomic) IBOutlet NZLabel *withdrawDescriptionLab;
@property (strong, nonatomic) IBOutlet NZLabel *telServiceLabel;//联系客服
@property (assign, nonatomic) float tableviewCellHeight;//联系客服
@property (strong, nonatomic) NSString *telServiceNo;

- (IBAction)getMobileCheckCode:(id)sender;
- (IBAction)sumitBtnClick:(id)sender;
- (IBAction)clickChooseBankbranchVC:(UIButton *)sender;
- (IBAction)gotoHonerCashActivityView:(id)sender;

- (IBAction)clickAllCashMoneyBtn:(UIButton *)sender;
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
    
    [self getMyBindCardMessage];//初始化数据
    [self initCashStyle]; //初始化提现方式
    //_warnSendLabel.hidden = YES;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//    [_timer setFireDate:[NSDate distantFuture]];
//    _counter = 60;
    _height1.constant = 0.5;
    _height2.constant = 0.5;
    _height3.constant = 0.5;
    _height4.constant = 0.5;
    _height5.constant = 0.5;
    _height6.constant = 0.5;
    
    
    
//    _codeTextField.hidden = YES;
//    _getCodeBtn.hidden = YES;
    
    isSendSMS = NO;
    self.getMoneyBtn.tag = 1010; //设置当前按钮tag 为 1010
    if (self.accoutType == SelectAccoutTypeHoner) {
         baseTitleLabel.text = @"尊享提现";
    }else{
         baseTitleLabel.text = @"微金提现";
    }
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
    tap.delegate = self;
    [_baseScrollView addGestureRecognizer:tap];
    self.view.backgroundColor = UIColorWithRGBA(230, 230, 234, 1);
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)];
    tap1.delegate = self;
    [_phoneLabel addGestureRecognizer:tap1];
    _phoneLabel.text = [NSString stringWithFormat:@"如果您绑定的银行卡暂不支持手机快捷支付请联系客服%@",_telServiceNo];
    [_phoneLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:_telServiceNo];
    //[_warnSendLabel setHidden:YES];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    tapGes.delegate = self;
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
    viewController.accoutType = self.accoutType;
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
    NSString *telUrl = [NSString stringWithFormat:@"telprompt://%@",_telServiceNo];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
   
}

- (void)fradeTextField
{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
    //设置ScrollView总高度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        float scrollViewHeight = CGRectGetMaxY(_telServiceLabel.frame);
        self.baseScrollView.contentSize = CGSizeMake(ScreenWidth, scrollViewHeight + 50);
        DLog(@"%@",self.baseScrollView);
    });
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    if(self.accoutType == SelectAccoutTypeHoner)
    {
        [self honerCashActivityAnimating];
    }
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
        if (ScreenHeight == 480 || ScreenHeight == 568) {
            _baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 150);
            _baseScrollView.contentOffset = CGPointMake(0, 0);
        }
    }
    else
    {
        if (ScreenHeight == 480 || ScreenHeight == 568) {
            _baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 260);
            [UIView animateWithDuration:0.6 animations:^{
                _baseScrollView.contentOffset = CGPointMake(0, 100);
            }];
        }

    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.tableviewCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cashWayArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"CashTableViewCell";
    UCFCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFCashTableViewCell" owner:nil options:nil] firstObject];
    }
    
    UCFSettingItem *item = _cashWayArray[indexPath.row];
    cell.cashWayTitle.text = item.title;
    cell.cashWayDetailTitle.text = item.subtitle;
    [cell.cashWayDetailTitle setFont:[UIFont systemFontOfSize:9] string:_perDayRealTimeTipStr];
    [cell.cashWayDetailTitle setFontColor:[UIColor redColor] string:_perDayRealTimeTipStr];
    cell.cashWayButton.selected = item.isSelect;
    cell.cashWayButton.tag = indexPath.row +100;
    [cell.cashWayButton addTarget:self action:@selector(clickcCashWayButton:) forControlEvents:UIControlEventTouchUpInside];
    if ([item.title isEqualToString:@"大额提现"] && cell.cashWayButton.selected) {//大额提现
        _bankBranchViewHeight2.constant = 44;
        _bankBrachLabel.hidden = NO;
        _pleasechooseLabel.hidden  = NO;
        _height4.constant = 0;
        _height5.constant = 0.5;
    }else{
        _bankBranchViewHeight2.constant = 0;
        _bankBrachLabel.hidden = YES;
        _pleasechooseLabel.hidden  = YES;
        _height4.constant = 0.5;
        _height5.constant = 0;
    }
    if (_cashWayArray.count == 2 && indexPath.row == 0) {
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(49, self.tableviewCellHeight - 0.5,ScreenWidth - 49, 0.5)];
        lineview.backgroundColor = UIColorWithRGB(0xE3E5EA);
        [cell addSubview:lineview];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.crachTextField  resignFirstResponder];
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_cashWayArray.count == 1) {
         UCFSettingItem *item = _cashWayArray[indexPath.row];
        item.isSelect = YES;
        
    }else{
        UCFSettingItem *item1 = [_cashWayArray firstObject];
        UCFSettingItem *item2 = [_cashWayArray lastObject];

        if (indexPath.row == 0) {
            item1.isSelect = YES;
            item2.isSelect = NO;
        }else{
            item1.isSelect = NO;
            item2.isSelect = YES;
        }
    }
    [tableView reloadData];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if (touch.view.tag  == 1001) {//cell 上的所有子View的tag == 1001
        return NO;
    }
    return  YES;
}
-(void)clickcCashWayButton:(UIButton *)button{
    if (_cashWayArray.count == 2) {
        UCFSettingItem *item1 = [_cashWayArray firstObject];
        UCFSettingItem *item2 = [_cashWayArray lastObject];
        if (button.tag == 100) {
            item1.isSelect = YES;
            item2.isSelect = NO;
        }else{
            item1.isSelect = NO;
            item2.isSelect = YES;
        }
        [_cashWayTableView reloadData];
        
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
    [self realTimeWithdrawalAmount:textField.text];
    return textField;
}
-(void)textFieldEditingDidEnd:(UITextField *)textField{

//    [self realTimeWithdrawalAmount:textField.text];
}
#pragma mark -实时监测提现金额
-(void)realTimeWithdrawalAmount:(NSString *)cashMoneyStr{
    double withdrawalMoney = [cashMoneyStr doubleValue];
    
    if (withdrawalMoney >[_accountAmountStr doubleValue]) {
        _crachTextField.text = _accountAmountStr;
        withdrawalMoney = [_accountAmountStr doubleValue];
    }
    if(_isCompanyAgent || _isSpecial){//如果是机构用户 或 特殊用户
        _bankBranchViewHeight2.constant = 44;
    }else {
        if ([_bankName.text isEqualToString:@""]) { //如果是无行别的用户
            _bankBranchViewHeight2.constant = 0;
        }else{
            UCFSettingItem *item1 = [_cashWayArray firstObject];
            UCFSettingItem *item2 = [_cashWayArray lastObject];
            if (withdrawalMoney /10000.00 > [_criticalValueStr doubleValue]) {//大额提现临界值
                item1.isSelect = NO;
                item2.isSelect = YES;
            }else{
                item1.isSelect = YES;
                item2.isSelect = NO;
            }
            [_cashWayTableView reloadData];
        }
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
        _bankName.text = [bankInfoDic objectSafeForKey:@"bankName"];
    }
    
    _bankNum.text = [bankInfoDic objectForKey:@"bankCardNo"];
    _accountAmountStr = [NSString stringWithFormat:@"%.2f",[dataDic[@"accountAmount"] doubleValue]];
    _availableLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod AddComma:_accountAmountStr]];
    NSString *bankBranchNameStr = [bankInfoDic objectSafeForKey:@"bankBranchName"];
    if([bankBranchNameStr isEqualToString:@""]){
         _bankBrachLabel.text = @"开户支行";
         _cashBankNo  = @"" ;
    }else{
        _bankBrachLabel.text = bankBranchNameStr;
        _cashBankNo = [bankInfoDic objectSafeForKey:@"bankNo"];
    }
    _withdrawToken = [dataDic objectSafeForKey:@"withdrawToken"];
    _isSpecial = [[bankInfoDic objectSafeForKey:@"isSpecial"] boolValue];
    _isCompanyAgent = [[bankInfoDic objectSafeForKey:@"isCompanyAgent"] boolValue];
    _doTime = [dataDic objectSafeForKey:@"doTime"];
    _fee = [dataDic objectSafeForKey:@"fee"];
    _workingDay = [dataDic objectSafeForKey:@"workingDay"];
    _criticalValueStr =  [dataDic objectSafeForKey:@"criticalValue"];
    _perDayAmountLimit =  [dataDic objectSafeForKey:@"perDayAmountLimit"];
    _perDayRealTimeAmountLimit = [dataDic objectSafeForKey:@"perDayRealTimeAmountLimit"];
    _perDayRealTimeTipStr = [dataDic objectSafeForKey:@"realWithdrawMess"];//实时提现银行维护时间描述
    _noticeTxt = [dataDic objectSafeForKey:@"noticeTxt"];
    _hasCoupon = [[dataDic objectSafeForKey:@"hasCoupon"] boolValue];
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.alignment = NSTextAlignmentLeft;
//    paragraph.lineSpacing = 1;
//    NSDictionary *dic = @{
//                          NSFontAttributeName:[UIFont systemFontOfSize:13],/*(字体)*/
//                          NSParagraphStyleAttributeName:paragraph,/*(段落)*/
//                          };
    NSString *isThreePlatStr = self.accoutType == SelectAccoutTypeP2P ? @"平台方":@"第三方支付平台";
    NSString *withdrawDescriptionStr = [NSString stringWithFormat: @"•单笔提现金额不能低于%@元，提现申请成功后不可撤回；\n•对首次充值后无投资的提现，%@收取%@%%的手续费；\n•徽电子账户采用原卡进出设置，为了您的资金安全，只能提现至您绑定的银行卡；",[dataDic  objectForKey:@"minAmt"],isThreePlatStr,_fee];
    _withdrawDescriptionLab.text = withdrawDescriptionStr;
    __weak typeof(self) weakSelf = self;
    self.telServiceNo = [dataDic objectSafeForKey:@"customerServiceNo"];
    self.telServiceLabel.text = [NSString stringWithFormat:@"•如遇问题请与客服联系%@。",self.telServiceNo];
    [self.telServiceLabel addLinkString:self.telServiceNo block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf openURL];
    }];
    [self.telServiceLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:self.telServiceNo];

   
}
#pragma mark --- 初始化提现方式
-(void)initCashStyle{
    NSString *realTimeCashStr = @"";
//    _perDayRealTimeTipStr = @"每晚23:00至次日1:00是银行系统的维护时间，为避免掉单请勿该时段提现。";
////    _perDayRealTimeTipStr = @"";
    if([_perDayRealTimeTipStr isEqualToString:@""]){
        self.tableviewCellHeight = 70.f;
    }else{
        self.tableviewCellHeight = 73.0f;
    }

    if ([_perDayRealTimeAmountLimit isEqualToString:@""]) { //如果实时提现单日限额为空，则不展示
        realTimeCashStr = [NSString stringWithFormat:@"单笔金额≤%@万，7*24小时实时到账。\n%@",_criticalValueStr,_perDayRealTimeTipStr];
    }else{
        realTimeCashStr = [NSString stringWithFormat:@"单笔金额≤%@万，单日≤%@万，7*24小时实时到账。\n%@",_criticalValueStr,_perDayRealTimeAmountLimit,_perDayRealTimeTipStr];
    }
    NSString *largeCashStr = [NSString stringWithFormat:@"工作日%@受理，预计2小时内到账。",_doTime];

    if(_isCompanyAgent || _isSpecial){//如果是机构用户 或 特殊用户
        
        
        _bankBranchViewHeight2.constant = 44;
        _height4.constant = 0;
        _height5.constant = 0.5;
        _bankBrachLabel.hidden = NO;
        _pleasechooseLabel.hidden  = NO;
        UCFSettingItem *item = [UCFSettingItem itemWithTitle:@"大额提现"];
        item.subtitle = largeCashStr;
        item.isSelect = YES;
        _cashWayArray = @[item];
        self.baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 180);
    }else {
        _bankBranchViewHeight2.constant = 0;
        _bankBrachLabel.hidden = YES;
        _pleasechooseLabel.hidden  = YES;
        if ([_bankName.text isEqualToString:@""]) { //如果是无行别的用户
            UCFSettingItem *item = [UCFSettingItem itemWithTitle:@"实时提现"];
            item.subtitle = realTimeCashStr;
            item.isSelect = YES;
            _cashWayArray = @[item];
            self.baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 180);
            _height4.constant = 0.5;
        }else{
            UCFSettingItem *item1 = [UCFSettingItem itemWithTitle:@"实时提现"];
            item1.subtitle = realTimeCashStr;
            item1.isSelect = YES;
            UCFSettingItem *item2 = [UCFSettingItem itemWithTitle:@"大额提现"];
            item2.subtitle = largeCashStr;
            item2.isSelect = NO;
            _cashWayArray = @[item1,item2];
            _height4.constant = 0;
            _height5.constant = 0.5;
            self.baseScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 300);
        }
    }
    
    if(self.accoutType == SelectAccoutTypeHoner)
    {
        self.honerCashTipViewHight.constant= 44.0f;
//        [self honerCashActivityAnimating];
    }else{
        self.honerCashTipViewHight.constant= 0;
    }

    _baseScrollView.contentOffset = CGPointMake(0, 0);
    _cashWayTableView.delegate = self;
    _cashWayTableView.dataSource = self;
    _cashWayTableViewHeigt.constant = _cashWayArray.count * self.tableviewCellHeight;
}
#pragma mark -尊享活动view  动画
-(void)honerCashActivityAnimating
{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:100 animations:^{
        weakSelf.honerCashTipViewLeft.constant = 0;
        weakSelf.honerCashTipViewRight.constant = 0;
    }];
}
#pragma mark --- 初始化提现方式
/**
 *  平移
 */
- (void)translate {
    // 创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 修改CALayer的position属性的值可以实现平移效果
    anim.keyPath = @"position";
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    
    anim.duration = 1.0;
    
    // 下面两句代码的作用：保持动画执行完毕后的状态(如果不这样设置，动画执行完毕后会回到原状态)
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    // 添加动画
//    [self.iconView.layer addAnimation:anim forKey:@"translate"];
}

#pragma mark --- 点击修改提现金额按钮
- (IBAction)clickModifyWithdrawCashBtn:(UIButton *)sender{
    _crachTextField.userInteractionEnabled = YES;
    [_crachTextField becomeFirstResponder];
    _bankBrachLabel.hidden = YES;
    _pleasechooseLabel.hidden  = YES;
    _codeTextField.hidden = YES;
    _getCodeBtn.hidden = YES;
    [UIView animateWithDuration:0.8 animations:^{
        _bankBranchViewHeight1.constant = 0;
        _bankBranchViewHeight2.constant = 0;
        _height4.constant = 0.5;
    }];
    //修改提现金额，重新设置发送验证码按钮的状态
    [self resetGetCodeButtonStuats];
    self.codeTextField.text = @"";
//    self.isShowGetCodeBtn = NO;
}
#pragma mark --- 点击全提按钮
- (IBAction)clickAllCashMoneyBtn:(UIButton *)sender{
    _crachTextField.text = _accountAmountStr;
    [self realTimeWithdrawalAmount:_accountAmountStr];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    }else if (tag.intValue == kSXTagIdentifyCode) {
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
            webVC.accoutType = self.accoutType;
            webVC.rootVc = self.rootVc;
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
//    原提现验证码网络请求。
//            NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userId",@"",@"destPhoneNo", _type,@"isVms",@"1",@"type",nil];
//            [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagIdentifyCode owner:self signature:YES];
            //同盾
            // 获取设备管理器实例
            FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
//            manager->getDeviceInfoAsync(nil, self);
//#warning 同盾修改
            NSString *blackBox = manager->getDeviceInfo();
//            NSLog(@"同盾设备指纹数据: %@", blackBox);
            [self didReceiveDeviceBlackBox:blackBox];
        }
        else{
            self.getMoneyBtn.userInteractionEnabled = YES;
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
//    if (![SharedSingleton isValidateMsg:_codeTextField.text]) {
//        [MBProgressHUD displayHudError:@"请输入验证码"];
//        return;
//    }
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
        NSString *alertStr = [NSString stringWithFormat:@"可转出余额不足，多多%@吧",self.accoutType == SelectAccoutTypeP2P ? @"出借":@"投资"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_bankBranchViewHeight2.constant == 44) {
//        if ([self isWorkTimeCash] ||_isHoliday) {
//            NSString *messageStr = [NSString stringWithFormat:@"大额提现仅在工作日%@间处理，请耐心等待。",_doTime];
//            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert1 show];
//            return;
//        }
        //临界值判断10万  大额提现时判断联行号是否为空
        if ( [self.bankBrachLabel.text  isEqualToString: @"开户支行"] || [_cashBankNo isEqualToString: @""] || _cashBankNo == nil ) {
            [MBProgressHUD displayHudError:@"请选择开户支行"];
            return;
        }
    }
    if (_bankBranchViewHeight2.constant == 0) { //选择 实时提现
        UCFSettingItem *item = [_cashWayArray firstObject];
        if ([item.title isEqualToString:@"实时提现"] && item.isSelect) {
            if ([_crachTextField.text doubleValue] /10000.0 > [_criticalValueStr doubleValue]) { // 提现金额大于实时提现金额单笔限额
        
                NSString *messageStr = [NSString stringWithFormat:@"您实时提现单笔已超过%@万限制，请使用大额提现！",_criticalValueStr];
                if([_bankName.text isEqualToString:@""]){//无行别 实时提现
                    messageStr = [NSString stringWithFormat:@"您实时提现单笔已超过%@万限制，请修改提现金额！",_criticalValueStr];
                }
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertView.tag = 1011;
                [alertView show];
                return;
            }
        }
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
    if (self.accoutType == SelectAccoutTypeHoner && ![_noticeTxt isEqualToString:@""])
    {
        MjAlertView *honerlertView =[[MjAlertView alloc]initHonerCashWithMessage:_noticeTxt  delegate:self];
        honerlertView.tag = 1009;
        [honerlertView show];
        return;
    }
    sender.userInteractionEnabled = NO;
    [self withdrawalAmountIsExceedsTheLimitHttPRequest];
}
#pragma mark-- 提现金额是否超过限制网络请求
-(void)withdrawalAmountIsExceedsTheLimitHttPRequest
{
    
    NSString *bankNoStr = @"";
    if(_bankBranchViewHeight2.constant != 44){//开户支行未选择的用户 就是实时提现
        bankNoStr = @"";//联行号为空 意味着用户选择的是实时提现 不为空 则为大额提现
    }else{
        bankNoStr = _cashBankNo;
    }
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userId",_crachTextField.text,@"reflectAmount",bankNoStr,@"bankNo",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagWithdrawMoneyValidate owner:self signature:YES Type:self.accoutType];
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
- (IBAction)clickChooseBankbranchVC:(UIButton *)sender
{
    UCFChoseBankViewController *choseBankVC = [[UCFChoseBankViewController alloc]initWithNibName:@"UCFChoseBankViewController" bundle:nil];
    choseBankVC.delegate = self;
    choseBankVC.bankName = _bankName.text;
    choseBankVC.title = @"选择开户支行";
    choseBankVC.accoutType = self.accoutType;
    [self.navigationController pushViewController:choseBankVC  animated:YES];
}

//进入尊享活动页面
- (IBAction)gotoHonerCashActivityView:(id)sender
{
    UCFRedBagViewController *redbag = [[UCFRedBagViewController alloc] initWithNibName:@"UCFRedBagViewController" bundle:nil];
    redbag.sourceVC = self;
    if (_hasCoupon)
    {//如果已经领取直接进入
        redbag.fold = NO;
        [self.navigationController presentViewController:redbag animated:NO completion:nil];
    }
    else {
        redbag.fold = YES;
        [self.navigationController presentViewController:redbag animated:YES completion:^{
            
        }];
    }
}
#pragma mark -选择开户支行支行回调函数
-(void)chosenBranchBank:(NSDictionary*)_dicBranchBank{
    self.bankBrachLabel.text = _dicBranchBank[@"bankName"];
    self.cashBankNo = _dicBranchBank[@"bankNo"];
}
#pragma mark - 同盾
- (void) didReceiveDeviceBlackBox: (NSString *) blackBox {
//    NSString *wanip = [[NSUserDefaults standardUserDefaults] valueForKey:@"curWanIp"];
    NSString *bankNoStr = @"";
    if(_bankBranchViewHeight2.constant != 44){//开户支行未选择的用户 就是实时提现
        bankNoStr = @"";//联行号为空 意味着用户选择的是实时提现 不为空 则为大额提现
    }else{
        bankNoStr = _cashBankNo;
    }
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",_crachTextField.text,@"reflectAmount",bankNoStr,@"bankNo",@"",@"validateCode",_withdrawToken,@"withdrawTicket",blackBox, @"token_id",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagWithdrawSub owner:self signature:YES Type:self.accoutType];
}
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    if(alertview.tag == 1009)
    {
        if (index == 101)
        {
            //是否进入尊享提现活动页面
            [self gotoHonerCashActivityView:nil];
        }
        else//去提现
        {
             [self withdrawalAmountIsExceedsTheLimitHttPRequest];
        }
        
    }else{
        if (index == 1) {
            [self withdrawalAmountIsExceedsTheLimitHttPRequest];
        }
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1011) {
        if([_bankName.text isEqualToString:@""]){
            [_crachTextField becomeFirstResponder];
        }else{
           [self realTimeWithdrawalAmount:_crachTextField.text];
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
