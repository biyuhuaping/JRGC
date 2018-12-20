//
//  UCFInvestmentCouponCashTicketController.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFInvestmentCouponCashTicketController : UCFBaseViewController

@property (nonatomic, copy) NSString *fromSite; //微金尊享标识

@property (nonatomic, copy) NSString *prdclaimid;//标id

@property (nonatomic, copy) NSString *investAmt;//投资金额

@property (nonatomic, copy) NSMutableArray *selectArray;//选中的数组

@end

NS_ASSUME_NONNULL_END
