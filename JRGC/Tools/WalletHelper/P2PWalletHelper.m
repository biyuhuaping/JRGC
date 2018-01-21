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
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:WALLET_DATADICT];
    self.paramDict = dict;
    if (!self.paramDict) {
        
        self.walletController = [UcfWalletSDK wallet:nil retHandler:self retSelector:nil navTitle:@"生活"];
        return _walletController;
    }
    self.walletController =  [UcfWalletSDK wallet:[self resetWalletDataDict:self.paramDict] retHandler:self retSelector:nil navTitle:@"生活"];
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
    if (!self.paramDict || [self.paramDict[@"bankList"] count] == 0) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        __weak typeof(app.tabBarController) weakSelf = app.tabBarController;
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:@"绑定银行卡后，才可以访问生活频道" cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
            //开通尊享徽商账户
            if (index == 1) {
                UpgradeAccountVC *accountVC = [[UpgradeAccountVC alloc] initWithNibName:@"UpgradeAccountVC" bundle:nil];
                accountVC.fromVC = 1;
                accountVC.accoutType = SelectAccoutTypeP2P;

//                if ([UserInfoSingle sharedManager].superviseSwitch) {
//                    if ([UserInfoSingle sharedManager].level > 1) {
//                        accountVC.accoutType = SelectAccoutTypeHoner;
//                    }
//                    else {
//                        if ([UserInfoSingle sharedManager].zxIsNew) {
//                            accountVC.accoutType = SelectAccoutTypeP2P;
//                        } else {
//                            accountVC.accoutType = SelectAccoutTypeHoner;
//                        }
//                    }
//                } else {
//                    accountVC.accoutType = SelectAccoutTypeHoner;
//                }
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
        [self refreshWalletData:self.paramDict];
        NSDictionary *dic = [self.paramDict[@"bankList"] objectAtIndex:0];
        if (![self.paramDict[@"isBindCard"] boolValue]) {
            [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"selectType":dic[@"accType"]} tag:kSXTagWalletSelectBankCar owner:self signature:YES Type:SelectAccoutDefault];
        }

        return YES;
    }
    return YES;
}
- (NSDictionary *)resetWalletDataDict:(NSDictionary *)dict
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
    NSDictionary *bankDic = dict[@"bankList"][0];
    [params setValue:dict[@"merchantId"] forKey:@"merchantId"];
    [params setValue:[NSString stringWithFormat:@"%@",bankDic[@"userId"]] forKey:@"userId"];
    [params setValue:bankDic[@"realName"] forKey:@"realName"];
    [params setValue:[NSString stringWithFormat:@"%@",bankDic[@"idNo"]] forKey:@"cardNo"];
    [params setValue:[NSString stringWithFormat:@"%@",bankDic[@"phone"]] forKey:@"mobileNo"];
    [params setValue:@"01" forKey:@"cardType"]; // 证件类型 01身份证，写死即可
    [params setValue:[NSString stringWithFormat:@"%@",bankDic[@"bankCard"]] forKey:@"bankCardNo"];
    [params setValue:[NSString stringWithFormat:@"%@",bankDic[@"bankPhone"]] forKey:@"bankCardPhone"];
    [params setValue:dict[@"sign"] forKey:@"sign"];
    return params;
}
- (void)refreshWalletData:(NSDictionary *)dict
{
    [UcfWalletSDK refreshWalletVC:[self resetWalletDataDict:dict] navTitle:@"生活" walletVC:_walletController];
//    [self changeTabMoveToWalletTabBar];
}
#pragma mark NetworkModuleDelegate
- (void)getUserWalletData:(GetWalletDataSource)source;
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
            self.paramDict = dataDict;
            //1银行卡默认被选中，存储到本地
            if ([self.paramDict[@"bankList"] count] == 1) {
                if (self.source == GetWalletDataOpenHS) {
                    [UcfWalletSDK refreshWalletVC:[self resetWalletDataDict:self.paramDict] navTitle:@"生活" walletVC:_walletController];
                    //去绑定开通的这张银行卡
                    if (![dataDict[@"isBindCard"] boolValue]) {
                        NSDictionary *bankDic = self.paramDict[@"bankList"][0];
                        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"selectType":bankDic[@"accType"]} tag:kSXTagWalletSelectBankCar owner:self signature:YES Type:SelectAccoutDefault];
                    }
                } else if (self.source == GetWalletDataTwoBank) {
                    
                }
                [[NSUserDefaults standardUserDefaults] setValue:dataDict forKey:WALLET_DATADICT];
            }
        } else {

        }
    } else if (tag.integerValue == kSXTagWalletSelectBankCar) {
        if ([dic[@"ret"] boolValue]) {
         
        } else {
            
        }
    }
    
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
//    self.paramDict = nil;
}
- (void)changeTabMoveToWalletTabBar
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.tabBarController setSelectedIndex:3];
//    [self getUserWalletData];
}
@end
