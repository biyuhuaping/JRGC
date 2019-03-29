//
//  AppDelegate.m
//  JRGC
//
//  Created by HeJing on 15/3/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "AppDelegate.h"
//#import "UCFSession.h"
#import "LLLockPassword.h"
#import "JSONKit.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"
#import "UCFToolsMehod.h"
#import "CalculatorView.h"
#import "Common.h"
#import "ToolSingleTon.h"
#import "UMSocialQQHandler.h"
#import "IPDetector.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+NetImageView.h"
#import "UCFSecurityCenterViewController.h"
#import "LockFlagSingle.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "UCFFacCodeViewController.h"
#import "Touch3DSingle.h"
#import "PraiseAlert.h"
#import "UITabBar+TabBarBadge.h"
#import "UIImage+GIF.h"
#import "Growing.h"
#import "UCFHomeViewController.h"
#import "MD5Util.h"
#import "JPUSHService.h"//极光推送
#import "MongoliaLayerCenter.h"
#import "UCFInvestViewController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "UCFLanchViewController.h"
#import "RealReachability.h"
#import "IQKeyboardManager.h"
#import "YTKNetworkConfig.h"
#import "RequestUrlArgumentsFilter.h"
#import "BaseRequest.h"
#import "GuideViewController.h"
@interface AppDelegate () <JPUSHRegisterDelegate,LanchViewControllerrDelegate,GuideViewContlerDelegate>

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (assign, nonatomic) NSInteger backTime;
@property (assign, nonatomic) BOOL isComePushNotification;
@property (assign, nonatomic) BOOL isFirstStart;
@property (assign, nonatomic) BOOL isComeForceUpdate;
@property (assign, nonatomic) BOOL isAfter;//是否延时（只在3DTouch启动时使用）
@property (strong, nonatomic) RTRootNavigationController *rootNavigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self startGLobalRealReachability]; //开启网络监测
    [self startNetConfig];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //请求开关状态
    [self checkNovicePoliceOnOff];
    [self luachNormalCode:launchOptions];
    
    UCFLanchViewController *lanchVC = [[UCFLanchViewController alloc] initWithNibName:@"UCFLanchViewController" bundle:nil];
    lanchVC.delegate = self;
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:lanchVC];
    self.rootNavigationController = nav;
    [GlobalView sharedManager].rootNavController = nav;

    self.window.rootViewController = nav;
    
    
//    今天测试软件的时候，发现在iOS12.1系统上push控制器后，点击返回键或者滑动返回时，底部tabbar出现了偏移，经过排查发现为定义了 self.navigationItem.leftBarButtonItem
//    后经过网络搜索，当 UITabBar 设置为透明，且 push viewController 为 hidesBottomBarWhenPushed = YES 返回的时候就会触发。
//    出现这个现象的直接原因是 tabBar 内的按钮 UITabBarButton 被设置了错误的 frame，frame.size 变为 (0, 0) 导致的。
    [[UITabBar appearance] setTranslucent:NO];
    [self IQBoardSetting];
    [self initializeLog];//初始化日志
    return YES;
}
- (void)startNetConfig
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = SERVER_IP;
    RequestUrlArgumentsFilter *urlFilter = [RequestUrlArgumentsFilter filterWithArguments:[BaseRequest getPublicParameters]];
    [config addUrlFilter:urlFilter];
}
#pragma mark IQBoardSetting
- (void)IQBoardSetting
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = NO; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

#pragma mark - 初始化网络监控
- (void)startGLobalRealReachability
{
    GLobalRealReachability.hostForPing = @"www.baidu.com";
    GLobalRealReachability.hostForCheck = @"www.apple.com";
    [GLobalRealReachability startNotifier];
}
#pragma 新手政策弹框
- (void)checkNovicePoliceOnOff
{
    //请求开关状态
    [[NetworkModule sharedNetworkModule] newPostReq:@{} tag:kSXTagGetInfoForOnOff owner:self signature:NO Type:SelectAccoutDefault];
}
#pragma mark LanchViewControllerrDelegate
- (void)switchRootView
{
    BOOL islaunch= [GuideViewController isShow];
    if (islaunch) {
        GuideViewController *guideViewController = [[GuideViewController alloc] init];
        guideViewController.delegate = self;
        self.window.rootViewController = guideViewController;

        NSString *strParameters = nil;
        strParameters = [NSString stringWithFormat:@"equipment=%@&remark=%@&serialNumber=%@&sourceType=%@",[Common platformString],@"1",[Common getKeychain],@"1"];
        //统计用户数量
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagCalulateInstallNum owner:self Type:SelectAccoutDefault];
    } else {
        NSInteger useLockView = [[[NSUserDefaults standardUserDefaults] valueForKey:@"useLockView"] integerValue];
        [self showTabbarController];
        //使用手势密码 显示
        if (useLockView == 1) {
            [self showGCode];
        }
    }
}
- (void)changeRootView:(GuideViewController *)controller
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islaunch"];
    [self showTabbarController];
}

