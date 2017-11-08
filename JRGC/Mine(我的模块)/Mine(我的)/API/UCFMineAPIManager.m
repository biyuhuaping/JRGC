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

@interface UCFMineAPIManager () <NetworkModuleDelegate>

@end

@implementation UCFMineAPIManager
- (void)getAssetFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagMyReceipt owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)getBenefitFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagMySimpleInfo owner:self signature:YES Type:SelectAccoutDefault];
}
//提现请求
- (void)getCashAccoutBalanceNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagGetAccountBalanceList owner:self signature:YES Type:SelectAccoutDefault];
}
//充值请求
- (void)getRecharngeBindingBankCardNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagGetBindingBankCardList owner:self signature:YES Type:SelectAccoutDefault];
}
- (void)beginPost:(kSXTag)tag
{
    UIViewController *vc = (UIViewController *)self.delegate;

    [MBProgressHUD showOriginHUDAddedTo:vc.view animated:YES];
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagMyReceipt) {
        UIViewController *vc = (UIViewController *)self.delegate;
        [MBProgressHUD hideOriginAllHUDsForView:vc.view animated:YES];
        if ([rstcode intValue] == 1) {
            
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                NSString *oepnState =  [resultData objectSafeForKey:@"openStatus"];
                [UserInfoSingle sharedManager].openStatus = [oepnState integerValue];
                NSString *zxOpenState = [resultData objectSafeForKey:@"zxOpenStatus"];
                [UserInfoSingle sharedManager].enjoyOpenStatus = [zxOpenState integerValue];
                BOOL isCompanyAgent = [[resultData objectSafeForKey:@"isCompanyAgent"] boolValue];
                [UserInfoSingle sharedManager].companyAgent = isCompanyAgent;
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
        UIViewController *vc = (UIViewController *)self.delegate;
        [MBProgressHUD hideOriginAllHUDsForView:vc.view animated:YES];
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
        UIViewController *vc = (UIViewController *)self.delegate;
        [MBProgressHUD hideOriginAllHUDsForView:vc.view animated:YES];
        if ([rstcode intValue] == 1) {
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([self.delegate respondsToSelector:@selector(mineApiManager:didSuccessedCashAccoutBalanceResult:withTag:)]) {
                [self.delegate mineApiManager:self didSuccessedCashAccoutBalanceResult:resultData withTag:1];
            }
        }else {
            [self.delegate mineApiManager:self didSuccessedCashAccoutBalanceResult:rsttext withTag:2];
        }
    }else if (tag.intValue == kSXTagGetBindingBankCardList) {
        UIViewController *vc = (UIViewController *)self.delegate;
        [MBProgressHUD hideOriginAllHUDsForView:vc.view animated:YES];
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
    }
}

@end
