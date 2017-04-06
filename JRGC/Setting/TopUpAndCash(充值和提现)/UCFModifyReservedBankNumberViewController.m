//
//  UCFModifyReservedBankNumberViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2016/12/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFModifyReservedBankNumberViewController.h"
#import "NZLabel.h"
#import "SharedSingleton.h"
#import "Common.h"
@interface UCFModifyReservedBankNumberViewController ()
{
    BOOL isSendSMS;//是否是sms SMS："普通短信渠道"；VMS："验证码语音渠道"
    NSTimer *_timer;
    BOOL _isfirstSendCode;//是否第一步发送验证码
    int _counter;
    NSString *_updatePhoneNoTicketStr;//修改银行预留手机号校验码
    NSString *_newMobileNumberStr;//新预留手机号码 注意加****之后的
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIImageView *stepOneImageView;
@property (strong, nonatomic) IBOutlet UILabel *stepOneTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *stepTwoImageView;
@property (strong, nonatomic) IBOutlet UILabel *stepTwoTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *stepArrowImageView;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *stepNextOrSaveBtn;
@property (strong, nonatomic) IBOutlet NZLabel *telServerLabel;
- (IBAction)getPhoneCode:(UIButton *)sender;
- (IBAction)gotoStepNext:(UIButton *)sender;
@end

@implementation UCFModifyReservedBankNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.accoutType  == SelectAccoutTypeHoner){
          baseTitleLabel.text = @"尊享修改银行预留手机号";
    }else{
          baseTitleLabel.text = @"P2P修改银行预留手机号";
    }
    [self addLeftButton];
    [self initFirstViewUI];
}
//初始化验证注册手机号View的UI
-(void)initFirstViewUI{
    _stepOneTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 37)];
    view1.backgroundColor = UIColorWithRGB(0xf4f4f4);;
    _phoneNumberTextField.leftView = view1;
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumberTextField.backgroundColor = UIColorWithRGB(0xf4f4f4);
    _phoneNumberTextField.text = [UserInfoSingle sharedManager].mobile;
    _phoneNumberTextField.textColor = UIColorWithRGB(0x999999);
    _phoneNumberTextField.userInteractionEnabled = NO;
    [self.phoneNumberTextField addTarget:self action:@selector(formatPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 37)];
    view2.backgroundColor = [UIColor whiteColor];
    _codeTextField.leftView = view2;
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _getCodeBtn.tag = 1001;
    _stepNextOrSaveBtn.tag = 1001;
    
    __weak typeof(self) weakSelf = self;
    _telServerLabel.text = @"若注册手机号无法进行验证，请联系客服人工解决";
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telServerOpenUrl)];
//    [_telServerLabel addGestureRecognizer:tap];
//    [_telServerLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"联系客服"];
    
    [_telServerLabel addLinkString:@"联系客服" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf telServerOpenUrl];
    }];
    [_telServerLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"联系客服"];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    _counter = 60;
    
  
}
//初始化验证新手机号View的UI
-(void)initSencodeViewUI{
    
    _firstView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    _stepOneImageView.image = [UIImage imageNamed:@"authentication_icon_finish"];
    _stepOneTitleLabel.textColor = UIColorWithRGB(0x999999);
    _stepOneTitleLabel.font = [UIFont systemFontOfSize:14];
    _stepArrowImageView.image = [UIImage imageNamed:@"step_arrow_gray"];
    _stepTwoImageView.image = [UIImage imageNamed:@"ic_step_2_normal"];
    _stepTwoTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    _stepTwoTitleLabel.textColor = UIColorWithRGB(0x6280a8);
    
    _phoneNumberTextField.leftView.backgroundColor = [UIColor whiteColor];
    _phoneNumberTextField.backgroundColor = [UIColor whiteColor];
    _phoneNumberTextField.text = @"";
    _phoneNumberTextField.textColor = UIColorWithRGB(0x000000);
    _phoneNumberTextField.userInteractionEnabled = YES;
    [_phoneNumberTextField becomeFirstResponder];
    
    _codeTextField.text = @"";
    _getCodeBtn.tag = 1002;
    [_stepNextOrSaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _stepNextOrSaveBtn.tag = 1002;
    _telServerLabel.text = @"";
    [self resetGetCodeButtonStuats]; //重置获取验证码状态
}
-(void)telServerOpenUrl{
    [self.view endEditing:YES];
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[_tellNumber  stringByReplacingOccurrencesOfString:@"-" withString:@""]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];

//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4000322988"]];DZWD
}
#pragma mark 获取验证码的timer倒计时
- (void)timerFired
{
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_counter] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _getCodeBtn.backgroundColor = UIColorWithRGB(0xd4d4d4);
    _counter--;
    if (_counter == 0) {
        [self resetGetCodeButtonStuats];
    }
}
#pragma mark 重置获取验证码的状态
-(void)resetGetCodeButtonStuats{
    [_timer  setFireDate:[NSDate distantFuture]];
    _counter = 60;
    _getCodeBtn.userInteractionEnabled = YES;
    _getCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -获取手机验证码
- (IBAction)getPhoneCode:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString* str = [self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([Common deleteStrSpace:str].length != 11) {
        [MBProgressHUD displayHudError:@"请输入正确的手机号"];
        return;
    }
    if (sender.tag == 1001) { //验证注册手机号
        [self getVerificationCodeNetworkRequest:YES isVmsType:@"SMS"]; //短信验证码
    }else  {
        [self getVerificationCodeNetworkRequest:NO isVmsType:@"SMS"]; //短信验证码
    }
}
#pragma mark -点击下一步或保存按钮的事件
- (IBAction)gotoStepNext:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString* str = [self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([Common deleteStrSpace:str].length != 11) {
        [MBProgressHUD displayHudError:@"请输入正确的手机号"];
        return;
    }
    if (![SharedSingleton isValidateMsg:_codeTextField.text]) {
        [MBProgressHUD displayHudError:@"请输入验证码"];
        return;
    }
    
    if (sender.tag == 1001) { //下一步
        [self verifyRigisterPhoneNunmberHttpRequst];
    }else{
        [self modifyBankReservePhoneNunmberHttpRequst];
    }
}
#pragma mark -获取验证注册验证码与新手机号验证码的网络请求
-(void)getVerificationCodeNetworkRequest:(BOOL)isFirst  isVmsType:(NSString *)vmsType{
    _isfirstSendCode = isFirst;
    if (isFirst) {
        NSDictionary *dataDic =@{@"destPhoneNo":@"",@"isVms":vmsType ,@"userId":[UserInfoSingle sharedManager].userId,@"type":@"10"};
        [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagIdentifyCode owner:self signature:YES Type:self.accoutType];
    }else{
        NSString* str = [self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary *dic = @{@"destPhoneNo":[Common deleteStrSpace:str],@"isVms":vmsType,@"type":@"9",@"userId":[UserInfoSingle sharedManager].userId};
        [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagIdentifyCode owner:self signature:YES Type:self.accoutType];
    }
}
#pragma mark -验证注册手机号验证码网络请求
-(void)verifyRigisterPhoneNunmberHttpRequst{
    NSDictionary *dataDic =@{@"userId":[UserInfoSingle sharedManager].userId,@"validateCode":_codeTextField.text};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagValidateOldPhoneNo owner:self signature:YES Type:self.accoutType];
}
#pragma mark -修改银行预留手机号网络请求
-(void)modifyBankReservePhoneNunmberHttpRequst{
    NSString* str = [self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *dataDict = @{@"phoneNum":[Common deleteStrSpace:str],@"validateCode":_codeTextField.text,@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"updatePhoneNoTicket":_updatePhoneNoTicketStr};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagChangeReserveMobileNumber owner:self signature:YES Type:self.accoutType];
}
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    if (tag.intValue == kSXTagIdentifyCode){
        if (_isfirstSendCode) {
            if([dic[@"ret"] intValue] == 1){

                [MBProgressHUD displayHudError:@"已发送，请等待接收，60秒后可再次获取。"];
                _getCodeBtn.userInteractionEnabled = NO;
                [_timer setFireDate:[NSDate distantPast]];
                [_getCodeBtn setBackgroundColor:UIColorWithRGB(0xd4d4d4)];
//                NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:PHONENUM];
//                NSString *tempText = [NSString stringWithFormat:@"已向您绑定的手机号码%@发送短信验证码",mobile];
//                if (!isSendSMS) {
//                    _telServerLabel.text = tempText;
//                }
            }else{
                self.getCodeBtn.userInteractionEnabled = YES;
                NSString *messageStr = [dic objectSafeForKey:@"message"];
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert1 show];
            }
            
        }else{
            if([dic[@"ret"] intValue] == 1){
                
                [MBProgressHUD displayHudError:@"已发送，请等待接收，60秒后可再次获取。"];
                _getCodeBtn.userInteractionEnabled = NO;
                [_timer setFireDate:[NSDate distantPast]];
                [_getCodeBtn setBackgroundColor:UIColorWithRGB(0xd4d4d4)];
                NSString* str = [self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                _newMobileNumberStr = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                NSString *tempText = [NSString stringWithFormat:@"已向手机%@发送短信验证码，若收不到请点击这里获取语音验证码",_newMobileNumberStr];
                if (!isSendSMS) {
                    _telServerLabel.text = tempText;
                }
                __weak typeof(self) weakSelf = self;
                [_telServerLabel addLinkString:@"点击这里" block:^(ZBLinkLabelModel *linkModel) {
                    if (_counter > 0 && _counter < 60) {
                        [AuxiliaryFunc showToastMessage:weakSelf.getCodeBtn.titleLabel.text withView:weakSelf.view];
                        return;
                    } else {
                        isSendSMS  = YES;
                        [weakSelf getVerificationCodeNetworkRequest:NO isVmsType:@"VMS"];
                    }
                    
                }];
                [_telServerLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"点击这里"];
            }else{
                self.getCodeBtn.userInteractionEnabled = YES;
                NSString *messageStr = [dic objectSafeForKey:@"message"];
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert1 show];
            }
        }
        
    }else if(tag.intValue == kSXTagValidateOldPhoneNo){//校验注册手机号tag
        if ([dic[@"ret"] intValue] == 1) {
            [self initSencodeViewUI];
            _updatePhoneNoTicketStr = [[dic objectSafeDictionaryForKey:@"data"]  objectSafeForKey:@"updatePhoneNoTicket"];
        }else{
            NSString *messageStr = [dic objectSafeForKey:@"message"];
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
        }
    }else if(tag.intValue == kSXTagChangeReserveMobileNumber){//修改预留手机tag
        
        if ([dic[@"ret"] intValue] == 1) {
            [self performSelector:@selector(gotoTopUpVC) withObject:nil afterDelay:1];
            [MBProgressHUD displayHudError:@"修改成功"];
        }else{
            NSString *messageStr = [dic objectSafeForKey:@"message"];
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
        }
    }
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _getCodeBtn.userInteractionEnabled = YES;
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}

-(void)gotoTopUpVC{
    [self.delegate modifyReservedBankNumberSuccess:_newMobileNumberStr];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
//1.在UITextField的代理方法中实现手机号只能输入数字并满足我们的要求（首位只能是1，其他必须是0~9的纯数字）
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    
    if (range.location == 0){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest){
            //[self showMyMessage:@"只能输入数字"];
            return NO;
        }
    }
    else {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}

//3.实现formatPhoneNumber:方法以来让手机号实现344格式
- (void)formatPhoneNumber:(UITextField*)textField{
    //限制手机账号长度（有两个空格）
    if (textField.text.length > 13) {
        textField.text = [textField.text substringToIndex:13];
    }
    
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //正在执行删除操作时为0，否则为1
    char editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    } else {
        editFlag = 1;
    }
    
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 7 && currentStr.length > 2) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 6) {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
        }else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
        }else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
    }
    
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    if (currentStr.length < 4) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    }else if(currentStr.length > 3 && currentStr.length < 12) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    textField.text = tempStr;
    // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    
    if (editFlag == 0) {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
        //添加
        if (currentStr.length == 8 || currentStr.length == 4) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
}

@end
