//
//  UCFCollectionViewModel.h
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseViewModel.h"

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
@end

NS_ASSUME_NONNULL_END
