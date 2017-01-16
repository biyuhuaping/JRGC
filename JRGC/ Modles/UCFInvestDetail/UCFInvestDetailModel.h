//
//  UCFInvestDetailModel.h
//  JRGC
//
//  Created by NJW on 15/5/12.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFRefundDetailModel.h"
#import "UCFConstractModel.h"

@interface UCFInvestDetailModel : NSObject
// 应收违约金
@property (nonatomic, strong) NSString *refundPrepaymentPenalty;
// 已收本金
@property (nonatomic, strong) NSString *refundPrincipal;
// 标状态
@property (nonatomic, copy) NSString *status;
// 标类型
@property (nonatomic, copy) NSString *claimsType;
// 应收利息
@property (nonatomic, strong) NSString *awaitInterest;
// 已收利息
@property (nonatomic, strong) NSString *refundInterest;
// 标名称
@property (nonatomic, copy) NSString *prdName;
// 应收总额
@property (nonatomic, strong) NSString *allAmt;
// 标id
@property (nonatomic, copy) NSString *prdNum;
// 年化
@property (nonatomic, copy) NSString *annualRate;
// 预期收益
@property (nonatomic, copy) NSString *taotalIntrest;
// 标限期
@property (nonatomic, copy) NSString *repayPeriod;
// 订单id
@property (nonatomic, copy) NSString *Id;
// 投资金额
@property (nonatomic, strong) NSString *investAmt;
// 还款方式
@property (nonatomic, copy) NSString *repayModeText;
// 当前期数
@property (nonatomic, copy) NSString *refundSummarysNow;
// 应收本金
@property (nonatomic, strong) NSString *awaitPrincipal;
// 回款期数
@property (nonatomic, copy) NSString *refundSummarysCount;
// 起息日
@property (nonatomic, copy) NSString *effactiveDate;
//最近回款日
@property (nonatomic,copy) NSString *currentRepayPerDate;

//实际回款日
@property (nonatomic,copy) NSString * paidTime;

// 实付金额
@property (nonatomic, strong) NSString *actualInvestAmt;
// 原标年化收益
@property (nonatomic, strong) NSString *oldPrdClaimAnnualRate;
// 原标剩余期限
@property (nonatomic, strong) NSString *oldPrdClaimRepayPeriod;
// 原标还款方式
@property (nonatomic, strong) NSString *oldPrdClaimRepayModeText;
// 原标起息日期
@property (nonatomic, strong) NSString *oldPrdClaimEffactiveDate;


// 合同数组
@property (nonatomic, strong) NSArray *contractClauses;
// 回款明细数组
@property (nonatomic, strong) NSArray *refundSummarys;

//等级加息
@property (nonatomic, strong) NSString *gradeIncreases;

//返还工豆
@property (nonatomic, strong) NSString *returnBeans;

//计息方式
@property (nonatomic, strong) NSString *interestMode;



-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)investDetailWithDict:(NSDictionary *)dict;
@end
