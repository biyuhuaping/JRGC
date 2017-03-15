//
//  UCFLoginViewController.m
//  JRGC
//
//  Created by HeJing on 15/3/31.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFLoginViewController.h"
#import "AppDelegate.h"
#import "UCFRegisterStepOneViewController.h"
#import "UCFRetrievePasswordStepOneViewController.h"
#import "JSONKit.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "AuxiliaryFunc.h"
#import "LLLockPassword.h"
#import "UCFMainTabBarController.h"
#import "AuxiliaryFunc.h"
#import "UIButton+Misc.h"
#import "UCFValidFaceLoginViewController.h"
#import "UCFLoginFaceView.h"
#import "CWLivessViewController.h"//---qyy0815
#import "MD5Util.h"
#import "UCFSession.h"

@interface UCFLoginViewController ()<UCFLoginFaceViewDelegate,cwIntegrationLivessDelegate>////---qyy0815
{
    UCFLoginView *_loginView;
    UCFLoginFaceView *_loginViewFace;
    
    BOOL _sameUser;
}
@property (nonatomic,strong) CWLivessViewController *controller;//---qyy0815
@end

@implementation UCFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.translucent = NO;
    baseTitleLabel.text = @"登录";
    if ([_sourceVC isEqualToString:@""] || _sourceVC == nil || [_sourceVC isEqualToString:@"changeUser"] || [_sourceVC isEqualToString:@"fromPersonCenter"] || [_sourceVC isEqualToString:@"errorNum"] || [_sourceVC isEqualToString:@"homePage"] || [_sourceVC isEqualToString:@"webViewLongin"]|| [_sourceVC isEqualToString:@"errorNum"] || [_sourceVC isEqualToString:@"bannerLongin"]|| [_sourceVC isEqualToString:@"homePage"] )  {
        [self addLeftButton];
    } else {
        [LLLockPassword saveLockPassword:nil];
//        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UUID];
        [[UserInfoSingle sharedManager] removeUserInfo];
    }
    _loginView = [[UCFLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight)];
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
    
    //-------------------------------人脸登录页面
    _loginViewFace = [[[NSBundle mainBundle] loadNibNamed:@"UCFLoginFaceView" owner:self options:nil] lastObject];
    _loginViewFace.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight);
    _loginViewFace.delegate = self;
    [self.view addSubview:_loginViewFace];
     BOOL useValidFace = [[NSUserDefaults standardUserDefaults] boolForKey:FACESWITCHSTATUS];//***人脸开关状态
    if(useValidFace == YES)
    {
        _loginViewFace.hidden = NO;
    }else{
        _loginViewFace.hidden = YES;
        [_loginView setFirstResponder];//***弹出键盘
    }
     //最近一次登录的用户名
    NSString *lastName = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"];
    if (lastName.length!=0) {
        [_loginView setUserNameFieldText:lastName];
    }
    
    if ([_sourceVC isEqualToString:@"errorNum"]) {
        [[UserInfoSingle sharedManager] removeUserInfo];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:GCODE];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:NO];
    
        AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [del.tabBarController setSelectedIndex:0];
//        NSString *strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
//        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagUserLogout owner:self];
    }
    //从切换用户和输错5次跳转过来
    if ([_sourceVC isEqualToString:@"changeUser"]) { 
        [_loginView setUserNameFieldText:@""];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self.view addSubview:lineView];
}
#pragma mark - 按钮-刷脸登陆界面
- (void)rightBtnClicked:(id)sender
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getToBack
{
    [self.view endEditing:YES];
    if ([_sourceVC isEqualToString:@"fromPersonCenter"]) {
        //个人中心跳到登录页
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate.tabBarController setSelectedIndex:4];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ([_sourceVC isEqualToString:@"changeUser"]) {
        //切换用户跳到登录页
        [self dismissViewControllerAnimated:NO completion:^{
            [self showGestureCode];
        }];
    }
    else if ([_sourceVC isEqualToString:@"bannerLongin"]) {
        //切换用户跳到登录页
        
        [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BACK_TO_LOGIN object:nil];
        }];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -UCFLoginViewDelegate

