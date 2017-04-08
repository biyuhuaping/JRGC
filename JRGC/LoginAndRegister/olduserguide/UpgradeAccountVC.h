//
//  UpgradeAccountVC.h
//  JRGC
//
//  Created by biyuhuaping on 16/8/4.
//  Copyright © 2016年 qinwei. All rights reserved.
//  升级存管账户

#import <UIKit/UIKit.h>
#import "UCFOldUserGuideViewController.h"

@interface UpgradeAccountVC : UCFBaseViewController

@property (assign, nonatomic) UCFOldUserGuideViewController *db;
@property (strong, nonatomic) NSString *idCardNo;//身份证号
@property (assign, nonatomic) BOOL isFromeBankCardInfo;//是否是从修改绑定银行卡页面进来
@property (copy, nonatomic)NSString     *site; //徽商还是p2p

@end