#pragma ------
- (void)luachNormalCode:(NSDictionary *)launchOptions
{
    //设置公告展示标志位
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowNotice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [UcfWalletSDK setEnvironment:1];

    [[UserInfoSingle sharedManager] getUserData];
    [self setWebViewUserAgent];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceUpdateVersion) name:CHECK_NEW_VERSION object:nil];
    
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
#ifdef DEBUG //Debug模式，如果是Relase模式将不会执行以下代码
    [options setValue:@"allowd" forKey:@"allowd"]; //允许调试，缺省不允许调试
    [options setValue:@"sandbox" forKey:@"env"]; //对接测试环境，缺省为对接生产环境
#endif
    [options setValue:@"jrgc" forKey:@"partner"]; //您的合作方标识
    // [options setValue:@5000 forKey:@"timeout"];  //超时设置，缺省值为10000毫秒，即10秒
    manager->initWithOptions(options);                 //初始化
    
    // SDK具有防调试功能，当使用xcode运行时，请取消此行注释，开启调试模式
    // 否则使用xcode运行会闪退，(但直接在设备上点APP图标可以正常运行)
    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
    // [options setValue:@"allowd" forKey:@"allowd"];  // TODO
    
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkInitiaLogin) name:CheckIsInitiaLogin object:nil];
    [self checkInitiaLogin];
    //去掉navigationbar 下面默认的白线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self setUMData];
    //初始化手势密码失败次数
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:5] forKey:@"nRetryTimesRemain"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
    
    [MobClick startWithAppkey:@"544b0681fd98c525ad0372f2" reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPersonCenterRedPoint) name:CHECK_RED_POINT object:nil];
    [self checkPersonCenterRedPoint];
    //调用红点接口，通知服务器红点标示倍查看
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRedPointShouldHide:) name:REDALERTISHIDE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConponCenter) name:CHECK_COUPON_CENTER object:nil];


    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowHornor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self getLoginImage];
