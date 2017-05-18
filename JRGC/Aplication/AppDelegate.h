//
//  AppDelegate.h
//  JRGC
//
//  Created by HeJing on 15/3/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideViewController.h"
#import "UCFMainTabBarController.h"
#import "UCFLockHandleViewController.h"
#import "NetworkModule.h"
#import "FMDeviceManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,GuideViewContlerDelegate,NetworkModuleDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)  UCFMainTabBarController *tabBarController;
@property (strong, nonatomic) UCFLockHandleViewController* lockVc; // 添加解锁界面
@property (nonatomic, assign) BOOL isSubmitAppStoreTestTime; //判断是否为苹果商店审核时间 YES为审核时间
@property (nonatomic, strong) UIView                  *loadingBaseView;
@property (strong, nonatomic) UIImageView *advertisementView;

// 手势解锁相关
- (void)showLLLockViewController:(LLLockViewType)type;
// 退出应用
- (void)exitApplication;

//检查是否显示尊享
- (void)checkIsShowHornor;

@end

