//
//  UCFCouponPopupCell.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "YYLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFCouponPopupCell : BaseTableViewCell

@property (nonatomic, strong) MyRelativeLayout *couponTypeLayout;
@property (nonatomic, strong) UILabel     *couponAmounLabel;//券面值
@property (nonatomic, strong) UIButton    *immediateUseBtn; //立即使用
@property (nonatomic, strong) UILabel     *remarkLabel; //券名称
@property (nonatomic, strong) UILabel     *overdueTimeLabel;//过期时间

@property (nonatomic, strong) MyRelativeLayout *couponDateLayout;
@property (nonatomic, strong) UILabel     *investMultipLabel;//投资限额
@property (nonatomic, strong) UILabel     *inverstPeriodLabel;//投资期限

@end

NS_ASSUME_NONNULL_END
