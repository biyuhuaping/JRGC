//
//  UCFSettingViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/8.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFGuaPopViewController.h"
#import "UCFLoginShaowView.h"

typedef NS_ENUM(NSInteger, UIGoodCommentAlertState) {
    StateDefault = 0,               //弹框默认
    StateHavePayment,               //回款状态
    StateHavePaymentChecked,        //回款查看状态
};
@interface UCFSettingViewController : UCFBaseViewController<GuaPopViewDelegate,UIAlertViewDelegate,LoginShadowDelegate>
@property (assign, nonatomic)UIGoodCommentAlertState alertState;
@property (assign, nonatomic) BOOL     checkedFeedBack;

@end
