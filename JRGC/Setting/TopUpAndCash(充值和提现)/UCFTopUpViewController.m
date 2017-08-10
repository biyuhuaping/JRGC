//
//  UCFTopUpViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//  充值页面

#import "UCFTopUpViewController.h"
//#import "UCFSettingViewController.h"
#import "RechargeListViewController.h"
#import "UCFToolsMehod.h"
#import "NZLabel.h"
#import "HWWeakTimer.h"
#import "CJLabel.h"
#import "NSString+CJString.h"
#import "FullWebViewController.h"
#import "SharedSingleton.h"
#import "AppDelegate.h"
#import "MjAlertView.h"
#import "RechargeFixedTelNumView.h"
#import "UCFHuiShangBankViewController.h"
#import "FMDeviceManager.h"
#import "UCFModifyReservedBankNumberViewController.h"
@interface UCFTopUpViewController () <UITextFieldDelegate,FMDeviceManagerDelegate,UCFModifyReservedBankNumberDelegate>
{
    NSString *curCodeType;          //当前验证码的状态
    NSString *rechargeLimiteUrl;    //产看银行限额的地址
    NSString *telNum;               //客服电话
    NSString *minRecharge;          //最小充值金额
    NSString *fee;                  //提现费率
    MjAlertView         *mjalert; //修改预留手机号弹框
    UITextField         *telTextField;
    UITextField         *codeTextField;
    UIButton            *getCodeBtn;
    UIView              *fixedBaseView;
    CGFloat              fixMaxYValue;
    BOOL                 isSpecial;//是否是特殊用户
    MjAlertView         *moneylessAlertView; //账户余额不足弹框
    NSString * _RechargeTokenStr;
}
//底部滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

// 银行卡图标
@property (weak, nonatomic) IBOutlet UIImageView *bankBranchImageVIew;
// 银行卡名称
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
// 开户名
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
// 卡号
@property (weak, nonatomic) IBOutlet UILabel *cardCodeLabel;
// 服务电话
@property (weak, nonatomic) IBOutlet NZLabel *serviceLabel;
// 金额输入框
@property (weak, nonatomic) IBOutlet UITextField *topUpLabelTextField;
//银行预留手机号输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;

@property (weak, nonatomic) IBOutlet UIImageView *fastPayImageView;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
// 充值按钮
@property (weak, nonatomic) IBOutlet UIButton *topUpButton;
//充值说明介绍
@property (weak, nonatomic) IBOutlet NZLabel *desLabel;

//充值出借人协议
@property (weak, nonatomic) IBOutlet NZLabel *deleagateLabel;

@property (weak, nonatomic) IBOutlet NZLabel *telServiceLabel;
//充值说明介绍
@property (weak, nonatomic) IBOutlet UILabel *msgTipLabel;
//计时器
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSTimer *fixTelNumTimer;
//秒数
@property (assign, nonatomic) NSInteger counter;

@property (assign, nonatomic) NSInteger fixTelNumCounter;
@property (weak, nonatomic) IBOutlet UIButton *modiyPhoneButton;
@property (copy, nonatomic) NSString *telStr;
@property (nonatomic, copy) NSString *smsSerialNo;
- (IBAction)gotoPay:(id)sender;
- (IBAction)getMsgCode:(id)sender;
- (IBAction)clickModiyPhoneButton:(UIButton *)sender;

#pragma mark - 调整卡片的约束参数


// scrollView 的content高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rechargeTopCo;
@end

@implementation UCFTopUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addControll];
    [self getMyBindCardMessage];
    [self setTimer];
    [self registKeyBordNoti];
}
#pragma mark 初始化界面构建

