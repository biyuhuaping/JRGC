//
//  UCFMicroBankOpenAccountDepositCellView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountDepositCellView : BaseView

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UITextField     *contentField;//开户名

@property (nonatomic, strong) UIView *itemLineView;//下划线
@end

NS_ASSUME_NONNULL_END
