//
//  UpgradeAccountVC.m
//  JRGC
//
//  Created by biyuhuaping on 16/8/4.
//  Copyright © 2016年 qinwei. All rights reserved.
//  升级存管账户

#import "UpgradeAccountVC.h"
#import "NZLabel.h"
#import "AccountSuccessVC.h"//开户成功->设置交易密码
#import "HWWeakTimer.h"
#import "UCFToolsMehod.h"
#import "UCFHuiShangChooseBankViewController.h"
#import "FullWebViewController.h"
#import "BlockUIAlertView.h"
#import "UserInfoSingle.h"
#import "AccountWebView.h"
#import "NSString+Misc.h"
@interface UpgradeAccountVC ()<UITextFieldDelegate,NetworkModuleDelegate,UCFHuiShangChooseBankViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NZLabel *customLabel1;
@property (strong, nonatomic) IBOutlet NZLabel *customLabel2;
@property (strong, nonatomic) IBOutlet UIButton *submitDataButton;//提交数据按钮

@property (strong, nonatomic) UIButton *getCodeBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger counter;

@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UITextField *textField3;
@property (strong, nonatomic) UITextField *textField4;

@property (strong, nonatomic) UIImageView *bankLogoView;//银行logo
@property (strong, nonatomic) UILabel *bankNameLabel;//银行名称
@property (strong, nonatomic) NSString *bankId;//银行id
@property (strong, nonatomic) NSString *tempBankId;//本地临时存储银行id，用于判断银行id是否变化
@property (strong, nonatomic) NSString *notSupportDes;
@property BOOL isQuick;//银行是否支持快捷支付
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHight;

@property (strong, nonatomic) NSString *openStatus;//开户状态:1：未开户 2：已开户 3：已绑卡 4：已设交易密码 5：特殊用户
@property (assign, nonatomic) BOOL isNotFirstCome;//不是第一次进入本页面

@property (assign, nonatomic) BOOL isSendVoiceMessage;//是否发送语音验证码 默认为没有发送
@property (strong, nonatomic) NSString *phoneNum;//手机号
@property (copy,nonatomic) NSString *currentMSGRoute; //当前发送形式

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;

@end

@implementation UpgradeAccountVC

- (void)getToBack
{
    if (_isFromeBankCardInfo)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.accoutType == SelectAccoutTypeP2P) {
        self.buttonTopConstraint.constant = 15;
        if (_isFromeBankCardInfo) {
            self.tableViewHight.constant = 44*5;
        } else {
            if ([UserInfoSingle sharedManager].openStatus == 2) {
                self.tableViewHight.constant = 44*5;
            } else {
                self.tableViewHight.constant = 44*3;
            }
        }
        baseTitleLabel.text = @"开通微金徽商存管账户";
    } else {
        self.tableViewHight.constant = 44*5;
        self.buttonTopConstraint.constant = 15;
        baseTitleLabel.text = @"开通尊享徽商存管账户";
    }
    
    [self addLeftButton];
    //    }
    
    _isSendVoiceMessage = NO;
    _height1.constant = 0.5;
    _height2.constant = 0.5;
    
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.10)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(soudLabelClick:)];
    [_customLabel1 addGestureRecognizer:tap];
    [_customLabel1 setFontColor:UIColorWithRGB(0x4aa1f9) string:@"获取语音验证码"];
    
    if (self.accoutType == SelectAccoutTypeP2P) {
        
        //        NSString *showStr = @"开通即视为本人已阅读并同意《资金存管三方协议》";
        //         _customLabel2.text = showStr;
        //        __weak typeof(self) weakSelf = self;
        //        [_customLabel2 setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《资金存管三方协议》"];
        //        [_customLabel2 addLinkString:@"《资金存管三方协议》" block:^(ZBLinkLabelModel *linkModel) {
        //            FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:TRUSTEESHIP title:@"资金存管三方协议"];
        //            webController.baseTitleType = @"specialUser";
        //            [weakSelf.navigationController pushViewController:webController animated:YES];
        //        }];
        
        
    } else {
        _customLabel2.text = @"开通即视为本人已阅读并同意《资金存管三方协议》";
        [_customLabel2 setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《资金存管三方协议》"];
        
        __weak typeof(self) weakSelf = self;
        [_customLabel2 addLinkString:@"《资金存管三方协议》" block:^(ZBLinkLabelModel *linkModel) {
            FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:ZXTRUSTEESHIP title:@"《资金存管三方协议》"];
            webController.baseTitleType = @"specialUser";
            [weakSelf.navigationController pushViewController:webController animated:YES];
        }];
    }
    
    
    
    if (_isFromeBankCardInfo) {
        self.tableViewHight.constant = 44 * 5;
        [_submitDataButton setTitle:@"提交" forState:UIControlStateNormal];
        _customLabel2.hidden = YES;
        self.isQuick = NO;
        [self addLeftButton];
        baseTitleLabel.text = @"修改绑定银行卡";
    }else{
        lineViewAA.hidden = YES;
    }
    [self initTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (!_isNotFirstCome) {
        [self getHSAccountInfo];//获取用户信息
        _isNotFirstCome = YES;
    }
}

