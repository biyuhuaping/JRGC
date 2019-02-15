//
//  UVFBidDetailViewModel.h
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseViewModel.h"
#import "UCFBidDetailModel.h"
#import "UCFBidModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UVFBidDetailViewModel : BaseViewModel
#pragma mark 标题
@property(nonatomic, copy)NSString  *prdName;
@property(nonatomic, copy)NSString  *childName;
@property(nonatomic, copy)NSString  *navFinish;


- (void)blindModel:(UCFBidDetailModel *)model;
- (UCFBidDetailModel *)getDataModel;
#pragma mark 表头

/**
 总借款
 */
@property(nonatomic, copy)NSString *borrowAmount;
/**
 可投金额
 */
@property(nonatomic, copy)NSString *remainMoney;
/**
 利率
 */
@property(nonatomic, copy)NSString *annualRate;
/**
 期限
 */
@property(nonatomic, copy)NSString *markTimeStr;
/**
 完成百分比
 */
@property(nonatomic, copy)NSString *percentage;

/**
 平台补贴利息
 */
@property(nonatomic, copy)NSString *platformSubsidyExpense;

///**
// 完成百分比
// */
//@property(nonatomic, copy)NSString *completeRateStr;
@property(nonatomic, strong)NSArray     *markList;

#pragma mark 倒计时

/**
 标识 0 代表投标中 1代表满标
 */
@property(nonatomic, strong)NSString *stopStatus;



@property(nonatomic, assign)PROJECTDETAILTYPE type;
@property(nonatomic, assign)BOOL isP2P;
- (NSArray *)getTableViewData;
- (NSArray *)getTableViewData1;


@property(nonatomic,copy)NSString *bidInvestText;

- (void)dealClickAction:(NSString *)title;

@property(nonatomic, strong)UCFBidModel *bidInfoModel;

@property(nonatomic, weak)UIView *view;

@end

NS_ASSUME_NONNULL_END
