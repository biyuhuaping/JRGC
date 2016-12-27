//
//  FundsDetailFrame.h
//  JRGC
//
//  Created by NJW on 15/4/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FundsDetailModel;

@interface FundsDetailFrame : NSObject
/**
 *  明细名称的frame
 */
@property (nonatomic, assign, readonly) CGRect nameF;
/**
 *  金额标题的frame
 */
@property (nonatomic, assign, readonly) CGRect jinETitleF;
/**
 *  金额的frame
 */
@property (nonatomic, assign, readonly) CGRect jinEF;
/**
 *  冻结金额标题的frame
 */
@property (nonatomic, assign, readonly) CGRect frozenJinETitleF;
/**
 *  冻结金额的frame
 */
@property (nonatomic, assign, readonly) CGRect frozenJinEF;
/**
 *  发生时间标题的frame
 */
@property (nonatomic, assign, readonly) CGRect happendTimeTitleF;
/**
 *  发生时间的frame
 */
@property (nonatomic, assign, readonly) CGRect happendTimeF;
/**
 *  备注标题的frame
 */
@property (nonatomic, assign, readonly) CGRect markTitleF;
/**
 *  备注的frame
 */
@property (nonatomic, assign, readonly) CGRect markF;

/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;


@property (nonatomic, strong) FundsDetailModel *fundsDetailModel;
@end
