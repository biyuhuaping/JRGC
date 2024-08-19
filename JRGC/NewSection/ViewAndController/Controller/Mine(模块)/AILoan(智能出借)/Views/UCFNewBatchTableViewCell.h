//
//  UCFNewBatchTableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/3/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UCFMyBatchBidModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewBatchTableViewCell : BaseTableViewCell

@property(nonatomic, strong)UCFMyBatchBidResult *model;
@end

NS_ASSUME_NONNULL_END
