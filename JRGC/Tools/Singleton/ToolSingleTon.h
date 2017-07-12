//
//  ToolSingleTon.h
//  JRGC
//
//  Created by 金融工场 on 15/7/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuxiliaryFunc.h"
@interface ToolSingleTon : NSObject
@property(nonatomic, copy)NSString      *apptzticket;
@property(nonatomic, assign)double      readTimePrice;
//@property(nonatomic,assign) BOOL checkIsInviteFriendsAlert;//监测是否邀友赚钱弹框
+ (ToolSingleTon *)sharedManager;

//获取黄金价格
- (void)getGoldPrice;
//展示视图
- (void)showAlertViewWithQianDaoGongDouCount:(NSString *)gongDouCount nextDayBeans:(NSString *)nextDayBeans signDays:(NSString *)signDays  win:(BOOL)isWin winAmount:(NSString *)winAmount rewardAmt:(NSString *)rewardAmt;
- (void)hideAlertAction:(id)sender;
@end
