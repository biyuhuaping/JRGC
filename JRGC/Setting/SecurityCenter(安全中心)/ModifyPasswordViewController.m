//
//  ModifyPasswordViewController.m
//  JRGC
//
//  Created by NJW on 15/4/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "BaseAlertView.h"
#import "MD5Util.h"
#import "SharedSingleton.h"

@interface ModifyPasswordViewController ()
{
    BOOL _isSecureTextEntry;
    UIButton *_eyeButton;
}
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *lastPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *handInButton;
@end

@implementation ModifyPasswordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 从storyboard中加载界面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"modifypassword"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"修改登录密码";
    baseTitleLabel.text = @"修改登录密码";
    [self addLeftButton];
    //  设置隐藏导航栏
    _isSecureTextEntry = YES;
    self.isHideNavigationBar = YES;
    
    // 初始化界面
    [self createUI];
    [self.oldPasswordTextField becomeFirstResponder];
}

// 初始化界面
- (void)createUI
{
    self.oldPasswordTextField.layer.cornerRadius = 3;
    self.oldPasswordTextField.clipsToBounds = YES;
    self.oldPasswordTextField.layer.borderWidth = 0.5;
    self.oldPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.oldPasswordTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.oldPasswordTextField.secureTextEntry = YES;
    
    self.lastPasswordTextField.layer.cornerRadius = 3;
    self.lastPasswordTextField.clipsToBounds = YES;
    self.lastPasswordTextField.layer.borderWidth = 0.5;
    self.lastPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.lastPasswordTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.lastPasswordTextField.secureTextEntry = YES;
    
    UIImageView *oldPwLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    oldPwLeftImageView.contentMode = UIViewContentModeCenter;
    oldPwLeftImageView.image = [UIImage imageNamed:@"login_icon_password"];
    
    self.oldPasswordTextField.leftView = oldPwLeftImageView;
    
    UIImageView *lastPwLeftImageView = [[UIImageView alloc] init];
    lastPwLeftImageView.frame = oldPwLeftImageView.frame;
    lastPwLeftImageView.contentMode = UIViewContentModeCenter;
    lastPwLeftImageView.image = [UIImage imageNamed:@"login_icon_password"];
    self.lastPasswordTextField.leftView = lastPwLeftImageView;
    
    [self.handInButton setBackgroundImage:[self.handInButton.currentBackgroundImage stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [self.handInButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    self.lastPasswordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _eyeButton.frame = CGRectMake(0, 0, 40, 30);
    [_eyeButton setImage:[UIImage imageNamed:@"login_btn_visible"] forState:UIControlStateNormal];
    [_eyeButton addTarget:self action:@selector(visibleNewPassword:) forControlEvents:UIControlEventTouchUpInside];
    _eyeButton.contentMode = UIViewContentModeCenter;
    self.lastPasswordTextField.rightView = _eyeButton;
}

// 按钮的点击事件
- (IBAction)handIn:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_oldPasswordTextField.text isEqualToString:@""] || _oldPasswordTextField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入原密码"];
        [_oldPasswordTextField becomeFirstResponder];
        return;
    }
    if ([_lastPasswordTextField.text isEqualToString:@""] || _lastPasswordTextField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入新密码"];
        [_lastPasswordTextField becomeFirstResponder];
        return;
    }
    if (![SharedSingleton isValidatePassWord:_lastPasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:@"6-16位字符，只能包含字母、数字及标点符号（需两两组合），区分大小写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:userName forKey:@"userId"];
    [parDic setValue:[MD5Util MD5Pwd:_oldPasswordTextField.text] forKey:@"oldPwd"];
    [parDic setValue:[MD5Util MD5Pwd:_lastPasswordTextField.text] forKey:@"newPwd"];

    if (parDic) {
        [[NetworkModule sharedNetworkModule] newPostReq:parDic tag:kSXTagUpdatePwd owner:self signature:YES Type:SelectAccoutDefault];
    }
}

- (void)visibleNewPassword:(UIButton *)sender {
    _isSecureTextEntry = !_isSecureTextEntry;
    _lastPasswordTextField.secureTextEntry = _isSecureTextEntry;
    NSString *tempStr = _lastPasswordTextField.text;
    _lastPasswordTextField.text = @"";
    _lastPasswordTextField.text = tempStr;
    
    if (!_isSecureTextEntry) {
        [_eyeButton setImage:[UIImage imageNamed:@"login_btn_invisible"] forState:UIControlStateNormal];
    } else {
        [_eyeButton setImage:[UIImage imageNamed:@"login_btn_visible"] forState:UIControlStateNormal];
    }
}

// 触摸代理事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - RequsetDelegate

- (void)beginPost:(kSXTag)tag
{
//    if (self.settingBaseBgView.hidden) {
//        self.settingBaseBgView.hidden = NO;
//    }
//    [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
//    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
//    self.settingBaseBgView.hidden = YES;
    
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    
    if (tag.intValue == kSXTagUpdatePwd) {

        if([rstcode boolValue] )
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
            alertView.tag = 10001;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
            [SingleUserInfo deleteUserData];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
//        else
//        {
//            [AuxiliaryFunc showReEnterAlertViewWithMessage:rsttext delegate:self];
//        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
//    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
//    self.settingBaseBgView.hidden = YES;
}



- (void)dealloc
{
    [self.oldPasswordTextField removeFromSuperview];
    self.oldPasswordTextField = nil;
    [self.lastPasswordTextField removeFromSuperview];
    self.lastPasswordTextField = nil;
}

@end
