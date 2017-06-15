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
+ (MongoliaLayerCenter *)sharedManager;
- (void)showLogic;

@end
