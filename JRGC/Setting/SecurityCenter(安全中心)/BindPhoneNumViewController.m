//
//  BindPhoneNumViewController.m
//  JRGC
//
//  Created by NJW on 15/4/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "BindPhoneNumViewController.h"
#import "UCFModifyPhoneViewController.h"
#import "SharedSingleton.h"

@interface BindPhoneNumViewController () <UITextFieldDelegate, UIAlertViewDelegate>{
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}

// 已绑定的手机号
@property (weak, nonatomic) IBOutlet UILabel *bindedPhoneLabel;
// 新手机号
@property (weak, nonatomic) IBOutlet UITextField *moddifyPhoneTextField;
// 登录密码
@property (weak, nonatomic) IBOutlet UITextField *loginPwdTextField;
// 下一步
@property (weak, nonatomic) IBOutlet UIButton *nextStep;

@end

@implementation BindPhoneNumViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

// 初始化界面
- (void)createUI
{
//    self.bindedPhoneLabel.text = self.authedPhone == nil ? @"" : self.authedPhone;
    [self addLeftButton];
    baseTitleLabel.text = @"绑定手机号";
    if (self.authedPhone == nil) {
        self.bindedPhoneLabel.text = @"";
    }
    else {
        self.bindedPhoneLabel.text = self.authedPhone;
    }
    
    self.moddifyPhoneTextField.layer.cornerRadius = 3;
    self.moddifyPhoneTextField.clipsToBounds = YES;
    self.moddifyPhoneTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.moddifyPhoneTextField.layer.borderWidth = 0.5;
    
    UIImageView *idImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    idImageView.image = [UIImage imageNamed:@"login_icon_phone"];
    idImageView.contentMode = UIViewContentModeCenter;
    self.moddifyPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.moddifyPhoneTextField.leftView = idImageView;
    
    self.loginPwdTextField.layer.cornerRadius = 3;
    self.loginPwdTextField.clipsToBounds = YES;
    self.loginPwdTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.loginPwdTextField.layer.borderWidth = 0.5;
    
    UIImageView *loginPwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    loginPwdImageView.image = [UIImage imageNamed:@"login_icon_password"];
    loginPwdImageView.contentMode = UIViewContentModeCenter;
    self.loginPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.loginPwdTextField.leftView = loginPwdImageView;
    
    [self.nextStep setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [self.nextStep setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [self.moddifyPhoneTextField becomeFirstResponder];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.moddifyPhoneTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

// 键盘通知
- (void)keyboardFrameChanged:(NSNotification *)noti
{
    NSValue *keyboardFrame = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGFloat keyboardY = CGRectGetMinY([keyboardFrame CGRectValue]);
    CGFloat textfieldBottomY = CGRectGetMaxY(self.loginPwdTextField.frame);
    if (keyboardY < textfieldBottomY + 10) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, keyboardY - textfieldBottomY - 10, ScreenWidth, ScreenHeight);
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }];
    }
}

#pragma mark - UITextField
//1.在UITextField的代理方法中实现手机号只能输入数字并满足我们的要求（首位只能是1，其他必须是0~9的纯数字）
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _moddifyPhoneTextField) {
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
    return YES;
}

//3.让手机号实现344格式
- (void)textFieldEditingChanged:(UITextField *)textField
{
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



//  下一步按钮的点击事件
- (IBAction)nextStep:(id)sender {
    [self.view endEditing:YES];
    NSString* str = [self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *oldPhoneNum = [Common deleteStrHeadAndTailSpace:str];
    if (oldPhoneNum.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请输入原绑定手机号" withView:self.view];
//        [self.moddifyPhoneTextField becomeFirstResponder];
        return;
    }
    NSString *password = [Common deleteStrHeadAndTailSpace:self.loginPwdTextField.text];
    if (password.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请输入登录密码" withView:self.view];
//        [self.loginPwdTextField becomeFirstResponder];
        return;
    }
    BOOL isPhoneNum = [SharedSingleton checkPhoneNumber:str];
    if (!isPhoneNum) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alertView.tag = 99;
        [alertView show];
        return;
    }
//    BOOL isPassword = [SharedSingleton isValidatePassWord:self.loginPwdTextField.text];
//    if (!isPassword) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码格式错误" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
//        alertView.tag = 100;
//        [alertView show];
//        return;
//    }
    [self getIsValidPhoneNumAndPasswordFromNetData];
//    UCFModifyPhoneViewController *modifyPhone = [[UCFModifyPhoneViewController alloc] init];
//    modifyPhone.title = @"修改绑定手机号";
//    [self.navigationController pushViewController:modifyPhone animated:YES];
    
}

// 获取网络数据
- (void)getIsValidPhoneNumAndPasswordFromNetData
{
    NSString* str = [self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *param = @{@"phone": str, @"pwd": self.loginPwdTextField.text};
    [[NetworkModule sharedNetworkModule] postReq2:param tag:kSXTagValidBindedPhone owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
    if (tag.intValue == kSXTagValidBindedPhone) {
        if ([rstcode intValue] == 1) {
            UCFModifyPhoneViewController *modifyPhone = [[UCFModifyPhoneViewController alloc]initWithNibName:@"UCFModifyPhoneViewController" bundle:nil];
            modifyPhone.title = @"修改绑定手机号";
            modifyPhone.rootVc = _uperViewController;
            [self.navigationController pushViewController:modifyPhone animated:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
            alertView.tag = [rstcode  integerValue];
            [alertView show];
        }
    }
}

// 警告框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 2:
            return;
        case 3: {
            self.loginPwdTextField.text = @"";
            [self.loginPwdTextField becomeFirstResponder];
        }
            break;
        case 4: {
            self.loginPwdTextField.text = @"";
            [self.moddifyPhoneTextField becomeFirstResponder];
        }
            break;
        case 99:
            [self.moddifyPhoneTextField becomeFirstResponder];
            break;
        case 100:
            [self.loginPwdTextField becomeFirstResponder];
            break;
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagValidBindedPhone) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
