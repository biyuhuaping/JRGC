//
//  UCFRegisterTwoView.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRegisterTwoView.h"
#import "UITextFieldFactory.h"
#import "UILabel+Misc.h"
#import "Common.h"
#import "SharedSingleton.h"
#import "AuxiliaryFunc.h"
#import "BaseAlertView.h"
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"

@interface UCFRegisterTwoView ()
{
    UITextField *_verificationCodeField;//验证码
    UITextField *_passwordField;//密码
    UITextField *_ucfCodeField;//用户名
    UITextField *_refereesCodeField;//推荐人工场码
    UIButton *_verificationCodeBtn;//获取验证码按钮
    UIButton *_submitBtn;//提交按钮
    UILabel *label3;
    UIView *lineView;
    NSString *_phoneNumber;
    UIImageView *_pwdIconView2;
    BOOL _isSecureTextEntry;
    
    WPHotspotLabel *_soundVerificationCodeLabel;//语音验证码label
}

@end

@implementation UCFRegisterTwoView

- (id)initWithFrame:(CGRect)frame phoneNumber:(NSString *)number
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        _phoneNumber = number;
        _isSecureTextEntry = YES;
        [self initRegisterTwoView];
    }
    return self;
}

- (void)setVatifacationBtnVisible:(BOOL)isVisible
{
    if (!isVisible) {
        [_verificationCodeBtn setUserInteractionEnabled:NO];
        _verificationCodeBtn.backgroundColor = UIColorWithRGB(0xd4d4d4);
    } else {
        [_verificationCodeBtn setUserInteractionEnabled:YES];
        _verificationCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);
    }
}

- (void)setVatifacationTitle:(NSString*)str
{
    [_verificationCodeBtn setTitle:str forState:UIControlStateNormal];
}

- (NSString*)getVerficationCode
{
    return _verificationCodeField.text;
}

- (NSString*)getUserName
{
    return _ucfCodeField.text;
}

- (NSString*)getPassword
{
    return _passwordField.text;
}

- (NSString*)getRefereesCode
{
    return _refereesCodeField.text;
}

- (void)setVerifiFieldFirstReponder
{
    [_verificationCodeField becomeFirstResponder];
}

- (void)initRegisterTwoView
{
    _verificationCodeField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, YPOS, (ScreenWidth - XPOS*2) - 107 - 10, TEXTFIELDHEIGHT) delegate:nil placeholder:@"请输入验证码" returnKeyType:UIReturnKeyDefault];
    _verificationCodeField.backgroundColor = [UIColor whiteColor];
    _verificationCodeField.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _verificationCodeField.layer.borderWidth = 0.5;
    _verificationCodeField.layer.cornerRadius = 4.0f;
    _verificationCodeField.layer.masksToBounds = YES;
    _verificationCodeField.font = [UIFont systemFontOfSize:15];
    _verificationCodeField.leftViewMode = UITextFieldViewModeAlways;
    _verificationCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCodeField.delegate = self;
    _verificationCodeField.tag = 10002;
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 37)];
    _verificationCodeField.leftView = viewBg;
    [self addSubview:_verificationCodeField];
    
    _verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verificationCodeBtn.frame = CGRectMake(CGRectGetMaxX(_verificationCodeField.frame) + 10, YPOS, 107, BTNHEIGHT);
    _verificationCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);
    [_verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verificationCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_verificationCodeBtn addTarget:self action:@selector(codeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _verificationCodeBtn.layer.cornerRadius = 2.0f;
    _verificationCodeBtn.layer.masksToBounds = YES;
    [self addSubview:_verificationCodeBtn ];
    
    //NSString *nowNumber = [_phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    //NSString *text1 = [NSString stringWithFormat:@"已向您输入的手机号码 %@ 发送短信验证码",nowNumber];
//    UILabel *label1 = [UILabel labelWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + 5, ScreenWidth - XPOS*2, 20) text:[NSString stringWithFormat:@"已向您输入的手机号码 %@ 发送短信验证码",nowNumber] textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:11]];
//    label1.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:label1];
    
//    _soundVerificationCodeLabel = [UILabel labelWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + 5, ScreenWidth - XPOS*2, 0) text:nil textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:13]];
    
    _soundVerificationCodeLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + 5, ScreenWidth - XPOS*2, 0)];
    _soundVerificationCodeLabel.textAlignment = NSTextAlignmentLeft;
    //_soundVerificationCodeLabel.textColor = UIColorWithRGB(0x999999);
    _soundVerificationCodeLabel.numberOfLines = 0;
    [self addSubview:_soundVerificationCodeLabel];
    
    //[_soundVerificationCodeLabel setHidden:YES];
    
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
//    [tapGes addTarget:self action:@selector(soudLabelClick:)];
//    [_soundVerificationCodeLabel addGestureRecognizer:tapGes];
//    _soundVerificationCodeLabel.userInteractionEnabled = YES;
    
