//
//  PraiseAlert.m
//  JRGC
//
//  Created by 金融工场 on 15/11/6.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "PraiseAlert.h"
#import "LockFlagSingle.h"
@interface PraiseAlert () <UIAlertViewDelegate>
@end
@implementation PraiseAlert
- (void)checkPraiseAlertIsEjectWithGoodCommentAlertType:(UIGoodCommentAlertType )alertType WithRollBack:(rollBack)roback
{
    self.block = roback;
    self.showAlertType = alertType;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [NSString stringWithFormat:@"%@_%@",[infoDic objectForKey:@"CFBundleShortVersionString"],[LockFlagSingle sharedManager].netVersion];
    NSString *keyName = [NSString stringWithFormat:@"%@_%ld",PRAISALERTISUP,(long)_showAlertType];
    NSDictionary *preCurrentDict = [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
    //为空标示第一次安装app 从未弹出过
    if (preCurrentDict == nil) {
        [self upalert:nil];
        
    } else {
        //上次弹出框的版本号
        NSString *preVersion = [preCurrentDict valueForKey:@"version"];
        if ([preVersion isEqualToString:currentVersion]) {
            //取出对应版本号存放的数值，如果0是给过好评 1是稍后 2残忍的拒绝
            NSString *isUp = [preCurrentDict valueForKey:@"clickMark"];
            //如果是0 则认为没有弹出过
            if ([isUp isEqualToString:@"0"]) {
                //给过好评 不弹
            } else if ([isUp isEqualToString:@"1"]) {
                //点击的稍后 比较是不是两天前的点击的
                NSTimeInterval lastTimer = [[preCurrentDict valueForKey:@"clickTime"] doubleValue];
                NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                if (nowTime - lastTimer > 2 * 24 * 3600) {
                    [self upalert:@"1"];
                }
            } else if ([isUp isEqualToString:@"2"]) {
                //残忍的拒绝 不弹
            }
        } else {
            [self upalert:nil];
        }
    }
}
- (void)upalert:(NSString *)upStyle
{
    NSString *showStr = @"";
    if (_showAlertType == PaymentStyle) {
        if (upStyle != nil && [upStyle isEqualToString:@"1"]) {
            showStr = @"豆哥给您的收益还满意吗？给个5星好评吧~";
        } else {
            showStr = @"我们已把您的本息护送到账,您的评价是我们护送时最大的动力!";
        }
    } else if (_showAlertType == SingSevenDays) {
        showStr = @"连续签到7天有额外的奖励,这个设置您还满意吗~";
    } else if (_showAlertType == FirstInvestSuceess) {
        if (upStyle != nil && [upStyle isEqualToString:@"1"]) {
            showStr = @"投资的过程中我们还有让您不满意的地方吗?";
        } else {
            showStr = @"恭喜您在新版中第一次成功投资,您对我们投资的过程有什么不满意的地方吗?";

        }
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:showStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"给个好评",@"我要吐槽",@"残忍的拒绝", nil];
    [alert show];
    self.block();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(55.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [NSString stringWithFormat:@"%@_%@",[infoDic objectForKey:@"CFBundleShortVersionString"],[LockFlagSingle sharedManager].netVersion];
    NSString *isUp = @"";
    NSDictionary *dict = nil;
    if (buttonIndex == 0) {
        // 去给好评
        isUp = @"0";
        dict = [NSDictionary dictionaryWithObjectsAndKeys:currentVersion,@"version",isUp,@"clickMark" ,nil];
        NSURL *url = [NSURL URLWithString:APP_RATING_URL];
        [[UIApplication sharedApplication] openURL:url];
    } else if (buttonIndex == 1) {
        // 拒绝
        isUp = @"2";
        dict = [NSDictionary dictionaryWithObjectsAndKeys:currentVersion,@"version",isUp,@"clickMark" ,nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(popYouMengFeedBackViewController)]) {
            [self.delegate popYouMengFeedBackViewController];
        }
        
    } else if (buttonIndex == 2){
        if (_showAlertType == PaymentStyle || _showAlertType == FirstInvestSuceess)
        {
            // 残忍的拒绝 2天后继续提醒
            isUp = @"1";
            NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:currentVersion,@"version",isUp,@"clickMark",[NSNumber numberWithDouble:nowTime],@"clickTime",nil];
        } else if (_showAlertType == SingSevenDays) {
            // 拒绝
            isUp = @"2";
            dict = [NSDictionary dictionaryWithObjectsAndKeys:currentVersion,@"version",isUp,@"clickMark" ,nil];
        }
    }
    NSString *keyName = [NSString stringWithFormat:@"%@_%ld",PRAISALERTISUP,(long)_showAlertType];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShouldWarnUserUpdate:(NSString *)netVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [NSString stringWithFormat:@"%@_%@",[infoDic objectForKey:@"CFBundleShortVersionString"],netVersion];

    NSDictionary *preCurrentDict = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATEWARNALERT];
    if (preCurrentDict == nil) {
        //warnMarked 
        [self storageUpdateMarked:currentVersion];
        //*第一次提醒无论wifi 还是 移动网络的状态 都给用户提醒 */
        return YES;
    } else {
        //*第一次提醒无论wifi 还是 移动网络的状态 都给用户提醒 */
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATEWARNALERT];
        NSString *key = [[dic allKeys] objectAtIndex:0];
        if ([key isEqualToString:currentVersion]) {
            NSString *value = dic[key];
            if ([value isEqualToString:@"warnMarked"]) {
                if ([[DeviceInfo getNetConnectionState] isEqualToString:WIFI]) {
                    return YES;
                } else {
                    return NO;
                }
            } else {
                return YES;
            }
        } else {
            [self storageUpdateMarked:currentVersion];
            return YES;
        }
        return YES;
    }
    return NO;
}
// 存储是否弹过更新框的标示符
+ (void)storageUpdateMarked:(NSString *)version
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"warnMarked" forKey:version];
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:UPDATEWARNALERT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
