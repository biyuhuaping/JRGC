//
//  UCFCommodityView.h
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFCommodityView : BaseView

@property(nonatomic, strong)UIImageView *shopImageView;
@property(nonatomic, strong)UILabel     *shopName;
@property(nonatomic, strong)UILabel     *shopValue;

- (instancetype)initWithFrame:(CGRect)frame withHeightOfCommodity:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
