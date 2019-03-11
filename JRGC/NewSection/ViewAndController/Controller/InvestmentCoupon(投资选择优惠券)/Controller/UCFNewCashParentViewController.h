//
//  UCFNewCashParentViewController.h
//  JRGC
//
//  Created by zrc on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"
#import "UCFInvestmentCouponCashTicketController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewCashParentViewController : UCFNewBaseViewController



@property(nonatomic, strong)NSArray     *canUseCashArray;
@property(nonatomic, strong)NSArray     *unCanUseCashArray;


@property(nonatomic, strong)NSArray     *cashSelectArr; //选中的返现券数组
@property (nonatomic, copy) NSString    *investAmt;//投资金额

- (void)backToTheInvestmentPage;

- (void)confirmTheCouponOfYourChoice;

@end

NS_ASSUME_NONNULL_END