//初始化界面信息
- (void)createUI
{
    if (self.accoutType == SelectAccoutTypeHoner) {
         baseTitleLabel.text = @"尊享充值";
    }else{
       baseTitleLabel.text = @"微金充值";
    }
    [self addLeftButton];
    [self addRightButtonWithName:@"充值记录"];
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    [_getCodeButton setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
//    [_getCodeButton setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateDisabled];
    _getCodeButton.backgroundColor = UIColorWithRGB(0x8296af);

//    if (!isVisible) {
//        [_verificationCodeBtn setUserInteractionEnabled:NO];
//        _verificationCodeBtn.backgroundColor = UIColorWithRGB(0xd4d4d4);
//    } else {
//        [_verificationCodeBtn setUserInteractionEnabled:YES];
//        _verificationCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);
//    }
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telServiceNo)];
//    [_serviceLabel addGestureRecognizer:tap1];
//    [_serviceLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"400-0322-988"];
    
    [self.topUpButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [self.topUpButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    NSString *bankUrl = [_dataDict objectForKey:@"url"];
    [_bankBranchImageVIew sd_setImageWithURL:[NSURL URLWithString:bankUrl]];
    _bankNameLabel.text = [UCFToolsMehod isNullOrNilWithString:[_dataDict objectForKey:@"bankName"]];
    _accountNameLabel.text = [UCFToolsMehod isNullOrNilWithString:[_dataDict objectForKey:@"realName"]];
    _cardCodeLabel.text = [UCFToolsMehod isNullOrNilWithString:[_dataDict objectForKey:@"bankCard"]];
    if ([[_dataDict objectForKey:@"cjflag"] isEqualToString:@"1"]) {
        _fastPayImageView.hidden = NO;
    } else {
        _fastPayImageView.hidden = YES;
    }

    
    _msgTipLabel.userInteractionEnabled = YES;
    _msgTipLabel.text = @"";
    
    
    
}
-(void)showDeleagateView{
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:@"https://m.9888.cn/static/wap/protocol-entrust-transfer/index.html" title:@"出借人委托划款授权书"];
    webController.sourceVc = @"topUpVC";//充值页面
    webController.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)getToBack
{
    if (self.uperViewController) {
        [self.navigationController popToViewController:self.uperViewController animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置ScrollView总高度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _contentHeight.constant = CGRectGetMaxY(_telServiceLabel.frame);
        self.baseScrollView.contentSize = CGSizeMake(ScreenWidth, _contentHeight.constant + 100);
        DLog(@"%@",self.baseScrollView);
    });
}
- (void)controldesLabel
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineSpacing = 1;
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:13],/*(字体)*/
                          NSParagraphStyleAttributeName:paragraph,/*(段落)*/
                          };
    NSString *str = self.accoutType == SelectAccoutTypeHoner ? @"无投资":@"未出借";
    NSString *desStr = [NSString stringWithFormat:@"• 使用快捷支付充值最低金额应大于等于%@元。\n• 对首次充值后%@的提现，第三方支付平台收取%@%%的手续费。\n• 充值/提现必须为银行借记卡，不支持存折、信用卡充值。\n• 充值需开通银行卡网上支付功能，如有疑问请咨询开户行客服。\n• 单笔充值不可超过该银行充值限额。\n• 如手机快捷支付充值失败，可尝试在电脑上进行网银转账，或使用支付宝进行转账操作。",minRecharge,str,fee];
    //查看各银行充值限额；
    _desLabel.attributedText = [NSString getNSAttributedString:desStr labelDict:dic];
    [_desLabel setBoldFontToString:@"网银"];
    [_desLabel setBoldFontToString:@"支付宝"];

    __weak typeof(self) weakSelf = self;
    self.telServiceLabel.text = @"• 如果充值金额没有及时到账，请拨打客服查询。";
    [self.telServiceLabel addLinkString:@"拨打客服" block:^(ZBLinkLabelModel *linkModel) {
       [weakSelf telServiceNo];
    }];
    [self.telServiceLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"拨打客服"];
    
    
    self.deleagateLabel.text = @"我同意签署《出借人委托划款授权书》";
    self.deleagateLabel.textColor = UIColorWithRGB(0x999999);
    NSString *tmpStr = @"《出借人委托划款授权书》";
    [self.deleagateLabel addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf showDeleagateView];
    }];
    [self.deleagateLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:tmpStr];