//    [self getAdversementLift];
    [self getSharePictureAdversementLink];
    [self geInvestmentSuccesseLift];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLoginOut) name:USER_LOGOUT object:nil];
    
    //TODO:------------------启动GrowingIO--------------------
    [Growing startWithAccountId:@"b9ed2e92ac9b1c59"];
    // 其他配置
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKEY channel:nil apsForProduction:YES];
    [JPUSHService setAlias:SingleUserInfo.loginData.userInfo.userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [JPUSHService setBadge:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registJush) name:REGIST_JPUSH object:nil];


}
//友盟
- (void)setUMData
{
    [MobClick startWithAppkey:@"544b0681fd98c525ad0372f2" reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"544b0681fd98c525ad0372f2"];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa4dda834af9ee6df" appSecret:@"0e6e9464cb38e6f71f7a4da473a25ffc" redirectURL:@"http://mobile.umeng.com/social"];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1104610513"  appSecret:@"RUImkrSeNaT0lxkV" redirectURL:@"http://mobile.umeng.com/social"];
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2022554825"  appSecret:@"e496f6f9df690579441c9ae4e26be6e4" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}


/**  自定义消息的回调
- (void)networkDidLogin:(NSNotification *)notification {
    DLog(@"%@", [APService registrationID]);
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    [MBProgressHUD displayHudError:@"有消息"];
}
*/
- (void)registJush
{
   //fixes IOS-3537
    if (nil != [UserInfoSingle sharedManager].loginData && nil != [UserInfoSingle sharedManager].loginData.userInfo.userId) {
        [JPUSHService setAlias:SingleUserInfo.loginData.userInfo.userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    } else {
        [JPUSHService setBadge:0];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags,alias];
    DDLogDebug(@"%@",callbackString);
}
// 之所以把这个红点提到这里，是因为启动APP之后，没有点击个人中心页面的话，未初始化这个api，直接投资查看奖励列表，不能通知服务端把这个红点去掉

- (void)checkConponCenter
{
    if (SingleUserInfo.loginData.userInfo.userId) {
        NSDictionary *parmDic = nil;
        if (SingleUserInfo.loginData.userInfo.userId) {
            parmDic = [NSDictionary dictionaryWithObject:SingleUserInfo.loginData.userInfo.userId forKey:@"userId"];
        }
        [[NetworkModule sharedNetworkModule] newPostReq:parmDic tag:kSXTagCheckConponCenter owner:self signature:YES Type:SelectAccoutDefault];
    }

}
//- (void) createItem {
//    //自定义icon 的初始化方法
//    UIApplicationShortcutIcon *icon0 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"工场码"];
//    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"邀请返利"];
//    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"0" localizedTitle:@"我的工场码" localizedSubtitle:nil icon:icon0 userInfo:nil];
//    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"邀请返利" localizedSubtitle:nil icon:icon1 userInfo:nil];
//    [UIApplication sharedApplication].shortcutItems = @[item2,item3];
//}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    // react to shortcut item selections
    DDLogDebug(@"title:%@,type:%@,userInfo:%@",shortcutItem.localizedTitle,shortcutItem.type,shortcutItem.userInfo);
    if (SingleUserInfo.loginData.userInfo.userId) {
        
        [Touch3DSingle sharedTouch3DSingle].isLoad = YES;
        [Touch3DSingle sharedTouch3DSingle].type = shortcutItem.type;

        //如果重新启动程序，就延时跳转。否则就直接跳转
        if (_isAfter) {
            _isAfter = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tabBarController.selectedIndex = 4;
            });
        }else{
            self.tabBarController.selectedIndex = 4;
        }
        
        //没有手势密码时并且进程还在后台运行，进入个人中心不会重新请求接口
        if (![Touch3DSingle sharedTouch3DSingle].isShowLock) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"responds3DTouchClick" object:nil];
        }
    }
}

- (void)forceUpdateVersion
{
    _isComeForceUpdate = YES;
    [self checkNovicePoliceOnOff];
}
// 检测是否首次登录
- (void)checkInitiaLogin
{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), queue, ^{
    DDLogDebug(@"主队列--延迟执行------%@",[NSThread currentThread]);
          [[ToolSingleTon sharedManager] getGoldPrice];
    });
}


-(void)beginPost:(kSXTag)tag
{
    
}
- (void)saveLoginOut
{
    NSString *useridstr = [NSString stringWithFormat:@"%@",SingleUserInfo.loginData.userInfo.userId];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:useridstr,@"userId",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagUserLogout owner:self signature:YES Type:SelectAccoutDefault];
    
