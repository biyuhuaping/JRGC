//
//  UCFNewCouponTableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/3/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NZLabel.h"
#import "UCFCouponListModel.h"
#import "PrintView.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewCouponTableViewCell : BaseTableViewCell
@property (nonatomic, strong) MyRelativeLayout *couponTypeLayout;
@property (nonatomic, strong) UIImageView      *separteImageView;
@property (nonatomic, strong) NZLabel          *couponAmounLabel;//券面值
@property (nonatomic, strong) UILabel     *remarkLabel; //券名称
@property (nonatomic, strong) UILabel     *overdueTimeLabel;//过期时间
@property (nonatomic, strong) MyRelativeLayout *willExpireLayout; //即将过期的图标
@property (nonatomic, strong) UILabel     *investMultipLabel;//投资限额
@property (nonatomic, strong) UILabel     *inverstPeriodLabel;//投资期限
@property (nonatomic, strong) UIButton      *donateButton; //转赠按钮
@property (nonatomic, strong) UIButton      *investButton; //转赠按钮
@property (nonatomic, strong) PrintView *printView;

@property (nonatomic, strong)UCFCouponListResult *model;

@end

NS_ASSUME_NONNULL_END