//    _serviceLabel.text =[NSString stringWithFormat:@"如果您绑定的银行卡暂不支持手机一键支付请联系客服%@",telNum];
//    [_serviceLabel addLinkString:telNum block:^(ZBLinkLabelModel *linkModel){
//        [weakSelf telServiceNo];
//    }];
//    
//    [_serviceLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:telNum];
    
    _topUpLabelTextField.placeholder = [NSString stringWithFormat:@"输入充值金额,最低%@元",minRecharge];
    //设置ScrollView总高度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _contentHeight.constant = CGRectGetMaxY(_telServiceLabel.frame);
        self.baseScrollView.contentSize = CGSizeMake(ScreenWidth, _contentHeight.constant + 100);
        DLog(@"%@",self.baseScrollView);
    });


}
- (void)telServiceNo
{
    NSString *telStr = [NSString stringWithFormat:@"呼叫%@",telNum];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:telStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
    [alert show];
}
- (void)checkBankRechargeLimit
{
//    rechargeLimiteUrl = [@"http:" stringByAppendingString:rechargeLimiteUrl];
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:rechargeLimiteUrl title:@"银行充值限额"];
    webController.sourceVc = @"topUpVC";//充值页面
    webController.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webController animated:YES];
}
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            [self resetGetCodeButtonStuats];
            _topUpLabelTextField.text = @"";
            _verificationCodeField.text = @"";
            _RechargeTokenStr = @"";
            
            
        } else if (buttonIndex == 1) {
           NSString *className = [NSString stringWithUTF8String:object_getClassName(_uperViewController)];
            if ([className hasSuffix:@"UCFPurchaseBidViewController"] || [className hasSuffix:@"UCFPurchaseTranBidViewController"] || [className hasSuffix:@"UCFSelectPayBackController"]) {
                [self.navigationController popToViewController:_uperViewController animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:NO];
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                [appDelegate.tabBarController setSelectedIndex:0];
            }
        }
    } else if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            
        }
    }else if (alertView.tag == 1002) {//特殊用户弹窗
        if (buttonIndex == 0) { //取消 -- 原路返回
             [self.navigationController popViewControllerAnimated:YES];
        }else{ //查看电子账户
            UCFHuiShangBankViewController *subVC = [[UCFHuiShangBankViewController alloc] initWithNibName:@"UCFHuiShangBankViewController" bundle:nil];
            subVC.rootVc = _uperViewController;
            subVC.accoutType = self.accoutType;
            [self.navigationController pushViewController:subVC animated:YES];
        }
    } else if (alertView.tag == 1003) {//验证码次数用完弹框
        if (buttonIndex == 1) {
           [self tappedTelePhone];    //联系客服
        }
    } else {
        if (buttonIndex == 1) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[telNum  stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}
/**
 *  增加一些页面控制
 */
- (void)addControll
{
    [_topUpLabelTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    _topUpLabelTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _topUpLabelTextField.text = _defaultMoney;
    UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
    [_baseScrollView addGestureRecognizer:frade];
    [_phoneTextField addTarget:self action:@selector(verifyPhoneNumber:) forControlEvents:UIControlEventEditingDidEnd];
}
- (void)setTimer
{
    _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    _counter = 60;
    
    _fixTelNumTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(telNumTimerFired) userInfo:nil repeats:YES];
    [_fixTelNumTimer setFireDate:[NSDate distantFuture]];
    _fixTelNumCounter = 60;
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
- (void)registKeyBordNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}
#pragma  ---------------------------------------
#pragma mark 响应事件
- (void)fadeKeyboard
{
    [self.view endEditing:YES];
}
- (void)clickRightBtn
{
    RechargeListViewController *viewController = [[RechargeListViewController alloc] init];
    viewController.accoutType = self.accoutType;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)telNumTimerFired
{
    [getCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_fixTelNumCounter] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    getCodeBtn.backgroundColor = [UIColor lightGrayColor];
    getCodeBtn.backgroundColor = UIColorWithRGB(0xd4d4d4);
    _fixTelNumCounter--;
    if (_fixTelNumCounter == 0) {
        [self resetFixNumGetCodeButtonStuats];
    }
}
- (void)resetFixNumGetCodeButtonStuats
{
    [_fixTelNumTimer  setFireDate:[NSDate distantFuture]];
    _fixTelNumCounter = 60;
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    getCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);

//    [getCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
//    [getCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    getCodeBtn.enabled = YES;
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)timerFired
{
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_counter] forState:UIControlStateNormal];
    _getCodeButton.backgroundColor = UIColorWithRGB(0xd4d4d4);
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    _getCodeButton.backgroundColor = [UIColor lightGrayColor];
    _counter--;
    if (_counter == 0) {
        [self resetGetCodeButtonStuats];
    }
}
-(void)resetGetCodeButtonStuats{
    [_timer  setFireDate:[NSDate distantFuture]];
    _counter = 60;
    _msgTipLabel.text = @"";
    _getCodeButton.userInteractionEnabled = YES;
    _getCodeButton.backgroundColor = UIColorWithRGB(0x8296af);
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_getCodeButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
    _getCodeButton.backgroundColor = UIColorWithRGBA(111, 131, 159, 1);
}
- (void)tappedTelePhone
{
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4000322988"]];
}

