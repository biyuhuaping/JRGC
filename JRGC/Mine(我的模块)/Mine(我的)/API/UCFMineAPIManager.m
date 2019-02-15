//
//  UCFMineAPIManager.m
//  JRGC
//
//  Created by njw on 2017/9/22.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFMineAPIManager.h"
#import "NetworkModule.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "UIDic+Safe.h"
#import "UCFUserAssetModel.h"
#import "UCFUserBenefitModel.h"
#import "UCFSignModel.h"
#import "UCFSignView.h"
#import "MjAlertView.h"

@interface UCFMineAPIManager () <NetworkModuleDelegate>
{
    BOOL coinPageFlag;
}
@end

@implementation UCFMineAPIManager
- (void)getAssetFromNet
{
    NSString *userId =  SingleUserInfo.loginData.userInfo.userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagMyReceipt owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)getBenefitFromNet
{
    NSString *userId =  SingleUserInfo.loginData.userInfo.userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagMySimpleInfo owner:self signature:YES Type:SelectAccoutDefault];
}
//提现请求
- (void)getCashAccoutBalanceNet
{
    NSString *userId =  SingleUserInfo.loginData.userInfo.userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagGetAccountBalanceList owner:self signature:YES Type:SelectAccoutDefault];
}
//充值请求
- (void)getRecharngeBindingBankCardNet
{
    NSString *userId =  SingleUserInfo.loginData.userInfo.userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagGetBindingBankCardList owner:self signature:YES Type:SelectAccoutDefault];
}
//微金P2P提现请求
- (void)getP2PAccoutCashRuqestHTTP
{
    NSString *userId =  SingleUserInfo.loginData.userInfo.userId;
    if (!userId) {
        return;
    }
    NSString *userSatues = [NSString stringWithFormat:@"%@",SingleUserInfo.loginData.userInfo.openStatus];
    NSDictionary *parametersDict =  @{@"userId":userId,@"userSatues":userSatues};
    [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:SelectAccoutTypeP2P];
}
- (void)signWithToken:(NSString *)token
{
    NSString *userId =  SingleUserInfo.loginData.userInfo.userId;
    if (!userId || !token) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID], @"apptzticket":token} tag:kSXTagSingMenthod owner:self signature:YES Type:SelectAccoutDefault];
}
//进入工贝页面的请求
- (void)getUserIntoGoCoinPageHTTP:(BOOL)isCoinPage
{
    coinPageFlag = isCoinPage;
    if (isCoinPage) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID]} tag:kSXTagIntoCoinPage owner:self signature:YES Type:SelectAccoutDefault];
    } else {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"pageType":@"vip"} tag:kSXTagIntoCoinPage owner:self signature:YES Type:SelectAccoutDefault];
    }
}

