//
//  UCFRegisterStepTwoViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRegisterStepTwoViewController.h"
#import "BaseAlertView.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "AppDelegate.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "MD5Util.h"
//#import "UCFSession.h"
#import "P2PWalletHelper.h"
@interface UCFRegisterStepTwoViewController ()
{
    UCFRegisterTwoView *_registerTwoView;
    NSString *_phoneNumber;
    NSString *_mobileTicket;
    int _timeNum;
//    NSString *_apptzticket;
    NSString *_curVerifyType;
    
    BOOL _isSendVoiceMessage;
}

@property(nonatomic,retain) NSTimer *timer;

@end

@implementation UCFRegisterStepTwoViewController

- (id)initWithPhoneNumber:(NSString*)phoneNum
{
    self = [super init];
    if (self) {
        _phoneNumber = phoneNum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"注册";
    [self addLeftButton];
    _registerTwoView = [[UCFRegisterTwoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight) phoneNumber:_phoneNumber isLimitFactoryCode:_isLimitFactoryCode];
    _registerTwoView.delegate = self;
    [self.view addSubview:_registerTwoView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self.view addSubview:lineView];
    
    _isSendVoiceMessage = NO;//默认没有发送
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getToBack
{
    if (kIS_IOS7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self codeBtnClicked:nil];
}

#pragma mark -RetrieveViewDelegate

//点击语音验证码
- (void)soudLabelClick:(UITapGestureRecognizer *)tap
{
    _curVerifyType = @"VMS";
    if (_timeNum > 0 && _timeNum <60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%d秒后重新获取",_timeNum] withView:self.view];
        return;
    } else {
        if(!_isSendVoiceMessage){
            NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber,@"destPhoneNo", _curVerifyType,@"isVms",@"2",@"type",@"1",@"userId", nil];
            [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagRegisterSendCodeAndFindPwd owner:self signature:NO Type:SelectAccoutDefault];
        }
    }
}

- (void)codeBtnClicked:(id)sender
{
    if (_timeNum > 0 && _timeNum <60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%d秒后重新获取",_timeNum] withView:self.view];
        return;
    }
    _curVerifyType = @"SMS";
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber,@"destPhoneNo", _curVerifyType,@"isVms",@"2",@"type",@"1",@"userId", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagRegisterSendCodeAndFindPwd owner:self signature:NO Type:SelectAccoutDefault];
}

- (void)submitBtnClicked:(id)sender
{
    if (![_registerTwoView.getRefereesCode isEqualToString:@""]) {
        NSString *strParameters = [NSString stringWithFormat:@"pomoCode=%@",_registerTwoView.getRefereesCode];
        if (strParameters) {
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagValidpomoCode owner:self Type:SelectAccoutDefault];
        }
    } else {
        //同盾
        // 获取设备管理器实例
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
//        manager->getDeviceInfoAsync(nil, self);
//#warning 同盾修改
        NSString *blackBox = manager->getDeviceInfo();
//        NSLog(@"同盾设备指纹数据: %@", blackBox);
        [self didReceiveDeviceBlackBox:blackBox];
    }
}

#pragma mark -RequsetDelegate

-(void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)veriFieldFstRepder:(NSNumber*)delay
{
    [_registerTwoView setVerifiFieldFirstReponder];
}

