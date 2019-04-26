//
//  UCFMainTabBarController.m
//  JRGC
//
//  Created by JasonWong on 14-9-5.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFMainTabBarController.h"
#import "UCFHomeViewController.h"
#import "UCFMoreViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "UITabBar+TabBarBadge.h"
#import "Touch3DSingle.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFOldUserGuideViewController.h"
#import "UCFProjectListController.h"
#import "UCFDiscoveryViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "BlockUIAlertView.h"
#import "UCFInvestViewController.h"
#import "UCFMineViewController.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFNewHomeViewController.h"
#import "UCFNewMineViewController.h"
#import "UCFNewLoginViewController.h"
#import "RTRootNavigationAddPushController.h"
#import "UCFAssetAccountViewController.h"
#import "UCFNewMallWebViewController.h"
@interface UCFMainTabBarController ()


@property (strong, nonatomic) UCFNewHomeViewController *LatestView;
@property (strong, nonatomic) UCFInvestViewController *AssignmentView;
@property (strong, nonatomic) UCFNewMineViewController *mineView;
@end

@implementation UCFMainTabBarController
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action
{
    return nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}
- (void)viewDidLoad
{   
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redbag_toLend:) name:@"UCFRedBagViewController_to_lend" object:nil];
    [self initAllTabbarItems];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [tapGestureRecognizer setNumberOfTapsRequired:2];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.tabBar addGestureRecognizer:tapGestureRecognizer];

    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    UIImageView *imaview = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, ScreenWidth, 10)];
    imaview.image = tabImag;
    
    self.tabBar.clipsToBounds = NO;
    [self.tabBar addSubview:imaview];
    [[UITabBar appearance] setShadowImage:tabImag];

//    @PGWeakObj(self);
//    [self.KVOController observe:self.tabBar keyPaths:@[@"shadowImage"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
//        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
//        if ([keyPath isEqualToString:@"shadowImage"]) {
//
//        }
//
//    }];
}

