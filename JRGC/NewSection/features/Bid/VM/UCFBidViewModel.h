//
//  UCFBidViewModel.h
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFBidModel.h"
#import "FBKVOController.h"
#import "NSObject+FBKVOController.h"
#import "UCFContractTypleModel.h"
#import "NewPurchaseBidController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFBidViewModel : NSObject
- (void)setDataModel:(UCFBidModel *)model;

/**
 获取标ID

 @return 标ID
 */
- (NSString *)getDataModelBidID;

/**
 获取输入框金额

 @return 金额
 */
- (NSString *)getTextFeildInputMoeny;
@property(nonatomic,strong) UIView    *superView;
@property(nonatomic, strong)NSString *prdName;
@property(nonatomic, strong)NSArray  *prdLabelsList;
@property(nonatomic, copy) NSString  *platformSubsidyExpense; //贴
@property(nonatomic, copy) NSString  *guaranteeCompanyName;   //盾牌
@property(nonatomic, copy) NSString  *fixedDate;              //固
@property(nonatomic, copy) NSString  *holdTime;               //灵

/**
 利率
 */
@property(nonatomic, copy)NSString *annualRate;

/**
 期限
 */
@property(nonatomic, copy)NSString *timeLimitText;

/**
 可投金额
 */
@property(nonatomic, copy)NSString *remainingMoney;
/**
 二级以上标签数组
 */
@property(nonatomic, strong)NSMutableArray  *markList;

/**
 我的资金
 */
@property(nonatomic, copy)NSString          *myFundsNum;

/**
 我的工豆
 */
@property(nonatomic, copy)NSString          *myBeansNum;

/**
 所有资金
 */
@property(nonatomic, copy)NSString          *totalFunds;

/**
 预期利息
 */
@property(nonatomic, copy)NSString          *expectedInterestNum;

/**
 输入框默认填充
 */
@property(nonatomic, copy)NSString          *inputViewPlaceStr;

/**
 返息券可用张数
 */
@property(nonatomic, copy)NSString          *couponNum;

@property(nonatomic, assign)BOOL            couponIsHide;

/**
 返息券反的钱数
 */
@property(nonatomic, copy)NSString          *repayCoupon;
/**
返现券可用张数
 */
@property(nonatomic, copy)NSString          *cashNum;
@property(nonatomic, assign)BOOL            cashIsHide;
/**
 返现券反的钱数
 */
@property(nonatomic, copy)NSString          *repayCash;

@property(nonatomic, assign)BOOL          headherIsHide;

@property(nonatomic, copy)NSString          *allMoneyInputNum;

- (void)dealMyfundsNumWithBeansSwitch:(UISwitch *)switchView;
- (void)calculate:(NSString *)investMoney;
- (void)calculateTotalMoney;

//******************************************************
//我的合同

/**
 投资限额文本
 */
@property(nonatomic,copy)NSString       *limitAmountMess;

/**
 限投数字
 */
@property(nonatomic,copy)NSString       *limitAmountNum;

/**
 是否显示CFCA
 */
@property(nonatomic,copy)NSString       *cfcaContractName;

/**
 合同内容
 */
@property(nonatomic,strong)NSArray       *contractMsg;


/**
 返回合同t标题

 @param viewModel self
 @param contractName 合同名称
 */
- (void)bidViewModel:(UCFBidViewModel *)viewModel WithContractName:(NSString *)contractName;

@property(nonatomic,strong)UCFContractTypleModel *contractTypeModel;


- (void)dealInvestLogic;


@property(nonatomic, assign)BOOL      isExistRecomder;
@property(nonatomic, assign)BOOL      isLimit;

- (void)outputRecommendCode:(NSString *)string;


//投标数据
@property(nonatomic, strong)NSDictionary    *hsbidInfoDict;
@property(nonatomic, weak) NewPurchaseBidController *rootController;
@property(nonatomic, copy) NSString         *rechargeStr;

- (void)bidViewModel:(UCFBidViewModel *)viewModel Witalert:(UIAlertView *)alertView;
@end

NS_ASSUME_NONNULL_END
