//
//  UCFTransterBidHeadDetail.h
//  JRGC
//
//  Created by MAC on 14-9-26.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFTransterBidHeadDetail : NSObject
{
    
}
//债权转让Id
@property(nonatomic,retain) NSString *transtrId;
//原订单Id
@property(nonatomic,retain) NSString *oldPrdOrderId;
//转让标名称
@property(nonatomic,retain) NSString *transterName;
//债券剩余天数
@property(nonatomic,retain) NSString *lastDays;
//债券总天数
@property(nonatomic,retain) NSString *totalDays;
//补偿利息折扣
@property(nonatomic,retain) NSString *interestlDiscount;
//本金折扣
@property(nonatomic,retain) NSString *principalDiscount;
//计划转让本金
@property(nonatomic,retain) NSString *planPrincipalAmt;
//已转让本金
@property(nonatomic,retain) NSString *realPrincipalAmt;
//剩余时间
@property(nonatomic,retain) NSString *lastTime;
//下一回款日
@property(nonatomic,retain) NSString *nextRepaymentTime;
//最低转让额
@property(nonatomic,retain) NSString *investAmt;
@property(nonatomic,retain) NSString *transferName;

//--------原始借款标信息----------
//头像路径
@property(nonatomic,retain) NSString *prdLogoPath;
//原始标名称
@property(nonatomic,retain) NSString *prdName;
//预期年化收益率
@property(nonatomic,retain) NSString *annualRate;
//投资期限
@property(nonatomic,retain) NSString *repayPeriod;
//还款方式
@property(nonatomic,retain) NSString *repayMode;
//原始表标借款人名称
@property(nonatomic,retain) NSString *borrowName;
//原始标放款时间
@property(nonatomic,retain) NSString *loanDate;
//担保公司名称
@property(nonatomic,retain) NSString *guaranteeCompanyName;
//担保方式
@property(nonatomic,retain) NSString *guaranteeCoverageNane;

//初始化方法
-(id)initWithDictionary:(NSDictionary *)dicJson;

@end
