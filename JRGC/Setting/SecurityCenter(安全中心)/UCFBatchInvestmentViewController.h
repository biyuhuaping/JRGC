//
//  UCFBatchInvestmentViewController.h
//  JRGC
//
//  Created by 金融工场 on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//


#import "UCFBaseViewController.h"
typedef enum {
    BachApply, //徽商存管
    SetQuota,   //设置交易密码
    BachEnd,    //开户成功web页
} BachStep;
@interface UCFBatchInvestmentViewController : UCFBaseViewController
@property (nonatomic, assign) NSInteger isStep;
@end
