//
//  AppDelegate.m
//  JRGC
//
//  Created by HeJing on 15/3/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "AppDelegate.h"
#import "UCFSession.h"
#import "UCFLoginViewController.h"
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
#import "JPUSHService.h"//极光推送
#import "Growing.h"


#import "JSPatch.h"
#import "MD5Util.h"


@interface AppDelegate () <UCFSessionDelegate>

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (strong, nonatomic) UIImageView *advertisementView;
@property (assign, nonatomic) NSInteger backTime;
@property (assign, nonatomic) BOOL isComePushNotification;
@property (assign, nonatomic) BOOL isFirstStart;
@property (assign, nonatomic) BOOL isComeForceUpdate;
@property (assign, nonatomic) BOOL isShowAdversement;
@property (assign, nonatomic) BOOL isAfter;//是否延时（只在3DTouch启动时使用）

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    @"JOJO";
    //修改webView标识
    [self setWebViewUserAgent];
    [UCFSession sharedManager].delegate = self;
    [self checkUpdate];
    [self checkIsShowHornor];
    //[self getHealthData];
//    return YES;
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
    manager->initWithOptions(options); 				//初始化
    
    // SDK具有防调试功能，当使用xcode运行时，请取消此行注释，开启调试模式
    // 否则使用xcode运行会闪退，(但直接在设备上点APP图标可以正常运行)
    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
    // [options setValue:@"allowd" forKey:@"allowd"];  // TODO

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkInitiaLogin) name:CheckIsInitiaLogin object:nil];
    
    [IPDetector getWANIPAddressWithCompletion:^(NSString *IPAddress) {
        NSString *curWanIp = IPAddress;
        if (![curWanIp isEqualToString:@""] && curWanIp) {
            curWanIp = [AuxiliaryFunc deleteHuanHang:[NSMutableString stringWithString:curWanIp]];
        }
        [[NSUserDefaults standardUserDefaults] setValue:curWanIp forKey:@"curWanIp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
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

    
    //初始化广告view
    _advertisementView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    //获取广告地址
    if ([[Common machineName] isEqualToString:@"4"]) {
        [self getAdversementImageStyle:4];
    } else {
        [self getAdversementImageStyle:3];
    }
    
    BOOL islaunch= [[NSUserDefaults standardUserDefaults] boolForKey:@"islaunch"];
    if (!islaunch ) {
        [self showGuidePageController];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLockView"];
        NSString *strParameters = nil;
        strParameters = [NSString stringWithFormat:@"equipment=%@&remark=%@&serialNumber=%@&sourceType=%@",[Common platformString],@"1",[Common getKeychain],@"1"];
        //统计用户数量
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagCalulateInstallNum owner:self];
        _advertisementView = nil;
    } else {
        [self showTabbarController];
        NSInteger useLockView = [[[NSUserDefaults standardUserDefaults] valueForKey:@"useLockView"] integerValue];
        //使用手势密码 显示
        if (useLockView == 1) {
            [self showGCode];
        } else {
            [self checkInitiaLogin];
        }
        [self addLoadingBaseView];
        //本地存储的广告地址 为空或者不存在 则不显示广告
        NSString *imagUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"adversementImageUrl"];
        SDImageCache *cache = [[SDImageCache alloc] init];
        //检查本地是否存在最新的广告图片
        BOOL hasImage = [cache diskImageExistsWithKey:imagUrl];
        if (hasImage) {
            _isShowAdversement = YES;
        } else {
            _isShowAdversement = NO;
        }
        //显示广告
        if (_isShowAdversement) {
            [self showAdvertisement];
        } else {
            [self.lockVc openTouchidAlert];
        }
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLoginOut) name:SAFE_LOGIN_OUT object:nil];

    if (launchOptions) {
        NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (message) {
            _isFirstStart = YES;
        }
    } else {
        _isFirstStart = NO;
    }

    //TODO:3D Touch-------------------------------------------
    if (kIS_IOS9) {
        [self createItem];
        UIApplicationShortcutItem *item = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if (item) {
            DBLog(@"从快捷方式打开项目: %@", item.localizedTitle);
        } else {
            DBLog(@"正常启动.");
        }
        _isAfter = YES;
    }
    
    //TODO:------------------启动GrowingIO--------------------
    [Growing startWithAccountId:@"b9ed2e92ac9b1c59"];
    // 其他配置
    // 开启Growing调试日志 可以开启日志
