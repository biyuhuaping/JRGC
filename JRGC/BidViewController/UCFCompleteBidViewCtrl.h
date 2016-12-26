//
//  UCFCompleteBidViewCtrl.h
//  JRGC
//
//  Created by biyuhuaping on 15/5/14.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFPurchaseBidViewController.h"
@interface UCFCompleteBidViewCtrl : UCFBaseViewController

@property (strong, nonatomic)   NSMutableDictionary *dataDict;
@property (nonatomic, assign)   UCFPurchaseBidViewController * superView;
@property (nonatomic, assign)   BOOL      isTransid;
@property (nonatomic, assign)   BOOL      isBackWorkPointGotoShop; //是否从工分页面跳转到工豆商城页面
/**
 *  更改用户返回的跳转页
 */
- (void)changeBackActionMark;
@end