- (void)initTextField{
    _textField1 = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-40-6, 44)];
    _textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField1.returnKeyType = UIReturnKeyDone;
    _textField1.delegate = self;
    _textField1.font = [UIFont systemFontOfSize:14];
    _textField1.textColor = UIColorWithRGB(0x555555);
    [_textField1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField1.placeholder = @"请输入真实姓名";
    
    _textField2 = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-40-6, 44)];
    _textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _textField2.returnKeyType = UIReturnKeyDone;
    _textField2.delegate = self;
    _textField2.font = [UIFont systemFontOfSize:14];
    _textField2.textColor = UIColorWithRGB(0x555555);
    [_textField2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField2.placeholder = [UserInfoSingle sharedManager].companyAgent ? @"社会信用代码/组织机构代码": @"请输入身份证号";
    
    _textField3 = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-40-6, 44)];
    _textField3.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField3.keyboardType = UIKeyboardTypeNumberPad;
    _textField3.delegate = self;
    _textField3.font = [UIFont systemFontOfSize:14];
    _textField3.textColor = UIColorWithRGB(0x555555);
    [_textField3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField3.placeholder = @"请输入银行卡号";
    
    _textField4 = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-127-15, 44)];
    _textField4.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField4.keyboardType = UIKeyboardTypeNumberPad;
    _textField4.returnKeyType = UIReturnKeyDone;
    _textField4.delegate = self;
    _textField4.placeholder = @"请输入验证码";
    _textField4.font = [UIFont systemFontOfSize:14];
    _textField4.textColor = UIColorWithRGB(0x555555);
}

