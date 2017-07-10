//
//  TradePasswordVC.m
//  JRGC
//
//  Created by biyuhuaping on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//  设置交易密码

#import "TradePasswordVC.h"
#import "NZLabel.h"
#import "HWWeakTimer.h"
#import "UCFToolsMehod.h"
#import "AccountWebView.h"

@interface TradePasswordVC ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NZLabel *label;
@property (strong, nonatomic) IBOutlet UIButton *submitDataButton;//提交数据按钮

@property (strong, nonatomic) UIButton *getCodeBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger counter;//计数器

@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UITextField *textField3;
@property (strong, nonatomic) UITextField *textField4;
@property (assign, nonatomic) BOOL         isVoiceMsg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation TradePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    
    if([self.title isEqualToString:@"修改交易密码"] ){
        baseTitleLabel.text = @"验证身份";
        [self.submitDataButton setTitle:@"修改交易密码" forState:UIControlStateNormal];
    }else{
        baseTitleLabel.text = self.title;
        lineViewAA.hidden = YES;
    }

    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.10)];
    
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [_label setFontColor:UIColorWithRGB(0x4aa1f9) string:@"点击这里"];
    __weak typeof(self) weakSelf = self;
    [self.label addLinkString:@"点击这里" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf soudLabelClick];
    }];
    _isCompanyAgent = [[NSUserDefaults standardUserDefaults] boolForKey: @"isCompanyAgentType"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //如果是按开通徽商流程进入本页面(不需要填身份证)，就只显示2行
    if (self.db.isOpenAccount) {
        _tableViewHeight.constant = 88;//176;
      
    }else{
        _tableViewHeight.constant = 176;//176;显示4行的情况
    }
      [self.tableView reloadData];
}

