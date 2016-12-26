//
//  UCFMyInvestment.h
//  JRGC
//
//  Created by MAC on 14-10-8.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//  我的投资数据模型
//
#import <Foundation/Foundation.h>

@interface UCFMyInvestment : NSObject

@property (nonatomic, strong) NSString *prdId;          //债权单id
@property (nonatomic, strong) NSString *prdName;        //借款标题
@property (nonatomic, strong) NSString *prdLogoPath;    //logo
@property (nonatomic, strong) NSString *repayPeriod;    //还款期限
@property (nonatomic, strong) NSString *repayMode;      //还款方式
@property (nonatomic, strong) NSString *investAmt;      //投资金额
@property (nonatomic, strong) NSString *annualRate;     //年化收益率
@property (nonatomic, strong) NSString *effactiveDate;  //起息日
@property (nonatomic, strong) NSString *applyDate;      //交易时间status
@property (nonatomic, strong) NSString *status;         //订单状态
@property (nonatomic, strong) NSString *completeLoan;

- (id)initWithDictionary:(NSDictionary *)dicJson;
- (id)initWithBorrowDictionary:(NSDictionary *)dicJson;

@end
