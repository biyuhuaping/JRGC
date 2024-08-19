//
//  UCFCouponPopupHomeView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "BaseBottomButtonView.h"
#import "UCFCouponPopupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFCouponPopupHomeView : BaseView

//@property (nonatomic, strong) UIButton *cancelButton; //取消



- (id)initWithFrame:(CGRect)frame withModel:(UCFCouponPopupModel *)model;
@end

NS_ASSUME_NONNULL_END
