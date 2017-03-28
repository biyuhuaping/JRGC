//
//  HSHelper.m
//  JRGC
//
//  Created by 金融工场 on 2017/3/28.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "HSHelper.h"

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
            UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
            bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
            [nav pushViewController:bankDepositoryAccountVC animated:YES];
        } else {
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
            [nav pushViewController:vc animated:YES];
        }
    } else {
        UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:step];
        [nav pushViewController:vc animated:YES];
    }
}
@end
