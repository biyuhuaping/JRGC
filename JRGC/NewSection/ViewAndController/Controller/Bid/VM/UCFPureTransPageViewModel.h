//
//  UCFPureTransPageViewModel.h
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseViewModel.h"
#import "UCFPureTransBidRootModel.h"
#import "UCFContractTypleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFPureTransPageViewModel : BaseViewModel
- (void)setDataModel:(UCFPureTransBidRootModel *)model;

/**
 标标题
 */
@property(nonatomic, copy) NSString     *prdName;


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
 标签数组
 */
@property(nonatomic, strong)NSArray    *markList;

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



/**
 全透计算金额
 */
- (void)calculateTotalMoney;

/**
 计算预期收益

 @param currentText 输入框金额
 */
- (void)calculate:(NSString *)currentText;


/**
 是否显示CFCA合同 NO 不显示，YES 显示
 */
@property(nonatomic, assign)BOOL    isShowCFCA;

/**
 是否显示风险提示合同 NO 不显示，YES 显示
 */
@property(nonatomic, assign)BOOL    isShowRisk;

/**
 合同内容
 */
@property(nonatomic,strong)NSArray       *contractMsg;
/**
 是否显示尊享 NO 不显示，YES 显示
 */
@property(nonatomic, assign)BOOL    isShowHonerTip;

/**
 合同点击
 
 @param viewModel self
 @param contractName 合同名称
 */
- (void)bidViewModel:(UCFPureTransPageViewModel *)viewModel WithContractName:(NSString *)contractName;


@property(nonatomic,strong)UCFContractTypleModel *contractTypeModel;

@property(nonatomic, weak) UIView    *superView;

- (void)dealInvestLogic;

@property(nonatomic, strong)NSDictionary    *hsbidInfoDict;

@end

NS_ASSUME_NONNULL_END
