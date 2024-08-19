//
//  RTRootNavigationAddPushController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "RTRootNavigationAddPushController.h"

@interface RTRootNavigationAddPushController ()

@end

@implementation RTRootNavigationAddPushController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
{
#pragma mark - 是否显示tabbar
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];

}
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated complete:(void (^)(BOOL))block
//{
//    //判断即将到栈底
//    UINavigationController *nav = SingGlobalView.tabBarController.selectedViewController;
//    if (nav.viewControllers.count == 1) {
//        SingGlobalView.tabBarController.tabBar.hidden = NO;
//    } else {
//        SingGlobalView.tabBarController.tabBar.hidden = YES;
//    }
//    //显示自定义的tabBar
//    //  pop出栈
//    return [super popViewControllerAnimated:animated complete:block];
//}


//- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated complete:(void (^)(BOOL))block
//{
//    UINavigationController *nav = SingGlobalView.tabBarController.selectedViewController;
//    UIViewController *vc  = nav.viewControllers.lastObject;
//    if (nav.viewControllers.count == 1) {
//        [SingGlobalView.tabBarController showTabBar];
//
//    } else {
//        SingGlobalView.tabBarController.tabBar.hidden = YES;
//        vc.tabBarController.hidesBottomBarWhenPushed = YES;
//               [SingGlobalView.tabBarController hideTabBar];
        
//    }
    //显示自定义的tabBar
    //  pop出栈
//    return [super popToRootViewControllerAnimated:animated complete:block];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
