//
//  UCFRetrievePasswordStepOneView.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRetrievePasswordStepOneView.h"
#import "UITextFieldFactory.h"
#import "SharedSingleton.h"
#import "AuxiliaryFunc.h"
#import "BaseAlertView.h"

@interface UCFRetrievePasswordStepOneView ()<UITextFieldDelegate>
{
    UITextField *_userNameTfd;
    UITextField *_phoneNumTfd;
    UIButton *_nextBtn;
    UIButton *_concactUsBtn;
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}

@end

@implementation UCFRetrievePasswordStepOneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        [self initStepOneView];
    }
    return self;
}

- (NSString*)getPhoneFieldText
{
    NSString* nStr = [_phoneNumTfd.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return nStr;
}

- (NSString*)getUserNameText
{
    return _userNameTfd.text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)initStepOneView
{
//    _userNameTfd = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, YPOS, ScreenWidth - 30, TEXTFIELDHEIGHT) delegate:self placeholder:@"请输入用户名" returnKeyType:UIReturnKeyDefault];
//    
//    _userNameTfd.backgroundColor = [UIColor whiteColor];
//    _userNameTfd.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
//    _userNameTfd.layer.borderWidth = 0.5;
//    _userNameTfd.layer.cornerRadius = 4.0f;
//    _userNameTfd.layer.masksToBounds = YES;;
//    _userNameTfd.font = [UIFont systemFontOfSize:15];
//    UIImageView *userIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_name.png"]];
//    UIView *iconBg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
//    userIconView.frame = CGRectMake(9, 8, 20, 20);
//    [iconBg1 addSubview:userIconView];
//    _userNameTfd.leftView = iconBg1;
//    _userNameTfd.leftViewMode = UITextFieldViewModeAlways;
//    [_userNameTfd becomeFirstResponder];
//    [self addSubview:_userNameTfd];
    
    _phoneNumTfd = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, YPOS, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:self placeholder:@"请输入绑定手机号" returnKeyType:UIReturnKeyDefault];
    _phoneNumTfd.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTfd.backgroundColor = [UIColor whiteColor];
    _phoneNumTfd.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _phoneNumTfd.layer.borderWidth = 0.5;
    _phoneNumTfd.layer.cornerRadius = 4.0f;
    _phoneNumTfd.layer.masksToBounds = YES;
    _phoneNumTfd.font = [UIFont systemFontOfSize:15];
    UIImageView *phoneIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_phone.png"]];
    UIView *iconBg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
    phoneIconView.frame = CGRectMake(9, 8, 20, 20);
    [iconBg2 addSubview:phoneIconView];
    _phoneNumTfd.leftView = iconBg2;
    _phoneNumTfd.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumTfd.delegate = self;
    [_phoneNumTfd addTarget:self action:@selector(formatPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_phoneNumTfd];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(_phoneNumTfd.frame) + SPACING, ScreenWidth - XPOS*2, BTNHEIGHT);
    _nextBtn.backgroundColor = UIColorWithRGB(0xf03b43);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.layer.cornerRadius = 2.0f;
    _nextBtn.layer.masksToBounds = YES;
    [self addSubview:_nextBtn];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, CGRectGetMaxY(_nextBtn.frame) + 10, ScreenWidth - XPOS*2, 18)];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = UIColorWithRGB(0x999999);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor clearColor];
    [self addSubview:label1];
    
    NSString *strTitle = @"找回密码遇到问题，请联系客服400-6766-988";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTitle];
    NSRange rang = [strTitle rangeOfString:@"400-6766-988"];
    [str setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:UIColorWithRGB(0x4aa1f9)} range:rang];
    NSRange rang2 = [strTitle rangeOfString:@"找回密码遇到问题，请联系客服"];
    [str setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:UIColorWithRGB(0x999999)} range:rang2];
    label1.attributedText = str;
    
    _concactUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _concactUsBtn.frame = CGRectMake(0, 0, ScreenWidth - XPOS*2, 18);
    _concactUsBtn.backgroundColor = [UIColor clearColor];
    [_concactUsBtn addTarget:self action:@selector(concactUs:) forControlEvents:UIControlEventTouchUpInside];
    [label1 addSubview:_concactUsBtn];
    label1.userInteractionEnabled = YES;
}

- (void)nextStep:(id)sender
{
//    if ([_userNameTfd.text isEqualToString:@""] || _userNameTfd.text == nil) {
//        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入用户名"];
//        [_userNameTfd becomeFirstResponder];
//        return;
//    }
    if ([_phoneNumTfd.text isEqualToString:@""] || _phoneNumTfd.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入手机号"];
        [_phoneNumTfd becomeFirstResponder];
        return;
    }
    [_delegate nextStep:sender];
}

- (void)concactUs:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-6766-988"]];
    [_delegate concactUs:sender];
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