//    [[UCFSession sharedManager] transformBackgroundWithUserInfo:nil withState:UCFSessionStateUserLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
    [SingleUserInfo deleteUserData];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //退出时清cookis
    [Common deleteCookies];
    [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
    //通知首页隐藏tipView
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
//    恢复屏幕的亮度
        DDLogDebug(@"\n ===> 程序暂行 !");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    CalculatorView * view =  (CalculatorView * )[self.window viewWithTag:173924];;
    [view removeFromSuperview];
    _isFirstStart = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    _backTime = 0;
    
    _backgroundUpdateTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
        [application endBackgroundTask:_backgroundUpdateTask];
        _backgroundUpdateTask = UIBackgroundTaskInvalid;
    }];
    if (_backgroundUpdateTask == UIBackgroundTaskInvalid) {
        DDLogDebug(@"failed to start background task!");
    }
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do the work associated with the task, preferably in chunks.
        NSTimeInterval timeRemain = 0;
        do{
            [NSThread sleepForTimeInterval:1];
            if (_backgroundUpdateTask!= UIBackgroundTaskInvalid) {
                timeRemain = [application backgroundTimeRemaining];
                _backTime ++;
//                DLog(@"Time remaining: %f",timeRemain);
            }
        }while(_backgroundUpdateTask!= UIBackgroundTaskInvalid && timeRemain > 0); // 如果改为timeRemain > 5*60,表示后台运行5分钟
        // done!
        // 如果没到10分钟，也可以主动关闭后台任务，但这需要在主线程中执行，否则会出错
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_backgroundUpdateTask != UIBackgroundTaskInvalid)
            {
                // 和上面10分钟后执行的代码一样
                // ...
                [application endBackgroundTask:_backgroundUpdateTask];
                _backgroundUpdateTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    // 如果没到10分钟又打开了app,结束后台任务
    if (_backgroundUpdateTask!=UIBackgroundTaskInvalid) {
            [application endBackgroundTask:_backgroundUpdateTask];
            _backgroundUpdateTask = UIBackgroundTaskInvalid;
        }
    NSInteger useLockView = [[[NSUserDefaults standardUserDefaults] valueForKey:@"useLockView"] integerValue];
    if (useLockView == 1) {
        if (_backTime > 60) {
            [[ToolSingleTon sharedManager] hideAlertAction:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"guaguakaHide" object:nil];
            [self showGCode];
        }
    }
    else {
        [self checkInitiaLogin];
    }
    [self checkIsGongChaView];
    [self checkIsLockView];
    [self checkFirstViewController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     //进入前台之后，获取当前屏幕亮度，并保存更新屏幕亮
    NSInteger selectIndex = self.tabBarController.selectedIndex;
    if (selectIndex == 2) {
        //    进入前台之后，判断当前页面是否是工场码页面，如果是，调整屏幕亮度 如果不是，获取当前屏幕亮度
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
        if ([nav.visibleViewController isKindOfClass:[UCFFacCodeViewController class]]) {
//            [[UIScreen mainScreen] setBrightness:1];
            //增加屏幕亮度
            [[NSNotificationCenter defaultCenter] postNotificationName:AddBrightness object:nil];
        } else if ([nav.visibleViewController isKindOfClass:[UCFSecurityCenterViewController class]]) {
            UCFSecurityCenterViewController *tmpController = (UCFSecurityCenterViewController *)nav.topViewController;
            [tmpController checkSystemTouchIdisOpen];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_COUPON_CENTER object:nil];

}
//进入前台的时候，判断是否是个人中心的工场码页面,如果是，判断指纹开关是否开闭
- (void)checkIsGongChaView
{
        NSInteger selectIndex = self.tabBarController.selectedIndex;
        if (selectIndex == 2) {
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
            if ([nav.visibleViewController isKindOfClass:[UCFSecurityCenterViewController class]]) {
                UCFSecurityCenterViewController *tmpController = (UCFSecurityCenterViewController *)nav.topViewController;
                [tmpController checkSystemTouchIdisOpen];
            }
        }
}
//进入前台的时候，判断是否是首页页面,如果是 通知邀友弹框
- (void)checkFirstViewController
{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), queue, ^{
        DDLogDebug(@"主队列--延迟执行------%@",[NSThread currentThread]);
        NSInteger selectIndex = self.tabBarController.selectedIndex;
        if (selectIndex == 0 && !self.lockVc) {
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
            if ([nav.visibleViewController isKindOfClass:[UCFHomeViewController class]]) {
                    [[MongoliaLayerCenter sharedManager] showLogic];
                }
        }
    });
}
- (void)checkIsLockView
{
    //判断当前页是否解锁
    if ([LockFlagSingle sharedManager].disappearType == DisHome && [LockFlagSingle sharedManager].showSection == LockFingerprint) {
         [self.lockVc openTouchidAlert];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    //   将要杀死进程，删除保存的亮度数据和工场码标示符
//    [[NSNotificationCenter defaultCenter] postNotificationName:EndBrightnessTimer object:nil];
//
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"preScreenLight"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showTabbarController
{
    self.tabBarController = [[UCFMainTabBarController alloc] init];
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:self.tabBarController];
    [GlobalView sharedManager].tabBarController = self.tabBarController;
    [GlobalView sharedManager].rootNavController = nav;
    self.window.rootViewController = nav;
}
//显示手势密码
- (void)showGCode
{
    NSString* pswd = [LLLockPassword loadLockPassword];
    if (SingleUserInfo.loginData.userInfo.userId) {
        if (pswd) {
            [self showLLLockViewController:LLLockViewTypeCheck];
        } else {
            [self showLLLockViewController:LLLockViewTypeCreate];
        }
    }
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
    if(self.window.rootViewController.presentingViewController == nil){
        LLLog(@"root = %@", self.window.rootViewController.class);
        LLLog(@"lockVc isBeingPresented = %d", [self.lockVc isBeingPresented]);
        if (self.lockVc) {
            self.lockVc = nil;
        }
        self.lockVc = [[UCFLockHandleViewController alloc] init];

        self.lockVc.nLockViewType = type;

        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [self.window.rootViewController presentViewController:self.lockVc animated:NO completion:^{
        }];
        LLLog(@"创建了一个pop=%@", self.lockVc);
    }
}

#pragma mark GuideViewContlerDelegate
//- (void)addLoadingBaseView
//{
//    _loadingBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    _loadingBaseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//    _loadingBaseView.hidden = YES;
//    [self.window addSubview:_loadingBaseView];
//    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 91, 95.5)];
//    NSMutableArray * animateArray = [[NSMutableArray alloc]initWithCapacity:8];
//    for (int i = 1; i <= 8 ; i++) {
//        [animateArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i]]];
//    }
//    view1.animationImages = animateArray;
//    view1.animationRepeatCount = 0;
//    view1.animationDuration = 0.8;//设置动画时间
//    view1.center = _loadingBaseView.center;
//    view1.backgroundColor = [UIColor clearColor];
//    [_loadingBaseView addSubview:view1];
//
//    UILabel *textLab = [[UILabel alloc] init];
//    textLab.text = @"全力加载中";
//    textLab.frame = CGRectMake(CGRectGetMinX(view1.frame), CGRectGetMaxY(view1.frame), CGRectGetWidth(view1.frame), 16);
//    textLab.textAlignment = NSTextAlignmentCenter;
//    textLab.textColor = [UIColor whiteColor];
//    textLab.font = [UIFont systemFontOfSize:14.0f];
//    [_loadingBaseView addSubview:textLab];
//    [view1 startAnimating];
//}

    
- (void)checkIsShowHornor
{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowHornor"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    if (nil==userId) {
        return;
    }
    //请求开关状态
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagIsShowHornor owner:self signature:YES Type:SelectAccoutDefault];
}


