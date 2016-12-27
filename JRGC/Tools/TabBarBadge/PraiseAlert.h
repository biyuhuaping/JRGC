//
//  PraiseAlert.h
//  JRGC
//
//  Created by 金融工场 on 15/11/6.
//  Copyright © 2015年 qinwei. All rights reserved.
//

@protocol PraiseAlertDelegate <NSObject>

- (void)popYouMengFeedBackViewController;

@end
typedef NS_ENUM(NSInteger, UIGoodCommentAlertType) {
    PaymentStyle = 0,               // 回款状态
    SingSevenDays,                  //连续签到7天的状态
    FirstInvestSuceess,             //第一次投资成功
};
#import <Foundation/Foundation.h>
typedef void(^rollBack)();
#import "DeviceInfo.h"
@interface PraiseAlert : NSObject
@property (copy, nonatomic) rollBack block;
@property (assign,nonatomic)UIGoodCommentAlertType showAlertType;
@property(nonatomic,weak)id<PraiseAlertDelegate> delegate;
//检测好评框是否弹出
- (void)checkPraiseAlertIsEjectWithGoodCommentAlertType:(UIGoodCommentAlertType )alertType WithRollBack:(rollBack)roback;
//是否弹更新提醒框
+ (BOOL)isShouldWarnUserUpdate:(NSString *)netVersion;
@end
