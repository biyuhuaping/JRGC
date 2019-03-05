//
//  UCFNewCashParentViewController.h
//  JRGC
//
//  Created by zrc on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewCashParentViewController : UCFNewBaseViewController
@property(nonatomic, strong)NSArray     *canUseCashArray;
@property(nonatomic, strong)NSArray     *unCanUseCashArray;
@property(nonatomic, strong)NSMutableArray  *selectCashArray;
@end

NS_ASSUME_NONNULL_END