- (void)checkUpdate
{
    [[NetworkModule sharedNetworkModule] newPostReq:@{} tag:kSXTagKicItemList owner:self signature:NO Type:SelectAccoutDefault];
}
//新手政策弹框
- (void)novicecheck:(NSDictionary *)dic
{
    int  novicePoliceOnOff = [[dic objectSafeForKey:@"novicePoliceOnOff"] intValue];
    [[MongoliaLayerCenter sharedManager].mongoliaLayerDic setValue:[NSNumber numberWithInt:novicePoliceOnOff] forKey:@"novicePoliceOnOff"];
    NSString *novicePoliceContext = [dic objectSafeForKey:@"novicePoliceContext"];
    [[MongoliaLayerCenter sharedManager].mongoliaLayerDic setValue:novicePoliceContext forKey:@"novicePoliceContext"];
    NSString *novicePoliceUrl = [dic objectSafeForKey:@"novicePoliceUrl"];
    [[MongoliaLayerCenter sharedManager].mongoliaLayerDic setValue:novicePoliceUrl forKey:@"novicePoliceUrl"];
}
- (void)zxSwitchCheck:(NSDictionary *)dic
{
    //尊享开关
    BOOL zxSwitch = [[dic objectForKey:@"showZXOnOff"] boolValue];
    if (zxSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowHornor"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowHornor"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userisloginandcheckgrade" object:@(YES)];
}

//#warning about supervise
- (void)superviseSwitchWithState:(BOOL)state {
    [UserInfoSingle sharedManager].superviseSwitch = state;
    if (state) {
        [[UserInfoSingle sharedManager] checkUserLevelOnSupervise];
    }
}

- (void)endPost:(id)result tag:(NSNumber*)tag
{
    if (tag.integerValue == kSXTagGetInfoForOnOff) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"ret"] boolValue] == 1)
        {
            dic = dic[@"data"];
            
            //以下是升级信息
            NSString *netVersion = [dic objectSafeForKey: @"lastVersion"];
            [LockFlagSingle sharedManager].netVersion = netVersion;
            //是否强制更新 0强制 1随便 2不稳定
            NSInteger versionMark = [[dic objectSafeForKey:@"forceUpdateOnOff"] integerValue];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
            NSComparisonResult comparResult = [netVersion compare:currentVersion options:NSNumericSearch];
            [UserInfoSingle sharedManager].isShowCouple = [dic[@"couponIsShow"] boolValue];
            if (comparResult == NSOrderedAscending || comparResult == NSOrderedSame) {
                if (versionMark == 2) {
                    self.isSubmitAppStoreTestTime = YES;
                    [UserInfoSingle sharedManager].isSubmitTime = YES;
       
                }

            } else {

                NSString *des = dic[@"updateInfo"];
                if (versionMark == 0) {
                    if (_isComeForceUpdate) {
                        //服务器版本和appstore版本一致
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 V%@",netVersion] message:des delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
                        alert.tag = 102;
                        [alert show];
                        _isComeForceUpdate = NO;
                    }
                } else if (versionMark == 1) {
                    if ([PraiseAlert isShouldWarnUserUpdate:netVersion]) {
                        //可选择性更新
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 V%@",netVersion] message:des delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"更新", nil];
                        alert.tag = 101;
                        NSLog(@"%lf",alert.window.windowLevel);
                        [alert show];
                    }
                } else if (versionMark == 2) {
                    DDLogDebug(@"升级期内");
                }
            }
            
            
            [self novicecheck:dic];
            [self zxSwitchCheck:dic];
            SingleUserInfo.loginData.userInfo.goldIsShow = [[dic objectSafeForKey:@"goldIsShow"] boolValue];
            SingleUserInfo.loginData.userInfo.transferIsShow = [[dic objectSafeForKey:@"transferIsShow"] boolValue];
            SingleUserInfo.loginData.userInfo.wjIsShow = [[dic objectSafeForKey:@"wjIsShow"] boolValue];
            SingleUserInfo.loginData.userInfo.zxIsShow = [[dic objectSafeForKey:@"zxIsShow"] boolValue];
            [SingleUserInfo setUserData:SingleUserInfo.loginData];
            NSString *superviseStr = [dic objectForKey:@"compliance"];
            //监管开关
            if ([superviseStr isEqualToString:@"1"]) {
                [self superviseSwitchWithState:NO];
            }
            else if ([superviseStr isEqualToString:@"2"]) {
                [self superviseSwitchWithState:YES];
            }
            else {
                [self superviseSwitchWithState:YES];
            }


            /*
                注意点
                1.第一个主要是给苹果测试人员用 ipa 版本号 大于等于 后台配置 版本号 并且version 为2 此时进入灰度环境（注意：使用灰度环境不要用自动上架，有可能客户自动升级了，进入灰度环境）
                2.上线流程，等app提交审核，就需要要求后台配置升级信息人员，把升级信息挂出来，但是versionMark不能写0 和 1 ，
                          app 审核完成，需要改写为0和1，
             */
        }
        else {
            [self superviseSwitchWithState:YES];
        }
    }else if (tag.intValue == kSXTagCheckPersonRedPoint) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if ([dic[@"ret"] boolValue]) {
            NSString *unReadMsgCount = [dic[@"data"] objectSafeForKey:@"unReadMsgCount"];
            if ([unReadMsgCount intValue] > 0) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:4];
            } else {
                [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
            }
        }else{
            [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        }
    } else if (tag.intValue == kSXTagRedPointCheck) {
//        NSString *Data = (NSString *)result;
//        NSDictionary * dic = [Data objectFromJSONString];
//        if ([dic[@"status"] intValue] == 1) {
//            // 通知个人中心刷新，之所以加这个通知，是因为投标成功页查看我的奖励，跟个人中心都要刷新个人中心数据，保持统一（但会造成一次网络浪费，从投标成功页查看我的奖励列表，点击tab的时候也会请求一次这个接口）
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
//        }
    } else if (tag.intValue == kSXTagCheckConponCenter) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if ([dic[@"ret"] boolValue]) {
            if (!self.isSubmitAppStoreTestTime) {
                NSString *availableNum = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"availableNum"];
                if ([availableNum integerValue] > 0) {
                    [self.tabBarController.tabBar showBadgeOnItemIndex:2];
                } else {
                    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
                }
            }
        } else {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
    }
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:@"网络连接异常"];
//#warning about supervise
    [self superviseSwitchWithState:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            [[SDImageCache sharedImageCache] clearDisk];
            NSURL *url = [NSURL URLWithString:APP_RATING_URL];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (alertView.tag == 102) {
        NSURL *url = [NSURL URLWithString:APP_RATING_URL];
        [[UIApplication sharedApplication] openURL:url];
        [self exitApplication];
    }else if (alertView.tag == 2000) {
        [self exitApplication];
    }
}

