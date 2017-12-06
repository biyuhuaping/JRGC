//
//  MongoliaLayerCenter.h
//  JRGC
//
//  Created by 张瑞超 on 2017/5/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MjAlertView.h"
#import "NetworkModule.h"
@interface MongoliaLayerCenter : NSObject<MjAlertViewDelegate,NetworkModuleDelegate>
//蒙层显示数组
@property (nonatomic, strong) NSMutableDictionary *mongoliaLayerDic;
@property (nonatomic, assign) BOOL lockViewDisappear; //默认为NO
@property (nonatomic, weak)   UITableView   *tableView;
//@property (nonatomic, assign) BOOL honerAlert;        //默认为NO
@property (nonatomic, assign)   BOOL  switchFlag;//   开关标识：1:弹出 0:不弹出    string; zrc fixed
@property (nonatomic,strong)NSString  *activityType;//  活动类型标识：新的活动标识（判断和之前活动是否相同）

+ (MongoliaLayerCenter *)sharedManager;
- (void)showLogic;

@end
