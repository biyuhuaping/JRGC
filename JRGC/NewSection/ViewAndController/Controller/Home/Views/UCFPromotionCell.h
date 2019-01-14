//
//  UCFPromotionCell.h
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, VSpaceType) {
    HomeBeansAdType,
    HomeShopAdType,
    
};
NS_ASSUME_NONNULL_BEGIN

@interface UCFPromotionCell : BaseTableViewCell
@property(nonatomic, assign)CGFloat           vTopSpace;
@property(nonatomic, assign)CGFloat           vBottomSpace;
@property(nonatomic, assign)CGFloat           hLeftSpace;
@property(nonatomic, assign)CGFloat           hRightSpace;
@property(nonatomic, assign)VSpaceType        cellType;
@end

NS_ASSUME_NONNULL_END
