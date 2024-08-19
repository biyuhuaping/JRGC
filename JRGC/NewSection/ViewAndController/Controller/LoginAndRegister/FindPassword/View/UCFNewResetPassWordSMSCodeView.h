//
//  UCFNewResetPassWordSMSCodeView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "CQCountDownButton.h"
typedef void(^callBackBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewResetPassWordSMSCodeView : BaseView

@property (nonatomic, strong) CQCountDownButton *verifyCodeButton;

@property (nonatomic,strong) callBackBlock backBlock;

@property (nonatomic, strong) UITextField     *contentField;//输入名称
@end

NS_ASSUME_NONNULL_END
