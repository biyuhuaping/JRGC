//
//  UCFBankDepositoryAccountViewController.h
//  JRGC
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//


#import "UCFWebViewJavascriptBridgeController.h"
@interface UCFBankDepositoryAccountViewController : UCFBaseViewController


//用户开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码 5：特殊用户
@property(nonatomic, assign) NSInteger openStatus;
@end
