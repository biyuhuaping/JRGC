//
//  UCFNewRechargeViewController.h
//  JRGC
//
//  Created by 金融工场 on 2018/11/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFTransRechargeViewController.h"
#import "UCFQuickRechargeViewController.h"
@interface UCFNewRechargeViewController : UCFBaseViewController
@property(nonatomic,copy)NSString *defaultMoney;
@property(nonatomic, weak)UCFBaseViewController   *uperViewController;
@end
