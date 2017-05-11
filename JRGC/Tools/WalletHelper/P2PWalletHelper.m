//
//  P2PWalletHelper.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "P2PWalletHelper.h"
#import "UcfWalletSDK.h"
#import "AppDelegate.h"
#import "UpgradeAccountVC.h"
#import "UCFWalletSelectBankCarViewController.h"

@implementation P2PWalletHelper

+ (UIViewController *)getUCFWalletTargetController
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
    [params setValue:@"MT10000000" forKey:@"merchantId"];
    [params setValue:@"402462" forKey:@"userId"];
//    [params setValue:@"张三" forKey:@"realName"];
//    [params setValue:@"112233444444402418" forKey:@"cardNo"];
//    [params setValue:@"18401255051" forKey:@"mobileNo"];
//    [params setValue:@"01" forKey:@"cardType"]; // 证件类型 01身份证，写死即可
    [params setValue:@"f156dc284e32b654860891a1e480d8f0" forKey:@"sign"];

   return [UcfWalletSDK wallet:params retHandler:self retSelector:@selector(walletCallBack) navTitle:@"生活"];
}
+ (void)walletCallBack
{
    
}
+ (NSString *)getSign
{
    NSString  *data = @"merchantId=MT10000000&userId=402462&key=hmYB5Ue6OPoHsW2YX5VlaQ";
    data = data.lowercaseString;
    NSString *sign = [Common md5:data];
    return sign;
}
+ (BOOL)checkUserHSStateCanOpenWallet
{
    if ([UserInfoSingle sharedManager].openStatus < 3 && [UserInfoSingle sharedManager].openStatus < 3) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        __weak typeof(app.tabBarController) weakSelf = app.tabBarController;
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:@"绑定银行卡后，才可以访问生活频道" cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
            //开通尊享徽商账户
            if (index == 1) {
                UpgradeAccountVC *accountVC = [[UpgradeAccountVC alloc] initWithNibName:@"UpgradeAccountVC" bundle:nil];
                accountVC.accoutType = SelectAccoutTypeHoner;
                accountVC.fromVC = 1;
                UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:accountVC];
                [weakSelf presentViewController:loginNaviController animated:YES completion:nil];
            }

        } otherButtonTitles:@"确定"];
        [alert show];
        return NO;
    } else if([UserInfoSingle sharedManager].openStatus > 3 && [UserInfoSingle sharedManager].openStatus > 3) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        __weak typeof(app.tabBarController) weakSelf = app.tabBarController;
        UCFWalletSelectBankCarViewController *selct = [[UCFWalletSelectBankCarViewController alloc] initWithNibName:@"UCFWalletSelectBankCarViewController" bundle:nil];
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:selct];
        [weakSelf presentViewController:loginNaviController animated:YES completion:nil];
        //让用户选择用哪张银行卡
        return NO;
        
    }else if([UserInfoSingle sharedManager].openStatus > 3 || [UserInfoSingle sharedManager].openStatus > 3) {
        //让用户进入钱包
        
        //更新用户数据
//        [UcfWalletSDK updateWalletBadgeWithMerchantId:<#(NSString *)#> UserId:<#(NSString *)#> isDelete:<#(BOOL)#> result:<#^(NSDictionary *resultDict)result#>]
        return YES;
    }
    return YES;
}
@end
