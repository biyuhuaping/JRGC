//
//  UCFTransRechargeViewController.h
//  JRGC
//
//  Created by 金融工场 on 2018/11/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFTransRechargeViewController : UCFBaseViewController
@property(nonatomic, copy) NSString *bankStr;
- (void)refreshTableView;

@end
