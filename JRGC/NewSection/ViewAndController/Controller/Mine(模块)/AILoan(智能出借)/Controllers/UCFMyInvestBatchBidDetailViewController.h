//
//  UCFMyInvestBatchBidDetailViewController.h
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFNewBaseViewController.h"
#import "UCFMyBtachBidRoot.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFMyInvestBatchBidDetailViewController : UCFNewBaseViewController
@property(nonatomic, strong)UCFMyBtachBidRoot   *dataModel;
@property(nonatomic, copy) NSString *colPrdClaimIdStr;
@property(nonatomic, copy) NSString *batchOrderIdStr;
@end

NS_ASSUME_NONNULL_END
