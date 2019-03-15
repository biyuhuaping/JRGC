//
//  UCFCollectionChildCell.h
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UCFCollectionRootModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFCollectionChildCell : BaseTableViewCell
@property(nonatomic, strong)UCFCollcetionResult *dataModel;
@end

NS_ASSUME_NONNULL_END