#pragma mark - 验证码
//更新label
- (void)updateLabel {
    NSString *str = [NSString stringWithFormat:@"%02ld秒后重新获取",(long)_counter];
    
    [_getCodeBtn setTitle:str forState:UIControlStateNormal];
    _counter--;
    if (_counter < 0) {
        self.label.userInteractionEnabled = YES;
        [_timer invalidate];
        [_getCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        _getCodeBtn.userInteractionEnabled = YES;
        [_getCodeBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    }
}

//点击获取短信验证码
- (void)getCodeBtn:(id)sender {
    
    [self.view endEditing:YES];
    
    if (_counter > 0 && _counter < 60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%ld秒后可重新获取",_counter] withView:self.view];
        return;
    }
    _getCodeBtn.userInteractionEnabled = YES;
    _isVoiceMsg = NO;
    [self sendVerifyCode:@"SMS"];
}

//点击语音验证码
- (void)soudLabelClick {
    if (_counter > 0 && _counter < 60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%ld秒后可重新获取",_counter] withView:self.view];
        return;
    } else {
        self.label.userInteractionEnabled = NO;
        _isVoiceMsg = YES;
        [self sendVerifyCode:@"VMS"];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _textField2 && !_isCompanyAgent) {
        if (textField.text.length > 18 && ![string isEqualToString:@""]) {
            return NO;
        }
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        return YES;
    }else if(textField == _textField2 && _isCompanyAgent){
        if (textField.text.length >=20  && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

//第二步,实现回调函数
- (void)textFieldDidChange:(UITextField *)textField{
    //只能输入中文
    if (textField == _textField1) {
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
    }
    
    NSString *idCardNo = [_textField2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (idCardNo.length == 0 && self.idCardNo.length == 0) {
        self.getCodeBtn.enabled = NO;
    }else{
        self.getCodeBtn.enabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _textField2) {
        [_textField4 becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _textField4 && !self.db.isOpenAccount) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [self.db.scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textField1 && ![Common isChinese:_textField1.text]) {
        [AuxiliaryFunc showToastMessage:@"请输入正确的姓名" withView:self.view];
        return;
    }else if (textField == _textField2){
        NSInteger openStatus = [UserInfoSingle sharedManager].openStatus;
        
        //机构用户
        if (_isCompanyAgent && ![Common isEnglishAndNumbers:textField.text]) {
            [AuxiliaryFunc showToastMessage:@"请输入正确的证件号" withView:self.view];
        }
        //排除机构、和特殊用户
        else if (!_isCompanyAgent && ![Common isIdentityCard:textField.text] && openStatus != 5){
            [AuxiliaryFunc showToastMessage:@"请输入正确的身份证号码" withView:self.view];
        }
        return;
    }else if (textField == _textField3 && ![Common validateMobile:_textField3.text]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的手机号" withView:self.view];
        return;
    }else if (textField == _textField4) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [self.db.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.db.isOpenAccount) {
        return 2;
    }
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *indentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tableView setSeparatorColor:UIColorWithRGB(0xe3e5ea)];
        if (!self.db.isOpenAccount) {
            switch (indexPath.row) {
                case 0:{//姓名
                    UIImageView *imaView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                    imaView.image = [UIImage imageNamed:@"tabbar_icon_user_normal"];
                    [cell addSubview:imaView];
                    
                    _textField1 = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-40-15, 44)];
                    _textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _textField1.returnKeyType = UIReturnKeyDone;
                    _textField1.delegate = self;
                    _textField1.font = [UIFont systemFontOfSize:14];
                    _textField1.textColor = UIColorWithRGB(0x555555);
                    _textField1.placeholder = [UserInfoSingle sharedManager].realName;
                    _textField1.userInteractionEnabled = NO;
                    [cell.contentView addSubview:_textField1];
                }
                    break;
                case 1:{//身份证号码
                    UIImageView *imaView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                    imaView.image = [UIImage imageNamed:@"safecenter_icon_id"];
                    [cell addSubview:imaView];
                    
                    _textField2 = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-40-15, 44)];
                    _textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _textField2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    _textField2.returnKeyType = UIReturnKeyDone;
                    _textField2.delegate = self;
                    _textField2.font = [UIFont systemFontOfSize:14];
                    _textField2.textColor = UIColorWithRGB(0x555555);
                    [_textField2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    _textField2.placeholder = [[NSUserDefaults standardUserDefaults] boolForKey: @"isCompanyAgentType"] ? @"请输入社会信用代码/组织机构代码":@"请输入身份证号";
                    [cell.contentView addSubview:_textField2];
                }
                    break;
                case 2:{//请输入手机号
                    UIImageView *imaView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                    imaView.image = [UIImage imageNamed:@"login_icon_phone"];
                    [cell addSubview:imaView];
                    
                    _textField3 = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-40-15, 44)];
                    _textField3.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _textField3.keyboardType = UIKeyboardTypeNumberPad;
//                    _textField3.delegate = self;
                    _textField3.placeholder = [UserInfoSingle sharedManager].mobile;
                    _textField3.userInteractionEnabled = NO;
                    _textField3.font = [UIFont systemFontOfSize:14];
                    _textField3.textColor = UIColorWithRGB(0x555555);
//                    _textField3.text = @"请输入手机号";
                    [cell.contentView addSubview:_textField3];
                }
                    break;
                case 3:{//验证码
                    _textField4 = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-127-15, 44)];
                    _textField4.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _textField4.keyboardType = UIKeyboardTypeNumberPad;
                    _textField4.returnKeyType = UIReturnKeyDone;
                    _textField4.delegate = self;
                    _textField4.placeholder = @"请输入验证码";
                    _textField4.font = [UIFont systemFontOfSize:14];
                    _textField4.textColor = UIColorWithRGB(0x555555);
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
                    _getCodeBtn.enabled = NO;
                    [_getCodeBtn addTarget:self action:@selector(getCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:_getCodeBtn];
                    
                    //分割线
                    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_getCodeBtn.frame), 12, 1, 20)];
                    lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
                    [cell addSubview:lineView];
                }
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:{//请输入手机号
                    UIImageView *imaView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
                    imaView.image = [UIImage imageNamed:@"login_icon_phone"];
                    [cell addSubview:imaView];
                    
                    _textField3 = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth-40-15, 44)];
                    _textField3.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _textField3.keyboardType = UIKeyboardTypeNumberPad;
                    //                _textField3.delegate = self;
                    _textField3.placeholder = [UserInfoSingle sharedManager].mobile;
                    _textField3.userInteractionEnabled = NO;
                    _textField3.font = [UIFont systemFontOfSize:14];
                    _textField3.textColor = UIColorWithRGB(0x555555);
                    [cell.contentView addSubview:_textField3];
                }
                    break;
                case 1:{//验证码
                    _textField4 = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-127-15, 44)];
                    _textField4.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _textField4.keyboardType = UIKeyboardTypeNumberPad;
                    _textField4.returnKeyType = UIReturnKeyDone;
                    _textField4.delegate = self;
                    _textField4.placeholder = @"请输入验证码";
                    _textField4.font = [UIFont systemFontOfSize:14];
                    _textField4.textColor = UIColorWithRGB(0x555555);
                    [cell.contentView addSubview:_textField4];
                    
                    //获取验证码按钮
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(ScreenWidth - 127, 0, 127, 44);
                    [button setTitle:@"获取短信验证码" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                    [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont  systemFontOfSize:14];
                    _getCodeBtn = button;
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
    }
    return cell;
}