//    _ucfCodeField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_soundVerificationCodeLabel.frame) + SPACING, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:nil placeholder:@"请输入用户名" returnKeyType:UIReturnKeyDefault];
//    _ucfCodeField.backgroundColor = [UIColor whiteColor];
//    _ucfCodeField.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
//    _ucfCodeField.layer.borderWidth = 0.5;
//    _ucfCodeField.layer.cornerRadius = 4.0f;
//    _ucfCodeField.layer.masksToBounds = YES;
//    _ucfCodeField.font = [UIFont systemFontOfSize:15];
//    UIImageView *userIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_name.png"]];
//    UIView *iconBg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
//    userIconView.frame = CGRectMake(9, 8, 20, 20);
//    [iconBg1 addSubview:userIconView];
//    _ucfCodeField.leftView = iconBg1;
//    _ucfCodeField.tag = 10003;
//    _ucfCodeField.delegate = self;
//    _ucfCodeField.leftViewMode = UITextFieldViewModeAlways;
//    [self addSubview:_ucfCodeField];
    
    _passwordField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_soundVerificationCodeLabel.frame) + SPACING, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:self placeholder:@"6位－16位密码，数字、字母组合" returnKeyType:UIReturnKeyDefault];
    _passwordField.backgroundColor = [UIColor whiteColor];
    _passwordField.tag = 10001;
    _passwordField.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _passwordField.layer.borderWidth = 0.5;
    _passwordField.layer.cornerRadius = 4.0f;
    _passwordField.layer.masksToBounds = YES;
    _passwordField.font = [UIFont systemFontOfSize:15];
    UIImageView *pwdIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password.png"]];
    UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
    pwdIconView.frame = CGRectMake(9, 8, 20, 20);
    [iconBg addSubview:pwdIconView];
    _passwordField.leftView = iconBg;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    _pwdIconView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_btn_visible.png"]];
    UIView *iconBg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 37)];
    _pwdIconView2.frame = CGRectMake(0, 6, 25, 25);
    [iconBg2 addSubview:_pwdIconView2];
    _passwordField.rightView = iconBg2;
    _passwordField.rightViewMode = UITextFieldViewModeAlways;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    [self addSubview:_passwordField];
    
    UIButton *viewPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewPassBtn addTarget:self action:@selector(viewPassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    viewPassBtn.frame = CGRectMake(0, 0, 37, 37);
    [iconBg2 addSubview:viewPassBtn];
    iconBg2.userInteractionEnabled = YES;
  //2.3.0版本取消
//    lineView = [[UIView alloc] initWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_passwordField.frame) + SPACING, ScreenWidth - XPOS*2, 1)];
//    [lineView setBackgroundColor:UIColorWithRGB(0xd8d8d8)];
//    [self addSubview:lineView];
    
    _refereesCodeField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_passwordField.frame) + 10, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:self placeholder:@"请输入推荐人工场码" returnKeyType:UIReturnKeyDefault];
    _refereesCodeField.backgroundColor = [UIColor whiteColor];
    _refereesCodeField.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _refereesCodeField.layer.borderWidth = 0.5;
    _refereesCodeField.layer.cornerRadius = 4.0f;
    _refereesCodeField.layer.masksToBounds = YES;
    _refereesCodeField.font = [UIFont systemFontOfSize:16];
    _refereesCodeField.tag = 10009;
    UIImageView *_refereesIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_Id.png"]];
    UIView *iconBg3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
    _refereesIconView.frame = CGRectMake(9, 8, 20, 20);
    [iconBg3 addSubview:_refereesIconView];
    _refereesCodeField.leftView = iconBg3;
    _refereesCodeField.leftViewMode = UITextFieldViewModeAlways;
    _refereesCodeField.delegate = self;
    [self addSubview:_refereesCodeField];
    
    label3 = [UILabel labelWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_refereesCodeField.frame) + 5, ScreenWidth - XPOS*2, 11) text:[NSString stringWithFormat:@"输入推荐人工场码，将获得更多返利（没有推荐人可不填）"] textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:11]];
    label3.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label3];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(label3.frame) + 25, ScreenWidth - XPOS*2, BTNHEIGHT);
    _submitBtn.backgroundColor = UIColorWithRGB(0xf03b43);
    [_submitBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.cornerRadius = 2.0f;
    _submitBtn.layer.masksToBounds = YES;
    [self addSubview:_submitBtn ];
    
    [self resetAllControlFrame];
    [self showVatiLabelText];
}

