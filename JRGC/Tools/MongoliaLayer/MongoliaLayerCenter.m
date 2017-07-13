//
//  MongoliaLayerCenter.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "MongoliaLayerCenter.h"
#import "NSDate+IsBelongToToday.h"
#import "MaskView.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UCFHomeViewController.h"
#import "HSHelper.h"
#import "FestivalActivitiesWebView.h"
#import "FullWebViewController.h"
@interface MongoliaLayerCenter ()<MaskViewDelegate>
{
    NSInteger num;
}
@end
@implementation MongoliaLayerCenter
+ (MongoliaLayerCenter *)sharedManager
{
    static MongoliaLayerCenter *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (NSMutableDictionary *)mongoliaLayerDic
{
    if (!_mongoliaLayerDic) {
        _mongoliaLayerDic = [NSMutableDictionary dictionary];
        [_mongoliaLayerDic setValue:[NSNumber numberWithInt:1] forKey:@"authorization"];
    }
    return _mongoliaLayerDic;
}
- (void)checkCurrentController
{
    
}
- (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}
- (void)showLogic
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = app.tabBarController.selectedViewController;
    if (app.advertisementView || [self isCurrentViewControllerVisible:app.lockVc] || ![nav.visibleViewController isKindOfClass:[UCFHomeViewController class]]) {
        return;
    }
    
//    FestivalActivitiesWebView *festivalView = [[FestivalActivitiesWebView alloc] initWithNibName:@"FestivalActivitiesWebView" bundle:nil];
//    festivalView.url = @"https://m.9888.cn/static/wap/topic-invite/index.html";
//    festivalView.isHideNavigationBar = YES;
//    festivalView.definesPresentationContext = YES;
//    festivalView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    if (kIS_IOS8) {
//        festivalView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    }
//    [nav presentViewController:festivalView animated:NO completion:nil];
    
    //不登录就需要查看的
    NSDate *lastFirstLoginTime = [[NSUserDefaults standardUserDefaults] objectForKey:FirstAlertViewShowTime];
    BOOL isBelongToToday = [NSDate isBelongToTodayWithDate:lastFirstLoginTime]; //是不是同一天
    //NO 代表当天只显示一回的
    if (!isBelongToToday) {
//        //新手政策是否显示
        if ([[self.mongoliaLayerDic valueForKey:@"novicePoliceOnOff"] boolValue]) {
            //通知弹窗显示新手政策
            [self.tableView setContentOffset:CGPointMake(0, 0)];
            MjAlertView *alertView = [[MjAlertView alloc] initInviteFriendsToMakeMoneyDelegate:self];
            alertView.tag = 1000;
            [alertView show]; 
            return;
        }
    }
    //下面是需要登录后查看的
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        return;
    }
    //是否弹用户引导蒙层 *****3.0.30需求去掉引导遮罩
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:CHECK_ISSHOW_MASKVIEW]) {
//        //发送弹蒙层通知
//        MaskView *view = [MaskView makeViewWithMask:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//        view.delegate = self;
//        [view show];
//        return;
//    }
    //是否弹平台升级调整公告
    if (![[self.mongoliaLayerDic valueForKey:@"authorization"] boolValue]) {
        NSString *authorizationDate = [self.mongoliaLayerDic valueForKey:@"authorizationDate"];
        MjAlertView *alertView = [[MjAlertView alloc] initPlatformUpgradeNotice:self withAuthorizationDate:authorizationDate];
        alertView.tag = 1001;
        [alertView show];
        return;
    }
    //
    if (([UserInfoSingle sharedManager].enjoyOpenStatus == 1 || [UserInfoSingle sharedManager].enjoyOpenStatus == 2) && !_honerAlert) {
        MjAlertView *alertView = [[MjAlertView alloc] initSkipToHonerAccount:self];
        alertView.tag = 1002;
        _honerAlert = YES;
        [alertView show];
    }
}
- (void)viewWillRemove:(MaskView *)view
{
    [view removeFromSuperview];
    [self showLogic];
}

- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = app.tabBarController.selectedViewController;
    if (alertview.tag == 1000) {
        FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:HOMEINVITATIONURL title:@"邀请返利"];
        webView.flageHaveShareBut = @"分享";
        webView.sourceVc = @"UCFLatestProjectViewController";
        [nav pushViewController:webView animated:YES];
    }else if (alertview.tag == 1001) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:KSXTagADJustMent owner:self signature:YES Type:SelectAccoutDefault];
        [self showLogic];
    } else if (alertview.tag == 1002) {
        
        HSHelper *helper = [HSHelper new];
        if (![helper checkP2POrWJIsAuthorization:SelectAccoutTypeHoner]) {
            [helper pushP2POrWJAuthorizationType:SelectAccoutTypeHoner nav:nav];
        } else {
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:nav];
        }
    }
}
#pragma mark  netMethod
-(void)beginPost:(kSXTag)tag {
    
}
-(void)endPost:(id)result tag:(NSNumber*)tag {
    //    NSString *data = (NSString *)result;
    //    NSMutableDictionary *dic = [data objectFromJSONString];
    [self.mongoliaLayerDic setValue:[NSNumber numberWithInt:1] forKey:@"authorization"];
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag {
    
}
@end