//    [Growing setEnableLog:NO];
    
    // ------------ 极光推送 ------------
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKEY channel:nil apsForProduction:YES];
    [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:UUID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [JPUSHService setBadge:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registJush) name:REGIST_JPUSH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPersonCenterRedPoint) name:CHECK_RED_POINT object:nil];
    [self checkPersonCenterRedPoint];
    //调用红点接口，通知服务器红点标示倍查看
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRedPointShouldHide:) name:REDALERTISHIDE object:nil];
    /**
     *  极光推送自定义消息推送
     NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
     [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
     [defaultCenter addObserver:self
     selector:@selector(networkDidLogin:)
     name:kJPFNetworkDidLoginNotification
     object:nil];
     */
    //[self performSelector:@selector(checkSwitchState) withObject:nil afterDelay:2];
    [self checkJSPatchUpdate];
    [[UserInfoSingle sharedManager] getUserData];

//    YWFPSLabel *aaa = [[YWFPSLabel alloc] init];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:aaa];
    return YES;
}
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
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2022554825"  appSecret:@"e496f6f9df690579441c9ae4e26be6e4" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}
//检测JSPatch 是否有更新
- (void)checkJSPatchUpdate
{
    
    if(EnvironmentConfiguration == 1 || EnvironmentConfiguration == 2) { //线上或者灰度
         [JSPatch startWithAppKey:JSPATCH_APPKEY];
         [JSPatch setupRSAPublicKey:JSPATCH_RSA_PUBLICKEY];
         [JSPatch sync];
    } else { //测试
         [JSPatch startWithAppKey:@"1d0e92fa182f2874"];
         [JSPatch setupRSAPublicKey:JSPATCH_RSA_PUBLICKEY];
         [JSPatch testScriptInBundle];
    }

    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
        switch (type) {
            case JPCallbackTypeUpdate: {
                DBLog(@"updated %@ %@", data, error);
                break;
            }
            case JPCallbackTypeRunScript: {
                DBLog(@"run script %@ %@", data, error);
                break;
            }
            default:
                break;
        }
    }];
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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:UUID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    } else {
        [JPUSHService setBadge:0];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
//    NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags,alias];
//    DLog(@"%@",callbackString);
}
// 之所以把这个红点提到这里，是因为启动APP之后，没有点击个人中心页面的话，未初始化这个api，直接投资查看奖励列表，不能通知服务端把这个红点去掉
- (void)checkRedPointShouldHide:(NSNotification *)noti
{
    NSString *upFlag = noti.object;
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&updFlag=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID],upFlag];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagRedPointCheck owner:self];
}
- (void) createItem {
    //自定义icon 的初始化方法
    UIApplicationShortcutIcon *icon0 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"刮刮卡"];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"邀请返利"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"工场码"];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"签到"];
    
    UIMutableApplicationShortcutItem *item0 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"0" localizedTitle:@"我的刮刮卡" localizedSubtitle:nil icon:icon0 userInfo:nil];
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"我的邀请返利" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"2" localizedTitle:@"我的工场码" localizedSubtitle:nil icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"3" localizedTitle:@"签到抽红包" localizedSubtitle:nil icon:icon3 userInfo:nil];
    [UIApplication sharedApplication].shortcutItems = @[item0,item1,item2,item3];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    // react to shortcut item selections
    DBLOG(@"title:%@,type:%@,userInfo:%@",shortcutItem.localizedTitle,shortcutItem.type,shortcutItem.userInfo);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"guaguakaHide" object:nil];//清理一下个人中心刮刮卡的弹出层
        
        [Touch3DSingle sharedTouch3DSingle].isLoad = YES;
        [Touch3DSingle sharedTouch3DSingle].type = shortcutItem.type;

        //如果重新启动程序，就延时跳转。否则就直接跳转
        if (_isAfter) {
            _isAfter = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tabBarController.selectedIndex = 3;
            });
        }else{
            self.tabBarController.selectedIndex = 3;
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
    [self checkUpdate];
}
// 检测是否首次登录
- (void)checkInitiaLogin
{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), queue, ^{
    DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
          [[ToolSingleTon sharedManager] checkIsSign];
    });
}