- (void)resetPassword:(id)sender
{
    UCFRetrievePasswordStepOneViewController *controller = [[UCFRetrievePasswordStepOneViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)regisiterBtn:(id)sender
{
    UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
    [self.navigationController pushViewController:registerControler animated:YES];
//    [[NetworkModule sharedNetworkModule] postReq:nil tag:kSXTagGetBanner owner:self];
}

-(void)userLogin:(id)sender
{
    [self.view endEditing:YES];    
    //同盾
    // 获取设备管理器实例
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    manager->getDeviceInfoAsync(nil, self);
}


#pragma mark -RequsetDelegate

-(void)beginPost:(kSXTag)tag
{
    if (tag == kSXTagGetBanner) {
        
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == kSXTagLogin) {
        if ([[dic valueForKey:@"ret"] boolValue]) {
            DLog(@"log%@",dic);
//            NSString *uuid = [NSString stringWithFormat:@"%@",dic[@"data"][@"userInfo"][@"userId"]];
//            NSString *time = dic[TIME];
            [Common deleteCookies];
            //登录成功保存用户的资料
            [[UserInfoSingle sharedManager] setUserData:dic[@"data"][@"userInfo"]];
//            [[UserInfoSingle sharedManager] setUserLevel:dic[@"data"][@"userLevel"]];
            [Common setHTMLCookies:dic[@"data"][@"userInfo"][@"jg_ckie"]];//html免登录的cookies

            NSString *lastName = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"];
            if (lastName != nil) {
                if (![lastName isEqualToString:[Common deleteStrHeadAndTailSpace:_loginView.userNameFieldText]]) {
                    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                    [del.tabBarController setSelectedIndex:0];
                    UINavigationController *contoller = (UINavigationController*)del.tabBarController.selectedViewController;
                    [contoller popToRootViewControllerAnimated:YES];
                    //切换用户重新请求放心花页面
                    [[NSNotificationCenter defaultCenter] postNotificationName:IS_RELOADE_URL object:nil];
                } else {
                    _sameUser = YES;
                    //同一个用户
                    [[NSNotificationCenter defaultCenter] postNotificationName:IS_RELOADE_REQUEST object:nil];
                }
            }
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:0] forKey:WRANGGCODENUMBER];

            [LLLockPassword saveLockPassword:nil];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:5] forKey:@"nRetryTimesRemain"];
            [[NSUserDefaults standardUserDefaults] setObject:[Common deleteStrHeadAndTailSpace:_loginView.userNameFieldText] forKey:@"lastLoginName"];
            NSString *md5Str = _loginView.passwordFieldText.length > 0 ? [UCFToolsMehod md5:[MD5Util MD5Pwd:_loginView.passwordFieldText]] :[UCFToolsMehod md5:@""];
            NSString *yanQian = [NSString stringWithFormat:@"%@%@%@",_loginView.userNameFieldText,md5Str,dic[@"data"][@"userInfo"][@"time"]];
            NSString *gcmCode = [(NSDictionary *)dic[@"data"][@"userInfo"] objectSafeForKey: @"promotionCode"];
            NSString *signatureStr  = [UCFToolsMehod md5:yanQian];
            [[NSUserDefaults standardUserDefaults] setObject:signatureStr forKey:SIGNATUREAPP];
            [[NSUserDefaults standardUserDefaults] setValue:gcmCode forKey:@"gcmCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
            //更新个人中心数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
            [self loginSuccess:dic];
            //登录成功检测一次红点
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
            [self sendiWatchData:signatureStr withGcm:gcmCode];//登录成功之后向iWatch发送数据
            [Common addTestCookies];//app审核用的灰度
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"message"] delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil];
            [alertView show];
        }
        

        
    }else if(tag.integerValue == kSXTagUserLogout){
        
    }  else if (tag.intValue == kSXTagGetBanner) {

    }
    
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagGetBanner) {
        UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
        [self.navigationController pushViewController:registerControler animated:YES];
    } else {
        [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}
#pragma mark  登录成功之后向iOS发送数据 验签串 和工场码Data
-(void)sendiWatchData:(NSString *)signatureStr withGcm:(NSString *)gcm{
    
    NSData *data = [Common createImageCode:gcm];
    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSDictionary *loginSuccessDic = @{@"userId":[UserInfoSingle sharedManager].userId, @"source_type":@"1",@"imei":[Common getKeychain],@"version":[Common getIOSVersion],@"signature":signatureStr,@"imageData":data,@"isSubmitAppStoreAndTestTime":@(del.isSubmitAppStoreTestTime).stringValue};
    [[UCFSession sharedManager] transformBackgroundWithUserInfo:loginSuccessDic withState:UCFSessionStateUserLogin];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
            AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [del.tabBarController setSelectedIndex:4];
        }
        [self dismissViewControllerAnimated:NO completion:^{
            //[[NSNotificationCenter defaultCenter] postNotificationName:BACK_TO_PERSON_CENTER object:nil];
            [self showGestureCode];
        }];
    }
}

/** 登录成功*/
- (void)loginSuccess:(NSDictionary *)dict
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray *allObj = [tempDic allKeys];
    for (int i = 0; i < allObj.count; i ++) {
        id obj = [tempDic objectForKey:allObj[i]];
        if ([obj isEqual:[NSNull null]]) {
            [tempDic removeObjectForKey:allObj[i]];
        }
    }
   // [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginUserMsg"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FirstLoginTimeEveryday];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self gesturePage];
}

