//
//  UCFModifyPhoneViewController.m
//  JRGC
//
//  Created by NJW on 15/5/20.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFModifyPhoneViewController.h"
#import "SharedSingleton.h"
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "HWWeakTimer.h"
#import "UCFToolsMehod.h"

@interface UCFModifyPhoneViewController () <UITextFieldDelegate, UIAlertViewDelegate>{
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}

// 新绑定的手机号
@property (weak, nonatomic) IBOutlet UITextField *modifyPhoneTextField;
// 验证码
@property (weak, nonatomic) IBOutlet UITextField *validCodeTextField;
// 获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getValidCodeButton;
// 提示标签
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelHeight;

@property (weak, nonatomic) IBOutlet WPHotspotLabel *tipLabel;
@property (weak, nonatomic) WPHotspotLabel *voiceTipLabel;
// 提交
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
// 验证码有效时间
@property (nonatomic, assign) NSInteger validTime;
// 验证码计时器
@property (nonatomic, strong) NSTimer *validTimer;

@property (assign, nonatomic) BOOL isUsingVoiceCode;
@end

@implementation UCFModifyPhoneViewController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
//        self = [storyboard instantiateViewControllerWithIdentifier:@"modifyphone"];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

// 初始化界面
- (void)createUI
{
    [self addLeftButton];
    
    baseTitleLabel.text = @"修改绑定手机号";
    
    [self.getValidCodeButton setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [self.getValidCodeButton setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateDisabled];
    
    [self.submitButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    UIView *leftSpace1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.modifyPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.modifyPhoneTextField.leftView = leftSpace1;
    
    UIView *leftSpace2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.validCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.validCodeTextField.leftView = leftSpace2;
    
    self.modifyPhoneTextField.layer.cornerRadius = 4;
    self.modifyPhoneTextField.clipsToBounds = YES;
    self.modifyPhoneTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.modifyPhoneTextField.layer.borderWidth = 0.5;
    self.modifyPhoneTextField.delegate = self;
    [self.modifyPhoneTextField addTarget:self action:@selector(formatPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    
    self.validCodeTextField.layer.cornerRadius = 4;
    self.validCodeTextField.clipsToBounds = YES;
    self.validCodeTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.validCodeTextField.layer.borderWidth = 0.5;

    _validTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerfuc) userInfo:nil repeats:YES];
    [_validTimer setFireDate:[NSDate distantFuture]];
    _validTime = 60;
    
    [self.modifyPhoneTextField becomeFirstResponder];
    
    WPHotspotLabel *tipLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tipLabel.frame), CGRectGetMinY(self.tipLabel.frame)-5, ScreenWidth - XPOS*2, 23.5)];
//    tipLabel.backgroundColor = [UIColor blueColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    //_soundVerificationCodeLabel.textColor = UIColorWithRGB(0x999999);
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    self.voiceTipLabel = tipLabel;
    
    __weak typeof(self) weakSelf = self;
    NSDictionary* style = @{@"body":@[[UIFont systemFontOfSize:13.0], UIColorWithRGB(0x999999)],
                            @"help":@[UIColorWithRGB(0x4aa1f9),[WPAttributedStyleAction styledActionWithAction:^{
                                if (weakSelf.validTime>0 && weakSelf.validTime<60) {
                                    [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%ld秒后重新获取",(long)weakSelf.validTime] withView:self.view];
                                    return;
                                }
                                weakSelf.isUsingVoiceCode = YES;
//                                [weakSelf getSendMessageTicketFromNet];
                                [weakSelf getValidCode];
                            }]],
                            @"link": UIColorWithRGB(0x4aa1f9)};
    tipLabel.attributedText = [@"收不到短信？点击获取 <help>语音验证码</help>" attributedStringWithStyleBook:style];
    self.tipLabel.hidden = YES;
    self.voiceTipLabel.hidden = YES;
}