//显示广告
- (void)showAdvertisement
{
    UIImage *placehoderImage = [Common getTheLaunchImage];

    _advertisementView.contentMode = UIViewContentModeScaleToFill;
    [_lockVc.view setUserInteractionEnabled:NO];
    //self.window.userInteractionEnabled = NO;
    [_advertisementView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"adversementImageUrl"]] placeholderImage:placehoderImage];
    [_advertisementView setBackgroundColor:[UIColor clearColor]];
    [self.window addSubview:_advertisementView];
    [self.window bringSubviewToFront:_advertisementView];
    
    //跳过按钮
    [_advertisementView setUserInteractionEnabled:YES];
    UIButton *runbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    runbtn.frame = CGRectMake(ScreenWidth - 60, ScreenHeight - 39, 45, 24);
    [runbtn addTarget:self action:@selector(runbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [runbtn setBackgroundImage:[UIImage imageNamed:@"skip.png"] forState:UIControlStateNormal];
    //[runbtn setTitle:@"跳过" forState:UIControlStateNormal];
    [_advertisementView addSubview:runbtn];
    
    [self performSelector:@selector(disapperAdversement) withObject:nil afterDelay:3.0];
}

- (void)runbtnClicked:(id)sender
{
    [self closeAdvertimentView];
}

- (void)closeAdvertimentView
{
    [_advertisementView removeFromSuperview];
    _advertisementView = nil;
    [_lockVc.view setUserInteractionEnabled:YES];
    //添加一个通知 知道广告业退出了 去触发touchid 的事件
    [self.lockVc openTouchidAlert];
}

- (void)disapperAdversement
{
    __weak typeof(self) weakSelf = self;
    if (_advertisementView) {
        [UIView animateWithDuration:1.0 animations:^{
            _advertisementView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [weakSelf closeAdvertimentView];
        }];
    }
}


//- (void)checkIsBeta
//{
//    NSString *strParameters = [NSString stringWithFormat:@"type=%@",@"BETA"];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagIsBetaVerSion owner:self];
//}
-(void)beginPost:(kSXTag)tag
{
    
}
//- (void)saveLoginOut
//{
//    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagUserLogout owner:self];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
//    恢复屏幕的亮度
        DBLog(@"\n ===> 程序暂行 !");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[NSNotificationCenter defaultCenter] postNotificationName:EndBrightnessTimer object:nil];

//    CGFloat  preScreenLight  = [[NSUserDefaults standardUserDefaults] floatForKey:@"preScreenLight"];
//    [[UIScreen mainScreen] setBrightness:preScreenLight];
//    [[NSNotificationCenter defaultCenter] postNotificationName:ReduceBrightness object:nil];

//    DLog(@"DidEnterBackground preScreenLight ==  %lf",preScreenLight);

    CalculatorView * view =  (CalculatorView * )[self.window viewWithTag:173924];;
    [view removeFromSuperview];
    _isFirstStart = YES;

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    _backTime = 0;
    
    _backgroundUpdateTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
        // ...
        // stopped or ending the task outright.
        [application endBackgroundTask:_backgroundUpdateTask];
        _backgroundUpdateTask = UIBackgroundTaskInvalid;
    }];
    if (_backgroundUpdateTask == UIBackgroundTaskInvalid) {
        DBLog(@"failed to start background task!");
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
                // if you don't call endBackgroundTask, the OS will exit your app.
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guaguakaHide" object:nil];
            [self showGCode];
        }
    }
    else {
        [self checkInitiaLogin];
    }
    [self checkIsGongChaView];
    [self checkIsLockView];
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
- (void)checkIsLockView
{
    //判断当前页是否解锁页
//    if (_advertisementView == nil) {
//        if ([Common deveiceIsHaveTouchId]) {
            if ([LockFlagSingle sharedManager].disappearType == DisHome && [LockFlagSingle sharedManager].showSection == LockFingerprint) {
                 [self.lockVc openTouchidAlert];
            }
//        }
//    }
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
    self.window.rootViewController = _tabBarController;
}

// 展示引导页
- (void)showGuidePageController
{
    GuideViewController *guideViewController = [[GuideViewController alloc] init];
    guideViewController.delegate = self;
    self.window.rootViewController = guideViewController;
}

