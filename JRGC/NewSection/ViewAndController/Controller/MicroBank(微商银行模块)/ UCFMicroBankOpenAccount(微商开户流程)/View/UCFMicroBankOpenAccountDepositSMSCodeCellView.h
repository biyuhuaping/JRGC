//
//  UCFMicroBankOpenAccountDepositSMSCodeCellView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "CQCountDownButton.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^callBackBlock)(void);

@interface UCFMicroBankOpenAccountDepositSMSCodeCellView : BaseView

@property (nonatomic, strong) CQCountDownButton *verifyCodeButton;

@property (nonatomic,strong) callBackBlock backBlock;

@property (nonatomic, strong) UITextField     *contentField;//开户名

@end

NS_ASSUME_NONNULL_END
