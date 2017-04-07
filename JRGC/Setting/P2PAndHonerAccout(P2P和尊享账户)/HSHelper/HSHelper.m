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
}
@end
@implementation HSHelper

- (BOOL)checkHSState:(SelectAccoutType)type withValue:(NSInteger)vlaue
{
    if (vlaue == 4) {
        return YES;
    } else {
        return NO;
    }
}
- (void)pushOpenHSType:(SelectAccoutType)type Step:(NSInteger)step nav:(UINavigationController *)nav;
{
    if (type == SelectAccoutTypeHoner) {
        if (step == 1) {
            tmpNav = nav;
            tmpStep = step;
            [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:kSXTagGetUserAgreeState owner:self signature:YES Type:SelectAccoutTypeHoner];
        } else {
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
            vc.site = @"2";
            [nav pushViewController:vc animated:YES];
        }
    } else {
        if (step == 1) {
            step = 2;
        }
        UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
        vc.site = @"1";
        [nav pushViewController:vc animated:YES];
    }
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if ([dic[@"ret"] boolValue]) {
        if ([dic[@"data"][@"zxIsAuthorization"] isEqualToString:@"false"]) {
            UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
            bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
            [tmpNav pushViewController:bankDepositoryAccountVC animated:YES];
        } else {
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
            vc.site = @"2";
            [tmpNav pushViewController:vc animated:YES];
//            NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:tmpNav.viewControllers];
//            [navVCArray removeObjectAtIndex:navVCArray.count-2];
//            [tmpNav setViewControllers:navVCArray animated:NO];
        }
    } else {
        [MBProgressHUD displayHudError:dic[@"message"]];
    }
}
- (void)beginPost:(kSXTag)tag
{
    
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}
@end