- (void)setVatiLabelHide:(BOOL)isHide
{
    [_soundVerificationCodeLabel setHidden:isHide];
}

- (void)showVatiLabelText
{
    NSDictionary* style = @{@"body":@[[UIFont systemFontOfSize:13.0], UIColorWithRGB(0x999999)],
                             @"help":@[UIColorWithRGB(0x4aa1f9),[WPAttributedStyleAction styledActionWithAction:^{
                                 [_delegate soudLabelClick:nil];
                             }]],
                             @"link": UIColorWithRGB(0x4aa1f9)};
    _soundVerificationCodeLabel.attributedText = [@"收不到短信？点击获取 <help>语音验证码</help>" attributedStringWithStyleBook:style];
//    NSMutableAttributedString *str = [SharedSingleton getAcolorfulStringWithText1:[NSString stringWithFormat:@"%@",@"若长时间未收到短信验证码，倒数时间结束后可选择 语音验证码 获取"] Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", @" 语音验证码 "] Color2:UIColorWithRGB(0x4aa1f9) AllText:[NSString stringWithFormat:@"%@",@"若长时间未收到短信验证码，倒数时间结束后可选择<help>语音验证码<help>获取"]];
//    _soundVerificationCodeLabel.attributedText = str;
}

- (void)resetAllControlFrame
{
    _soundVerificationCodeLabel.frame = CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + 5, ScreenWidth - XPOS*2, 20);
    _passwordField.frame = CGRectMake(XPOS, CGRectGetMaxY(_soundVerificationCodeLabel.frame) + SPACING, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT);
//    lineView.frame = CGRectMake(XPOS, CGRectGetMaxY(_passwordField.frame) + SPACING, ScreenWidth - XPOS*2, 1);
    _refereesCodeField.frame = CGRectMake(XPOS, CGRectGetMaxY(_passwordField.frame) + 10, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT);
    label3.frame = CGRectMake(XPOS, CGRectGetMaxY(_refereesCodeField.frame) + 5, ScreenWidth - XPOS*2, 11);
    _submitBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(label3.frame) + 25, ScreenWidth - XPOS*2, BTNHEIGHT);
}

- (void)soudLabelClick:(UITapGestureRecognizer*)tap
{
    [_delegate soudLabelClick:tap];
}

- (void)codeBtnClicked:(id)sender
{
    [_delegate codeBtnClicked:sender];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)submitBtnClicked:(id)sender
{
    if ([_verificationCodeField.text isEqualToString:@""] || _verificationCodeField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入验证码"];
        [_verificationCodeField becomeFirstResponder];
        return;
    }
//    if ([_ucfCodeField.text isEqualToString:@""] || _ucfCodeField.text == nil) {
//        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入用户名"];
//        [_ucfCodeField becomeFirstResponder];
//        return;
//    }
    if ([_passwordField.text isEqualToString:@""] || _passwordField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入密码"];
        [_passwordField becomeFirstResponder];
        return;
    }
    
    if (![SharedSingleton isValidatePassWord:_passwordField.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:@"6-16位字符，只能包含字母、数字及标点符号（必须组合），区分大小写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self endEditing:YES];
    [_delegate submitBtnClicked:sender];
}

- (void)viewPassBtnClick:(id)sender
{
    _isSecureTextEntry = !_isSecureTextEntry;
    _passwordField.secureTextEntry = _isSecureTextEntry;
    if (!_isSecureTextEntry) {
        _pwdIconView2.image = [UIImage imageNamed:@"login_btn_invisible.png"];
    } else {
        _pwdIconView2.image = [UIImage imageNamed:@"login_btn_visible.png"];
    }
}

#pragma mark -textfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField.tag == 10001 || textField.tag == 10003) {
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    } else if (textField.tag == 10002) {
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 10001 || textField.tag == 10009) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0,-100,self.frame.size.width, self.frame.size.height);
            }];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10001 || textField.tag == 10009) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0,0,self.frame.size.width, self.frame.size.height);
            }];
        }
    }
}
@end