- (void) performDismiss:(NSTimer *)timer
{
    UIAlertView *alert = [timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    if (tag.intValue == kSXTagValidpomoCode) {
        if (rstcode && [rstcode intValue] == 1) {
            //同盾
            // 获取设备管理器实例
            FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
//            manager->getDeviceInfoAsync(nil, self);
//#warning 同盾修改
            NSString *blackBox = manager->getDeviceInfo();
//            DBLOG(@"同盾设备指纹数据: %@", blackBox);
            [self didReceiveDeviceBlackBox:blackBox];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if (tag.intValue == kSXTagUserRegist) {
        
        if ([[dic valueForKey:@"ret"] boolValue]) {
            //注册成功后，先清cookies，把老账户的清除掉，然后再用新账户的信息
            [Common deleteCookies];
            //登录成功保存用户的资料
            dic = dic[@"data"][@"userInfo"];
            
            [[UserInfoSingle sharedManager] setUserData:dic];
//            [[UserInfoSingle sharedManager] setUserLevel:dic[@"data"][@"userLevel"]];
            [Common setHTMLCookies:dic[@"jg_ckie"]];//html免登录的cookies

            [self saveInfoDic:dic];
            
            [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber forKey:@"lastLoginName"];
            [UserInfoSingle sharedManager].goldAuthorization = [[(NSDictionary *)dic[@"data"][@"userInfo"] objectSafeForKey: @"nmAuthorization"] boolValue];
            [UserInfoSingle sharedManager].isSpecial = [[(NSDictionary *)dic[@"data"][@"userInfo"] objectSafeForKey: @"isSpecial"] boolValue];
            //更新验签串
            NSString *yanQian = [NSString stringWithFormat:@"%@%@%@",dic[@"loginName"],[UCFToolsMehod md5:[MD5Util MD5Pwd:_registerTwoView.getPassword]],dic[@"time"]];
            
            NSString *signatureStr  = [UCFToolsMehod md5:yanQian];
            NSString *gcmCode = [dic objectSafeForKey: @"promotionCode"]; //用户工场码
            [[NSUserDefaults standardUserDefaults] setObject:signatureStr forKey:SIGNATUREAPP];
            [[NSUserDefaults standardUserDefaults] setValue:gcmCode forKey:GCMCODE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 注册成功之后向iOS发送数据 验签串 和工场码Data
            [self sendiWatchSignature:signatureStr withGcm:gcmCode];
            //将个人中心table划到顶部
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
            //注册通知
            [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:BACK_TO_BANNER object:nil];//返回banner时刷新
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [[NSNotificationCenter defaultCenter] postNotificationName:IS_RELOADE_URL object:nil];
//            [[P2PWalletHelper sharedManager] getUserWalletData];

            [delegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                [LLLockPassword saveLockPassword:nil];
                [self showGestureCode];
                NSUInteger selectedIndex = delegate.tabBarController.selectedIndex;
                UINavigationController *nav = [delegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
                [nav popToRootViewControllerAnimated:NO];
            }];
        } else {
            NSInteger rstcode = [[dic valueForKey:@"code"] integerValue];
            NSString *message = [dic valueForKey:@"message"];
            if(rstcode == 2) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户名格式不正确" message:message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [alertView show];
            } else if(rstcode == 4) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }

    } else if (tag.intValue == kSXTagRegisterSendCodeAndFindPwd) {
        

//        NSString *rsttext = dic[@"message"];
        if ([[dic objectForKey:@"ret"] boolValue]) {
            if ([_curVerifyType isEqualToString:@"VMS"])
            {
                [MBProgressHUD displayHudError:@"系统正在准备外呼，请保持手机信号畅通"];
            }
            [self performSelector:@selector(veriFieldFstRepder:) withObject:nil afterDelay:2.5];
            [self verificatioCodeSend];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"message"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服", nil];
            alertView.tag = 1001;
            [NSTimer scheduledTimerWithTimeInterval:55.0f target:self selector:@selector(performDismiss:) userInfo:alertView repeats:NO];
            [alertView show];
        }
    }
}
#pragma mark  注册成功之后向iOS发送数据 验签串 和工场码Data
-(void)sendiWatchSignature:(NSString *)signatureStr withGcm:(NSString *)gcm{
    NSData *data = [Common createImageCode:gcm];
    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSDictionary *loginSuccessDic = @{@"userId":[UserInfoSingle sharedManager].userId, @"source_type":@"1",@"imei":[Common getKeychain],@"version":[Common getIOSVersion],@"signature":signatureStr,@"imageData":data,@"isSubmitAppStoreAndTestTime":@(del.isSubmitAppStoreTestTime).stringValue};
//    [[UCFSession sharedManager] transformBackgroundWithUserInfo:loginSuccessDic withState:UCFSessionStateUserLogin];
}

- (void)saveInfoDic:(NSDictionary *)dict
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray *allObj = [tempDic allKeys];
    for (int i = 0; i < allObj.count; i ++) {
        id obj = [tempDic objectForKey:allObj[i]];
        if ([obj isKindOfClass:[NSNull class]]) {
            [tempDic removeObjectForKey:allObj[i]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"regUserMsg"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4000322988"]];
        }
    }else {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [AuxiliaryFunc showToastMessage:@"当前没有网络，请检查网络！" withView:self.view];
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

- (void)verificatioCodeSend
{
    _timeNum = 60;
    [_registerTwoView setVatifacationBtnVisible:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfuc) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)timerfuc
{
    _timeNum --;
    if (_timeNum == 0) {
        [_timer invalidate];
        [_registerTwoView setVatifacationBtnVisible:YES];
        [_registerTwoView setVatifacationTitle:@"获取验证码"];
        //[_registerTwoView setVatiLabelHide:NO];
        //[_registerTwoView showVatiLabelText];
        //[_registerTwoView resetAllControlFrame];
    } else {
        [_registerTwoView setVatifacationTitle:[NSString stringWithFormat:@"%d秒后重新获取",_timeNum]];
    }
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if(del.window.rootViewController.presentingViewController == nil){
            UCFLockHandleViewController *lockVc = [[UCFLockHandleViewController alloc] init];
            lockVc.nLockViewType = type;
            lockVc.isFromRegister = YES;
            lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [del.window.rootViewController presentViewController:lockVc animated:NO completion:^{
        }];
    }
}

#pragma mark - 同盾
- (void) didReceiveDeviceBlackBox: (NSString *) blackBox {
//    NSString *wanip = [[NSUserDefaults standardUserDefaults] valueForKey:@"curWanIp"];
    NSString *blockId = blackBox;
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    //[parDic setValue:_registerTwoView.getUserName forKey:@"username"];
    [parDic setValue:@"AppStore" forKey:@"channelCode"];
    [parDic setValue:_phoneNumber forKey:@"phoneNo"];
    [parDic setValue:_registerTwoView.getVerficationCode forKey:@"validateCode"];
    [parDic setValue: [MD5Util MD5Pwd:_registerTwoView.getPassword] forKey:@"pwd"];
    [parDic setValue:_registerTwoView.getRefereesCode forKey:@"factoryCode"];
    [parDic setValue:@"1" forKey:@"sourceType"];
    [parDic setValue:blockId forKey:@"token_id"];
//    [parDic setValue:wanip forKey:@"ip"];
    [parDic setValue:_registerTokenStr forKey:@"registTicket"];
    [parDic setValue:@"1" forKey:@"userId"];
    if (![QDCODE isEqualToString:@""]) {
        [parDic setValue:QDCODE forKey:@"channelCode"];
    }
    [[NetworkModule sharedNetworkModule] newPostReq:parDic tag:kSXTagUserRegist owner:self signature:NO Type:SelectAccoutDefault];
}


@end
