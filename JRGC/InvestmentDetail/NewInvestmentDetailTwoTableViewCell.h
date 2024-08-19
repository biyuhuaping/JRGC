//
//  NewInvestmentDetailTwoTableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/3/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UCFInvestDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewInvestmentDetailTwoTableViewCell : BaseTableViewCell
- (void)setValueOfTableViewCellLabel:(UCFInvestDetailModel *)model type:(NSString*)tp;
@end

NS_ASSUME_NONNULL_END
