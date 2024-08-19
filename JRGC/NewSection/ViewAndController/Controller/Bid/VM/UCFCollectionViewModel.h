//
//  UCFCollectionViewModel.h
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseViewModel.h"
#import "UCFContractTypleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFCollectionViewModel : BaseViewModel

@property(nonatomic, strong)BaseModel   *model;
/**
 标名
 */
@property(nonatomic, copy)NSString      *prdName;

/**
 利率
 */
@property(nonatomic, copy)NSString      *annualRate;

/**
 期限
 */
@property(nonatomic, copy)NSString      *timeLimitText;

/**
 剩余期限
 */
@property(nonatomic, copy)NSString      *remainingMoney;

/**
 标签数组
 */
@property(nonatomic, strong)NSArray     *markList;



/**
 个人资金
 */
@property(nonatomic, copy)NSString      *myMoneyNum;

/**
 输入框默认金额
 */
@property(nonatomic, copy)NSString      *inputViewPlaceStr;


@property(nonatomic, copy)NSString      *expectedInterestStr;

@property(nonatomic, copy)NSString      *allMoneyInputNum;


- (void)calculate:(NSString *)investMoney;
- (void)calculateTotalMoney;
#pragma mark 合同

/**
 字符串长度大于0 展示CFCA
 */
@property(nonatomic, copy)NSString      *cfcaContractName;
//是否展示风险提示
@property(nonatomic, assign)BOOL          isShowRisk;
/**
 合同内容
 */
@property(nonatomic,strong)NSArray       *contractMsg;
//当前点击的合同模型，在controller 里进行监听
@property(nonatomic, strong)UCFContractTypleModel *contractTypeModel;

- (void)bidViewModel:(UCFCollectionViewModel *)viewModel WithContractName:(NSString *)contractName;

@property(nonatomic, weak)UIViewController  *parentViewController;

/**
 是否填写工场吗
 */
@property(nonatomic, assign)BOOL    isLimit;

- (void)dealInvestLogic;

@property(nonatomic, copy)NSString  *recommendStr;

- (void)outputRecommendCode:(NSString *)recommendStr;
@end

NS_ASSUME_NONNULL_END
