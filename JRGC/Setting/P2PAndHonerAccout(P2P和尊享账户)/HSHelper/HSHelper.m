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
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"isCompanyAgentType" ]) {//企业老用户
   
      if (accoutType == SelectAccoutTypeHoner) {
        
        if([UserInfoSingle sharedManager].enjoyOpenStatus < 3){
          messageStr =@"请先登录金融工场网站开通尊享微商存管账户";
        }
      }else{
        if([UserInfoSingle sharedManager].openStatus < 3){
        messageStr =@"请先登录金融工场网站开通微金微商存管账号户";
        }
      }
    }
    return messageStr;
}

-(BOOL)checkP2POrWJIsAuthorization:(SelectAccoutType)accoutType{
    
    if (accoutType == SelectAccoutTypeHoner) {
        return [UserInfoSingle sharedManager].zxAuthorization;
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

- (void)pushOpenHSType:(SelectAccoutType)type Step:(NSInteger)step nav:(UINavigationController *)nav;
{
    _accoutType = type;
    tmpNav = nav;
    tmpStep = step;
    if (type == SelectAccoutTypeHoner) {
        if (step == 1) {
            step = 2;
//            [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:kSXTagGetUserAgreeState owner:self signature:YES Type:SelectAccoutTypeHoner];
        }
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
            vc.site = @"2";
            vc.accoutType = SelectAccoutTypeHoner;
            [nav pushViewController:vc animated:YES];
    } else {
        if (step == 1 ) {
            step = 2;
//             [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:KSXTagP2pISAuthorization owner:self signature:YES Type:SelectAccoutTypeP2P];
        }
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
            vc.site = @"1";
            vc.accoutType = SelectAccoutTypeP2P;
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
                    bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
                    bankDepositoryAccountVC.accoutType = _accoutType;
                    [tmpNav pushViewController:bankDepositoryAccountVC animated:YES];
                } else {
                    UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
                    vc.site = @"2";
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
                    bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
                     bankDepositoryAccountVC.accoutType = _accoutType;
                    [tmpNav pushViewController:bankDepositoryAccountVC animated:YES];
                } else { //已经授权
                    UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
                    vc.site = @"2";
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
