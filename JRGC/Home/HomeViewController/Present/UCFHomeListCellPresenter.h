//
//  UCFHomeListCellPresenter.h
//  JRGC
//
//  Created by njw on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeListCellModel.h"

@interface UCFHomeListCellPresenter : NSObject
+ (instancetype)presenterWithItem:(UCFHomeListCellModel *)item;

- (UCFHomeListCellModel *)item;

- (NSString *)proTitle;
- (UCFHomeListCellModelType)modelType;
- (NSString *)type;
- (NSString *)annualRate;
- (NSString *)repayModeText;
- (NSString *)repayPeriodtext;
- (NSString *)minInvest;
- (NSString *)maxInvest;
- (NSString *)repayPeriod;
- (NSString *)availBorrowAmount;
- (NSString *)platformSubsidyExpense;
- (NSString *)guaranteeCompanyName;
- (NSString *)fixedDate;
- (NSString *)holdTime;
- (NSString *)totalCount;
- (NSString *)p2pTransferNum;
- (NSString *)zxTransferNum;
- (NSString *)transferNum;
- (NSString *)completeLoan;
- (NSString *)appointPeriod;
- (int)status;

- (CGFloat)cellHeight;
@end
