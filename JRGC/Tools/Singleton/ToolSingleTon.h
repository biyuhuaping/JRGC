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
+ (ToolSingleTon *)sharedManager;

//检测是否已签到
- (void)checkIsSign;
//展示视图
- (void)showAlertViewWithQianDaoGongDouCount:(NSString *)gongDouCount nextDayBeans:(NSString *)nextDayBeans signDays:(NSString *)signDays  win:(BOOL)isWin winAmount:(NSString *)winAmount rewardAmt:(NSString *)rewardAmt;
- (void)hideAlertAction:(id)sender;
@end