// 获取验证码
- (IBAction)getValidCode:(UIButton *)sender {
    [_validCodeTextField resignFirstResponder];
    [_modifyPhoneTextField resignFirstResponder];
    self.isUsingVoiceCode = NO;
    NSString* str = [self.modifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请输入新绑定手机号" withView:self.view];
        return;
    }
    else {
        if ([SharedSingleton checkPhoneNumber:str]) {
//            [self getSendMessageTicketFromNet];
            [self getValidCode];
        }
        else {

            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不正确" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
            alertview.tag = 100;
            [alertview show];
            return;
        }
    }
}

- (void)timerfuc
{
    [_getValidCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_validTime] forState:UIControlStateDisabled];
    _getValidCodeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _getValidCodeButton.backgroundColor = [UIColor lightGrayColor];
    _validTime--;
    if (_validTime == 0) {
        [_validTimer  setFireDate:[NSDate distantFuture]];
        _validTime = 60;
        [_getValidCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_validTime] forState:UIControlStateDisabled];
        _getValidCodeButton.enabled = YES;
        _getValidCodeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_getValidCodeButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _getValidCodeButton.backgroundColor = UIColorWithRGBA(111, 131, 159, 1);
        if (!self.tipLabel.hidden) {
            self.tipLabel.hidden =YES;
        }
        self.voiceTipLabel.hidden = NO;
    }
}

// 提交
- (IBAction)submit:(id)sender {
    NSString* str = [self.modifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length != 0) {
        if (![SharedSingleton checkPhoneNumber:str]) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不正确" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
            alertview.tag = 100;
            [alertview show];
            return;
        }
        if (self.validCodeTextField.text.length != 0) {
            [self submitNewPhoneForBindingWithTelePhone:str andValidCode:self.validCodeTextField.text];
        }
        else {
           [AuxiliaryFunc showToastMessage:@"请输入验证码" withView:self.view];
        }
    }
    else {
        [AuxiliaryFunc showToastMessage:@"请输入新绑定手机号" withView:self.view];
    }
}

//// 获取token
//- (void)getSendMessageTicketFromNet
//{
//    [[NetworkModule sharedNetworkModule] postReq:nil tag:kSXTagSendMessageforTicket owner:self];
//}

// 从服务端获取验证码
//- (void)getValidCodeWithTicket:(NSString *)ticket
- (void)getValidCode
{
    NSString* str = [self.modifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.isUsingVoiceCode) {
        NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
        //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
        NSDictionary *dic = @{@"isVms":@"VMS",@"type":@"4",@"userId":userId, @"destPhoneNo":str};
        [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagIdentifyCode owner:self signature:YES Type:SelectAccoutDefault];
        return;
    }
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
    NSDictionary *dic = @{@"isVms":@"SMS",@"type":@"4",@"userId":userId, @"destPhoneNo":str};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagIdentifyCode owner:self signature:YES Type:SelectAccoutDefault];
}

// 提交新绑定的手机号
- (void)submitNewPhoneForBindingWithTelePhone:(NSString *)telephone andValidCode:(NSString *)code
{
    NSString* str = [self.modifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSDictionary *dic = @{@"phoneNum": str, @"userId":userId, @"validateCode":self.validCodeTextField.text};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagUpdateMobile owner:self signature:YES Type:SelectAccoutDefault];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    [_validCodeTextField resignFirstResponder];
    [_modifyPhoneTextField resignFirstResponder];
//    if (self.settingBaseBgView.hidden) {
//        self.settingBaseBgView.hidden = NO;
//    }
//    [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
}

