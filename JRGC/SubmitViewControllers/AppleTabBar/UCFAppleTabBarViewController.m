//
//  UCFAppleTabBarViewController.m
//  JRGC
//
//  Created by zrc on 2018/8/21.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFAppleTabBarViewController.h"
#import "UCFAppleMyViewController.h"
#import "UCFAppleHomeViewController.h"
#import "P2PWalletHelper.h"
#import "UCFDiscoveryViewController.h"
#import "BaseNavigationViewController.h"
#import "UCFLoginViewController.h"
@interface UCFAppleTabBarViewController ()<UITabBarControllerDelegate>
@property (strong, nonatomic) UCFAppleHomeViewController *LatestView;
@property (strong, nonatomic) UCFAppleMyViewController *mineView;
@end

@implementation UCFAppleTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllTabbarItems];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    UIImageView *imaview = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, ScreenWidth, 10)];
    //imaview.backgroundColor = [UIColor redColor];
    imaview.image = tabImag;
    self.tabBar.clipsToBounds = NO;
    [self.tabBar addSubview:imaview];
    [[UITabBar appearance] setShadowImage:tabImag];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[P2PWalletHelper sharedManager] getUserWalletData:[P2PWalletHelper sharedManager].source];
}
- (void)initAllTabbarItems
{
    NSMutableArray *vcArray = [NSMutableArray array];
    NSArray *tabbarTitleArray = @[@"首页",
                                  @"学堂",
                                  @"生活",
                                  @"我的"];
    
    NSArray *tabbarNormalArray = @[@"tabbar_icon_homepage_normal",
                                   @"tabbar_icon_find_normal",
                                   @"tabbar_icon_life_normal",
                                   @"tabbar_icon_user_normal"];
    
    NSArray *tabbarHighlightArray = @[@"tabbar_icon_homepage_highlight",
                                      @"tabbar_icon_find_highlight",
                                      @"tabbar_icon_life_highlight",
                                      @"tabbar_icon_user_highlight"];
    UIViewController *controller = nil;
    for (int i=0; i<4; i++) {
        switch (i) {
            case 0:{
                _LatestView = [[UCFAppleHomeViewController alloc] initWithNibName:@"UCFAppleHomeViewController" bundle:nil];
                controller = _LatestView;
            }
                break;

            case 1:{
                UCFDiscoveryViewController *discoveryWeb = [[UCFDiscoveryViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
                discoveryWeb.url      = @"https://m.9888.cn/static/wap/topic-invest-school/index.html";//请求地址;
                discoveryWeb.navTitle = @"学堂";
                controller = discoveryWeb;
            }
                break;
            case 2:{
                
                controller = [[P2PWalletHelper sharedManager] getUCFWalletTargetController];
                
            }
                break;
            case 3:{
                UCFAppleMyViewController *mine = [[UCFAppleMyViewController alloc] initWithNibName:@"UCFAppleMyViewController" bundle:nil];
                controller = mine;
                _mineView = mine;
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
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BaseNavigationViewController *contrl = (BaseNavigationViewController*)viewController;
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
    UIViewController *topView = nil;
    if (contrl.viewControllers.count != 0) {
        topView = [contrl.viewControllers objectAtIndex:0];
    }

    if ([self.viewControllers indexOfObject:viewController] == 2) {
        NSString *userId = [UserInfoSingle sharedManager].userId;
        if(nil == userId) {
            UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
            BaseNavigationViewController *loginNaviController = [[BaseNavigationViewController alloc] initWithRootViewController:loginViewController];
            loginViewController.sourceVC = @"homePage";
            [self presentViewController:loginNaviController animated:YES completion:nil];
            return NO;
        } else {
            return [[P2PWalletHelper sharedManager] checkUserHSStateCanOpenWallet];
        }
        
        return YES;
    }
    return YES;
}

@end
