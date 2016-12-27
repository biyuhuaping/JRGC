//
//  UCFNormalInvestment.h
//  JRGC
//
//  Created by MAC on 14-9-27.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFNormalInvestment : NSObject

//图标路径
@property(nonatomic,retain) NSString *prdLogoPath;
//债权Id
@property(nonatomic,retain) NSString *prdId;
//债权编码
@property(nonatomic,retain) NSString *prdNum;
//债券名称
@property(nonatomic,retain) NSString *prdName;
//借款金额
@property(nonatomic,retain)NSString *borrowAmount;
//投资完成额
@property(nonatomic,copy)NSString *completeLoan;
//最小投资额
@property(nonatomic,retain)NSString *minInvest;
//年化借款利率
@property(nonatomic,retain)NSString *loanAnnualRate;
//年化收益率
@property(nonatomic,retain)NSString *annualRate;
//剩余时间
@property(nonatomic,retain)NSString *lastTime;
//还款期限
@property(nonatomic,retain)NSString *repayPeriod;
//还款方式
@property(nonatomic,retain) NSString *repayMode;
@property(nonatomic,retain) NSString *fixedDate;
@property(nonatomic,copy) NSString *maxInvest;
//
@property(nonatomic,retain) NSString *platformSubsidyExpense;
//初始化方法
- (id)initWithDictionary:(NSDictionary *)dicJson;

@end