#pragma mark - 同盾
- (void) didReceiveDeviceBlackBox: (NSString *) blackBox {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *wanip = [[NSUserDefaults standardUserDefaults] valueForKey:@"curWanIp"];
    NSString *inputMoney = [Common deleteStrHeadAndTailSpace:_topUpLabelTextField.text];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setValue:inputMoney forKey:@"payAmount"];
    [paraDict setValue:_phoneTextField.text forKey:@"phoneNo"];
    [paraDict setValue:_verificationCodeField.text forKey:@"smsCode"];
    [paraDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:UUID] forKey:@"userId"];
    [paraDict setValue:self.smsSerialNo forKey:@"validateNo"];
    [paraDict setValue:blackBox forKey:@"token_id"];
    [paraDict setValue:wanip forKey:@"ip"];
    [paraDict setValue:_RechargeTokenStr forKey:@"rechargeToken"];
    [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:kSxTagHSPayMobile owner:self signature:YES Type:self.accoutType];
}

//判断订单状态，提交充值表单
- (IBAction)gotoPay:(id)sender {
    if ([self checkOrderIsLegitimate]) {
        [self.view endEditing:YES];
        FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
        manager->getDeviceInfoAsync(nil, self);
    }
}
//获取短信验证码
- (IBAction)getMsgCode:(id)sender {
    [self sendVerifyCode:@"SMS"];
    curCodeType = @"SMS";
}
#pragma mark -点击修改 预留手机号
- (void)closeView
{
    _fixTelNumCounter = 60;
    [_fixTelNumTimer setFireDate:[NSDate distantFuture]];
    [mjalert hide];
    mjalert = nil;
}
- (void)saveChangeTelCode
{
    if ([Common deleteStrSpace:telTextField.text].length != 11) {
        [MBProgressHUD displayHudError:@"请输入正确的手机号"];
        return;
    }
    if ([Common deleteStrSpace:codeTextField.text].length == 0) {
        [MBProgressHUD displayHudError:@"请输入验证码"];
        return;
    }
    NSDictionary *dataDict = @{@"phoneNum":[Common deleteStrSpace:telTextField.text],@"validateCode":codeTextField.text,@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagChangeReserveMobileNumber owner:self signature:YES Type:self.accoutType];
}
- (void)getPhoneCode
{
    if ([Common deleteStrSpace:telTextField.text].length != 11) {
        [MBProgressHUD displayHudError:@"请输入正确的手机号"];
        return;
    }
    NSDictionary *dic = @{@"destPhoneNo":[Common deleteStrSpace:telTextField.text],@"isVms":@"SMS",@"type":@"4",@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagIdentifyCode owner:self signature:YES Type:self.accoutType];

}
-(void)modifyReservedBankNumberSuccess:(NSString *)reservedBankNumber{
    _phoneTextField.text = reservedBankNumber;
}
- (IBAction)clickModiyPhoneButton:(UIButton *)sender {
    [self.view endEditing:YES];
    UCFModifyReservedBankNumberViewController *modifyBankNumberVC = [[UCFModifyReservedBankNumberViewController alloc]initWithNibName:@"UCFModifyReservedBankNumberViewController" bundle:nil];
    modifyBankNumberVC.title = @"修改银行预留手机号";
    modifyBankNumberVC.tellNumber = telNum;
    modifyBankNumberVC.delegate = self;
    modifyBankNumberVC.accoutType = self.accoutType;
    [self.navigationController pushViewController:modifyBankNumberVC animated:YES];
/*
    if ([sender.currentTitle isEqualToString:@"修改"]) {
            mjalert = [[MjAlertView alloc] initCustomAlertViewWithBlock:^(id blockContent) {
            fixedBaseView = (UIView *)blockContent;
            fixedBaseView.frame = CGRectMake(15, 0, 290, 212);
            fixedBaseView.backgroundColor = [UIColor whiteColor];
            fixedBaseView.layer.cornerRadius = 4.0f;
            fixedBaseView.layer.masksToBounds = YES;
        
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(fixedBaseView.frame), 40)];
            topView.backgroundColor = UIColorWithRGB(0xf9f9f9);
            topView.layer.masksToBounds = YES;
            topView.layer.cornerRadius = 4.0f;
            [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
            [fixedBaseView addSubview:topView];
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) - 10, CGRectGetWidth(topView.frame), 10)];
            bottomView.backgroundColor = [UIColor whiteColor];
            bottomView.backgroundColor = UIColorWithRGB(0xf9f9f9);
            [fixedBaseView addSubview:bottomView];
            
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(fixedBaseView.frame) - 15 - 44, 40)];
            topLabel.text = @"修改银行预留手机号";
            topLabel.font = [UIFont systemFontOfSize:16.0f];
            topLabel.backgroundColor = [UIColor clearColor];
            topLabel.textColor = UIColorWithRGB(0x555555);
            [topView addSubview:topLabel];
        
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.frame = CGRectMake(CGRectGetMaxX(topLabel.frame), 0, 44, 40);
            [closeBtn setImage:[UIImage imageNamed:@"calculator_gray_close"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
            [fixedBaseView addSubview:closeBtn];
            
          
            UIView * inputBaseView = [[UIView alloc] initWithFrame:CGRectMake(15.0f,CGRectGetMaxY(topView.frame) + 15, CGRectGetWidth(fixedBaseView.frame) - 30.0f, 37.0f)];
            inputBaseView.backgroundColor = UIColorWithRGB(0xf2f2f2);
            inputBaseView.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
            inputBaseView.layer.borderWidth = 0.5f;
            inputBaseView.layer.cornerRadius = 4.0f;
            [fixedBaseView addSubview:inputBaseView];

            
            telTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 8.5f, CGRectGetWidth(inputBaseView.frame) - 20, 20.0f)];
            telTextField.backgroundColor = [UIColor clearColor];
            telTextField.delegate = self;
            telTextField.textColor = UIColorWithRGB(0x333333);
            telTextField.font = [UIFont systemFontOfSize:14.0f];
            telTextField.returnKeyType = UIReturnKeyDone;
            telTextField.keyboardType = UIKeyboardTypeNumberPad;
            telTextField.placeholder = @"请输入银行预留手机号";
            [telTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];

            [inputBaseView addSubview:telTextField];
            
            
            UIView * inputBaseView1 = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(inputBaseView.frame) + 10, 145, 37.0f)];
            inputBaseView1.backgroundColor = UIColorWithRGB(0xf2f2f2);
            inputBaseView1.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
            inputBaseView1.layer.borderWidth = 0.5f;
            inputBaseView1.layer.cornerRadius = 4.0f;
            [fixedBaseView addSubview:inputBaseView1];
            
            codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 8.5f, CGRectGetWidth(inputBaseView1.frame) - 20, 20.0f)];
            codeTextField.backgroundColor = [UIColor clearColor];
            codeTextField.delegate = self;
            telTextField.textColor = UIColorWithRGB(0x333333);
            codeTextField.font = [UIFont systemFontOfSize:14.0f];
            codeTextField.returnKeyType = UIReturnKeyDone;
            codeTextField.keyboardType = UIKeyboardTypeNumberPad;
            codeTextField.placeholder = @"请输入验证码";
            [inputBaseView1 addSubview:codeTextField];
            
            getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            getCodeBtn.frame = CGRectMake(CGRectGetMaxX(inputBaseView1.frame) + 10, CGRectGetMinY(inputBaseView1.frame), 105, 37.0f);
            getCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);

//            [getCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
//            [getCodeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
            [getCodeBtn addTarget:self action:@selector(getPhoneCode) forControlEvents:UIControlEventTouchUpInside];
            [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [fixedBaseView addSubview:getCodeBtn];
            
            
            UIButton *savetButton = [UIButton buttonWithType:UIButtonTypeCustom];
            savetButton.frame = CGRectMake(15, CGRectGetMaxY(inputBaseView1.frame) + 15,CGRectGetWidth(fixedBaseView.frame) - 30 , 37);
            savetButton.titleLabel.font = [UIFont systemFontOfSize:16];
            savetButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
            savetButton.layer.cornerRadius = 2.0;
            savetButton.layer.masksToBounds = YES;
            [savetButton setTitle:@"保存" forState:UIControlStateNormal];
            [savetButton addTarget:self action:@selector(saveChangeTelCode) forControlEvents:UIControlEventTouchUpInside];
            [fixedBaseView addSubview:savetButton];
        }];
        [mjalert show];
        fixMaxYValue = mjalert.center.y + CGRectGetHeight(fixedBaseView.frame)/2;
        [telTextField becomeFirstResponder];
    }
*/
}


