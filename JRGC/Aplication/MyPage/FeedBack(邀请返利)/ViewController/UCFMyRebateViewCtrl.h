//
//  UCFMyRebateViewCtrl.h
//  JRGC
//
//  Created by biyuhuaping on 15/5/11.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFMyRebateViewCtrl : UCFBaseViewController

@property (copy, nonatomic) void(^headerInfoBlock)(NSDictionary *);
@property (nonatomic,strong) NSDictionary   *feedBackDictionary;
@end
