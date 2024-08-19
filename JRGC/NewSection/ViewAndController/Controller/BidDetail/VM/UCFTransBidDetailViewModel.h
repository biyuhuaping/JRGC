//
//  UCFTransBidDetailViewModel.h
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseViewModel.h"
#import "UCFTransBidInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFTransBidDetailViewModel : BaseViewModel
- (void)blindModel:(BaseModel *)model;

#pragma mark 标题
@property(nonatomic, copy)NSString  *prdName;
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



///**
// 完成百分比
// */
//@property(nonatomic, copy)NSString *completeRateStr;
@property(nonatomic, strong)NSArray     *markList;

@property(nonatomic, weak)UIView *view;

@property(nonatomic,copy)NSString *bidInvestText;
- (void)dealClickAction:(NSString *)title;

- (NSArray *)getTableViewData;
- (NSArray *)getTableViewData1;


@end

NS_ASSUME_NONNULL_END
