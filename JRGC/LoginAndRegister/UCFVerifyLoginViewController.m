//
//  UCFVerifyLoginViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFVerifyLoginViewController.h"
#import "UITextFieldFactory.h"
#import "UIButton+Misc.h"
#import "AuxiliaryFunc.h"
#import "LLLockPassword.h"
#import "UCFMainTabBarController.h"
#import "JSONKit.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "AppDelegate.h"
#import "BaseAlertView.h"
#import "MD5Util.h"
//#import "CloudwalkFaceSDK.h"
//#import "NewFaceViewController.h"
//#import "CWLivessViewController.h"//---qyy0815

@interface UCFVerifyLoginViewController ()
{
    UITextField *_userNameTfd;//用户名
    UITextField *_passWordTfd;//密码
    UIButton *_loginBtn;//验证登录按钮
    BOOL _sameUser;
}

@end

@implementation UCFVerifyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
     baseTitleLabel.text = @"验证登录密码";
    [self addLeftButton];
//    _userNameTfd = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, YPOS, ScreenWidth - 30, TEXTFIELDHEIGHT) delegate:self placeholder:@"用户名/邮箱/手机号" returnKeyType:UIReturnKeyDefault];
//    _userNameTfd.textColor = UIColorWithRGB(0x999999);
//    _userNameTfd.backgroundColor = [UIColor whiteColor];
//    _userNameTfd.userInteractionEnabled = NO;
//    _userNameTfd.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
//    _userNameTfd.layer.borderWidth = 0.5;
//    _userNameTfd.layer.cornerRadius = 4.0f;
//    _userNameTfd.layer.masksToBounds = YES;;
//    _userNameTfd.font = [UIFont systemFontOfSize:14];
//    UIImageView *userIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_name.png"]];
//    UIView *iconBg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
//    userIconView.frame = CGRectMake(9, 8, 20, 20);
//    [iconBg1 addSubview:userIconView];
//    _userNameTfd.leftView = iconBg1;
//    _userNameTfd.leftViewMode = UITextFieldViewModeAlways;
//    
//    NSString *lastName = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"];
//    if (lastName.length!=0) {
//        _userNameTfd.text =  [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"];
//    }
//    
//    [self.view  addSubview:_userNameTfd];
    
    _passWordTfd = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake(XPOS, YPOS, ScreenWidth - XPOS*2, TEXTFIELDHEIGHT) delegate:self placeholder:@"请输入密码" returnKeyType:UIReturnKeyDefault];
    _passWordTfd.backgroundColor = [UIColor whiteColor];
    _passWordTfd.layer.borderColor = UIColorWithRGB(0xdddddd).CGColor;
    _passWordTfd.layer.borderWidth = 0.5;
    _passWordTfd.layer.cornerRadius = 4.0f;
    _passWordTfd.layer.masksToBounds = YES;
    _passWordTfd.font = [UIFont systemFontOfSize:14];
    UIImageView *pwdIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password.png"]];
    UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 37)];
    pwdIconView.frame = CGRectMake(9, 8, 20, 20);
    [iconBg addSubview:pwdIconView];
    _passWordTfd.leftView = iconBg;
    _passWordTfd.leftViewMode = UITextFieldViewModeAlways;
    _passWordTfd.secureTextEntry = YES;
    _passWordTfd.delegate = self;
    [self.view  addSubview:_passWordTfd];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(XPOS, CGRectGetMaxY(_passWordTfd.frame) + 15, ScreenWidth - XPOS*2, BTNHEIGHT);
    _loginBtn.backgroundColor = UIColorWithRGB(0xf03b43);
    [_loginBtn setTitle:@"提交验证" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.cornerRadius = 2.0f;
    _loginBtn.layer.masksToBounds = YES;
//    [_loginBtn setEnabled:NO];
//    _loginBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_loginBtn];
    [_passWordTfd becomeFirstResponder];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self.view addSubview:lineView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kIS_IOS7) {
        self.navigationController.navigationBar.translucent = NO;
    } else {
    }
}

- (void)getToBack
{
    if ([_sourceVC isEqualToString:@"securityCenter"]) {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = YES;
//        BOOL useLock = [[NSUserDefaults standardUserDefaults] valueForKey:@"useLockView"];
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useLockView"];
    }else if([_sourceVC isEqualToString:@"validFaceLogin"]||[_sourceVC isEqualToString:@"validFaceSwitchSwip"]){
        //更新个人中心数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = YES;
    }else {
//        [self dismissViewControllerAnimated:NO completion:^{
//            [self showGestureCode];
//        }];
        [self.navigationController popViewControllerAnimated:YES];
    }

//    [self.view endEditing:YES];
//    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    UCFMainTabBarController *tabBarController = [[UCFMainTabBarController alloc] init];
//    [tabBarController setSelectedIndex:0];
//    del.window.rootViewController = tabBarController;
//    [self showGestureCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userLogin:(id)sender
{
    [self.view endEditing:YES];
    if ([_passWordTfd.text isEqualToString:@""]) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入密码"];
        [_passWordTfd becomeFirstResponder];
        return;
    }
//    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&username=%@&pwd=%@",SingleUserInfo.loginData.userInfo.userId,[[NSUserDefaults standardUserDefaults] objectForKey:LOGINNAME],_passWordTfd.text];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagValidLogin owner:self Type:SelectAccoutDefault];
    
    
    NSString* phoneNumberStr = [_passWordTfd.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *isCompanyStr  = [NSString stringWithFormat:@"%d",SingleUserInfo.loginData.userInfo.isCompanyAgent];
    NSDictionary *param = @{@"username":SingleUserInfo.loginData.userInfo.loginName, @"pwd": [MD5Util MD5Pwd:phoneNumberStr],@"isCompany":isCompanyStr};
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagValidBindedPhone owner:self signature:YES Type:SelectAccoutTypeP2P ];
}


