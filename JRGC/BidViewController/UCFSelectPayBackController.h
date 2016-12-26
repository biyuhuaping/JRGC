//
//  UCFSelectPayBackController.h
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFPurchaseBidViewController.h"
@interface UCFSelectPayBackController : UCFBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain)NSMutableArray     *youHuiArray;
@property (nonatomic, retain)UITableView        *youhuiTableView;

@property (nonatomic, retain)NSMutableArray     *beansArray;
@property (nonatomic, retain)UITableView        *beansTableView;

@property (nonatomic, assign)double             touZiMoney;
@property (nonatomic, assign)double             couponPrdaimSum;                //返现券需要投资金额
@property (nonatomic, assign)double             couponSum;                      //返现券返给用户金额
@property (nonatomic, assign)double             interestPrdaimSum;              //反息券需要投资金额
@property (nonatomic, assign)double             interestSum;                    //反息券返给用户金额
@property (nonatomic, retain)NSMutableArray     *selectedArray;                 //选中的返现券数组
@property (nonatomic, retain)NSMutableArray     *beansSelectArray;              //选中的返息券数组
@property (nonatomic, assign)NSMutableArray     *tmpSelectCashArray;            //返现券临时数据
@property (nonatomic, assign)NSMutableArray     *tmpSelectCounpArray;           //返息临时数据
@property (nonatomic, assign)double             keTouMoney;
@property (nonatomic, assign)double             keYongMoney;
@property (nonatomic, assign)double             onlyMoney;                      //仅现金金额
@property (nonatomic, assign) double            gongDouCount;
@property (nonatomic, copy)NSString             *prdclaimid;
@property (nonatomic, assign)NSInteger          listType;                       //0为返现券 1为反利息券
@property (nonatomic, strong)NSDictionary       *bidDataDict;                   //投标页数据源
@property (nonatomic, copy)NSString             *backInterestRate;              //选中返息券利息
@property (nonatomic, assign) double            occupyRate;                     //按月/按季等额还款资金占用率
@property (nonatomic, weak)UCFPurchaseBidViewController     *superViewController;
- (void)reloadView;
@end
