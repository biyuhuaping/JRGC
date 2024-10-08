//
//  UCFCommodityView.h
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "UCFHomeMallDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFCommodityView : BaseView

@property(nonatomic, strong)UIImageView *shopImageView;
@property(nonatomic, strong)UILabel     *shopName;
@property(nonatomic, strong)UILabel     *shopValue; //折扣价
//@property(nonatomic, strong)UILabel     *shopOrginalValue; //原价
@property(nonatomic, strong)UILabel     *discountLab;//折扣

- (instancetype)initWithFrame:(CGRect)frame withHeightOfCommodity:(CGFloat)height;

- (void)setShopValueWithModel:(id )model;

@end

NS_ASSUME_NONNULL_END
