//
//  UCFMainTabBarController.m
//  JRGC
//
//  Created by JasonWong on 14-9-5.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFMainTabBarController.h"
#import "UCFLoginViewController.h"
#import "UCFLatestProjectViewController.h"
#import "UCFAssignmentCreditorViewController.h"
#import "UCFSettingViewController.h"
#import "UCFMoreViewController.h"
#import "AppDelegate.h"

#import "BaseNavigationViewController.h"
#import "UITabBar+TabBarBadge.h"
#import "Touch3DSingle.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFOldUserGuideViewController.h"
#import "UCFProjectListController.h"

@interface UCFMainTabBarController ()

@property (strong, nonatomic) UCFLatestProjectViewController *LatestView;
//@property (strong, nonatomic) UCFAssignmentCreditorViewController *AssignmentView;
@property (strong, nonatomic) UCFProjectListController *AssignmentView;
@end

@implementation UCFMainTabBarController
- (void)viewDidLoad
{   
    [super viewDidLoad];
    [self initAllTabbarItems];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [tapGestureRecognizer setNumberOfTapsRequired:2];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.tabBar addGestureRecognizer:tapGestureRecognizer];
    
    
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    UIImageView *imaview = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, ScreenWidth, 10)];
    //imaview.backgroundColor = [UIColor redColor];
    imaview.image = tabImag;
    self.tabBar.clipsToBounds = NO;
    [self.tabBar addSubview:imaview];
    [[UITabBar appearance] setShadowImage:tabImag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initAllTabbarItems
{
    NSMutableArray *vcArray = [NSMutableArray array];
    NSArray *tabbarTitleArray = @[@"首页",
                                  @"产品列表",
                                  @"豆哥商城",
                                  @"个人中心"];
    NSArray *tabbarNormalArray = @[@"tabbar_icon_homepage_normal.png",
                                   @"tabbar_icon_project_normal.png",//tabbar_icon_transfer_normal.png
                                   @"tabbar_icon_shop_normal.png",
                                   @"tabbar_icon_user_normal.png"];
    NSArray *tabbarHighlightArray = @[@"tabbar_icon_homepage_highlight.png",
                                   @"tabbar_icon_project_highlight.png",//tabbar_icon_transfer_highlight.png
                                   @"tabbar_icon_shop_highlight.png",
                                      @"tabbar_icon_user_highlight.png"];
    
    UIViewController *controller = nil;
    for (int i=0; i<4; i++) {
        switch (i) {
            case 0:{
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
                _LatestView = [storyBoard instantiateViewControllerWithIdentifier:@"home"];
                _LatestView.baseTitleType = @"list";
                controller = _LatestView;
            }
                break;
            case 1:{
//                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UCFAssignmentCreditor" bundle:nil];
//                self.AssignmentView = [storyBoard instantiateViewControllerWithIdentifier:@"UCFAssignmentCreditorStoryboard"];
//                self.AssignmentView.baseTitleType = @"list";
//                controller = _AssignmentView;
                self.AssignmentView = [[UCFProjectListController alloc] initWithNibName:@"UCFProjectListController" bundle:nil];
                self.AssignmentView.baseTitleType = @"list";
                controller = _AssignmentView;
            }
                break;
            case 2:{
               
                UCFWebViewJavascriptBridgeMall *mallWeb = [[UCFWebViewJavascriptBridgeMall alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
                mallWeb.url = MALLURL;
                mallWeb.isHideNavigationBar = YES;
                [self useragent:mallWeb.webView];
                controller = mallWeb;
                mallWeb.navTitle = @"豆哥商城";
    
            }
                break;
            case 3:{
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
//                controller = [storyboard instantiateViewControllerWithIdentifier:@"settinghome"];
                controller = [[UCFSettingViewController alloc] initWithNibName:@"UCFSettingViewController" bundle:nil];
            }
                break;
            default:
                controller = nil;
                break;
        }
        if (controller) {
            [vcArray addObject:[[BaseNavigationViewController alloc] initWithRootViewController:controller]];
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:tabbarTitleArray[i] image:[[UIImage imageNamed:tabbarNormalArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:tabbarHighlightArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            item.tag = i;
            controller.tabBarItem = item;
        }
    }
    
    self.viewControllers = vcArray;
    self.delegate = self;
    [self.tabBar setClipsToBounds:YES];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorWithRGB(0x536f95), NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorWithRGB(0xfd4d4c), NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6){
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignmentUpdate" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
}

- (void)gestureRecognizerHandle:(UITapGestureRecognizer *)sender{
    CGPoint p = [sender locationInView:self.tabBar];
    int index = p.x/(ScreenWidth/4);
    
    switch (index) {
        case 0:{
            [_LatestView.tableView.header beginRefreshing];
        }
            break;
        case 1:{
//            [_AssignmentView.tableView.header beginRefreshing];
        }
            break;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BaseNavigationViewController *contrl = (BaseNavigationViewController*)viewController;
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
    UIViewController *topView = nil;
    if (contrl.viewControllers.count != 0) {
      topView = [contrl.viewControllers objectAtIndex:0];
    }
    if ([topView isKindOfClass:[UCFWebViewJavascriptBridgeMall class]]) {
        UCFWebViewJavascriptBridgeMall *mallWeb = [[UCFWebViewJavascriptBridgeMall alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
        mallWeb.url = MALLURL;
        mallWeb.rootVc = tabBarController.viewControllers[tabBarController.selectedIndex];
        mallWeb.isHideNavigationBar = YES;
        [self useragent:mallWeb.webView];
        mallWeb.navTitle = @"豆哥商城";
        mallWeb.isTabbarfrom = YES;
        mallWeb.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        UINavigationController *mallWebNaviController = [[UINavigationController alloc] initWithRootViewController:mallWeb];
//        SecondViewController *vc1 = [[SecondViewController alloc]init];
//        UITableViewController *settingVC = [[UITableViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self presentViewController:mallWebNaviController animated:YES completion:nil];
        
        return YES;
     }
    
    if ([topView isKindOfClass:[UCFSettingViewController class]] ) {
        if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
//            UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
//            loginViewController.sourceVC = @"fromPersonCenter";
//            BaseNavigationViewController *loginNaviController = [[BaseNavigationViewController alloc] initWithRootViewController:loginViewController];
//            loginViewController.sourceVC = @"homePage";
//            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"personCenterClick"];
//            [self presentViewController:loginNaviController animated:YES completion:nil];
//            [Touch3DSingle sharedTouch3DSingle].isLoad = NO;
//            return NO;
            self.selectedViewController = viewController;
            return YES;
        } else {
            if (![viewController isEqual:self.selectedViewController]) {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:@"fromTabBar" forKey:@"source"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:dict];
            }
            self.selectedViewController = viewController;
            return YES;
        }
    }
    return YES;
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    NSInteger index = item.tag;
//    if (index == 2) {
//        if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
//            UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
//            loginViewController.sourceVC = @"fromPersonCenter";
//            BaseNavigationViewController *loginNaviController = [[BaseNavigationViewController alloc] initWithRootViewController:loginViewController];
//            [self presentViewController:loginNaviController animated:YES completion:nil];
//        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:UCFGETPERSONALNETWORKINFO object:nil];
//            return;
//        }
//    }
//}


- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items
{

}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
        BaseNavigationViewController *loginNaviController = [[BaseNavigationViewController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginNaviController animated:YES completion:nil];
    }
}

-(void)checkLogin
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    loginViewController.sourceVC = @"fromPersonCenter";
    BaseNavigationViewController *loginNaviController = [[BaseNavigationViewController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}

- (void)choiceConWithIndex:(int)index webview:(UIWebView*)webview
{
    self.selectedViewController = self.childViewControllers[index];
}

#pragma mark - regAlertDelegate
- (void)lookBtnClicked:(id)sender
{
    
}

- (void)certificationBtnClicked:(id)sender
{
//    __weak typeof(self) weakSelf = self;
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
    //IDAuthViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"idauth"];
    //controller.title = @"身份认证";
    //AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //controller.rootVc = delegate.tabBarController;
    //BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:controller];
    //nav.navigationBarHidden = YES;
    //[delegate.tabBarController presentViewController:nav animated:YES completion:^{
    //
    //    }];
    UCFOldUserGuideViewController * VC = [UCFOldUserGuideViewController createGuideHeadSetp:1];
    VC.isPresentViewController = YES; //弹出视图
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    VC.rootVc = delegate.tabBarController;
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
    //[delegate.tabBarController addChildViewController:nav];
    //delegate.tabBarController.viewControllers = @[nav];
    //[nav pushViewController:VC animated:YES];
    [delegate.tabBarController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)useragent:(UIWebView *)webView
{
    //我的需求是不光要能更改user-agent，而且要保留WebView 原来的user-agent 信息，也就是说我需要在其上追加信息。在stackOverflow上搜集了多方答案，最终汇总的解决方案如下：
    
    //在启动时，比如在AppDelegate 中添加如下代码：
    
    //get the original user-agent of webview
    //UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:@"FinancialWorkshop"];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    //这样，WebView在请求时的user-agent 就是我们设置的这个了，如果需要在WebView 使用过程中再次变更user-agent，则需要再通过这种方式修改user-agent， 然后再重新实例化一个WebView。
}

@end
