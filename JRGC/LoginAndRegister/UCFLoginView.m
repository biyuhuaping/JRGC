//
//  UCFLoginView.m
//  JRGC
//
//  Created by HeJing on 15/3/31.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//


#import "UCFLoginView.h"
#import "UITextFieldFactory.h"
#import "UIButton+Misc.h"
#import "AuxiliaryFunc.h"
#import "BaseAlertView.h"

@interface UCFLoginView ()
{
    UITextField *_userNameTfd;//用户名
    UITextField *_passWordTfd;//密码
    UIButton *_loginBtn;//登录按钮
    UIButton *_forgetPasswordBtn;//忘记密码
    UIButton *_registerBtn;//注册
}

@end

@implementation UCFLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        [self initLoginViews];
    }
    return self;
}

- (void)setUserNameFieldText:(NSString*)text
{
    _userNameTfd.text = text;
}
- (void)setPasswordFieldText:(NSString*)text
{
     _passWordTfd.text = text;
}

- (NSString*)userNameFieldText
{
    return _userNameTfd.text;
}

- (NSString*)passwordFieldText
{
    return _passWordTfd.text;
}

//初始化登录页
- (void)initLoginViews
{
    _userNameTfd = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, YPOS, ScreenWidth - 30, TEXTFIELDHEIGHT) delegate:self placeholder:@"用户名/邮箱/手机号" returnKeyType:UIReturnKeyDefault];
    
    _userNameTfd.backgroundColor = [UIColor whiteColor];
    _userNameTfd.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _userNameTfd.layer.borderWidth = 0.5;
    _userNameTfd.layer.cornerRadius = 4.0f;
    _userNameTfd.layer.masksToBounds = YES;;
    _userNameTfd.font = [UIFont systemFontOfSize:15];
    UIImageView *userIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_name.png"]];
    UIView *iconBg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
    userIconView.frame = CGRectMake(9, 8, 20, 20);
    [iconBg1 addSubview:userIconView];
    _userNameTfd.leftView = iconBg1;
    _userNameTfd.leftViewMode = UITextFieldViewModeAlways;
//    _userNameTfd.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [self addSubview:_userNameTfd];
    
    _passWordTfd = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_userNameTfd.frame) + 15, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:self placeholder:@"登录密码" returnKeyType:UIReturnKeyDefault];
    _passWordTfd.backgroundColor = [UIColor whiteColor];
    _passWordTfd.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _passWordTfd.layer.borderWidth = 0.5;
    _passWordTfd.layer.cornerRadius = 4.0f;
    _passWordTfd.layer.masksToBounds = YES;
    _passWordTfd.font = [UIFont systemFontOfSize:15];
    UIImageView *pwdIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password.png"]];
    UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
    pwdIconView.frame = CGRectMake(9, 8, 20, 20);
    [iconBg addSubview:pwdIconView];
    _passWordTfd.leftView = iconBg;
    _passWordTfd.leftViewMode = UITextFieldViewModeAlways;
    _passWordTfd.secureTextEntry = YES;
    _passWordTfd.delegate = self;
    _passWordTfd.keyboardType = UIKeyboardTypeAlphabet;
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.frame = CGRectMake(0, 0, 40, 30);
    [scanBtn setImage:[UIImage imageNamed:@"login_btn_visible.png"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    scanBtn.contentMode = UIViewContentModeCenter;
    _passWordTfd.rightViewMode = UITextFieldViewModeAlways;
    _passWordTfd.rightView = scanBtn;
    [self addSubview:_passWordTfd];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(_passWordTfd.frame) + 15, ScreenWidth - XPOS*2, BTNHEIGHT);
    _loginBtn.backgroundColor = UIColorWithRGB(0xf03b43);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.cornerRadius = 2.0f;
    _loginBtn.layer.masksToBounds = YES;
    [self addSubview:_loginBtn];
    
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - XPOS - 200, CGRectGetMaxY(_loginBtn.frame) + 8, 200, 18)];
    describeLabel.font = [UIFont systemFontOfSize:15];
    describeLabel.textColor = UIColorWithRGB(0x999999);
    describeLabel.textAlignment = NSTextAlignmentRight;
    describeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:describeLabel];
    
    UILabel *forgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_loginBtn.frame) + 8, 200, 18)];
    forgetLabel.font = [UIFont systemFontOfSize:13];
    forgetLabel.textColor = UIColorWithRGB(0x999999);
    forgetLabel.textAlignment = NSTextAlignmentLeft;
    forgetLabel.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *btnTitle = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange = {0,[btnTitle length]};
    [btnTitle setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:UIColorWithRGB(0x4aa1f9)} range:strRange];
    forgetLabel.attributedText = btnTitle;
    [self addSubview:forgetLabel];
    
    NSString *strTitle = @"没有账号？立即注册";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTitle];
    NSRange rang = [strTitle rangeOfString:@"立即注册"];
    NSRange rang2 = [strTitle rangeOfString:@"没有账号？"];
    [str setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:UIColorWithRGB(0x4aa1f9)} range:rang];
    [str setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:UIColorWithRGB(0x999999)} range:rang2];
    describeLabel.attributedText = str;
    
    _forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPasswordBtn.frame = CGRectMake(0, 0, 100, 18);
    _forgetPasswordBtn.backgroundColor = [UIColor clearColor];
    [_forgetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [forgetLabel addSubview:_forgetPasswordBtn];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.frame = CGRectMake(0, 0, 200, 18);
    _registerBtn.backgroundColor = [UIColor clearColor];
    [_registerBtn addTarget:self action:@selector(regisiterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [describeLabel addSubview:_registerBtn];
    
    forgetLabel.userInteractionEnabled = YES;
    describeLabel.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 197, 23);
    button.center = CGPointMake(ScreenWidth/2, ScreenHeight- NavigationBarHeight - 25 - 23/2);
    [button setBackgroundImage:[UIImage imageNamed:@"sign_down"] forState:UIControlStateNormal];
    [button setTitle:@"金融工场专业互联网金融机构" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.userInteractionEnabled = NO;
    [self addSubview:button];
}

- (void)setFirstResponder
{
    [_userNameTfd becomeFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)userLogin:(id)sender
{
    [self endEditing:YES];
    if ([_userNameTfd.text isEqualToString:@""] || _userNameTfd.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入用户名"];
        [_userNameTfd becomeFirstResponder];
        return;
    }
    if ([_passWordTfd.text isEqualToString:@""] || _userNameTfd.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入密码"];
        [_passWordTfd becomeFirstResponder];
        return;
    }
    [_delegate userLogin:sender];
}

- (void)resetPassword:(id)sender
{
    [_delegate resetPassword:sender];
}

- (void)regisiterBtn:(id)sender
{
    [_delegate regisiterBtn:sender];
}

- (void)scanBtnClicked:(UIButton *)sender{
    NSString *tempStr = _passWordTfd.text;
    _passWordTfd.secureTextEntry = !_passWordTfd.secureTextEntry;
    _passWordTfd.text = @"";
    _passWordTfd.text = tempStr;
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.frame = CGRectMake(0, 0, 40, 30);
    if (_passWordTfd.secureTextEntry) {
        [scanBtn setImage:[UIImage imageNamed:@"login_btn_visible.png"] forState:UIControlStateNormal];
    }else{
        [scanBtn setImage:[UIImage imageNamed:@"login_btn_invisible.png"] forState:UIControlStateNormal];
    }
    
    [scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    scanBtn.contentMode = UIViewContentModeCenter;
    _passWordTfd.rightViewMode = UITextFieldViewModeAlways;
    _passWordTfd.rightView = scanBtn;
}

@end
