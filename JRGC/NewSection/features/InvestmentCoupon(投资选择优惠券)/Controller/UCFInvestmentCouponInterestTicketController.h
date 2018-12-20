//
//  UCFInvestmentCouponInterestTicketController.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"
@class UCFInvestmentCouponController;
NS_ASSUME_NONNULL_BEGIN

@interface UCFInvestmentCouponInterestTicketController : UCFBaseViewController

@property (nonatomic, copy) NSMutableArray *selectArray;//选中的数组

@property (nonatomic, weak) UCFInvestmentCouponController *db;

@end

NS_ASSUME_NONNULL_END