//显示手势密码
- (void)showGCode
{
    NSString* pswd = [LLLockPassword loadLockPassword];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        [Touch3DSingle sharedTouch3DSingle].isShowLock = YES;
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
- (void)addLoadingBaseView
{
    _loadingBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _loadingBaseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _loadingBaseView.hidden = YES;
    [self.window addSubview:_loadingBaseView];
    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 91, 95.5)];
    NSMutableArray * animateArray = [[NSMutableArray alloc]initWithCapacity:8];
    for (int i = 1; i <= 8 ; i++) {
        [animateArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i]]];
    }
    view1.animationImages = animateArray;
    view1.animationRepeatCount = 0;
    view1.animationDuration = 0.8;//设置动画时间
    view1.center = _loadingBaseView.center;
    view1.backgroundColor = [UIColor clearColor];
    [_loadingBaseView addSubview:view1];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.text = @"全力加载中";
    textLab.frame = CGRectMake(CGRectGetMinX(view1.frame), CGRectGetMaxY(view1.frame), CGRectGetWidth(view1.frame), 16);
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor whiteColor];
    textLab.font = [UIFont systemFontOfSize:14.0f];
    [_loadingBaseView addSubview:textLab];
    [view1 startAnimating];
}
- (void)changeRootView
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islaunch"];
    [self showTabbarController];
    [self addLoadingBaseView];
    //[self showGCode];
}
    
- (void)checkIsShowHornor
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowHornor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //请求开关状态
    [[NetworkModule sharedNetworkModule] newPostReq:nil tag:kSXTagIsShowHornor owner:self signature:NO];
}

- (void)checkSwitchState
{
    //请求开关状态
    [[NetworkModule sharedNetworkModule] postReq:@"" tag:kSXTagLevelIsOpen owner:self];
}
- (void)checkUpdate
{
    [[NetworkModule sharedNetworkModule] postReq:@"" tag:kSXTagKicItemList owner:self];
}

- (void)endPost:(id)result tag:(NSNumber*)tag
{
    if (tag.integerValue == kSXTagKicItemList) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] intValue] == 1)
        {
            NSString *netVersion = dic[@"result"][@"iosmaxversion"];
            [LockFlagSingle sharedManager].netVersion = netVersion;
            //是否强制更新 0强制 1随便 2不稳定
            NSInteger versionMark = [dic[@"result"][@"iosupdate"] integerValue];
      
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
            NSComparisonResult comparResult = [netVersion compare:currentVersion options:NSNumericSearch];
            //ipa 版本号 大于 或者等于 Apple 的版本，返回，不做自己服务器检测
            if (comparResult == NSOrderedAscending ||comparResult == NSOrderedSame) {
                if (versionMark == 2) {
                    self.isSubmitAppStoreTestTime = YES;
                }
                return;
            } else {
                NSString *des = @"";
                if ([dic[@"result"][@"iosdes"] isEqual:[NSNull null]]) {
                    des = @"";
                } else {
                    des =dic[@"result"][@"iosdes"];
                }
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
                        [alert show];
                    }
                } else if (versionMark == 2) {
                    DBLog(@"手动更新四小时之内");
                }
            }
        }
    } else if (tag.integerValue == kSXTagCalulateInstallNum){
        
    } else if (tag.integerValue == kSXTagUserLogout){
        [[UserInfoSingle sharedManager] removeUserInfo];
//        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UUID];
//        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:TIME];
//        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:IDCARD_STATE];
//        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:BANKCARD_STATE];
        //        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:GCODE];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [[NSNotificationCenter defaultCenter] postNotificationName:BACK_TO_LOGOUT object:nil];
        [self.tabBarController setSelectedIndex:2];
        //安全退出后弹出登录框
//        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
//        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        [self.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
    } else if (tag.intValue == kSXTagCheckPersonRedPoint) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if ([dic[@"status"] intValue] == 1) {
            NSString *has = dic[@"has"];
            if ([has isEqualToString:@"1"]) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
            } else {
                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
        }
    } else if (tag.intValue == kSXTagRedPointCheck) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if ([dic[@"status"] intValue] == 1) {
            // 通知个人中心刷新，之所以加这个通知，是因为投标成功页查看我的奖励，跟个人中心都要刷新个人中心数据，保持统一（但会造成一次网络浪费，从投标成功页查看我的奖励列表，点击tab的时候也会请求一次这个接口）
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        }
    } else if (tag.intValue == kSXTagLevelIsOpen) {
        //请求大开关 目前大开关已经废弃
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSString *guideIsOpen = dic[@"isOpen"];
        [[NSUserDefaults standardUserDefaults] setValue:guideIsOpen forKey:@"guideIsOpen"];
    }
    else if (tag.integerValue == kSXTagIsShowHornor) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
