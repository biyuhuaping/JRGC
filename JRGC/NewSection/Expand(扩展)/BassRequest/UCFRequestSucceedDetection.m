//
//  UCFRequestSucceedDetection.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRequestSucceedDetection.h"
#import "AppDelegate.h"
@interface UCFRequestSucceedDetection()<UIAlertViewDelegate>
@property (nonatomic, assign) BOOL isShowAlert;

@property (nonatomic, assign) BOOL isShowSingleAlert; //是否已经弹出单设备警告框

@end
@implementation UCFRequestSucceedDetection

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowAlert = YES;
        self.isShowSingleAlert = YES;
    }
    return self;
}
- (void)requestSucceedDetection:(NSDictionary *)succeedDetectionDic
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (![succeedDetectionDic isKindOfClass:[NSDictionary class]] || succeedDetectionDic == nil) {
        return;
    }
    DDLogDebug(@"%@",succeedDetectionDic);
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:succeedDetectionDic];
    NSInteger rstcode = [dic[@"code"] integerValue];
    BOOL ret = [dic[@"ret"] boolValue];
    if (rstcode == -1) {
        SingleUserInfo.loginType = LoginSingatureOut;
//  无效的请求,也需要退出
        UCFPopViewWindow *popView = [UCFPopViewWindow new];
        popView.delegate = appDelegate;
        popView.contentStr = dic[@"message"];
        popView.type = POPMessageLoginInvalid;
        popView.popViewTag = 10001;
        [popView startPopView];
    }
    else if (rstcode == -2 || rstcode == -3 || rstcode == -4 || rstcode == -6)
    {
        SingleUserInfo.loginType = LoginSingatureOut;
        //清空数据
        [SingleUserInfo deleteUserData];
        UCFPopViewWindow *popView = [UCFPopViewWindow new];
        popView.delegate = appDelegate;
        popView.contentStr = dic[@"message"];
        if (rstcode == -6) {
            popView.type = POPMessageLoginOutService;
            popView.popViewTag = 10002;
        }
        else
        {
            popView.type = POPMessageLoginOut;
            popView.popViewTag = 10001;
        }
        
        [popView startPopView];
        
    }
    else if (rstcode == -5 )
    {
        //强制更新
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_NEW_VERSION object:nil];
        
    }
//    if (rstcode != -1 && rstcode != -2 && rstcode != -3 && rstcode != -4 && rstcode != -6 && ret == NO) {
//        ShowMessage(dic[@"message"]);
//    }
}








// 提示框的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0x100)
    {
        if(buttonIndex == 0){//取消
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
            UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
            [nav popToRootViewControllerAnimated:NO];
            [appDelegate.tabBarController setSelectedIndex:0];
        } else {//重新登录
            [SingleUserInfo loadLoginViewController];
        }
        self.isShowSingleAlert = YES;
    }
    else if (alertView.tag == 0x101)
    {
        if (buttonIndex == 0) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSUInteger selectedIndex = app.tabBarController.selectedIndex;
            UINavigationController *nav = [app.tabBarController.viewControllers objectAtIndex:selectedIndex];
            if (app.tabBarController.presentedViewController)
            {
                NSString *className =  [NSString stringWithUTF8String:object_getClassName(app.tabBarController.presentedViewController)];
                if ([className hasSuffix:@"UINavigationController"]) {
                    [app.tabBarController dismissViewControllerAnimated:NO completion:^{
                        [nav popToRootViewControllerAnimated:NO];
                        [app.tabBarController setSelectedIndex:0];
                    }];
                }
            }
            else
            {
                [nav popToRootViewControllerAnimated:NO];
                [app.tabBarController setSelectedIndex:0];
            }
        }
        else {
            [SingleUserInfo loadLoginViewController];
        }
        self.isShowSingleAlert = YES;
    } else {
        // 升级新版本 退出应用
        NSURL *url = [NSURL URLWithString:APP_RATING_URL];
        [[UIApplication sharedApplication] openURL:url];
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [dele exitApplication];
    }
}
@end
