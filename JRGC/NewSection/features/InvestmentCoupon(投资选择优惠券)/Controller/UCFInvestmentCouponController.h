//
//  UCFInvestmentCouponController.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFInvestmentCouponCashTicketController.h"
#import "UCFInvestmentCouponInterestTicketController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFInvestmentCouponController : UCFBaseViewController

@property (nonatomic, strong) UCFInvestmentCouponCashTicketController *ctController;//返现券

@property (nonatomic, strong) UCFInvestmentCouponInterestTicketController *itController;//返息券

@end

NS_ASSUME_NONNULL_END
