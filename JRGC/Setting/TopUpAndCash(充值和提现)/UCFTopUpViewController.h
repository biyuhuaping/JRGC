//
//  UCFTopUpViewController.h
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFTopUpViewController : UCFBaseViewController

@property(nonatomic, assign)UCFBaseViewController   *uperViewController;
@property(nonatomic, copy)  NSString                *defaultMoney;
@property(nonatomic, strong)NSDictionary            *dataDict;
@end
