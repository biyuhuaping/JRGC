//
//  UCFRechargeOrCashViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFRechargeOrCashViewController : UCFBaseViewController
@property(nonatomic ,strong) NSDictionary *dataDict;

@property(nonatomic,assign) BOOL isRechargeOrCash;//是充值还是提现 NO 为充值  Yes 为提现
@end