#pragma mark - 请求网络及回调
//获取验证码
- (void)sendVerifyCode:(NSString*)isVms{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
    NSDictionary *dic = @{@"isVms":isVms,@"type":@"5",@"userId":userId,@"fromSite":_site};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagIdentifyCode owner:self signature:YES Type:self.accoutType];
}

- (IBAction)submitDataButton:(id)sender {
    [self.view endEditing:YES];
    //如果只显示2行（会默认填写手机号）
    if (self.db.isOpenAccount) {
        if (_textField4.text.length == 0) {
            [AuxiliaryFunc showToastMessage:@"请完善信息之后再提交" withView:self.view];
            return;
        }
    }else{
        if (_textField2.text.length == 0 || _textField4.text.length == 0) {
            [AuxiliaryFunc showToastMessage:@"请完善信息之后再提交" withView:self.view];
            return;
        }
        self.idCardNo = _textField2.text;       //身份证号
    }
    //因为开通徽商流程和修改交易密码共用，所以要区分开
    
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSDictionary *dic = @{@"idCardNo":self.idCardNo, @"validateCode":_textField4.text, @"userId":userId,@"fromSite":_site};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagSetHsPwdReturnJson owner:self signature:YES Type:self.accoutType];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    //    DBLOG(@"新用户开户：%@",data);
    
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagIdentifyCode) {
        if ([ret boolValue]) {
            DBLOG(@"%@",dic[@"data"]);
            [_getCodeBtn setTitle:@"60秒后重新获取" forState:UIControlStateNormal];
            _getCodeBtn.userInteractionEnabled = YES;
            [_getCodeBtn setTitleColor:UIColorWithRGB(0xcccccc) forState:UIControlStateNormal];
            _timer = [HWWeakTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
            _counter = 59;
//             [AuxiliaryFunc showToastMessage:@"已发送,请等待接收，60秒后可再次获取" withView:self.view];
            _label.text = [NSString stringWithFormat:@"已向手机%@发送短信验证码，若收不到，请点击这里获取语音验证码。",[UserInfoSingle sharedManager].mobile];
            [_label setFontColor:UIColorWithRGB(0x4aa1f9) string:@"点击这里"];
            _label.hidden = NO;
            self.label.userInteractionEnabled = YES;
            if (_isVoiceMsg) {
                [AuxiliaryFunc showToastMessage:@"系统正在准备外呼，请保持手机信号畅通" withView:self.view];
            }

        }else {
             _getCodeBtn.userInteractionEnabled = YES;
            self.label.userInteractionEnabled = YES;
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
    if (tag.intValue == kSXTagSetHsPwdReturnJson) {
        if ([ret boolValue]){
            _counter = 0;
            AccountWebView *webView = [[AccountWebView alloc] initWithNibName:@"AccountWebView" bundle:nil];
            webView.title = @"即将跳转";
            webView.isPresentViewController = self.db.isPresentViewController;
            webView.url = dic[@"data"][@"url"];
            webView.webDataDic = dic[@"data"][@"tradeReq"];
            if(self.db){
                [self.db.navigationController pushViewController:webView animated:YES];
            }else{
                [self.navigationController pushViewController:webView animated:YES];
            }
            NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            [navVCArray removeObjectAtIndex:navVCArray.count-2];//在栈里把上级视图移除
            [self.navigationController setViewControllers:navVCArray animated:NO];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
     _getCodeBtn.userInteractionEnabled = YES;
    self.label.userInteractionEnabled = YES;
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
