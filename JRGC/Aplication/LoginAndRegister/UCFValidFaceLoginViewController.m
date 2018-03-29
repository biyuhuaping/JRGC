//
//  UCFValidFaceLoginViewController.m
//  JRGC
//
//  Created by Qnwi on 16/2/23.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFValidFaceLoginViewController.h"
#import "JSONKit.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "AuxiliaryFunc.h"
#import "LLLockPassword.h"
#import "UCFMainTabBarController.h"
#import "AuxiliaryFunc.h"
#import "UITextFieldFactory.h"
#import "UIButton+Misc.h"
#import "AuxiliaryFunc.h"
#import "BaseAlertView.h"

@interface UCFValidFaceLoginViewController ()
{
    UITextField *_userNameTfd;//用户名
    UIButton *_loginBtn;//登录按钮
}

@end

@implementation UCFValidFaceLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
    [self addLeftButton];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.translucent = NO;
    baseTitleLabel.text = @"登录";
    self.baseTitleType = @"validFace";
    
    UIButton *rightBtn = [UIButton buttonWithTarget:self origin:CGPointMake(0, 0) normalImage:nil selector:@selector(rightBtnClicked:)];
    rightBtn.frame = CGRectMake(0, 0, 90, 30);
    [rightBtn setTitle:@"切换密码登录" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor redColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self initLoginViews];
    // Do any additional setup after loading the view.
}

- (void)rightBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//初始化登陆页
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
    
    
    [self.view addSubview:_userNameTfd];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(_userNameTfd.frame) + 15, ScreenWidth - XPOS*2, BTNHEIGHT);
    _loginBtn.backgroundColor = UIColorWithRGB(0xf03b43);
    [_loginBtn setTitle:@"刷脸" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.cornerRadius = 2.0f;
    _loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:_loginBtn];
    
    [_userNameTfd becomeFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)userLogin:(id)sender
{
    [self.view endEditing:YES];
    if ([_userNameTfd.text isEqualToString:@""] || _userNameTfd.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入用户名"];
        [_userNameTfd becomeFirstResponder];
        return;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
