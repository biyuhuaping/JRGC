//
//  UCFRetrievePasswordStepTwoView.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRetrievePasswordStepTwoView.h"
#import "UITextFieldFactory.h"
#import "UILabel+Misc.h"
#import "AuxiliaryFunc.h"
#import "BaseAlertView.h"
#import "Common.h"
#import "SharedSingleton.h"
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"

@interface UCFRetrievePasswordStepTwoView ()
{
    UITextField *_verificationCodeField;
    UIButton *_verificationCodeBtn;
    UITextField *_passwordField;
    UIButton *_submitBtn;
    NSString *_phoneNumber;
    int _timeNum;
    BOOL _isSecureTextEntry;
    UIImageView *pwdIconView2;
    UIButton *_concactUsBtn;
    
    WPHotspotLabel *_soundVerificationCodeLabel;//语音验证码label
    UILabel *label2;
}

@end

@implementation UCFRetrievePasswordStepTwoView

- (id)initWithFrame:(CGRect)frame phoneNumber:(NSString*)phoneNum
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        _phoneNumber = phoneNum;
        [self initStepTwoView];
    }
    return self;
}

- (NSString*)getVerficationCode
{
    return _verificationCodeField.text;
}

- (NSString*)getPassword
{
    return _passwordField.text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)setVerifiFieldFirstReponder
{
    [_verificationCodeField becomeFirstResponder];
}

- (void)initStepTwoView
{
    _verificationCodeField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, YPOS, (ScreenWidth - XPOS*2)*3/5, TEXTFIELDHEIGHT) delegate:nil placeholder:@"请输入验证码" returnKeyType:UIReturnKeyDefault];
    _verificationCodeField.backgroundColor = [UIColor whiteColor];
    _verificationCodeField.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _verificationCodeField.layer.borderWidth = 0.5;
    _verificationCodeField.layer.cornerRadius = 4.0f;
    _verificationCodeField.layer.masksToBounds = YES;
    _verificationCodeField.font = [UIFont systemFontOfSize:15];
    _verificationCodeField.leftViewMode = UITextFieldViewModeAlways;
    _verificationCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCodeField.tag = 0x101;
    _verificationCodeField.delegate = self;
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 37)];
    _verificationCodeField.leftView = viewBg;
    [self addSubview:_verificationCodeField];
    
    _verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verificationCodeBtn.frame = CGRectMake(CGRectGetMaxX(_verificationCodeField.frame) + 10, YPOS + 1, (ScreenWidth - XPOS*2)*2/5 - 10, TEXTFIELDHEIGHT - 2);
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
//    UILabel *label1 = [UILabel labelWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + SPACING, ScreenWidth - XPOS*2, 20) text:[NSString stringWithFormat:@"已向您输入的手机号码 %@ 发送短信验证码",nowNumber] textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:11]];
//    label1.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:label1];
    
//    _soundVerificationCodeLabel = [UILabel labelWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + 5, ScreenWidth - XPOS*2, 0) text:nil textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:13]];
//    _soundVerificationCodeLabel.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:_soundVerificationCodeLabel];
    
    _soundVerificationCodeLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + 5, ScreenWidth - XPOS*2, 0)];
    _soundVerificationCodeLabel.textAlignment = NSTextAlignmentLeft;
    _soundVerificationCodeLabel.numberOfLines = 0;
    [self addSubview:_soundVerificationCodeLabel];
    
    
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
//    [tapGes addTarget:self action:@selector(soudLabelClick:)];
//    [_soundVerificationCodeLabel addGestureRecognizer:tapGes];
//    _soundVerificationCodeLabel.userInteractionEnabled = YES;
    
    _passwordField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_soundVerificationCodeLabel.frame) + SPACING, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:self placeholder:@"请输入密码" returnKeyType:UIReturnKeyDefault];
    _passwordField.backgroundColor = [UIColor whiteColor];
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
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    _passwordField.tag = 0x102;
    [self addSubview:_passwordField];
    
    pwdIconView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_btn_visible.png"]];
    UIView *iconBg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 37)];
    pwdIconView2.frame = CGRectMake(0, 6, 25, 25);
    [iconBg2 addSubview:pwdIconView2];
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
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(_passwordField.frame) + 25, ScreenWidth - XPOS*2, BTNHEIGHT);
    _submitBtn.backgroundColor = UIColorWithRGB(0xf03b43);
    [_submitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.cornerRadius = 2.0f;
    _submitBtn.layer.masksToBounds = YES;
    [self addSubview:_submitBtn ];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_submitBtn.frame) + 10, ScreenWidth - XPOS*2, 18)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = UIColorWithRGB(0x999999);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor clearColor];
    [self addSubview:label2];
    
    NSString *strTitle = @"找回密码遇到问题，请联系客服400-0322-988";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTitle];
    NSRange rang = [strTitle rangeOfString:@"400-0322-988"];
    [str setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:UIColorWithRGB(0x4aa1f9)} range:rang];
    NSRange rang2 = [strTitle rangeOfString:@"找回密码遇到问题，请联系客服"];
    [str setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:UIColorWithRGB(0x999999)} range:rang2];
    label2.attributedText = str;
    
    _concactUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _concactUsBtn.frame = CGRectMake(0, 0, ScreenWidth - XPOS*2, 18);
    _concactUsBtn.backgroundColor = [UIColor clearColor];
    [_concactUsBtn addTarget:self action:@selector(concactUs:) forControlEvents:UIControlEventTouchUpInside];
    [label2 addSubview:_concactUsBtn];
    label2.userInteractionEnabled = YES;
    
    [self resetAllControlFrame];
    [self showVatiLabelText];
}