- (void)exitApplication {
    [UIView animateWithDuration:1.0f animations:^{
        self.window.alpha = 0;
        self.window.frame = CGRectMake(0, self.window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

#pragma mark - 分享
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *, id> *) options {
    NSString *urlStr = url.absoluteString;
    if ([urlStr rangeOfString:@"jrgc://jrgc.com"].location != NSNotFound) {
        NSString *selectedType = @"";
        if ([urlStr rangeOfString:@"view=p2p"].location != NSNotFound) {
            selectedType = @"P2P";
            [self msgSkipToView:selectedType];
        } else if ([urlStr rangeOfString:@"view=zx"].location != NSNotFound) {
            selectedType = @"ZX";
            [self msgSkipToView:selectedType];
        } else if ([urlStr rangeOfString:@"view=gold"].location != NSNotFound) {
            selectedType = @"Gold";
            [self msgSkipToView:selectedType];
        } else if ([urlStr rangeOfString:@"view=coupon"].location != NSNotFound) {
            if (SingleUserInfo.loginData.userInfo.userId) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"msgSkipToNativeAPP" object:@{@"type":@"coupon"}];
            }
        } else if ([urlStr rangeOfString:@"view=web&url="].location != NSNotFound) {
            if (SingleUserInfo.loginData.userInfo.userId) {
                NSString *url1 = [Common paramValueOfUrl:urlStr withParam:@"url"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"msgSkipToNativeAPP" object:
                 @{@"type":@"webUrl",@"value":url1}];
            }
        }else if ([urlStr rangeOfString:@"view=reserve&id="].location != NSNotFound) {
            if (SingleUserInfo.loginData.userInfo.userId) {
                NSString *bidID = [Common paramValueOfUrl:urlStr withParam:@"id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"msgSkipToNativeAPP" object: @{@"type":@"bidID",@"value":bidID}];
            }
        }
    }
    return YES;
}
- (void)msgSkipToView:(NSString *)targetStr
{
    if ([targetStr isEqualToString:@"P2P"] || [targetStr isEqualToString:@"ZX"] || [targetStr isEqualToString:@"Gold"] ) {
        if ([self.tabBarController.childViewControllers count] >1) {
            UCFInvestViewController *invest = (UCFInvestViewController *)[[self.tabBarController.childViewControllers objectAtIndex:1].childViewControllers firstObject];
            invest.selectedType = targetStr;
            if ([invest isViewLoaded]) {
                [invest changeView];
            }
            UINavigationController *nav = self.tabBarController.selectedViewController;
            [nav popToRootViewControllerAnimated:NO];
            [self.tabBarController setSelectedIndex:1];
        }
    } else {
        
    }

}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[UMSocialManager defaultManager] handleOpenURL:url]) {
        return YES;
    }
    return NO;