#pragma mark - 验证码
//更新label
- (void)updateLabel {
    NSString *str = [NSString stringWithFormat:@"%02ld秒后重新获取",(long)_counter];
    
    [_getCodeBtn setTitle:str forState:UIControlStateNormal];
    _counter--;
    if (_counter < 0)
    {
        _isSendVoiceMessage = NO;
        [_timer invalidate];
        _timer = nil;
        [_getCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        _getCodeBtn.userInteractionEnabled = YES;
        [_getCodeBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    }
}

//点击获取短信验证码
- (void)getCodeBtn:(id)sender {
    if (_counter > 0 && _counter < 60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%02ld秒后可重新获取",(long)_counter] withView:self.view];
        return;
    }
    [self sendVerifyCode:@"SMS"];
}

#pragma mark -
//点击语音验证码
- (void)soudLabelClick:(UITapGestureRecognizer *)tap
{
    if (_counter > 0 && _counter < 60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%02ld秒后可重新获取",(long)_counter] withView:self.view];
        return;
    } else {
        if (!_isSendVoiceMessage) {
            self.customLabel1.userInteractionEnabled = NO;
            [self sendVerifyCode:@"VMS"];
        }
    }
}

- (void)chooseBankData:(NSDictionary *)data {
    //开户行名称
    _bankNameLabel.text = data[@"bankName"];
    _bankNameLabel.frame = CGRectMake(ScreenWidth-225, 0, 160, 44);
    
    //银行logo
    NSURL *url = [NSURL URLWithString:data[@"logoUrl"]];
    [_bankLogoView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bank_default"]];
    
    //开户行id
    _bankId = [NSString stringWithFormat:@"%@",data[@"bankId"]];
    
    //是否支持快捷支付
    _isQuick = [data[@"isQuick"]boolValue];
    [_tableView reloadData];
    [self textFieldDidChange:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _textField2) {
        if (textField.text.length >= 18 && ![string isEqualToString:@""]) {
            if (range.location == 17 && range.length == 1) {
                return YES;
            }
            return NO;
        }
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        return YES;
    }
    else if (textField == _textField3) {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 20) {
            return NO;
        }
        
        [textField setText:newString];
        [self textFieldDidChange:nil];
        return NO;
    }
    return YES;
}

//第二步,实现回调函数
- (void)textFieldDidChange:(UITextField *)textField{
    //只能输入中文
    /*if (textField == _textField1) {
     NSMutableString *sting = [[NSMutableString alloc]init];
     for (int i = 0; i < textField.text.length; i++) {
     NSString *tempStr = [textField.text substringWithRange:NSMakeRange(i, 1)];
     if ([Common isChinese:tempStr]) {
     [sting appendString:tempStr];
     }else{
     [AuxiliaryFunc showToastMessage:@"请输入正确的姓名" withView:self.view];
     }
     }
     textField.text = sting;
     }*/
    
    //一下代码只为控制“获取验证码”按钮是否置为灰色。
    NSString *realName = [_textField1.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *idCardNo = [_textField2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bankCard = [_textField3.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //以下判断是在输入时控制‘获取验证码’按钮是否置为灰色
    if (realName.length == 0 && ![_textField1.placeholder hasPrefix:@"请输入"]) {
        realName = _textField1.placeholder;
    }
    if (idCardNo.length == 0 && ![_textField2.placeholder hasPrefix:@"请输入"]){
        idCardNo = _textField2.placeholder;
    }
    if (bankCard.length == 0 && ![_textField3.placeholder hasPrefix:@"请输入"]){
        bankCard = _textField3.placeholder;
    }
    if (realName.length != 0 && idCardNo.length != 0 && bankCard.length != 0 && _bankLogoView.image) {
        self.getCodeBtn.enabled = YES;
    }else{
        self.getCodeBtn.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _textField4) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [self.db.scrollView setContentOffset:CGPointMake(0, 90) animated:YES];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textField1 && [textField.text isEqualToString:@""] ) {//&& ![Common isChinese:_textField1.text]
        [AuxiliaryFunc showToastMessage:@"请输入正确的姓名" withView:self.view];
        return;
    }else if (textField == _textField2 && ![Common isIdentityCard:_textField2.text]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的身份证号码" withView:self.view];
        return;
    }else if (textField == _textField3 && ![Common isValidCardNumber:_textField3.text]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的银行卡号" withView:self.view];
        return;
    }
    else if (textField == _textField4) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [self.db.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.accoutType == SelectAccoutTypeHoner || _isFromeBankCardInfo) {
        
        return  5;
    }else{
        if (self.accoutType == SelectAccoutTypeP2P && [UserInfoSingle sharedManager].openStatus == 2) {
            return 5;
        } else {
            return 3;
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *indentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tableView setSeparatorColor:UIColorWithRGB(0xe3e5ea)];
        switch (indexPath.row) {
            case 0:{//姓名
                UIImageView *imaView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                imaView.image = [UIImage imageNamed:@"tabbar_icon_user_normal"];
                [cell addSubview:imaView];
                [cell.contentView addSubview:_textField1];
            }
                break;
            case 1:{//身份证号码
                UIImageView *imaView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                imaView.image = [UIImage imageNamed:@"safecenter_icon_id"];
                [cell addSubview:imaView];
                [cell.contentView addSubview:_textField2];
            }
                break;
            case 2:
            {
                if (self.accoutType == SelectAccoutTypeHoner || _isFromeBankCardInfo) {
                    //银行卡
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                    imgView.image = [UIImage imageNamed:@"safecenter_icon_bankcard"];
                    [cell addSubview:imgView];
                    [cell.contentView addSubview:_textField3];
                }else{
                    if ([UserInfoSingle sharedManager].openStatus == 2) {
                        //银行卡
                        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                        imgView.image = [UIImage imageNamed:@"safecenter_icon_bankcard"];
                        [cell addSubview:imgView];
                        [cell.contentView addSubview:_textField3];
                    } else {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.textLabel.textColor = UIColorWithRGB(0x555555);
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                        cell.textLabel.text = @"开户银行";
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225, 0, 160, 44)];
                        label.textColor = UIColorWithRGB(0x555555);
                        label.textAlignment = NSTextAlignmentRight;
                        label.font = [UIFont systemFontOfSize:14];
                        _bankNameLabel = label;
                        [cell addSubview:_bankNameLabel];
                        
                        _bankLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-60, 7, 29, 29)];
                        [cell addSubview:_bankLogoView];
                    }
                    
                    
                }
            }
                break;
            case 3:{//开户银行
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.textColor = UIColorWithRGB(0x555555);
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.text = @"开户银行";
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225, 0, 160, 44)];
                label.textColor = UIColorWithRGB(0x555555);
                label.textAlignment = NSTextAlignmentRight;
                label.font = [UIFont systemFontOfSize:14];
                _bankNameLabel = label;
                [cell addSubview:_bankNameLabel];
                
                _bankLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-60, 7, 29, 29)];
                [cell addSubview:_bankLogoView];
            }
                break;
            case 4:{//验证码
                [cell.contentView addSubview:_textField4];
                
                //获取验证码按钮
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(ScreenWidth - 127, 0, 127, 44);
                //                button.backgroundColor = [UIColor redColor];
                [button setTitle:@"获取短信验证码" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont  systemFontOfSize:14];
                _getCodeBtn = button;
                //                _getCodeBtn.enabled = NO;
                [_getCodeBtn addTarget:self action:@selector(getCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_getCodeBtn];
                
                //分割线
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_getCodeBtn.frame), 12, 1, 20)];
                lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
                [cell addSubview:lineView];
            }
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    BOOL isGotoChooseBankVC = NO;
    if (_isFromeBankCardInfo) {
        if(indexPath.row == 3)
        {
            isGotoChooseBankVC = YES;
        }
    }else{

        if((self.accoutType == SelectAccoutTypeP2P &&  indexPath.row == 2) || ([UserInfoSingle sharedManager].openStatus == 2 && indexPath.row == 3))
        {
            isGotoChooseBankVC = YES;
        }
        if(self.accoutType == SelectAccoutTypeHoner &&  indexPath.row == 3)
        {
            isGotoChooseBankVC = YES;//c不能充值填写的银行卡不能充值填写的银行卡不能充值填写的银行卡不能充值
        }
    }
    if (isGotoChooseBankVC) {
        UCFHuiShangChooseBankViewController *vc = [[UCFHuiShangChooseBankViewController alloc] initWithNibName:@"UCFHuiShangChooseBankViewController" bundle:nil];
        vc.bankDelegate = self;
        //        vc.site = _site;
        vc.accoutType = self.accoutType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 请求网络及回调
//获取用户信息
- (void)getHSAccountInfo{
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagGetOpenAccountInfo owner:self signature:YES Type:self.accoutType];
}