//点击语音验证码
- (void)soudLabelClick:(UITapGestureRecognizer *)tap
{
    if (_counter > 0 && _counter < 60) {
        [AuxiliaryFunc showToastMessage:_getCodeButton.titleLabel.text withView:self.view];
        return;
    } else {
        [self sendVerifyCode:@"VMS"];
        curCodeType = @"VMS";
    }
}
- (void)sendVerifyCode:(NSString*)type
{
    if (![SharedSingleton isValidateMsg:_topUpLabelTextField.text]) {
        [MBProgressHUD displayHudError:@"请输入充值金额"];
        return;
    }
    NSString *getMoney = [NSString stringWithFormat:@"%.2f",[_topUpLabelTextField.text doubleValue]];
    if ([Common stringA:getMoney ComparedStringB:minRecharge] == -1) {
        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"单笔充值金额不低于%@元",minRecharge]];
        return;
    }
//    if (_phoneTextField.text.length != 11) { //服务器校验手机号格式
//        [MBProgressHUD displayHudError:@"请输入正确手机号"];
//        return;
//    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _getCodeButton.userInteractionEnabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setValue:_phoneTextField.text forKey:@"phoneNo"];
    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:UUID] forKey:@"userId"];
    [[NetworkModule sharedNetworkModule] newPostReq:dict tag:kSXTagWithdrawalsSendPhone owner:self signature:YES Type:self.accoutType];
