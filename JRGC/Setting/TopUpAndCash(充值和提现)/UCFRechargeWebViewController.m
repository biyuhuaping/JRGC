//
//  UCFRechargeWebViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2018/1/26.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFRechargeWebViewController.h"
#import "AppDelegate.h"
@interface UCFRechargeWebViewController ()
@property BOOL flagInvestSuc;
@end

@implementation UCFRechargeWebViewController

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
    
    DBLOG(@"%@", controllerName);
    if ([controllerName isEqualToString:@"app_recharge"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([controllerName isEqualToString:@"app_invest_immediately"]) {
        NSString *className = [NSString stringWithUTF8String:object_getClassName(self.rootVc)];
        if ([className hasSuffix:@"UCFPurchaseBidViewController"] || [className hasSuffix:@"UCFPurchaseTranBidViewController"] || [className hasSuffix:@"UCFSelectPayBackController"] || [className hasSuffix:@"UCFFacReservedViewController"]) {
            [self.navigationController popToViewController:self.rootVc animated:YES];
        }
        else if([className hasSuffix:@"UCFRechargeOrCashViewController"])
        {
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
                UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
                [nav popToRootViewControllerAnimated:NO];
                [appDelegate.tabBarController setSelectedIndex:0];
            }];
        }
        else{
            [self.navigationController popToRootViewControllerAnimated:NO];
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [appDelegate.tabBarController setSelectedIndex:0];
        }
    }
}
-(void)jsClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jsSetTitle:(NSString *)title
{
    if ([title isEqualToString:@"充值成功"]) {
        self.flagInvestSuc  = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOADP2PORHONERACCOTDATA object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEINVESTDATA" object:nil];
    }
    baseTitleLabel.text = title;
}

- (void)addRefresh //去掉页面刷新
{
    
}
-(void)getToBack
{
    if (self.flagInvestSuc  || [baseTitleLabel.text isEqualToString:@"充值成功"]) { //提现成功返回个人中心
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
