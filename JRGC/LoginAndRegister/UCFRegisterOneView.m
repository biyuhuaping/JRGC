//
//  UCFRegisterOneView.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRegisterOneView.h"
#import "UITextFieldFactory.h"
#import "SharedSingleton.h"
#import "AuxiliaryFunc.h"
#import "UILabel+Misc.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+NetImageView.h"
@interface UCFRegisterOneView ()
{
    UIImageView *_headImageView;//手机号上面的图片
    UITextField *_userPhoneNumField;//手机号输入框
    UIButton *_readBtn;
    UIButton *_nextStepBtn;
}

@end

@implementation UCFRegisterOneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        [self initRegisterView];
    }
    return self;
}

- (NSString*)phoneNumberText
{
    return _userPhoneNumField.text;
}

- (void)setFirstResponder
{
    [_userPhoneNumField becomeFirstResponder];
}

//初始化
- (void)initRegisterView
{
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    _headImageView.image = [UIImage imageNamed:@"banner_default"];
    _headImageView.contentMode = UIViewContentModeScaleToFill;
    [_headImageView getBannerImageStyle:UserRegistration];
    [self addSubview:_headImageView];
    
    _userPhoneNumField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_headImageView.frame) + 15, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:self placeholder:@"请输入手机号" returnKeyType:UIReturnKeyDefault];
    _userPhoneNumField.backgroundColor = [UIColor whiteColor];
    _userPhoneNumField.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _userPhoneNumField.layer.borderWidth = 0.5;
    _userPhoneNumField.layer.cornerRadius = 4.0f;
    _userPhoneNumField.layer.masksToBounds = YES;
    _userPhoneNumField.font = [UIFont systemFontOfSize:15];
    UIImageView *phoneIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_phone.png"]];
    UIView *iconBg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
    phoneIconView.frame = CGRectMake(9, 8, 20, 20);
    [iconBg1 addSubview:phoneIconView];
    _userPhoneNumField.leftView = iconBg1;
    _userPhoneNumField.leftViewMode = UITextFieldViewModeAlways;
    _userPhoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    [_userPhoneNumField becomeFirstResponder];
    _userPhoneNumField.delegate = self;
    [self addSubview:_userPhoneNumField];
    
    UILabel *label1 = [UILabel labelWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_userPhoneNumField.frame) + 8, ScreenWidth - XPOS*2, 20) text:[NSString stringWithFormat:@"*注册即视为我已阅读并同意"] textColor:UIColorWithRGB(0x777777) font:[UIFont systemFontOfSize:13]];
    label1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label1];
    
    UILabel *label2 = [UILabel labelWithFrame:CGRectMake(XPOS, CGRectGetMaxY(label1.frame) + 5, ScreenWidth - XPOS*2, 20) text:[NSString stringWithFormat:@"《注册协议》"] textColor:UIColorWithRGB(0x4aa1f9) font:[UIFont systemFontOfSize:13]];
    label2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label2];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake((ScreenWidth - XPOS*2)*1/4, 0, (ScreenWidth - XPOS*2)*0.5, 20);
    but1.backgroundColor = [UIColor clearColor];
    [but1 addTarget:self action:@selector(but1Click:) forControlEvents:UIControlEventTouchUpInside];
    [label2 addSubview:but1];
    
    /*UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame = CGRectMake((ScreenWidth - XPOS*2)*2/5 + 20, 0, (ScreenWidth - XPOS*2)*3/5 - 20, 18);
    but2.backgroundColor = [UIColor clearColor];
    [but2 addTarget:self action:@selector(but2Click:) forControlEvents:UIControlEventTouchUpInside];
    [label2 addSubview:but2];*/
    label2.userInteractionEnabled = YES;
    
    _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextStepBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(label2.frame) + 15, ScreenWidth - XPOS*2, BTNHEIGHT);
    _nextStepBtn.backgroundColor = UIColorWithRGB(0xf03b43);
    [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStepBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_nextStepBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _nextStepBtn.layer.cornerRadius = 2.0f;
    _nextStepBtn.layer.masksToBounds = YES;
    [self addSubview:_nextStepBtn];
 
}

- (void)readBtnClicked:(id)sender
{
    [_delegate readBtnClicked:sender];
}

- (void)nextBtnClicked:(id)sender
{
    [_userPhoneNumField resignFirstResponder];
    if ([_userPhoneNumField.text isEqualToString:@""]) {
        [AuxiliaryFunc showToastMessage:@"请输入手机号" withView:self];
        [_userPhoneNumField becomeFirstResponder];
        return;
    }
    BOOL isPhoneNum = [SharedSingleton checkPhoneNumber:_userPhoneNumField.text];
    if (!isPhoneNum) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不正确" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alertView show];
        [_userPhoneNumField becomeFirstResponder];
        return;
    }
    [_delegate nextBtnClicked:sender];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)but1Click:(id)sender
{
    [_delegate but1Click:sender];
}

- (void)but2Click:(id)sender
{
    [_delegate but2Click:sender];
}

#pragma mark -textFeildDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 11) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *machineName = [Common machineName];
    if ([machineName isEqualToString:@"4"]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake (0,-100,self.frame.size.width, self.frame.size.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *machineName = [Common machineName];
    if ([machineName isEqualToString:@"4"]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake (0,0,self.frame.size.width, self.frame.size.height);
        }];
    }
}

@end