//    [[NetworkModule sharedNetworkModule] postReq:[NSString stringWithFormat:@"userId=%@&isVms=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UUID],type] tag:kSXTagActWithdrawSendPhoneVerifyCode owner:self];
}
//检查订单状态是否合法
- (BOOL)checkOrderIsLegitimate
{
    NSString *inputMoney = [Common deleteStrHeadAndTailSpace:_topUpLabelTextField.text];
    if ([Common isPureNumandCharacters:inputMoney]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return NO;
    }
    inputMoney = [NSString stringWithFormat:@"%.2f",[inputMoney doubleValue]];
    NSComparisonResult comparResult = [minRecharge compare:[Common deleteStrHeadAndTailSpace:inputMoney] options:NSNumericSearch];
    //ipa 版本号 大于 或者等于 Apple 的版本，返回，不做自己服务器检测
    if (comparResult == NSOrderedDescending) {
        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"单笔充值金额不低于%@元",minRecharge]];
        return NO;
    }
    comparResult = [inputMoney compare:@"10000000.00" options:NSNumericSearch];
    if (comparResult == NSOrderedDescending || comparResult == NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值金额不可大于1000万" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (_phoneTextField.text.length != 11) {
        [MBProgressHUD displayHudError:@"请输入正确手机号"];
        return NO;
    }
    if (![Common deleteStrHeadAndTailSpace:_verificationCodeField.text].length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入验证码" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField.tag == 20) { //输入手机号码
        if(existedLength - selectedLength + replaceLength> 11)
        {
            return NO;
        }
//        NSCharacterSet *characterSet;
//        characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
//        BOOL result = [string isEqualToString:filtered];
//        if (!result) {
//            return NO;
//        }
//        return YES;
    }else if(textField.tag == 30){
        if(existedLength - selectedLength + replaceLength> 6)
        {
            return NO;
        }
    }
    return YES;
}


#pragma mark ------------------------------
#pragma mark netMethod
/**
 *  获取银行卡信息
 */
- (void)getMyBindCardMessage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    NSDictionary *dataDict =@{@"userId":uuid};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagBankTopInfo owner:self signature:YES Type:self.accoutType];
}


