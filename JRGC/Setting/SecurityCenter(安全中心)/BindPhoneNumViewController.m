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

@interface BindPhoneNumViewController () <UITextFieldDelegate, UIAlertViewDelegate>
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
    [self.moddifyPhoneTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
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
// textfield代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if ((existedLength - selectedLength + replaceLength > 11)  && textField == self.moddifyPhoneTextField) {
        return NO;
    }
    return YES;
}
- (UITextField *)textfieldLength:(UITextField *)textField
{
    if (textField.text.length == 11) {
        [self.loginPwdTextField becomeFirstResponder];
    }
    return textField;
}
//  下一步按钮的点击事件
- (IBAction)nextStep:(id)sender {
    [self.view endEditing:YES];
    NSString *oldPhoneNum = [Common deleteStrHeadAndTailSpace:self.moddifyPhoneTextField.text];
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
    BOOL isPhoneNum = [SharedSingleton checkPhoneNumber:self.moddifyPhoneTextField.text];
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
    NSDictionary *param = @{@"phone": self.moddifyPhoneTextField.text, @"pwd": self.loginPwdTextField.text};
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
