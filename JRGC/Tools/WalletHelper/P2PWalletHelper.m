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

@interface P2PWalletHelper ()
@property(strong, nonatomic) NSDictionary *paramDict;
@property(strong, nonatomic) UIViewController *walletController;
@end

@implementation P2PWalletHelper

+ (P2PWalletHelper *)sharedManager
{
    static P2PWalletHelper *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (UIViewController *)getUCFWalletTargetController
{
    if (!self.paramDict) {
        self.walletController = [UcfWalletSDK wallet:nil retHandler:self retSelector:nil navTitle:@"生活"];
        return _walletController;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
    [params setValue:@"MT10000000" forKey:@"merchantId"];
    [params setValue:@"402462" forKey:@"userId"];
//    [params setValue:@"张三" forKey:@"realName"];
//    [params setValue:@"112233444444402418" forKey:@"cardNo"];
//    [params setValue:@"18401255051" forKey:@"mobileNo"];
//    [params setValue:@"01" forKey:@"cardType"]; // 证件类型 01身份证，写死即可
    [params setValue:@"f156dc284e32b654860891a1e480d8f0" forKey:@"sign"];
    self.walletController =  [UcfWalletSDK wallet:params retHandler:self retSelector:nil navTitle:@"生活"];
    return _walletController;
}

- (NSString *)getSign
{
    NSString  *data = [NSString stringWithFormat:@"merchantId=MT10000000&userId=%@&key=hmYB5Ue6OPoHsW2YX5VlaQ",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    data = data.lowercaseString;
    NSString *sign = [Common md5:data];
    return sign;
}
- (BOOL)checkUserHSStateCanOpenWallet
{
    if (!self.paramDict) {
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
    } else if([self.paramDict[@"bankList"] count] > 1) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        __weak typeof(app.tabBarController) weakSelf = app.tabBarController;
        UCFWalletSelectBankCarViewController *selct = [[UCFWalletSelectBankCarViewController alloc] initWithNibName:@"UCFWalletSelectBankCarViewController" bundle:nil];
        selct.dataDict = [NSDictionary dictionaryWithDictionary:self.paramDict];
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:selct];
        [weakSelf presentViewController:loginNaviController animated:YES completion:nil];
        //让用户选择用哪张银行卡
        return NO;
        
    }else if([self.paramDict[@"bankList"] count] == 1) {
        //更新用户数据
        NSArray *arr = self.paramDict[@"bankList"];
        NSDictionary *dict = [arr objectAtIndex:0];
        [self refreshWalletData:dict];
        return YES;
    }
    return YES;
}
- (void)refreshWalletData:(NSDictionary *)dict
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
    [params setValue:@"MT10000000" forKey:@"merchantId"];
    [params setValue:[NSString stringWithFormat:@"%@",dict[@"userId"]] forKey:@"userId"];
    [params setValue:dict[@"realName"] forKey:@"realName"];
    [params setValue:[NSString stringWithFormat:@"%@",dict[@"bankCard"]] forKey:@"cardNo"];
    [params setValue:[NSString stringWithFormat:@"%@",dict[@"phone"]] forKey:@"mobileNo"];
    [params setValue:@"01" forKey:@"cardType"]; // 证件类型 01身份证，写死即可
    [params setValue:[self getSign] forKey:@"sign"];
    [UcfWalletSDK refreshWalletVC:params navTitle:@"生活" walletVC:_walletController];
}
#pragma mark NetworkModuleDelegate
- (void)getUserWalletData
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:KSXTagWalletShowMsg owner:self signature:YES Type:SelectAccoutDefault];
    }
}
-(void)beginPost:(kSXTag)tag
{
    
}
-(void)endPost:(id)result tag:(NSNumber*)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == KSXTagWalletShowMsg) {
        if ([dic[@"ret"] boolValue]) {
            NSDictionary *dataDict = dic[@"data"];
            if ([dataDict[@"isOpen"] boolValue]) {
                NSArray *bankArr = dataDict[@"bankList"];
                if (bankArr.count > 0) {
                    self.paramDict = dataDict;
                    if (_walletController) {
                        [UcfWalletSDK refreshWalletVC:nil navTitle:@"生活" walletVC:_walletController];
                    } else {
                    }
                }
            } else {
                self.paramDict = nil;
            }
        } else {
            self.paramDict = nil;
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    self.paramDict = nil;
}

@end