- (void)beginPost:(kSXTag)tag
{
    UIViewController *vc = (UIViewController *)self.delegate;
    [MBProgressHUD showOriginHUDAddedTo:vc.view animated:YES];
//    if(tag == kSXTagGetAccountBalanceList || tag ==  kSXTagGetBindingBankCardList)
//    {
//        [MBProgressHUD showOriginHUDAddedTo:vc.view animated:YES];
//    }
//    else if (tag == kSXTagSingMenthod) {
//    }
//    else{
//    }
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    UIViewController *vc = (UIViewController *)self.delegate;
    [MBProgressHUD hideOriginAllHUDsForView:vc.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagMyReceipt) {
        
        if ([rstcode intValue] == 1) {
            
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                NSString *oepnState =  [resultData objectSafeForKey:@"openStatus"];
                 SingleUserInfo.loginData.userInfo.openStatus = [oepnState integerValue];
                NSString *zxOpenState = [resultData objectSafeForKey:@"zxOpenStatus"];
                 SingleUserInfo.loginData.userInfo.zxOpenStatus = zxOpenState;
                NSString *nmGoldAuthorization = [resultData objectSafeForKey:@"nmGoldAuthorization"];
                SingleUserInfo.loginData.userInfo.goldAuthorization = [nmGoldAuthorization integerValue];
                BOOL isCompanyAgent = [[resultData objectSafeForKey:@"isCompanyAgent"] boolValue];
                SingleUserInfo.loginData.userInfo.isCompanyAgent = isCompanyAgent;
                [SingleUserInfo setUserData:SingleUserInfo.loginData];
            }
            
            UCFUserAssetModel *userAsset = [UCFUserAssetModel userAssetWithDict:resultData];
            
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedReturnAssetResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedReturnAssetResult:userAsset withTag:[tag integerValue]];
            }
        }else {
            
            [AuxiliaryFunc showToastMessage:rsttext withView:vc.view];
        }
    }
    else if (tag.intValue == kSXTagMySimpleInfo) {
        if ([rstcode intValue] == 1) {
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            UCFUserBenefitModel *benefit = [UCFUserBenefitModel userBenefitWithDict:resultData];
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedReturnBenefitResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedReturnBenefitResult:benefit withTag:[tag integerValue]];
            }
        }else {
            
            [AuxiliaryFunc showToastMessage:rsttext withView:vc.view];
        }
    }
    else if (tag.intValue == kSXTagGetAccountBalanceList) {
        if ([rstcode intValue] == 1) {
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedCashAccoutBalanceResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedCashAccoutBalanceResult:resultData withTag:1];
            }
        }else {
            [self.delegate mineApiManager:self didSuccessedCashAccoutBalanceResult:rsttext withTag:2];
        }
    }else if (tag.intValue == kSXTagGetBindingBankCardList) {
        if ([rstcode intValue] == 1) {
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedRechargeBindingBankCardResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedRechargeBindingBankCardResult:resultData withTag:1];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedRechargeBindingBankCardResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedRechargeBindingBankCardResult:rsttext withTag:2];
            }
        }
    }
    else if (tag.intValue == kSXTagSingMenthod) {
        if ([dic[@"ret"] boolValue]) {
            NSDictionary *data = [dic objectForKey:@"data"];
            UCFSignModel *signModel = [UCFSignModel signWithDict:data];
            MjAlertView *alert = [[MjAlertView alloc] initRedBagAlertViewWithBlock:^(id blockContent) {
                UIView *view = (UIView *)blockContent;
                view.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
                UCFSignView *signView = [[UCFSignView alloc] initWithFrame:view.bounds];
                [view addSubview:signView];
                [view sendSubviewToBack:signView];
                signView.signModel = signModel;
            } delegate:self cancelButtonTitle:@"关闭"];
            alert.showViewbackImage = [UIImage imageNamed:@"checkin_bg"];
            [alert show];
        } else {
            UIViewController *vc = (UIViewController *)self.delegate;
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:vc.view];
        }
    }else if (tag.intValue == kSXTagCashAdvance) {
        if ([rstcode intValue] == 1) {
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedP2PAccoutCashBalanceResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedP2PAccoutCashBalanceResult:resultData withTag:1];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedP2PAccoutCashBalanceResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedP2PAccoutCashBalanceResult:rsttext withTag:2];
            }
        }
    }else if (tag.intValue == kSXTagIntoCoinPage) {
        if ([rstcode intValue] == 1) {
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedUserIntoGoCoinPageResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedUserIntoGoCoinPageResult:resultData withTag:coinPageFlag == YES ? 1 : 3];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedUserIntoGoCoinPageResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedUserIntoGoCoinPageResult:rsttext withTag:2];
            }
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    UIViewController *vc = (UIViewController *)self.delegate;
    if(tag.integerValue == kSXTagGetAccountBalanceList || tag.integerValue ==  kSXTagGetBindingBankCardList)
    {
        
        [MBProgressHUD hideOriginAllHUDsForView:vc.view animated:YES];
    }else{
        [MBProgressHUD hideOriginAllHUDsForView:vc.view animated:YES];
    }
    if (tag.integerValue == kSXTagMyReceipt) {
        if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedReturnAssetResult:withTag:)]) {
            [self.delegate mineApiManager:self didSuccessedReturnAssetResult:err withTag:[tag integerValue]];
        }
    }
    else if (tag.integerValue == kSXTagMySimpleInfo) {
        if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedReturnBenefitResult:withTag:)]) {
            [self.delegate mineApiManager:self didSuccessedReturnBenefitResult:err withTag:[tag integerValue]];
        }
    }else if (tag.integerValue == kSXTagGetAccountBalanceList) {
        if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedCashAccoutBalanceResult:withTag:)]) {
             [self.delegate mineApiManager:self didSuccessedCashAccoutBalanceResult:err.userInfo[@"NSLocalizedDescription"] withTag:0];
        }
    }else if (tag.integerValue == kSXTagGetBindingBankCardList) {
        if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedRechargeBindingBankCardResult:withTag:)]) {
            [self.delegate mineApiManager:self didSuccessedRechargeBindingBankCardResult:err.userInfo[@"NSLocalizedDescription"] withTag:0];
          
        }
    }else if (tag.integerValue == kSXTagCashAdvance) {
        if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedP2PAccoutCashBalanceResult:withTag:)]) {
            [self.delegate mineApiManager:self didSuccessedP2PAccoutCashBalanceResult:err.userInfo[@"NSLocalizedDescription"] withTag:0];
        }
    }
    else if (tag.integerValue == kSXTagIntoCoinPage) {
        if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedUserIntoGoCoinPageResult:withTag:)]) {
            [self.delegate mineApiManager:self didSuccessedUserIntoGoCoinPageResult:err.userInfo[@"NSLocalizedDescription"] withTag:0];
        }
    }
}

@end
