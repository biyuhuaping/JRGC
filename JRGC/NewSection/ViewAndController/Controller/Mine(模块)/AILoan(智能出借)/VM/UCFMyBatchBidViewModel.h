//
//  UCFMyBatchBidViewModel.h
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseViewModel.h"
#import "UCFMyBtachBidRoot.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFMyBatchBidViewModel : BaseViewModel

@property(nonatomic, strong)UCFMyBtachBidRoot   *myBatchModel;

@property(nonatomic, copy)NSString      *prdName;

#pragma mark 标信息

/**
 项目个数
 */
@property(nonatomic, copy)NSString  *projectNum;

/**
 可投金额
 */
@property(nonatomic, copy)NSString  *remainMoney;

/**
 利率
 */
@property(nonatomic, copy)NSString  *annualRate;

/**
 期限
 */
@property(nonatomic, copy)NSString  *markTimeStr;

/**
 投资百分比
 */
@property(nonatomic, copy)NSString  *percentage;


@property(nonatomic, strong)NSArray *markList;

@property(nonatomic, strong)NSString  *bidInvestText;

@end

NS_ASSUME_NONNULL_END