- (void) performDismiss:(NSTimer *)timer
{
    UIAlertView *alert = [timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
//    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
//    self.settingBaseBgView.hidden = YES;
    
    NSString *data = (NSString *)result;
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    [_validCodeTextField resignFirstResponder];
    [_modifyPhoneTextField resignFirstResponder];
    
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
//    if (tag.intValue == kSXTagSendMessageforTicket) {
//        [self getValidCodeWithTicket:dic[@"sendmessageticket"]];
//    }
    if (tag.intValue == kSXTagIdentifyCode) {
        bool ret = [dic[@"ret"] boolValue];
        if (ret) {
            DBLOG(@"%@",dic[@"data"]);
//            [_getValidCodeButton setTitle:@"60秒后重新获取" forState:UIControlStateDisabled];
            _getValidCodeButton.enabled = NO;
            
//            [_getValidCodeButton setTitleColor:UIColorWithRGB(0xcccccc) forState:UIControlStateNormal];
            _validTimer = [HWWeakTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(timerfuc) userInfo:nil repeats:YES];
            _tipLabel.text = [NSString stringWithFormat:@"已向手机%@发送短信验证码。",self.modifyPhoneTextField.text];
            if (self.isUsingVoiceCode) {
                self.voiceTipLabel.hidden = YES;
            }
            else {
                self.voiceTipLabel.hidden = YES;
            }
            _tipLabel.hidden = NO;
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
        
//        if (rstcode.intValue == 1) {
//            self.getValidCodeButton.enabled = NO;
//            [_validTimer setFireDate:[NSDate distantPast]];
//            [MBProgressHUD displayHudError:rsttext];
////            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//            self.tipLabel.hidden = !self.voiceTipLabel.hidden;
//            self.tipLabel.text = [NSString stringWithFormat:@"已向您输入的手机号码 %@ 发送短信验证码", self.modifyPhoneTextField.text];
//        }
//        else {
//            if (!self.tipLabel.hidden) {
//                self.tipLabel.hidden = YES;
//            }
//            self.voiceTipLabel.hidden = NO;
//            if (rstcode.intValue == 6) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:rsttext delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服", nil];
//                alertView.tag = 200;
//                [alertView show];
//                
//            }
//            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//        }
    }
    if (tag.intValue == kSXTagUpdateMobile) {
        bool ret = [dic[@"ret"] boolValue];
        rsttext = [dic objectSafeForKey:@"message"];
        if (ret) {
            NSString* str = [self.modifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"lastLoginName"];
            NSString *mobile  = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSelector:@selector(backLastView) withObject:nil afterDelay:1];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
//        if (rstcode.intValue == 7) {
//            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
//            [[NSUserDefaults standardUserDefaults] setObject:self.modifyPhoneTextField.text forKey:@"lastLoginName"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self performSelector:@selector(backLastView) withObject:nil afterDelay:1];
//        }
//        else {
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
//            alertview.tag = [rstcode integerValue];
//            [alertview show];
//        }
    }
}
// 返回上个界面
- (void)backLastView
{
    if (self.rootVc) {
        [self.navigationController popToViewController:self.rootVc animated:YES];
    }
    else [self.navigationController popViewControllerAnimated:YES];
}

// 警告框的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 3:
            [self.modifyPhoneTextField becomeFirstResponder];
            break;
            
        case 4:
        case 5: {
            self.modifyPhoneTextField.text = @"";
            [self.modifyPhoneTextField becomeFirstResponder];
        }
            break;
            
        case 7: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
            [self performSelector:@selector(backToRoot:) withObject:self.rootVc afterDelay:0.5];
        }
            break;
        case 100: {
            self.modifyPhoneTextField.text = @"";
            self.validCodeTextField.text = @"";
            [self.modifyPhoneTextField becomeFirstResponder];
        }
            break;
        case 200: {
            if (buttonIndex == 1) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4000322988"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }
            break;
    }
}

// 返回根视图
- (void)backToRoot:(id)obj
{
    [self.navigationController popToViewController:obj animated:YES];
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
//    if (tag.intValue == kSXTagSendMessageforTicket || tag.intValue == kSXTagSendMessage || tag.intValue == kSXTagUpdateMobile) {
//        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
//    }
    if (tag.intValue == kSXTagIdentifyCode || tag.intValue == kSXTagUpdateMobile) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
//    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
//    self.settingBaseBgView.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextField
//1.在UITextField的代理方法中实现手机号只能输入数字并满足我们的要求（首位只能是1，其他必须是0~9的纯数字）
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _modifyPhoneTextField) {
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
    }
    
    if (textField == self.validCodeTextField) {
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
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
    if (editFlag) {
        UITextRange *range = textField.selectedTextRange;
        UITextPosition* start = [textField positionFromPosition:range.start inDirection:UITextLayoutDirectionRight offset:textField.text.length];
        if (start)
        {
            [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:start]];
        }
        
    }
    else {
        UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
        [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
    }
}

@end