#warning 测试项目列表显示项
        NSString *zxSwitch = [[dic objectForKey:@"data"] objectForKey:@"zxSwitch"];
        BOOL isShowHornor = (zxSwitch.intValue>0) ? YES:NO;
        [[NSUserDefaults standardUserDefaults] setBool:isShowHornor forKey:@"isShowHornor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:@"网络连接异常"];
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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return   [[UMSocialManager defaultManager] handleOpenURL:url];
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
    DBLOG(@"收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];// 处理收到的APNS消息，向服务器上报收到APNS消息
    completionHandler(UIBackgroundFetchResultNewData);
    DBLOG(@"收到通知:%@", [self logDic:userInfo]);
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

- (void)getAdversementImageStyle:(int)style
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"http://fore.9888.cn/cms/api/appbanners.php?key=0ca175b9c0f726a831d895e&id=19&p=%d",style];
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
            if (imageStr && ![imageStr isEqualToString:@""]) {
                imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            [[NSUserDefaults standardUserDefaults] setValue:imageStr forKey:@"adversementImageUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_advertisementView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
        });
    });
}
// 开启指纹解锁页面
//- (void)openTouchId
//{
//    LAContext *lol = [[LAContext alloc] init];
//    lol.localizedFallbackTitle = @"";
//    NSError *error = nil;
//    NSString *showStr = @"通过home键验证已有手机指纹";
//    //是否存在
//    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
//        //开始运作
//        [lol evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:showStr reply:^(BOOL succes, NSError *error)
//         {
//             if (succes) {
//                 DBLog(@"指纹验证成功");
//                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                     //                     [self hide];
//                     [self.lockVc hide];
//                 }];
//             }
//             else
//             {
//                 DBLog(@"%@",error.localizedDescription);
//                 switch (error.code) {
//                     case LAErrorSystemCancel:
//                     {
//                         DBLog(@"Authentication was cancelled by the system");
//                         //切换到其他APP，系统取消验证Touch ID
//                         break;
//                     }
//                     case LAErrorUserCancel:
//                     {
//                         DBLog(@"Authentication was cancelled by the user");
//                         //用户取消验证Touch ID
//                         break;
//                     }
//                     case LAErrorUserFallback:
//                     {
//                         DBLog(@"User selected to enter custom password");
//                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                             //用户选择输入密码，切换主线程处理
//                         }];
//                         break;
//                     }
//                     default:
//                     {
//                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                             //其他情况，切换主线程处理
//                         }];
//                         break;
//                     }
//                 }
//             }
//         }];
//        
//    }
//    else
//    {
//        switch (error.code) {
//            case LAErrorTouchIDNotEnrolled:
//            {
//                DBLog(@"TouchID is not enrolled");
//                break;
//            }
//            case LAErrorPasscodeNotSet:
//            {
//                //没有touchID 的报错
//                DBLog(@"A passcode has not been set");
//                break;
//            }
//            default:
//            {
//                DBLog(@"TouchID not available");
//                break;
//            }
//        }
//    }
//    
//}
//检测是否有tab红点
- (void)checkPersonCenterRedPoint
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        NSString *strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagCheckPersonRedPoint owner:self];
    }
}

- (void)setWebViewUserAgent
{
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent=[webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@/%@/%@",userAgent,@"FinancialWorkshop",[Common getIOSVersion]],@"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [Common setHTMLCookies:[[NSUserDefaults standardUserDefaults] objectForKey:DOPA]];
    #warning 灰度测试重新加cookies
    [Common addTestCookies];
}

- (void)session:(UCFSession *)session didUCFSessionReceiveUserInfo:(id)userInfo
{
    
    if ([UserInfoSingle sharedManager].userId) {
        
       NSString *gcmcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"gcmCode"];
        NSData *data = [Common createImageCode:gcmcode];
        NSUserDefaults *signatureStr =[[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP];
        NSDictionary *loginSuccessDic = @{@"userId":[UserInfoSingle sharedManager].userId, @"source_type":@"1",@"imei":[Common getKeychain],@"version":[Common getIOSVersion],@"signature":signatureStr,@"imageData":data,@"isSubmitAppStoreAndTestTime":@(self.isSubmitAppStoreTestTime).stringValue};
//        [[UCFSession sharedManager] transformInactionWithInfo:loginSuccessDic withState:UCFSessionStateUserLogin];
        [session.session updateApplicationContext:loginSuccessDic error:nil];
    }

}

@end
