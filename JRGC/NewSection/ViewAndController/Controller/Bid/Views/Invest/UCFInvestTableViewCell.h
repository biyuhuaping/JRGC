//
//  UCFInvestTableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/1/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UCFMicroMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN
@class UCFInvestTableViewCell;
@protocol UCFInvestTableViewCellDelegate <NSObject>

- (void)investCell:(UCFInvestTableViewCell *)investCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface UCFInvestTableViewCell : BaseTableViewCell
@property (strong, nonatomic) UCFMicroMoneyModel *microMoneyModel;

@property (weak, nonatomic)id<UCFInvestTableViewCellDelegate>delegate;

@property (weak, nonatomic)NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
