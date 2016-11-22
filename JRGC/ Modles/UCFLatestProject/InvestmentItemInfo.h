//
//  InvestmentItemInfo.h
//  JRGC
//
//  Created by biyuhuaping on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestmentItemInfo : NSObject

//金融工场
@property (nonatomic, strong) NSString *annualRate;     //年化收益率
@property (nonatomic, strong) NSNumber *borrowAmount;   //标的总额/借款金额
@property (nonatomic, strong) NSString *guaranteeCompany;//字典查询(如果不为空显示担保ICON)
@property (nonatomic, strong) NSNumber *completeLoan;   //投资完成额
@property (nonatomic, strong) NSString *idStr;          //债权Id
@property (nonatomic, strong) NSString *holdTime;       //期限
@property (nonatomic, strong) NSNumber *minInvest;      //起投金额
@property (nonatomic, strong) NSNumber *maxInvest;      //最大投资额
@property (nonatomic, strong) NSString *fixedDate;      //固定起息日 固定起息日(如果不为空显示ICON)
@property (nonatomic, strong) NSString *platformSubsidyExpense;//如果不为空显示补贴icon

@property (nonatomic, strong) NSArray *prdLabelsList;   //标签列表
@property (nonatomic, strong) NSString *prdName;        //债权名称
//@property (nonatomic, strong) NSString *prdNum;         //债权编码
//@property (nonatomic, strong) NSNumber *repayMode;      //还款方式
@property (nonatomic, strong) NSString *repayModeText;  //还款方式text
//@property (nonatomic, strong) NSString *repayPeriod;    //投资期限
@property (nonatomic, strong) NSString *repayPeriodtext;//投资期限text
//@property (nonatomic, strong) NSString *showStatus;     //显示状态： 0、推荐 1、置顶
@property (nonatomic, strong) NSString *status;         //标状态
//@property (nonatomic, strong) NSString *tradeMark;      //交易备注类型(或者标品牌)
@property (nonatomic, strong) NSNumber *isOrder;        //登录用户是否投资过该标(>0就是投资过)
//@property (nonatomic, strong) NSString *repayPeriodDay;


@property (nonatomic, assign) BOOL isAnim;              //是否动画

@property (nonatomic, strong) NSString *homeType;//标类型
@property (nonatomic, strong) NSString *homeTile;//标类型名称
@property (nonatomic, strong) NSString *homeIconUrl;//标类型icon
//初始化方法
- (id)initWithDictionary:(NSDictionary *)dicJson;

@end
