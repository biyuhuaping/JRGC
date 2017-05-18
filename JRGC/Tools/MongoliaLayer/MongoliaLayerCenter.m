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

- (void)showLogic
{
    //不登录就需要查看的
    NSDate *lastFirstLoginTime = [[NSUserDefaults standardUserDefaults] objectForKey:FirstAlertViewShowTime];
    BOOL isBelongToToday = [NSDate isBelongToTodayWithDate:lastFirstLoginTime]; //是不是同一天
    //NO 代表当天只显示一回的
    if (isBelongToToday) {
        //新手政策是否显示
        if ([[self.mongoliaLayerDic valueForKey:@"novicePoliceOnOff"] boolValue]) {
            //通知弹窗显示新手政策
            MjAlertView *alertView = [[MjAlertView alloc]initInviteFriendsToMakeMoneyDelegate:self];
            alertView.tag = 1000;
            [alertView show];
            return;
        }
    }
    //下面是需要登录后查看的
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        return;
    }
    //是否弹用户引导蒙层
    if (![[NSUserDefaults standardUserDefaults] boolForKey:CHECK_ISSHOW_MASKVIEW]) {
        //发送弹蒙层通知
        MaskView *view = [MaskView makeViewWithMask:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.delegate = self;
        [view show];
        return;
    }
    //是否弹平台升级调整公告
    if (![[self.mongoliaLayerDic valueForKey:@"authorization"] boolValue]) {
        MjAlertView *alertView = [[MjAlertView alloc] initPlatformUpgradeNotice:self];
        alertView.tag = 1001;
        [alertView show];
        return;
    }
    //是否弹平风险评估
    //        if ([[self.mongoliaLayerDic valueForKey:@"风险评估"] boolValue]) {
    //            return;
    //        }
    
    //是否弹红包雨
    //        if ([[self.mongoliaLayerDic valueForKey:@"红包雨"] boolValue]) {
    //            return;
    //        }
}
- (void)viewWillRemove:(MaskView *)view
{
    [view removeFromSuperview];
    [self showLogic];
}

- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index
{
    if (alertview.tag == 1001) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:KSXTagADJustMent owner:self signature:YES Type:SelectAccoutDefault];
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
