//
//  UCFMicroBankDepositoryAccountHomeCellView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "NZLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankDepositoryAccountHomeCellView : BaseView

@property (nonatomic, strong) NZLabel     *microBankTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *microBankSubtitleLabel;//副标题

@property (nonatomic, strong) NZLabel     *microBankContentLabel;//内容

@property (nonatomic, strong) UIView *itemLineView;//下划线

@end

NS_ASSUME_NONNULL_END
