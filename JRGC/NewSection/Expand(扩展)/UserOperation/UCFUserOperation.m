//
//  UCFUserOperation.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFUserOperation.h"
#import "UCFToolsMehod.h"
#import "MD5Util.h"
#import "AppDelegate.h"
#import "FMDeviceManager.h"
#import "UCFLoginModel.h"
@implementation UCFUserOperation

+ (void)setUserData:(UCFLoginData *) loginData{
    
    NSDictionary *dic ;
    //注册成功后，先清cookies，把老账户的清除掉，然后再用新账户的信息
    [Common deleteCookies];
    //登录成功保存用户的资料
    dic = dic[@"data"][@"userInfo"];
    
    [[UserInfoSingle sharedManager] setUserData:dic];
    [Common setHTMLCookies:dic[@"jg_ckie"]];//html免登录的cookies
    
    [self saveInfoDic:dic];
    
//    [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber forKey:@"lastLoginName"];
    [UserInfoSingle sharedManager].goldAuthorization = [[(NSDictionary *)dic[@"data"][@"userInfo"] objectSafeForKey: @"nmAuthorization"] boolValue];
    [UserInfoSingle sharedManager].isSpecial = [[(NSDictionary *)dic[@"data"][@"userInfo"] objectSafeForKey: @"isSpecial"] boolValue];
    //更新验签串
//    NSString *yanQian = [NSString stringWithFormat:@"%@%@%@",dic[@"loginName"],[UCFToolsMehod md5:[MD5Util MD5Pwd:_registerTwoView.getPassword]],dic[@"time"]];
    
//    NSString *signatureStr  = [UCFToolsMehod md5:yanQian];
    NSString *signatureStr  = [UCFToolsMehod md5:@""];
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
        NSString *gode = [LLLockPassword loadLockPassword];
        if (gode) {
            [self showLLLockViewController:LLLockViewTypeCheck];
        } else {
            [self showLLLockViewController:LLLockViewTypeCreate];
        };
        NSUInteger selectedIndex = delegate.tabBarController.selectedIndex;
        UINavigationController *nav = [delegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
        [nav popToRootViewControllerAnimated:NO];
    }];
}
+ (void)saveInfoDic:(NSDictionary *)dict
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
#pragma mark  注册成功之后向iOS发送数据 验签串 和工场码Data
+ (void)sendiWatchSignature:(NSString *)signatureStr withGcm:(NSString *)gcm{
    NSData *data = [Common createImageCode:gcm];
    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSDictionary *loginSuccessDic = @{@"userId":[UserInfoSingle sharedManager].userId, @"source_type":@"1",@"imei":[Common getKeychain],@"version":[Common getIOSVersion],@"signature":signatureStr,@"imageData":data,@"isSubmitAppStoreAndTestTime":@(del.isSubmitAppStoreTestTime).stringValue};
    //    [[UCFSession sharedManager] transformBackgroundWithUserInfo:loginSuccessDic withState:UCFSessionStateUserLogin];
}

#pragma mark - 弹出手势解锁密码输入框
+ (void)showLLLockViewController:(LLLockViewType)type
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

+ (void)saveLoginPhoneNum:(NSDictionary *)dic
{
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"userType",@"",@"phoneNum", nil];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"lastLoginName"];
}

+ (NSDictionary *)getLoginPhoneNum
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"];
}


#pragma mark - 同盾
+ (NSString *) didReceiveDeviceBlackBox{
    
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    //    manager->getDeviceInfoAsync(nil, self);
    //#warning 同盾修改
    NSString *blackBox = manager->getDeviceInfo();
    return blackBox;
}










+ (UCFLoginData *)getUserData
{
    UCFLoginData *data;
    return data;
}

+ (void)deleteUserData{}

@end
