//
//  UCFBatchBidWebViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBatchBidWebViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MyViewController.h"
@interface UCFBatchBidWebViewController ()
@property (nonatomic, assign) BOOL flagInvestSuc;
@end

@implementation UCFBatchBidWebViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.frame  = CGRectMake(0, 64, ScreenWidth, ScreenHeight -64);
    self.flagInvestSuc = NO;
    self.fd_interactivePopDisabled = YES;
    [self removeRefresh];
    [self gotoURLWithSignature2:self.url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化webView 并加入js


- (void)jsToNative:(NSString *)controllerName{
    
    if([controllerName isEqualToString:@"batchOrder"])
    {
        MyViewController *subVC = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
        subVC.title = @"我的投资";
        subVC.selectedSegmentIndex = 1;
        subVC.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

-(void)getToBack {//***根据你投资或者提现的成功的返回标识来判断是poptoroot 还是popviewcontroller（现在由于后台还没有调好暂时不加上）
    //    if(self.flagInvestSuc == YES)//***投资成功以后导航栏上的返回按钮返回的是投资列表页面
    //    {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
    //         [self.navigationController popToRootViewControllerAnimated:YES];
    //    } else {//***投资失败以后导航栏上的返回按钮返回的是投资填写页面
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHonerPlanData" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadP2PData" object:nil];
    [self jsClose];
}
- (void)jsClose
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeData" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
 
    if (self.rootVc) {
        [self.navigationController popToViewController:self.rootVc animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
   
}
- (void)jsInvestSuc:(BOOL)isSuc
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    self.flagInvestSuc = isSuc;
    //    if (isSuc) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
    //    else
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    
}

@end