- (void)redbag_toLend:(NSNotification *)noty {
    if (self.mineView.navigationController.childViewControllers.count > 1) {
        [self.mineView.navigationController popViewControllerAnimated:NO];
    }
    
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
    if (self.AssignmentView) {
        [self.AssignmentView.navigationController popToRootViewControllerAnimated:NO];
        self.AssignmentView.selectedType = @"P2P";
        [self.AssignmentView changeView];
    }
    self.selectedIndex = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initAllTabbarItems
{
    NSMutableArray *vcArray = [NSMutableArray array];
    NSArray *tabbarTitleArray = @[@"首页",
                                  @"投资",
                                  @"奖励",
                                  @"商城",
                                  @"我的"];
    
    NSArray *tabbarNormalArray = @[@"tabbar_icon_homepage_normal",
                                   @"tabbar_icon_project_normal",
                                   @"tabbar_icon_find_normal",
                                   @"tabbar_icon_shop_normal",
                                   @"tabbar_icon_user_normal"];

    NSArray *tabbarHighlightArray = @[@"tabbar_icon_homepage_highlight",
                                      @"tabbar_icon_project_highlight",
                                      @"tabbar_icon_find_highlight",
                                      @"tabbar_icon_shop_highlight",
                                      @"tabbar_icon_user_highlight"];
    UIViewController *controller = nil;
    for (int i=0; i<5; i++) {
        switch (i) {
            case 0:{
                _LatestView = [[UCFNewHomeViewController alloc] init];
                controller = _LatestView;
            }
                break;
            case 1:{
                UCFInvestViewController *invest = [[UCFInvestViewController alloc] init];
                controller = invest;
                _AssignmentView = invest;
            }
                break;
            case 2:{
                UCFDiscoveryViewController *discoveryWeb = [[UCFDiscoveryViewController alloc] initWithNibName:@"UCFDiscoveryViewController" bundle:nil];
                discoveryWeb.url = DISCOVERYURL;//请求地址;
                discoveryWeb.navTitle = @"奖励";
                controller = discoveryWeb;
            }
                break;
            case 3:{
                UCFNewMallWebViewController *mallController = [[UCFNewMallWebViewController alloc] initWithNibName:@"UCFNewMallWebViewController" bundle:nil];
                mallController.url = @"https://m.dougemall.com?fromAppBar=true";//请求地址;
                mallController.navTitle = @"商城";
                controller = mallController;//
            }
                break;
            case 4:{
                UCFNewMineViewController *mine = [[UCFNewMineViewController alloc] init];
                controller = mine;
                _mineView = mine;

            }
                break;
            default:
                controller = nil;
                break;
        }
        if (controller) {
            [vcArray addObject:(i == 3 ?[[BaseNavigationViewController alloc] initWithRootViewController:controller] :[[RTRootNavigationAddPushController alloc] initWithRootViewController:controller])];
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:tabbarTitleArray[i] image:[[UIImage imageNamed:tabbarNormalArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:tabbarHighlightArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            item.tag = i;
            controller.tabBarItem = item;
        }
    }
    
    self.viewControllers = vcArray;
    self.delegate = self;
    [self.tabBar setClipsToBounds:YES];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorWithRGB(0x333333), NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorWithRGB(0xff4133), NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6){
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([self.viewControllers indexOfObject:toVC] == 4) {
        [self checkAppVersion];
    }
    return nil;
}

- (void)checkAppVersion {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *preVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"preVersion"];
    if (![preVersion isEqualToString:currentVersion]) {
        [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:@"preVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setZeroForTapMineNum];
        [self checkTapMineNum];
    }
    else {
        [self checkTapMineNum];
    }
}
- (void)checkTapMineNum {
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    if(nil != userId) {
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"tapMineNum"];
        if (index <= 5) {
            index ++;
            [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"tapMineNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)setZeroForTapMineNum {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tapMineNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)gestureRecognizerHandle:(UITapGestureRecognizer *)sender{
    CGPoint p = [sender locationInView:self.tabBar];
    int index = p.x/(ScreenWidth/5);
    
    switch (index) {
        case 0:{
//            [_LatestView refresh];
        }
            break;
        case 1:{
            [_AssignmentView refresh];
        }
            break;
            
        case 4:{
            [_mineView refresh];
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

    if ([self.viewControllers indexOfObject:viewController] == 4 || [self.viewControllers indexOfObject:viewController] == 2) {
        NSString *userId = SingleUserInfo.loginData.userInfo.userId;
        if(nil == userId) {
            [SingleUserInfo loadLoginViewController];
            [Touch3DSingle sharedTouch3DSingle].isLoad = NO;
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}
- (CATransition *)presentAnimation{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    /*私有API
     cube                   立方体效果
     pageCurl               向上翻一页
     pageUnCurl             向下翻一页
     rippleEffect           水滴波动效果
     suckEffect             变成小布块飞走的感觉
     oglFlip                上下翻转
     cameraIrisHollowClose  相机镜头关闭效果
     cameraIrisHollowOpen   相机镜头打开效果
     */
    
    //    transition.type = @"cube";
    transition.type = kCATransitionPush;
    
    //下面四个是系统共有的API
    //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    transition.subtype = kCATransitionFromRight;
    //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    return transition;
}
- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items
{

}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
       [SingleUserInfo loadLoginViewController];
    }
}

-(void)checkLogin
{
    [SingleUserInfo loadLoginViewController];
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
    UCFOldUserGuideViewController * VC = [UCFOldUserGuideViewController createGuideHeadSetp:1];
    VC.isPresentViewController = YES; //弹出视图
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    VC.rootVc = delegate.tabBarController;
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
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
- (void)showTabBar
{
//    if (self.tabBar.hidden == NO)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
//        contentView = [self.view.subviews objectAtIndex:1];
//    } else {
//        contentView = [self.view.subviews objectAtIndex:0];
//        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBar.frame.size.height);
//        self.tabBarController.tabBar.hidden = NO;
//    }
    if (self.tabBar.frame.origin.y == ScreenHeight - CGRectGetHeight(self.tabBar.frame)) {
        return;
    }
    [UIView animateWithDuration:0 animations:^{
        self.tabBar.frame = CGRectMake(0, ScreenHeight - CGRectGetHeight(self.tabBar.frame), CGRectGetWidth(self.tabBar.frame), CGRectGetHeight(self.tabBar.frame));
    }];
}
- (void)hideTabBar
{
//    if (self.tabBar.hidden == YES) {
//        return;
//    }
//    UIView *contentView;
//    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
//        contentView = [self.view.subviews objectAtIndex:1];
//    else
//        contentView = [self.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBar.frame.size.height);
//    self.tabBar.hidden = YES;
//    return;
    if (self.tabBar.frame.origin.y == ScreenHeight) {
        return;
    }
    self.tabBar.frame = CGRectMake(0, ScreenHeight, CGRectGetWidth(self.tabBar.frame), CGRectGetHeight(self.tabBar.frame));

}
- (void)viewWillLayoutSubviews
{
    self.tabBar.frame = CGRectMake(0, ScreenHeight - kTabBarHeight, ScreenWidth, kTabBarHeight);
}
//- (void)viewWillLayoutSubviews
//{
//    //    self.tabBar.frame = CGRectMake(0, ScreenHeight - kTabBarHeight, ScreenWidth, kTabBarHeight);
//    [super viewWillLayoutSubviews];
//    //TODO: adapt tabbar's y value.
//    if (kIs_iPhoneX) {
//        CGFloat deltaTabBarY = SCREEN_HEIGHT - CGRectGetHeight(self.tabBar.frame);
//        self.tabBar.frame = (CGRect){0, deltaTabBarY, self.tabBar.bounds.size};
//    }
//}
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    //TODO: adapt tabbar's y value.
//    if (kIs_iPhoneX) {
//        CGFloat deltaTabBarY = SCREEN_HEIGHT - CGRectGetHeight(self.tabBar.frame);
//        self.tabBar.frame = (CGRect){0, deltaTabBarY, self.tabBar.bounds.size};
//    }
//}
@end