//修改绑定银行卡接口
- (void)replaceBankCardInformation:(NSDictionary *)encryptParamDic{
    if(!self.isQuick){//绑定的银行卡不支持快捷支付的时候
        BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"您填写的银行卡不能充值，只能用于提现，确认要提交吗" cancelButtonTitle:@"确定" clickButton:^(NSInteger index) {
            if (index == 0) {
                //qinyangyue
                [[NetworkModule sharedNetworkModule] newPostReq:encryptParamDic tag:kSXTagReplaceBankCardInformation owner:self signature:YES Type:self.accoutType];
            }
        } otherButtonTitles:@"返回修改"];
        [alert show];
    }else{
        //qinyangyue
        [[NetworkModule sharedNetworkModule] newPostReq:encryptParamDic tag:kSXTagReplaceBankCardInformation owner:self signature:YES Type:self.accoutType] ;
    }
}

//获取验证码
- (void)sendVerifyCode:(NSString*)isVms{
    [self.view endEditing:YES];
    NSString *realName = _textField1.text;
    NSString *idCardNo = _textField2.text;
    NSString *bankCard = _textField3.text;
    
    if (realName.length == 0 && ![_textField1.placeholder hasPrefix:@"请输入"]) {
        realName = _textField1.placeholder;
    }
    if (idCardNo.length == 0 && ![_textField2.placeholder hasPrefix:@"请输入"]){
        idCardNo = _textField2.placeholder;
    }
    if (bankCard.length == 0 && ![_textField3.placeholder hasPrefix:@"请输入"]){
        bankCard = _textField3.placeholder;
    }
    
    if (realName.length == 0 || idCardNo.length == 0 || bankCard.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请完善信息之后再提交" withView:self.view];
        return;
    }
    //    if (![Common isChinese:realName]) {
    //        [AuxiliaryFunc showToastMessage:@"请输入正确的姓名" withView:self.view];
    //        return;
    //    }else
    if (![Common isIdentityCard:idCardNo] && [idCardNo rangeOfString:@"*"].location == NSNotFound){
        [AuxiliaryFunc showToastMessage:@"请输入正确的身份证号码" withView:self.view];
        return;
    }else if (![Common isValidCardNumber:bankCard]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的银行卡号" withView:self.view];
        return;
    }
    
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
    NSDictionary *dic = @{@"destPhoneNo":_phoneNum,@"isVms":isVms,@"type":_isFromeBankCardInfo?@"3":@"6",@"userId":userId};
    self.currentMSGRoute = isVms;
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagIdentifyCode owner:self signature:YES Type:self.accoutType];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//徽商绑定银行卡
- (IBAction)submitDataButton:(id)sender
{
    [self.view endEditing:YES];
    if ([_tempBankId isEqualToString:_bankId]) {
        BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:_notSupportDes cancelButtonTitle:nil clickButton:^(NSInteger index) {} otherButtonTitles:@"确定"];
        [alert show];
        return;
    }
    
    NSString *realName = _textField1.text;
    NSString *idCardNo = _textField2.text;
    
    
    if (realName.length == 0 && ![_textField1.placeholder hasPrefix:@"请输入"]) {//姓名
        realName = _textField1.placeholder;
    }
    if (idCardNo.length == 0 && ![_textField2.placeholder hasPrefix:@"请输入"]){//身份证
        idCardNo = _idCardNo;
    }
    NSString *bankCard = _textField3.text;
    if (bankCard.length == 0 && ![_textField3.placeholder hasPrefix:@"请输入"]){//银行卡
        bankCard = _textField3.placeholder;
    }
    
    
    
    if(self.accoutType == SelectAccoutTypeHoner || _isFromeBankCardInfo)
    {
        
        if (realName.length == 0 || idCardNo.length == 0 || bankCard.length == 0 || _textField4.text.length == 0) {
            [AuxiliaryFunc showToastMessage:@"请完善信息之后再提交" withView:self.view];
            return;
        }
    }else{
        if ([UserInfoSingle sharedManager].openStatus == 2) {
            if (realName.length == 0 || idCardNo.length == 0 || bankCard.length == 0 || _textField4.text.length == 0) {
                [AuxiliaryFunc showToastMessage:@"请完善信息之后再提交" withView:self.view];
                return;
            }
        } else {
            if (realName.length == 0 || idCardNo.length == 0 || _bankId.length == 0) {
                [AuxiliaryFunc showToastMessage:@"请完善信息之后再提交" withView:self.view];
                return;
            }
        }
        
    }
    
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    bankCard = [bankCard stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //修改绑定银行卡接口
    if (_isFromeBankCardInfo) {
        NSDictionary *encryptParamDic = @{
                                          @"bankCard":bankCard,              //银行卡号
                                          @"bankId":_bankId,                 //银行id
                                          @"openStatus":_openStatus,         //获取到的用户信息的状态，对应接口getOpenAccountInfo
                                          @"validateCode":_textField4.text,  //手机验证码
                                          @"userId":userId,                  //用户id
                                          };
        [self replaceBankCardInformation:encryptParamDic];
    }
    //升级存管账户接口
    else{
        NSMutableDictionary *encryptParamDic = nil;
        if (([UserInfoSingle sharedManager].openStatus == 2 && self.accoutType == SelectAccoutTypeP2P) || self.accoutType == SelectAccoutTypeHoner) {
            encryptParamDic =[[NSMutableDictionary alloc]initWithDictionary: @{@"realName":realName,             //真实姓名
                                                                               @"idCardNo":idCardNo,             //身份证号
                                                                               @"bankCardNo":bankCard,           //银行卡号
                                                                               @"bankNo":_bankId,                //银行id
                                                                               @"openStatus":_openStatus,        //获取到的用户信息的状态，对应接口getOpenAccountInfo
                                                                               @"validateCode":_textField4.text, //手机验证码
                                                                               @"userId":userId,                 //用户id
                                                                               }];
        } else {
            encryptParamDic =[[NSMutableDictionary alloc]initWithDictionary: @{@"realName":realName,             //真实姓名
                                                                               @"idCardNo":idCardNo,             //身份证号
                                                                               @"bankNo":_bankId,                //银行id
                                                                               @"openStatus":_openStatus,        //获取到的用户信息的状态，对应接口
                                                                               @"userId":userId,                 //用户id
                                                                               }];
        }
        
        if (self.accoutType == SelectAccoutTypeHoner)
        {
            [[NetworkModule sharedNetworkModule] newPostReq:encryptParamDic tag:kSXTagOpenAccount owner:self signature:YES Type:self.accoutType];
        }
        else
        {
            if ([UserInfoSingle sharedManager].openStatus == 2) {
                [[NetworkModule sharedNetworkModule] newPostReq:encryptParamDic tag:kSXTagOpenAccount owner:self signature:YES Type:self.accoutType];
            } else {
                [[NetworkModule sharedNetworkModule] newPostReq:encryptParamDic tag:kSXTagOpenAccuntIntoBank owner:self signature:YES Type:self.accoutType];
            }
            
        }
    }
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    if (tag == kSXTagOpenAccuntIntoBank) {//徽商绑定银行卡
        //        [GiFHUD show];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    //    DBLOG(@"新用户开户：%@",data);
    
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagGetOpenAccountInfo) {//获取徽商开户页面信息
        if ([ret boolValue]) {
            DBLOG(@"%@",dic[@"data"]);
            NSString *cfcaContractNameStr = [dic[@"data"] objectSafeForKey:@"cfcaContractName"];
            NSString *cfcaContractUrlStr = [dic[@"data"] objectSafeForKey:@"cfcaContractUrl"];
            if(![cfcaContractNameStr isEqualToString:@""]){
                //                _customLabel2.text = @"开通即视为本人已阅读并同意《CFCA数字证书服务协议》《资金存管三方协议》";
                //                __weak typeof(self) weakSelf = self;
                //                [_customLabel2 setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《CFCA数字证书服务协议》《资金存管三方协议》"];
                _customLabel2.text = @"开通即视为本人已阅读并同意《CFCA数字证书服务协议》";
                __weak typeof(self) weakSelf = self;
                [_customLabel2 setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《CFCA数字证书服务协议》"];
                [_customLabel2 addLinkString:@"《CFCA数字证书服务协议》" block:^(ZBLinkLabelModel *linkModel) {
                    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:cfcaContractUrlStr title:@"CFCA数字证书服务协议"];
                    webController.baseTitleType = @"specialUser";
                    [weakSelf.navigationController pushViewController:webController animated:YES];
                }];
            }
            NSDictionary *userInfoDic = dic[@"data"][@"userInfo"];
            _openStatus = dic[@"data"][@"openStatus"];
            if (self.accoutType == SelectAccoutTypeP2P) {
                [UserInfoSingle sharedManager].openStatus = [_openStatus integerValue];
            } else {
                [UserInfoSingle sharedManager].enjoyOpenStatus = [_openStatus integerValue];
            }
            _bankId = [NSString stringWithFormat:@"%@",userInfoDic[@"bankId"]];//[userInfoDic objectSafeForKey:@"bankId"];//
            NSString *realName = [userInfoDic objectSafeForKey:@"realName"];
            NSString *idCardNo = [userInfoDic objectSafeForKey:@"idCardNo"];
            NSString *bankCard = [userInfoDic objectSafeForKey:@"bankCard"];
            NSString *bankName = [userInfoDic objectSafeForKey:@"bankName"];
            NSString *bankLogo = [userInfoDic objectSafeForKey:@"bankLogo"];
            self.phoneNum = [userInfoDic objectSafeForKey:@"phoneNum"];
            self.notSupportDes = [userInfoDic objectSafeForKey:@"notSupportDes"];
            
            if (realName.length > 0) {
                
                if ([UserInfoSingle sharedManager].openStatus != 1)
                {
                    _textField1.userInteractionEnabled = NO;
                    _textField1.placeholder = realName;
                }
                else
                {
                    _textField1.text = realName;
                }
                [UserInfoSingle sharedManager].realName = realName;
            }
            if (idCardNo.length > 0){
                self.idCardNo = idCardNo;//此处是为了回传到总控制器，通过总控制器传到下级页面。
                
                //打码
                NSString *asteriskIdCardNo = [self replaceStringWithAsterisk:idCardNo startLocation:3 lenght:idCardNo.length -7];
                NSString *asteriskMobile = [self replaceStringWithAsterisk:self.phoneNum startLocation:3 lenght:self.phoneNum.length -7];
                if ([UserInfoSingle sharedManager].openStatus != 1)
                {
                    _textField2.userInteractionEnabled = NO;
                    _textField2.placeholder = asteriskIdCardNo;
                }
                else
                {
                    _textField2.text = self.idCardNo;
                }
                [UserInfoSingle sharedManager].mobile = asteriskMobile;
            }
            
            if (bankCard.length > 0 && !_isFromeBankCardInfo) {
                //将银行卡（textField3）要显示的文字四位分隔
                NSString *newString = @"";
                while (bankCard.length > 0) {
                    NSString *subString = [bankCard substringToIndex:MIN(bankCard.length,4)];
                    newString = [newString stringByAppendingString:subString];
                    if (subString.length == 4) {
                        newString = [newString stringByAppendingString:@" "];
                    }
                    bankCard = [bankCard substringFromIndex:MIN(bankCard.length,4)];
                }
                _textField3.text = newString;
            }
            
            //银行logo
            if (bankName.length > 0 && !_isFromeBankCardInfo){//如果有银行名称，就显示名称，否则显示“请选择”
                _bankNameLabel.text = bankName;
                NSURL *url = [NSURL URLWithString:bankLogo];
                [_bankLogoView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bank_default"]];
            }else{
                _bankNameLabel.frame = CGRectMake(ScreenWidth-225, 0, 190, 44);
                _bankNameLabel.text = @"请选择";
            }
            
            if (realName.length > 0 && idCardNo.length > 0 && _textField3.text.length > 0 && _bankLogoView.image) {
                self.getCodeBtn.enabled = YES;
            }
            
            //新老用户的提交按钮文字一样 ：立即开通
            if (!_isFromeBankCardInfo)
            {
                [_submitDataButton setTitle:@"立即开通" forState:UIControlStateNormal];
            }
            
            if (_notSupportDes.length > 0) {
                _tempBankId = _bankId;
                BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:_notSupportDes cancelButtonTitle:nil clickButton:^(NSInteger index) {} otherButtonTitles:@"确定"];
                [alert show];
            }
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
    else if (tag.intValue == kSXTagIdentifyCode) {//发送验证码
        if ([ret boolValue]) {
            
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.buttonTopConstraint.constant = 50;
            }];
            _isSendVoiceMessage = YES;
            DBLOG(@"%@",dic[@"data"]);
            [_getCodeBtn setTitle:@"60秒后重新获取" forState:UIControlStateNormal];
            _getCodeBtn.userInteractionEnabled = YES;
            [_getCodeBtn setTitleColor:UIColorWithRGB(0xcccccc) forState:UIControlStateNormal];
            _timer = [HWWeakTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
            _counter = 59;
            
            _customLabel1.text = [NSString stringWithFormat:@"已向手机%@发送短信验证码，若收不到，请点击这里获取语音验证码。",[UserInfoSingle sharedManager].mobile];
            [_customLabel1 setFontColor:UIColorWithRGB(0x4aa1f9) string:@"点击这里"];
            _customLabel1.hidden = NO;
            _customLabel1.userInteractionEnabled = YES;
            if ([self.currentMSGRoute isEqualToString:@"VMS"]) {
                [AuxiliaryFunc showToastMessage:@"系统正在准备外呼，请保持手机信号畅通" withView:self.view];
            } else {
                
            }
        }else {
            _isSendVoiceMessage = NO;
            _customLabel1.userInteractionEnabled = YES;
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
    else if (tag.intValue == kSXTagOpenAccount) {//徽商绑定银行卡
        if ([ret boolValue]) {
            DBLOG(@"%@",dic[@"data"]);
            if (self.accoutType == SelectAccoutTypeP2P) {
                [UserInfoSingle sharedManager].openStatus = 3;
            } else {
                [UserInfoSingle sharedManager].enjoyOpenStatus = 3;
            }
            NSString *realName = _textField1.text;//姓名
            NSString *idCardNo = _textField2.text;//身份证号
            if (realName.length == 0) {
                realName = _textField1.placeholder;
            }
            if (idCardNo.length > 0) {
                self.idCardNo = idCardNo;
            }
            [UserInfoSingle sharedManager].realName = realName;
            
            //提交信息成功之后，显示开户成功页面
            AccountSuccessVC *acVC = [[AccountSuccessVC alloc]initWithNibName:@"AccountSuccessVC" bundle:nil];
            //            acVC.site = self.site;
            acVC.accoutType = self.accoutType;
            acVC.fromVC = self.fromVC;
            acVC.view.frame = self.view.bounds;
            acVC.db = self.db;
            [acVC didMoveToParentViewController:self];
            self.db.isOpenAccount = YES;
            [self.view addSubview:acVC.view];
            [self addChildViewController:acVC];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }else if (tag.intValue == kSXTagReplaceBankCardInformation) {
        if ([ret boolValue]) {
            if([dic[@"code"] integerValue] == 10000) {
                BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"修改绑定银行卡信息成功！" cancelButtonTitle:@"确定" clickButton:^(NSInteger index) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MODIBANKZONE_SUCCESSED object:nil];//返回绑定银行卡页面刷刷新数据
                    [self.navigationController popViewControllerAnimated:YES];
                } otherButtonTitles:nil];
                [alert show];
            }
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
    else if (tag.intValue == kSXTagOpenAccuntIntoBank) {
        if ([ret boolValue])
        {
            [UserInfoSingle sharedManager].realName = _textField1.text;
            _counter = 0;
            AccountWebView *webView = [[AccountWebView alloc] initWithNibName:@"AccountWebView" bundle:nil];
            webView.title = @"即将跳转";
            webView.isPresentViewController = self.db.isPresentViewController;
            webView.rootVc = @"UpgradeAccountVC";
            webView.url =  dic[@"data"][@"url"];
            NSString *SIGNStr =   dic[@"data"][@"tradeReq"][@"SIGN"];
            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
            [data setValue: dic[@"data"][@"tradeReq"][@"PARAMS"]  forKey:@"PARAMS"];
            [data setValue:[NSString  urlEncodeStr:SIGNStr] forKey:@"SIGN"];
            webView.webDataDic = data;
            if(self.db){
                [self.db.navigationController pushViewController:webView animated:YES];
            }else{
                [self.navigationController pushViewController:webView animated:YES];
            }
            //            NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            //            [navVCArray removeObjectAtIndex:navVCArray.count-2];//在栈里把上级视图移除
            //            [self.navigationController setViewControllers:navVCArray animated:NO];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    _isSendVoiceMessage = NO;
    _customLabel1.userInteractionEnabled = YES;
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - 工具方法
//把字符串替换成星号
- (NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght
{
    NSString *newStr = originalStr;
    for (int i = 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}

@end
