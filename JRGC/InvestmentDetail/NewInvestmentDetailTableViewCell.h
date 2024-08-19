//
//  NewInvestmentDetailTableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/3/22.
//  Copyright © 2019 JRGC. All rights reserved.
//


#import "BaseTableViewCell.h"
#import "UCFInvestDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewInvestmentDetailTableViewCell : BaseTableViewCell
@property(assign,nonatomic) SelectAccoutType accoutType;//选择的账户 默认是P2P账户 hqy添加

- (void)setValueOfTableViewCellLabel:(UCFInvestDetailModel *)model type:(NSString*)tp;
@end

NS_ASSUME_NONNULL_END
