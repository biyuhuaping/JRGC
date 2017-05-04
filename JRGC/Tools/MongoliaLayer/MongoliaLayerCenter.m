//
//  MongoliaLayerCenter.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "MongoliaLayerCenter.h"
#import "NSDate+IsBelongToToday.h"
@interface MongoliaLayerCenter ()
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckInviteFriendsAlertView" object:nil];
            //通知弹窗显示新手政策
            return;
        }
    }
    
    //下面是需要登录后查看的
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
//        return;
//    }
    //是否弹用户引导蒙层
    if (![[NSUserDefaults standardUserDefaults] boolForKey:CHECK_ISSHOW_MASKVIEW]) {
        //发送弹蒙层通知
        return;
    }
    //是否弹平台升级调整公告
    if (![[self.mongoliaLayerDic valueForKey:@"升级"] boolValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_UPDATE_ALERT object:nil];
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
@end
