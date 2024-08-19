//
//  UCFMicroBankOpenAccountDepositBankListCellView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "NZLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountDepositBankListCellView : BaseView

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) NZLabel    *oaContentLabel;

@property (nonatomic, strong) UIImageView *bankImageView;

@property (nonatomic, strong) UIView *itemLineView;//下划线
@end

NS_ASSUME_NONNULL_END
