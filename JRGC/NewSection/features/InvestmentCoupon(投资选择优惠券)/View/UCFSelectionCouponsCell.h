//
//  UCFSelectionCouponsCell.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "YYLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFSelectionCouponsCell : BaseTableViewCell


@property (nonatomic, strong) MyRelativeLayout *couponTypeLayout;
@property (nonatomic, strong) YYLabel     *couponAmounLabel;//券面值
@property (nonatomic, strong) YYLabel     *remarkLabel; //券名称
@property (nonatomic, strong) YYLabel     *overdueTimeLabel;//过期时间
@property (nonatomic, strong) MyRelativeLayout *willExpireLayout; //即将过期的图标

@property (nonatomic, strong) MyRelativeLayout *couponDateLayout;
@property (nonatomic, strong) YYLabel     *investMultipLabel;//投资限额
@property (nonatomic, strong) YYLabel     *inverstPeriodLabel;//投资期限

@property (nonatomic, strong) UIButton    *selectCouponsBtn;//选择优惠券
@end

NS_ASSUME_NONNULL_END
