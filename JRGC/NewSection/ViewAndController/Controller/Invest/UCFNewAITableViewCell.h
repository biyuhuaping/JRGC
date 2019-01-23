//
//  UCFNewAITableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UCFMicroMoneyModel.h"
@class UCFNewAITableViewCell;
@protocol UCFNewAITableViewCellDelegate <NSObject>

- (void)aiTableViewCell:(UCFNewAITableViewCell *)aiTableViewCell didClickedInvestButtonWithModel:(UCFMicroMoneyModel *)model;


@end

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewAITableViewCell : BaseTableViewCell
@property (strong, nonatomic) UCFMicroMoneyModel *microModel;
@property (weak, nonatomic)id<UCFNewAITableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