//     || [UcfWalletSDK handleApplication:application openUrl:url]
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([Growing handleUrl:url]) {
        return [Growing handleUrl:url];
    }else
        return [[UMSocialManager defaultManager] handleOpenURL:url];
}

#pragma mark- --------------------极光推送---------------------------

// 新标推送
- (void)pushNewBid:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"choiceCon" object:nil userInfo:dict];
}

// 活动推送
- (void)pushActivityUrlBid:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"choiceCon" object:nil userInfo:dict];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];// 向服务器上报Device Token
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];// 处理收到的APNS消息，向服务器上报收到APNS消息
    DDLogDebug(@"收到通知:%@", [self logDic:userInfo]);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];// 处理收到的APNS消息，向服务器上报收到APNS消息
    completionHandler(UIBackgroundFetchResultNewData);
    DDLogDebug(@"收到通知:%@", [self logDic:userInfo]);
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}




// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    return str;
}



#pragma mark -
- (void)getLoginImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=57"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!recervedData) {
                return ;
            }
            NSString *imageStr=[[NSMutableString alloc] initWithData:recervedData encoding:NSUTF8StringEncoding];
            NSArray *arr = [imageStr objectFromJSONString];
            NSString *LoginURL = @"";
            if (ScreenHeight == 480) {
                LoginURL = [arr objectAtIndex:1][@"thumb"];
            } else if (ScreenHeight == 812) {
                LoginURL = [arr objectAtIndex:4][@"thumb"];
            }
            else{
                LoginURL = [arr objectAtIndex:0][@"thumb"];
            }

            [[NSUserDefaults standardUserDefaults] setValue:LoginURL forKey:@"LoginImageUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            SDImageCache *cache = [[SDImageCache alloc] init];
            NSURL * url = [NSURL URLWithString:LoginURL];
            BOOL hasImage = [cache diskImageExistsWithKey:LoginURL];
            if (!hasImage) {
                [Common storeImage:url];
            }
        });
    });
}