-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    if (tag.intValue == kSxTagHSPayMobile){
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([dic[@"ret"] boolValue]){
            DLog(@"%@",dic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOADP2PORHONERACCOTDATA object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEINVESTDATA" object:nil];
            _phoneTextField.text = [_phoneTextField.text stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
            self.modiyPhoneButton.hidden = NO;
            self.phoneTextField.textColor = UIColorWithRGB(0x999999);
            self.phoneTextField.backgroundColor = UIColorWithRGB(0xf4f4f4);
            self.phoneTextField.userInteractionEnabled = NO;
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"充值成功" message:@""delegate:self cancelButtonTitle:@"继续充值" otherButtonTitles:@"去投资", nil];
            alert1.tag = 1000;
            [alert1 show];
        } else {
            NSString *errorMessage = [dic objectSafeForKey:@"message"];
            if ([[dic objectSafeForKey:@"code"] intValue] == 31029) { //充值禁用时
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"充值失败" message:errorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert1.tag = 1001;
                [alert1 show];
                return;
            }
//          如手机快捷支付充值失败，可尝试在电脑上进行<font color='#fd4d4c'>网银转账</font>，或使用<font color='#fd4d4c'>支付宝</font>进行转账操作。
            NSArray *array = [errorMessage componentsSeparatedByString:@"\n"];
            NSString *errorMessageStr = [array firstObject];
            NSString *message = [NSString stringWithFormat:@"<font color='#555555'>%@</font>",[array lastObject]];
            if (array.count == 1) {
                message = @"";
            }
            moneylessAlertView = [[MjAlertView alloc] initRechargeViewWithTitle:@"充值失败" errorMessage:errorMessageStr message:message delegate:self cancelButtonTitle:@"继续充值"];
            moneylessAlertView.tag = 1001;
            [moneylessAlertView show];
        }
        
    }else if (tag.intValue == kSXTagBankTopInfo) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([[dic valueForKey:@"ret"] boolValue]) {
            NSDictionary *coreDict = dic[@"data"][@"bankInfo"];
            NSString *bankUrl = coreDict[@"bankLogo"];
            if (![bankUrl isEqual:[NSNull null]]) {
                [_bankBranchImageVIew sd_setImageWithURL:[NSURL URLWithString:bankUrl]];
            }
            if (![coreDict[@"bankName"] isEqual:[NSNull null]]) {
                _bankNameLabel.text = [UCFToolsMehod isNullOrNilWithString:coreDict[@"bankName"]];
            }
            _accountNameLabel.text = [UCFToolsMehod isNullOrNilWithString:coreDict[@"realName"]];
            _cardCodeLabel.text = [UCFToolsMehod isNullOrNilWithString:coreDict[@"bankCardNo"]];
            if ([coreDict[@"supportQPass"] boolValue]) {
                _fastPayImageView.hidden = NO;
            } else {
                _fastPayImageView.hidden = YES;
            }
            rechargeLimiteUrl = [NSString stringWithFormat:@"%@",dic[@"data"][@"rechargeLimiteUrl"]];
            telNum = [NSString stringWithFormat:@"%@",dic[@"data"][@"customerServiceNo"]];
            minRecharge = [NSString stringWithFormat:@"%@",dic[@"data"][@"minAmt"]];
            fee = [NSString stringWithFormat:@"%@",dic[@"data"][@"fee"]];
            NSString *bankPhone =  [dic[@"data"][@"bankInfo"] objectSafeForKey:@"bankPhone"];
            isSpecial = [[dic[@"data"][@"bankInfo"] objectSafeForKey:@"isSpecial"] boolValue];
          BOOL isCompanyAgent  = [[dic[@"data"][@"bankInfo"] objectSafeForKey:@"isCompanyAgent"] boolValue];
            if (isSpecial || isCompanyAgent) {
                //***以下方式为ios8 以上的方法可以用
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请直接转账至徽商电子账户"  preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//                UIAlertAction *checkAccountAction = [UIAlertAction actionWithTitle:@"查看账户" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    UCFHuiShangBankViewController *subVC = [[UCFHuiShangBankViewController alloc] initWithNibName:@"UCFHuiShangBankViewController" bundle:nil];
//                    subVC.rootVc = _uperViewController;
//                    [self.navigationController pushViewController:subVC animated:YES];
//                }];
//                [alertController addAction:cancelAction];
//                [alertController addAction:checkAccountAction];
//                [self presentViewController:alertController animated:YES completion:nil];
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请直接转账至徽商电子账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看账户", nil];
                alerView.tag = 1002;
                [alerView show];
            }
            if([bankPhone isEqualToString:@""]){
                self.modiyPhoneButton.hidden = YES;
            }else{
                _phoneTextField.text = bankPhone;
                self.modiyPhoneButton.hidden = NO;
                self.phoneTextField.textColor = UIColorWithRGB(0x999999);
                self.phoneTextField.backgroundColor = UIColorWithRGB(0xf4f4f4);
                self.phoneTextField.userInteractionEnabled = NO;
            }
            [self controldesLabel];
        } else {
            [MBProgressHUD displayHudError:dic[@"message"]];
        }
    } else if (tag.intValue == kSXTagWithdrawalsSendPhone) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        if([dic[@"ret"] boolValue])
        {
            _RechargeTokenStr = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"rechargeToken"];
            _getCodeButton.userInteractionEnabled = NO;
            [_timer setFireDate:[NSDate distantPast]];
            [_getCodeButton setBackgroundColor:[UIColor lightGrayColor]];
            NSString *tempText = @"";
            if([_phoneTextField.text rangeOfString:@"****"].location != NSNotFound ){
                tempText = [NSString stringWithFormat:@"已向您绑定的手机号码%@发送短信验证码",_phoneTextField.text];
            }else{
                tempText = [_phoneTextField.text stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                tempText = [NSString stringWithFormat:@"已向您绑定的手机号码%@发送短信验证码",tempText];
 
            }
            _msgTipLabel.text = tempText;
            _msgTipLabel.font = [UIFont systemFontOfSize:12.0f];
            self.smsSerialNo =[NSString stringWithFormat:@"%@",dic[@"data"][@"smsSerialNo"]];
           BOOL  isInThreeNum = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"isInThreeNum"] boolValue];
            if (isInThreeNum){//验证码次数剩下最后三次
                NSString *messageStr = [dic objectSafeForKey:@"message"];
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alerView show];
            }else{
                [MBProgressHUD displayHudError:@"已发送，请等待接收，60秒后可再次获取。"];
            }
        } else {
            
            _getCodeButton.userInteractionEnabled = YES;
            NSString *messageStr = [dic objectSafeForKey:@"message"];
            if([[dic objectSafeForKey:@"code"] intValue] == 41003){
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"明天再试" otherButtonTitles:@"联系客服",nil];
                alerView.tag = 1003;
                [alerView show];
            }else{ //其他失败情况
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alerView show];
            }
            
        }
        if (dic == nil) {
            _getCodeButton.userInteractionEnabled = YES;
            [MBProgressHUD displayHudError:@"系统繁忙,请稍候再试!"];
        }
    }else if (tag.integerValue == kSXTagChangeReserveMobileNumber){
        NSMutableDictionary *dic = [data objectFromJSONString];
        if([dic[@"ret"] boolValue]){
            NSString *tempText = [telTextField.text stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _phoneTextField.text = tempText;
            [self resetFixNumGetCodeButtonStuats];
            [self resetGetCodeButtonStuats];
             [mjalert hide];
             [MBProgressHUD displayHudError:@"保存成功"];
        }else{
            [MBProgressHUD displayHudError:dic[@"message"]];
        }
    } else if (tag.integerValue == kSXTagIdentifyCode) {
        //[MBProgressHUD displayHudError:@"已发送，请等待接收，60秒后可再次获取。"];
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([dic[@"ret"] boolValue]) {
            getCodeBtn.enabled = NO;
            [_fixTelNumTimer setFireDate:[NSDate distantPast]];
        }
        [MBProgressHUD displayHudError:dic[@"message"]];
    }
    
}
#pragma mark ---------------------------

