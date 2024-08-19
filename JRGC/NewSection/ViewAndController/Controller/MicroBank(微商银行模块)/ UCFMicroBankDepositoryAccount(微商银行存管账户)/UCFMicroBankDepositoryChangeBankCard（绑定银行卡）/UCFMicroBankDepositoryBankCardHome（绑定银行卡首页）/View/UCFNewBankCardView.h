//
//  UCFNewBankCardView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "NZLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewBankCardView : BaseView
@property (strong, nonatomic)  UIImageView *bankImageView;

@property (strong, nonatomic)  UIImageView *bankCardImageView;

@property (strong, nonatomic)  NZLabel *bankNameLabel;

@property (strong, nonatomic)  NZLabel *userNameLabel;

@property (strong, nonatomic)  NZLabel *cardNoLabel;

@property (strong, nonatomic)  UIImageView *quickPayImageView;//***快捷支付图片

//@property (strong, nonatomic)  UIImageView *image_bankCardValuable;//***银行卡失效图片

////***当银行卡失效的时候页面部分至灰色
//-(void)thisBankCardInvaluable:(BOOL)_gray;
@end

NS_ASSUME_NONNULL_END
