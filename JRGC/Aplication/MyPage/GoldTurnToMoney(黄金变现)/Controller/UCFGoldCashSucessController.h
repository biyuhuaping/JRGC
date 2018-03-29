//
//  UCFGoldCashSucessController.h
//  JRGC
//
//  Created by njw on 2017/8/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFCashGoldResultModel.h"

@interface UCFGoldCashSucessController : UCFBaseViewController
@property (strong, nonatomic) UCFCashGoldResultModel *cashResuModel;
@property (assign ,nonatomic) BOOL isPurchaseSuccess;//是否购买成功
@property(nonatomic ,strong) NSDictionary *dataDict;
@property (strong,nonatomic)NSString *errorMessageStr;
@end