#pragma mark -RequsetDelegate

-(void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    if (tag.intValue == kSXTagValidBindedPhone) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([dic[@"ret"] boolValue]) {
            [LLLockPassword saveLockPassword:nil];
            [self loginSuccess:dic];
        } else {
            NSString *rsttext =  dic[@"message"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil];
            [alertView show];
        }
    }else if(tag.integerValue == kSXTagUserLogout){
        
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    
    if (tag.intValue == kSXTagLogin||tag.intValue == kSXTagValidBindedPhone||tag.intValue == kSXTagUserLogout) {
        [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        if (SingleUserInfo.loginData.userInfo.userId) {
//            AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//            [del.tabBarController setSelectedIndex:3];
//        }
//        [self dismissViewControllerAnimated:NO completion:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:BACK_TO_PERSON_CENTER object:nil];
//            [self showGestureCode];
//        }];
//    }
}

/** 登录成功*/
- (void)loginSuccess:(NSDictionary *)dict
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray *allObj = [tempDic allKeys];
    for (int i = 0; i < allObj.count; i ++) {
        id obj = [tempDic objectForKey:allObj[i]];
        if ([obj isKindOfClass:[NSNull class]]) {
            [tempDic removeObjectForKey:allObj[i]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginUserMsg"];
    
    //刷脸
    if ([_sourceVC isEqualToString:@"validFaceLogin"]) {
       
        
        
        
        
//        CWLivessViewController *nfvctrl = [[CWLivessViewController alloc]initWithNibName:@"CWLivessViewController" bundle:nil];
//         nfvctrl.flagway = 0;
//         nfvctrl.delegate = self;
//        [nfvctrl setLivessParam:AuthCodeString livessNumber:3 livessLevel:CWLiveDetectLow isShowResultView:YES isFaceCompare:NO];
//
//        [self.navigationController pushViewController:nfvctrl animated:YES];//---qyy0815
        
    } else if ([_sourceVC isEqualToString:@"validFaceSwitchSwip"]) {//刷脸登录开关 由开---->>>关 的密码验证
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFaceSwitchSwip" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self gesturePage];
    }
}
// 手势代码界面处理
- (void)gesturePage
{
    //从安全中心过来的直接显示手势密码
    if ([_sourceVC isEqualToString:@"securityCenter"]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"useLockView"] == YES) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useLockView"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showGestureCode];
        }
    } else {
        AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [del.tabBarController setSelectedIndex:0];
        [del.tabBarController dismissViewControllerAnimated:NO completion:^{
            [self showGestureCode];
        }];
    }
}

-(void)showGestureCode
{
    NSString *gode = [LLLockPassword loadLockPassword];
    if (gode) {
        [self showLLLockViewController:LLLockViewTypeCheck];
    } else {
        [self showLLLockViewController:LLLockViewTypeCreate];
    }
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if(del.window.rootViewController.presentingViewController == nil){
        UCFLockHandleViewController *lockVc = [[UCFLockHandleViewController alloc] init];
        lockVc.nLockViewType = type;
        if ([_sourceVC isEqualToString:@"securityCenter"]) {
            lockVc.souceVc = @"securityCenter";
        }
        lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [del.window.rootViewController presentViewController:lockVc animated:NO completion:^{
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //不输入置灰的效果
//    NSInteger existedLength = textField.text.length;
//    NSInteger selectedLength = range.length;
//    NSInteger replaceLength = string.length;
//    if (existedLength - selectedLength + replaceLength >= 1) {
//        [_loginBtn setEnabled:YES];
//        _loginBtn.backgroundColor = UIColorWithRGB(0xf03b43);
//    } else {
//        [_loginBtn setEnabled:NO];
//        _loginBtn.backgroundColor = [UIColor grayColor];
//    }
    return YES;
}
///**
// *  @brief 活体检测、人脸比对的代理方法
// *
// *  @param isAlive       是否是活体
// *  @param bestFaceData 获取的最佳人脸图片（已压缩过的JPG图片数据）
// *  @param isSame        是否是同一个人
// *  @param faceScore     人脸比对的分数
// *  @param code          错误码(根据错误码判断是否有攻击)
// */
//
//-(void)cwIntergrationLivess:(BOOL)isAlive BestFaceImage:(NSData *)bestFaceData isTheSamePerson:(BOOL)isSame faceScore:(double)faceScore errorCode:(NSInteger)code{
//    
//    //最佳人脸可以直接转换成base64
//    NSString  * baseStr = [bestFaceData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    
//    //检测失败 根据code判断是否是攻击
////    if (code == CW_FACE_LIVENESS_ATTACK_SHAKE || code == CW_FACE_LIVENESS_ATTACK_MOUTH || code == CW_FACE_LIVENESS_ATTACK_RIGHTEYE||code == CW_FACE_LIVENESS_ATTACK_PICTURE || code == CW_FACE_LIVENESS_ATTACK_PAD || code == CW_FACE_LIVENESS_ATTACK_VIDEO ||
////        code == CW_FACE_LIVENESS_PEPOLECHANGED) {
////        
////    }
//    
//    NSLog(@"isAlive=%d  baseStr.length=%ld code=====%ld",isAlive,(unsigned long)baseStr.length,(long)code);
//}

@end
