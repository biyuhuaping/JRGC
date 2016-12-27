//
//  UCFTransterBid.h
//  JRGC
//
//  Created by MAC on 14-9-23.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//  债券转让

#import <Foundation/Foundation.h>

@interface UCFTransterBid : NSObject

@property (nonatomic, strong) NSString *transfereeYearRate;     //受让人年化收益
@property (nonatomic, strong) NSString *cantranMoney;           //可购买金额
@property (nonatomic, strong) NSString *completeRate;           //购买比例
@property (nonatomic, strong) NSString *transtrId;              //债权转让Id
@property (nonatomic, strong) NSString *investAmt;              //最低转让额
@property (nonatomic, strong) NSString *lastDays;               //剩余天数
@property (nonatomic, strong) NSString *name;                   //转让标名称
@property (nonatomic, strong) NSString *oldPrdOrderId;          //原订单Id
@property (nonatomic, strong) NSString *prdClaimsId;            //原始产品标id
@property (nonatomic, strong) NSString *status;                 //转让标状态
@property (nonatomic, strong) NSString *repayModeText;          //还款方式
@property (nonatomic, strong) NSString *guaranteeCompany;       //0：无担保公司1：有担保公司

@property (nonatomic, assign) BOOL isAnim;              //是否动画

//初始化方法
- (id)initWithDictionary:(NSDictionary *)dic;

@end