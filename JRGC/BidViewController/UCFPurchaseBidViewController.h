//
//  UCFPurchaseBidViewController.h
//  JRGC
//
//  Created by 金融工场 on 15/4/28.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//  投标页面

#import "UCFBaseViewController.h"

@interface UCFPurchaseBidViewController : UCFBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, assign)int              bidType;  //0 代表普通和权益 1代表债券转让
@property (nonatomic, strong)NSDictionary    *dataDict;
@property (nonatomic, strong)NSMutableArray  *bidArray;
@property (nonatomic, copy)NSString          *beanIds;

- (void)reloadMainView;
@end
