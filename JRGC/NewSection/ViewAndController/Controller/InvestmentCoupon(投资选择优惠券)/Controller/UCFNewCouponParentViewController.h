//
//  UCFNewCouponParentViewController.h
//  JRGC
//
//  Created by zrc on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"
#import "UCFInvestmentCouponInterestTicketController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewCouponParentViewController : UCFNewBaseViewController
@property(nonatomic, strong)NSArray     *canUseCouponArray;
@property(nonatomic, strong)NSArray     *unCanUseCouponArray;

@property(nonatomic, strong)NSArray     *couponSelectArr; //选中的返息券数组
@property (nonatomic, copy) NSString    *investAmt;//投资金额

- (void)backToTheInvestmentPage;

- (void)confirmTheCouponOfYourChoice;
@end

NS_ASSUME_NONNULL_END
