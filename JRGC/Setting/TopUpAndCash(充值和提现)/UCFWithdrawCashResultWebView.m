//
//  UCFWithdrawCashResultWebView.m
//  JRGC
//
//  Created by hanqiyuan on 16/9/19.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWithdrawCashResultWebView.h"
#import "AppDelegate.h"
@interface UCFWithdrawCashResultWebView ()
@property BOOL flagInvestSuc;
@end

@implementation UCFWithdrawCashResultWebView


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flagInvestSuc = NO;
    [self gotoURLWithSignature:self.url];
}
- (void)jsInvestSuc:(BOOL)isSuc
{
    self.flagInvestSuc = isSuc;
}
- (void)jsToNative:(NSString *)controllerName{
    
    if ([controllerName isEqualToString:@"app_withdraw"])//提现成功页面红色按妞
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        NSString *className = [NSString stringWithUTF8String:object_getClassName(self.rootVc)];
        if([className hasSuffix:@"UCFRechargeOrCashViewController"])
        {
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
                UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
                [nav popToRootViewControllerAnimated:NO];
            }];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [self refreshMineHome];
     
    }
    else if ([controllerName  isEqualToString:@"app_withdraw_recharge"])//提现失败页面
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([controllerName isEqualToString:@"app_withdraw_suc"]) //提现成功标识
    {
        self.flagInvestSuc = YES;
    }
    
}
- (void)addRefresh //去掉页面刷新
{
}
-(void)getToBack{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADP2PORHONERACCOTDATA object:nil];
    
    if (self.flagInvestSuc) { //提现成功返回个人中心
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        NSString *className = [NSString stringWithUTF8String:object_getClassName(self.rootVc)];
        if([className hasSuffix:@"UCFRechargeOrCashViewController"])
        {
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
                UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
                [nav popToRootViewControllerAnimated:NO];
            }];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self refreshMineHome];
}


- (void)refreshMineHome
{
    RTRootNavigationAddPushController *nav = SingGlobalView.tabBarController.viewControllers.lastObject;
    UCFBaseViewController *bs = nav.rt_viewControllers.firstObject;
    if ([bs isKindOfClass:[UCFBaseViewController class]]) {
        [bs monitorOpenStatueChange];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
