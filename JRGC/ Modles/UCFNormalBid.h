//
//  UCFNormalBid.h
//  JRGC
//
//  Created by MAC on 14-9-23.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//
//首页债券列表数据model
#import <Foundation/Foundation.h>

@interface UCFNormalBid : NSObject
{
    
}
//债券Id
@property(nonatomic,retain)NSString *prdId;
//债权编码
@property(nonatomic,retain)NSString *prdNum;
//债权名称
@property(nonatomic,retain)NSString *prdName;
//借款金额
@property(nonatomic,retain)NSString *borrowAmount;
//投资完成额
@property(nonatomic,copy)NSString *completeLoan;
//最小投资额
@property(nonatomic,retain)NSString *minInvest;
//还款期限
@property(nonatomic,retain)NSString *repayPeriod;
//还款方式
@property(nonatomic,retain)NSString *repayMode;
//年化借款利率
@property(nonatomic,retain)NSString *loanAnnualRate;
//annualRate
@property(nonatomic,retain)NSString *annualRate;
//年化平台补偿利率
@property(nonatomic,retain)NSString *platformSubsidyExpense;
//投标开始时间
@property(nonatomic,retain)NSString *startTime;
//投标期限
@property(nonatomic,retain)NSString *periodTerm;
//交易备注类型(或者标品牌)
@property(nonatomic,retain)NSString *tradeMark;
//标状态
@property(nonatomic,retain)NSString *status;
//业务类型
@property(nonatomic,retain)NSString *busType;
//剩余时间
@property(nonatomic,retain)NSString *lastTime;
//图标路径
@property(nonatomic,copy)NSString *prdLogoPath;
@property(nonatomic,retain)NSString *fixedDate;
@property(nonatomic,copy)NSString *guaranteeCompanyName;
// 标类型
@property(nonatomic,retain)NSArray *prdLabelsList;

//初始化方法
-(id)initWithDictionary:(NSDictionary *)dic;
@end
