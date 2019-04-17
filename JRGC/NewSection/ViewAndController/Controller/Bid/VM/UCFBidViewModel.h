//
//  UCFBidViewModel.h
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
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

@property(nonatomic, weak) UIView    *superView;
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
 是否为机构用户
 */
@property(nonatomic, assign)BOOL            isCompanyAgent;
//******************************************************

/**
 输入金额是否有变动,如果有变动会在controller里把先前选中的优惠券信息清空
 */
@property(nonatomic, assign)BOOL            investMoneyIsChange;

/**
 返息券可用张数
 */
@property(nonatomic, copy)NSString          *couponNum;
/**
 当前输入金额下的可用张数
 */
@property(nonatomic, copy)NSString          *availableCouponNum;


/**
 返现券所有数据的数组
 */
@property (nonatomic, strong)NSArray        *cashCouponArray;

/**
 返息券所有数据的数组
 */
@property (nonatomic, strong)NSArray        *interestCouponArray;

@property(nonatomic, assign)BOOL            couponIsHide;
/**
 返息券反的总钱数
 */
@property(nonatomic, copy)NSString          *repayCoupon;

/**
 返息券需要投资资金
 */
@property(nonatomic, copy)NSString          *couponTotalcouponAmount;
/**
 选中返息券张数
 */
@property(nonatomic, assign)NSInteger       couponSelectCount;

/**
 选中返息券ID串
 */
@property(nonatomic, copy)NSString          *couponIDStr;


/**
返现券可用张数
 */
@property(nonatomic, copy)NSString          *cashNum;

/**
 当前输入金额下的可用张数
 */
@property(nonatomic, copy)NSString          *availableCashNum;




@property(nonatomic, assign)BOOL            cashIsHide;
/**
 返现券返钱总额
 */
@property(nonatomic, copy)NSString          *repayCash;

/**
 返现券需要投资资金
 */
@property(nonatomic, copy)NSString          *cashTotalcouponAmount;

/**
 选中返现券张数
 */
@property(nonatomic, assign)NSInteger       cashSelectCount;

/**
 选中返现券ID串
 */
@property(nonatomic, copy)NSString          *cashTotalIDStr;


/**
 优惠券提示框
 */
@property(nonatomic, assign)BOOL          headherIsHide;


/**
 最大填充金额
 */
@property(nonatomic, copy)NSString          *allMoneyInputNum;


/**
 输入框金额
 */
@property (nonatomic, strong)NSString       *investMoeny;

- (void)dealMyfundsNumWithBeansSwitch:(UIButton *)switchView;
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

- (UCFBidModel *)getDataData;

/**
 计算返息券反的工豆
 
 @param backInterstae 返息券利率
 @return 返息工豆价值
 */
- (NSString  *)getInvestGetBeansByCoupon:(NSString *)backInterstae;
@end

NS_ASSUME_NONNULL_END
