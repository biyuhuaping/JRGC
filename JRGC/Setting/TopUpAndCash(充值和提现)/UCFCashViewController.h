//
//  UCFCashViewController.h
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "FMDeviceManager.h"

//@interface UCFCashViewController : UCFBaseViewController<FMDeviceManagerDelegate>
#warning 同盾修改
@interface UCFCashViewController : UCFBaseViewController
@property (nonatomic, strong)NSMutableDictionary    *cashInfoDic;
@property (nonatomic,assign) BOOL isCompanyAgent;
@end
