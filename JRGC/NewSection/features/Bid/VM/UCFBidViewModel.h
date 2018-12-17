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
NS_ASSUME_NONNULL_BEGIN

@interface UCFBidViewModel : NSObject
- (void)setDataModel:(UCFBidModel *)model;

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
- (void)dealMyfundsNumWithBeansSwitch:(UISwitch *)switchView;
- (void)calculate:(NSString *)investMoney;
@end

NS_ASSUME_NONNULL_END
