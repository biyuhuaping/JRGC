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
//- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    return self;
//}
//- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
//{
//    return @[self];
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
