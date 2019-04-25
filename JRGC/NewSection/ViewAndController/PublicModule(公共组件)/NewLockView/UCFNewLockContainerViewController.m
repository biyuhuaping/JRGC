//
//  UCFNewLockContainerViewController.m
//  JRGC
//
//  Created by zrc on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewLockContainerViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UCFCreateLockViewController.h"
#import "UCFUnlockViewController.h"
#import "UCFTouchIDViewController.h"
@interface UCFNewLockContainerViewController ()
@property(nonatomic, strong)UIViewController *currentController;
@property(nonatomic, strong)UCFTouchIDViewController *touchIDController;
@property(nonatomic, strong)UCFUnlockViewController *userLockController;
@property(nonatomic, assign)RCLockViewType   type;
@end

@implementation UCFNewLockContainerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ((RTContainerController *) (SingGlobalView.rootNavController.viewControllers.lastObject)).fd_interactivePopDisabled = YES;
}
- (id)initWithType:(RCLockViewType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == RCLockViewTypeCheck) {
        BOOL touchIDIsOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"isUserShowTouchIdLockView"];
        BOOL userLock = [[NSUserDefaults standardUserDefaults] boolForKey:@"useLockView"];
        
        if (touchIDIsOpen && userLock) { //手势和指纹都开
            [self addChildViewController:self.touchIDController];
            [self.view addSubview:self.touchIDController.view];
            [self addChildViewController:self.userLockController];
            self.currentController = _touchIDController;
            
        } else if(touchIDIsOpen && !userLock){ //手势关闭 指纹打开
            [self addChildViewController:self.touchIDController];
            [self.view addSubview:self.touchIDController.view];
            self.currentController = _touchIDController;
        } else if (!touchIDIsOpen && userLock) { //手势打开 指纹关闭
            [self addChildViewController:self.userLockController];
            [self.view addSubview:self.userLockController.view];
            self.currentController = _userLockController;
        }
    } else if (_type == RCLockViewTypeCreate) {
        [self addCreatePage];
    }
}
- (void)addCreatePage
{
    UCFCreateLockViewController *vc = [[UCFCreateLockViewController alloc] init];
    vc.isFromRegist = _isFromRegist;
    vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}
- (void)addTouchPage {
    
}
- (void)addUserLockPage{
    
}
- (void)childControlerCallShow:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UCFUnlockViewController class]]) {
        [self transitionFromViewController:self.childViewControllers[1] toViewController:self.childViewControllers[0]
                                  duration:0.3
                                  options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        self.currentController = self.childViewControllers[0];
                                    }else{
                                        
                                    }
                                }];
    } else if ([controller isKindOfClass:[UCFTouchIDViewController class]]) {
        [self transitionFromViewController:self.childViewControllers[0] toViewController:self.childViewControllers[1]
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        self.currentController = self.childViewControllers[1];
                                    }else{
                                        
                                    }
                                }];
    }
}
- (UCFTouchIDViewController *)touchIDController
{
    if (!_touchIDController) {
        _touchIDController = [[UCFTouchIDViewController alloc] init];
        _touchIDController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _touchIDController;
}
- (UCFUnlockViewController *)userLockController
{
    if (!_userLockController) {
        _userLockController = [[UCFUnlockViewController alloc] init];
        _userLockController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _userLockController;
}
@end