//- (void)getAdversementLift
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=54"];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString:URL]];
//        [request setHTTPMethod:@"GET"];
//        NSHTTPURLResponse *urlResponse = nil;
//        NSError *error = nil;
//        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!recervedData) {
//                return ;
//            }
//            NSString *imageStr=[[NSMutableString alloc] initWithData:recervedData encoding:NSUTF8StringEncoding];
//            NSArray *arr = [imageStr objectFromJSONString];
//            if (arr.count > 0) {
//                NSDictionary *dataDic = arr[0];
//                [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:@"AD_ACTIViTY_DIC_NEW"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//            }
//        });
//    });
//}
- (void)geInvestmentSuccesseLift
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=56"];;
        if ([[Common getBundleID] isEqualToString:@"com.dzlh.jgrcapp"]) {
            URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=56"];
        } else {
            //测试
            URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=29"];
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!recervedData) {
                return ;
            }
            NSString *imageStr=[[NSMutableString alloc] initWithData:recervedData encoding:NSUTF8StringEncoding];
            NSArray *arr = [imageStr objectFromJSONString];
            if (arr.count > 0) {
                NSDictionary *dataDic = arr[0];
                [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:@"InvestmentSuccesseLift"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        });
    });
}
- (void)getSharePictureAdversementLink
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //线上
        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=55"];
        if ([[Common getBundleID] isEqualToString:@"com.dzlh.jgrcapp"]) {
            URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=55"];
        } else {
            //测试
            URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner.php?key=0ca175b9c0f726a831d895e&id=28"];
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!recervedData) {
                return ;
            }
            NSString *imageStr=[[NSMutableString alloc] initWithData:recervedData encoding:NSUTF8StringEncoding];
            NSArray *arr = [imageStr objectFromJSONString];
            if (arr.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"SharePictureAdversementLink"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        });
    });
}

//检测是否有tab红点
- (void)checkPersonCenterRedPoint
{
    if (SingleUserInfo.loginData.userInfo.userId) {
        NSDictionary *paraDict = @{@"userId":SingleUserInfo.loginData.userInfo.userId};
        [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:kSXTagCheckPersonRedPoint owner:self signature:YES Type:SelectAccoutDefault];
    }
}

- (void)setWebViewUserAgent
{
    //修改webView标识

    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent=[webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@/%@/%@",userAgent,@"FinancialWorkshop",[Common getIOSVersion]],@"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
    [Common setHTMLCookies:[[NSUserDefaults standardUserDefaults] objectForKey:DOPA] andCookieName:@"jg_nyscclnjsygjr"];
    [Common setHTMLCookies:[UserInfoSingle sharedManager].wapSingature andCookieName:@"encryptParam"];//    #warning 灰度
    [[NSUserDefaults standardUserDefaults] synchronize];

    //    测试重新加cookies
//    [Common addTestCookies];
}
#pragma mark - 初始化日志
- (void)initializeLog
{
    DDLogDetailedMessage *logFormatter = [[DDLogDetailedMessage alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    //    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    //1> 开启使用XcodeColors
    setenv("XcodeColors", "YES", 0);
    //2 >检测是否开启 XcodeColors
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES")) == 0) {
        // XcodeColors is installed and enabled!
        DDLogDebug(@"XcodeColors is installed and enabled");
    }
    //3 >开启DDLog 颜色
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    UIColor *rc = [UIColor colorWithRed:(89/255.0) green:(120/255.0) blue:(218/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:rc backgroundColor:nil forFlag:DDLogFlagInfo];
    
    UIColor *gr = [UIColor colorWithRed:(25/255.0) green:(210/255.0) blue:(153/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:gr backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    UIColor *bl = [UIColor colorWithRed:(30/255.0) green:(231/255.0) blue:(249/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:bl backgroundColor:nil forFlag:DDLogFlagDebug];
    
    UIColor *ye = [UIColor colorWithRed:(249/255.0) green:(224/255.0) blue:(147/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:ye backgroundColor:nil forFlag:DDLogFlagWarning];
    
    UIColor *re = [UIColor colorWithRed:(234/255.0) green:(151/255.0) blue:(149/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:re backgroundColor:nil forFlag:DDLogFlagError];
    
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
}

@end
// iOS10.2 之后如果info.plist里面的ATS 为YES 的情况下，也需要加这个
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
