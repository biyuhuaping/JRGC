//
//  HSHelper.m
//  JRGC
//
//  Created by 金融工场 on 2017/3/28.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "HSHelper.h"
@interface HSHelper ()
{
    UINavigationController * tmpNav;
    NSInteger tmpStep;
    SelectAccoutType _accoutType;
}
@end
@implementation HSHelper

-(NSString *)checkCompanyIsOpen:(SelectAccoutType)accoutType{
     NSString *messageStr = @"";
    if (SingleUserInfo.loginData.userInfo.isCompanyAgent) {//企业老用户
   
      if (accoutType == SelectAccoutTypeHoner) {
        
        if([SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] < 3){
          messageStr =@"请先登录金融工场网站开通尊享徽商存管账户";
        }
      }else{
        if(SingleUserInfo.loginData.userInfo.openStatus < 3){
        messageStr =@"请先登录金融工场网站开通微金徽商存管账户";
        }
      }
    }
    return messageStr;
}

-(BOOL)checkP2POrWJIsAuthorization:(SelectAccoutType)accoutType{
    
    if (accoutType == SelectAccoutTypeHoner) {
        return SingleUserInfo.loginData.userInfo.zxAuthorization;
    }else{
        return YES;
//          return [UserInfoSingle sharedManager].p2pAuthorization;
    }
    return NO;
}

- (BOOL)checkHSState:(SelectAccoutType)type withValue:(NSInteger)vlaue
{
    if (vlaue == 4) {
        return YES;
    } else {
        return NO;
    }
}
- (void)pushP2POrWJAuthorizationType:(SelectAccoutType)type nav:(UINavigationController *)nav
{
    UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
//    bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
    bankDepositoryAccountVC.accoutType = type;
    [nav pushViewController:bankDepositoryAccountVC animated:YES];
}
- (void)pushGoldAuthorizationType:(SelectAccoutType)type nav:(UINavigationController *)nav sourceVC:(NSString *)soucreFrom
{
    UCFGoldAuthorizationViewController * bankDepositoryAccountVC =[[UCFGoldAuthorizationViewController alloc ]initWithNibName:@"UCFGoldAuthorizationViewController" bundle:nil];
    bankDepositoryAccountVC.sourceVc = soucreFrom;
    bankDepositoryAccountVC.accoutType = type;
    [nav pushViewController:bankDepositoryAccountVC animated:YES];
}
- (void)pushGoldAuthorizationType:(SelectAccoutType)type nav:(UINavigationController *)nav
{
    [self pushGoldAuthorizationType:type nav:nav sourceVC:@""];
}

- (void)pushOpenHSType:(SelectAccoutType)type Step:(NSInteger)step nav:(UINavigationController *)nav;
{
    [self pushOpenHSType:type Step:step nav:nav isPresentView:NO];
}
//isPrensentView 视图是否是模态出来的 默认是NO
- (void)pushOpenHSType:(SelectAccoutType)type Step:(NSInteger)step nav:(UINavigationController *)nav isPresentView:(BOOL)isPresent
{
    _accoutType = type;
    tmpNav = nav;
    tmpStep = step;
    if (type == SelectAccoutTypeHoner) {
        if (step == 1) {
            step = 2;
        }
        UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
        vc.accoutType = SelectAccoutTypeHoner;
        vc.isPresentViewController = isPresent;
        [nav pushViewController:vc animated:YES];
    } else {
        if (step == 1 ) {
            step = 2;
        }
        UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
        vc.accoutType = SelectAccoutTypeP2P;
        vc.isPresentViewController = isPresent;
        [nav pushViewController:vc animated:YES];
    }
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    BOOL ret = [[dic objectSafeForKey:@"ret"] boolValue];
    
    switch (tag.intValue) {
        case kSXTagGetUserAgreeState:
        {
            if (ret) {
                
                if (![dic[@"data"][@"zxIsAuthorization"] boolValue]) {
                    UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
                    bankDepositoryAccountVC.openStatus = SingleUserInfo.loginData.userInfo.openStatus;
                    bankDepositoryAccountVC.accoutType = _accoutType;
                    [tmpNav pushViewController:bankDepositoryAccountVC animated:YES];
                } else {
                    UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
//                    vc.site = @"2";
                    vc.accoutType = SelectAccoutTypeHoner;
                    [tmpNav pushViewController:vc animated:YES];
                }
            } else {
                [MBProgressHUD displayHudError:dic[@"message"]];
            }

        }
            break;
        case KSXTagP2pISAuthorization:
        {
            if (ret) {
                
                if (![dic[@"data"][@"p2pIsAuthorization"] boolValue]) {//未授权
                    UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
                    bankDepositoryAccountVC.openStatus = SingleUserInfo.loginData.userInfo.openStatus;
                     bankDepositoryAccountVC.accoutType = _accoutType;
                    [tmpNav pushViewController:bankDepositoryAccountVC animated:YES];
                } else { //已经授权
                    UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
//                    vc.site = @"2";
                    vc.accoutType = SelectAccoutTypeHoner;
                    [tmpNav pushViewController:vc animated:YES];
                }
            } else {
                [MBProgressHUD displayHudError:dic[@"message"]];
            }
            
        }
            break;
        default:
            break;
    }
   }
- (void)beginPost:(kSXTag)tag
{
    
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}
@end