#pragma mark TextFieldMethod
// 文本变化执行
- (UITextField *)textfieldLength:(UITextField *)textField
{
    if (textField == telTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
    } else {
        NSString *str = textField.text;
        NSArray *array = [str componentsSeparatedByString:@"."];
        
        NSString *jeLength = [array firstObject];
        if (jeLength.length > 7) {
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

    }
    
    return textField;
}
-(UITextField *)verifyPhoneNumber:(UITextField *)textField{
    if ([self.modiyPhoneButton.currentTitle isEqualToString:@"保存"]) {
       
    }
    return textField;
}
#pragma mark - 监听键盘
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
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}

#pragma mark - inputBarDelegate
-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)time
{
    if (mjalert) {
       CGFloat maxFixBaseView = mjalert.center.y + CGRectGetHeight(fixedBaseView.frame)/2;
        if (height == 0)
        {
            fixedBaseView.center = mjalert.center;
        }
        else
        {
            if (maxFixBaseView > ScreenHeight - height) {
                fixedBaseView.frame = CGRectMake((ScreenWidth - 290)/2, ScreenHeight - height - CGRectGetHeight(fixedBaseView.frame), 290, 212);
            } else {
                fixedBaseView.center = mjalert.center;

            }
        }
    } else {
        if (height == 0)
        {
            _contentHeight.constant = CGRectGetMaxY(_telServiceLabel.frame) + 100;
        }
        else
        {
            CGRect viewFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight);
            _contentHeight.constant = CGRectGetHeight(viewFrame) + height + 100;
        }
        self.baseScrollView.contentSize = CGSizeMake(ScreenWidth, _contentHeight.constant);
    }

}
#pragma mark ---------------------------
- (void)dealloc
{
    [_timer invalidate];
    self.timer = nil;
}
@end
