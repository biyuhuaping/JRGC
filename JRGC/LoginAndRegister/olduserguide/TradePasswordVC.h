//
//  TradePasswordVC.h
//  JRGC
//
//  Created by biyuhuaping on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//  设置交易密码

#import "UCFBaseViewController.h"
#import "UCFOldUserGuideViewController.h"

@interface TradePasswordVC : UCFBaseViewController

@property (assign, nonatomic) UCFOldUserGuideViewController *db;
@property (strong, nonatomic) NSString *idCardNo;       //身份证号

@property (assign, nonatomic) BOOL isCompanyAgent;//是否是机构用户

@end
