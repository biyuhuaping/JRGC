//
//  UCFRegisterStepTwoViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFRegisterTwoView.h"
#import "FMDeviceManager.h"

//@interface UCFRegisterStepTwoViewController : UCFBaseViewController<RegisterTwoViewDelegate,UIAlertViewDelegate,FMDeviceManagerDelegate>
#warning 同盾修改
@interface UCFRegisterStepTwoViewController : UCFBaseViewController<RegisterTwoViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) NSString *registerTokenStr;
@property(nonatomic,assign) BOOL      isLimitFactoryCode; //是否隐藏工场码
- (id)initWithPhoneNumber:(NSString*)phoneNum;


@end