- (void)setVatiLabelHide:(BOOL)isHide
{
    [_soundVerificationCodeLabel setHidden:isHide];
}

- (void)soudLabelClick:(UITapGestureRecognizer*)tap
{
    [_delegate soudLabelClick:tap nowTime:_timeNum];
}

- (void)viewPassBtnClick:(id)sender
{
    _isSecureTextEntry = !_isSecureTextEntry;
    _passwordField.secureTextEntry = _isSecureTextEntry;
    if (!_isSecureTextEntry) {
        pwdIconView2.image = [UIImage imageNamed:@"login_btn_invisible.png"];
    } else {
        pwdIconView2.image = [UIImage imageNamed:@"login_btn_visible.png"];
    }
}

- (void)codeBtnClicked:(id)sender
{
    [_delegate codeBtnClicked:sender];
}

- (void)verificatioCodeSend
{
    _timeNum = 60;
    [_verificationCodeBtn setUserInteractionEnabled:NO];
    _verificationCodeBtn.backgroundColor = UIColorWithRGB(0xd4d4d4);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfuc) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)showVatiLabelText
{
//    NSMutableAttributedString *str = [SharedSingleton getAcolorfulStringWithText1:[NSString stringWithFormat:@"%@",@"若长时间未收到短信验证码，倒数时间结束后可选择 语音验证码 获取"] Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", @" 语音验证码 "] Color2:UIColorWithRGB(0x4aa1f9) AllText:[NSString stringWithFormat:@"%@",@"若长时间未收到短信验证码，倒数时间结束后可选择 语音验证码 获取"]];
//    _soundVerificationCodeLabel.attributedText = str;
    
    NSDictionary* style = @{@"body":@[[UIFont systemFontOfSize:13.0], UIColorWithRGB(0x999999)],
                            @"help":@[UIColorWithRGB(0x4aa1f9),[WPAttributedStyleAction styledActionWithAction:^{
                                [_delegate soudLabelClick:nil nowTime:_timeNum];
                            }]],
                            @"link": UIColorWithRGB(0x4aa1f9)};
    _soundVerificationCodeLabel.attributedText = [@"收不到短信？点击获取 <help>语音验证码</help>" attributedStringWithStyleBook:style];
}

- (void)resetAllControlFrame
{
    _soundVerificationCodeLabel.frame = CGRectMake(XPOS, CGRectGetMaxY(_verificationCodeBtn.frame) + 5, ScreenWidth - XPOS*2, 20);
    _passwordField.frame = CGRectMake(XPOS, CGRectGetMaxY(_soundVerificationCodeLabel.frame) + SPACING, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT);
    _submitBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(_passwordField.frame) + 25, ScreenWidth - XPOS*2, BTNHEIGHT);
    label2.frame = CGRectMake(XPOS, CGRectGetMaxY(_submitBtn.frame) + 10, ScreenWidth - XPOS*2, 18);
}

- (void)timerfuc
{
    _timeNum --;
    if (_timeNum == 0) {
        [_timer invalidate];
        _soundVerificationCodeLabel.hidden = NO;
        //[self showVatiLabelText];
        //[self resetAllControlFrame];
        [_verificationCodeBtn setUserInteractionEnabled:YES];
        _verificationCodeBtn.backgroundColor = UIColorWithRGB(0x8296af);
        [_verificationCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
    } else {
        [_verificationCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",_timeNum] forState:UIControlStateNormal];
    }
}


- (void)submitBtnClicked:(id)sender
{
    if ([_verificationCodeField.text isEqualToString:@""] || _verificationCodeField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入验证码"];
        [_verificationCodeField becomeFirstResponder];
        return;
    }
    if ([_passwordField.text isEqualToString:@""] || _passwordField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入密码"];
        [_passwordField becomeFirstResponder];
        return;
    }
//    if (![SharedSingleton isValidatePassWord:_passwordField.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:@"6-16位字符，只能包含字母、数字及标点符号（必须组合），区分大小写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    [self endEditing:YES];
    [_delegate submitBtnClicked:sender];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField.tag == 0x102) {
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    } else if (textField.tag == 0x101) {
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 0x102) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0,-50,self.frame.size.width, self.frame.size.height);
            }];
        }
    } else if (textField.tag == 0x101) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"]) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0,-20,self.frame.size.width, self.frame.size.height);
            }];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0x102) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"] || [machineName isEqualToString:@"5"]) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0,0,self.frame.size.width, self.frame.size.height);
            }];
        }
    } else if (textField.tag == 0x101) {
        NSString *machineName = [Common machineName];
        if ([machineName isEqualToString:@"4"]) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake (0,0,self.frame.size.width, self.frame.size.height);
            }];
        }
    }
}

- (void)concactUs:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-0322-988"]];
    //[_delegate concactUs:sender];
}

@end
