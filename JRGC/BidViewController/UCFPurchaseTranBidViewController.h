//
//  UCFPurchaseTranBidViewController.h
//  JRGC
//
//  Created by 金融工场 on 15/5/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFPurchaseTranBidViewController : UCFBaseViewController
@property (nonatomic, strong)NSDictionary    *dataDict;
@property (nonatomic, strong)NSMutableArray  *bidArray;
- (void)reloadMainView;
@end
