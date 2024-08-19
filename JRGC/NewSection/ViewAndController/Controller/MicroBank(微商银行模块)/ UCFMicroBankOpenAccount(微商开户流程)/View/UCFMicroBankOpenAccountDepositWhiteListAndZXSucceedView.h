//
//  UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/7.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView : BaseView

@property (nonatomic, strong) UIButton   *settingTransactionPasswordButton;

- (void)setUserSelectAccoutType:(SelectAccoutType)accoutType;

@end

NS_ASSUME_NONNULL_END