// 手势代码界面处理
- (void)gesturePage
{
    if ([_sourceVC isEqualToString:@"changeUser"]) {
        [LLLockPassword saveLockPassword:nil];
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
        UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
        [nav popToRootViewControllerAnimated:NO];
        [self showGestureCode];
    }
    else if ([_sourceVC isEqualToString:@"webViewLongin"])
    {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
//            [self showGestureCode];
            [[NSNotificationCenter defaultCenter] postNotificationName:BACK_TO_BANNER object:nil];
            //[[NSNotificationCenter defaultCenter] postNotificationName:BACK_TO_BANNER object:nil];
        }];
//        return;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        [self showGestureCode];
//        if ([[NSUserDefaults standardUserDefaults] valueForKey: UUID]) {
//            if ([_sourceVC isEqualToString:@"homePage"] || [_sourceVC isEqualToString:@"otherPage"]) {
//                AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//                [del.tabBarController setSelectedIndex:3];
//            }
//        }
    }];
}

-(void)showGestureCode
{
    NSString *gode = [LLLockPassword loadLockPassword];
    if (gode) {
        //存在手势密码，校验
        [self showLLLockViewController:LLLockViewTypeCheck];
    } else {
        //不存在手势密码，创建
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
        lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [del.window.rootViewController presentViewController:lockVc animated:NO completion:^{
        }];
    }
}

#pragma mark - 同盾
- (void) didReceiveDeviceBlackBox: (NSString *) blackBox {
    NSString *blockId = blackBox;
    NSString *wanip = [[NSUserDefaults standardUserDefaults] valueForKey:@"curWanIp"];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:_loginView.userNameFieldText forKey:@"username"];
    [parDic setValue:[MD5Util MD5Pwd:_loginView.passwordFieldText] forKey:@"pwd"];
    [parDic setValue:blockId forKey:@"token_id"];
    [parDic setValue:wanip forKey:@"ip"];
    
    [[NetworkModule sharedNetworkModule] newPostReq:parDic tag:kSXTagLogin owner:self signature:NO];
}
#pragma mark - 刷脸登陆后反回的数据处理
- (void)transformCloudWalkReconise:(id)_data{
     NSString *data = [_data copy];
     //***设置用户密码和账户名称 用于验签
    [_loginView setUserNameFieldText:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"]];
    [_loginView setPasswordFieldText:@""];
    [self.controller backToHomeViewController:nil];//---qyy0815
    [self endPost:data tag:kSXTagLogin];
}
#pragma mark - 进入刷脸界面
-(void)goToFaceCheaking
{
  
    self.controller = [[CWLivessViewController alloc] initWithNibName:@"CWLivessViewController" bundle:nil];
    self.controller.delegate = self;
    self.controller.ForwardPageuserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"];//最近一次登录的用户名
    self.controller.flagway = 1;
   
    [self.controller setLivessParam:AuthCodeString livessNumber:1 livessLevel:CWLiveDetectLow isShowResultView:YES isFaceCompare:NO];
    [self.navigationController pushViewController:self.controller animated:YES];//---qyy0815
}
#pragma mark - 选择密码登陆后-将键盘弹出的回调用
-(void)keyBoardPushOut
{
     [_loginView setFirstResponder];//***弹出键盘
}

/**
 *  @brief 活体检测、人脸比对的代理方法
 *
 *  @param isAlive       是否是活体
 *  @param bestFaceData 获取的最佳人脸图片（已压缩过的JPG图片数据）
 *  @param isSame        是否是同一个人
 *  @param faceScore     人脸比对的分数
 *  @param code          错误码(根据错误码判断是否有攻击)
 */

-(void)cwIntergrationLivess:(BOOL)isAlive BestFaceImage:(NSData *)bestFaceData isTheSamePerson:(BOOL)isSame faceScore:(double)faceScore errorCode:(NSInteger)code{
    
    //最佳人脸可以直接转换成base64
    NSString  * baseStr = [bestFaceData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    //检测失败 根据code判断是否是攻击
    if (code == CW_FACE_LIVENESS_ATTACK_SHAKE || code == CW_FACE_LIVENESS_ATTACK_MOUTH || code == CW_FACE_LIVENESS_ATTACK_RIGHTEYE||code == CW_FACE_LIVENESS_ATTACK_PICTURE || code == CW_FACE_LIVENESS_ATTACK_PAD || code == CW_FACE_LIVENESS_ATTACK_VIDEO ||
        code == CW_FACE_LIVENESS_PEPOLECHANGED) {
        
    }
    
    NSLog(@"isAlive=%d  baseStr.length=%ld code=====%ld",isAlive,(unsigned long)baseStr.length,(long)code);
}

@end
