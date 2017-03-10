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

@interface UCFRegisterStepTwoViewController : UCFBaseViewController<RegisterTwoViewDelegate,UIAlertViewDelegate,FMDeviceManagerDelegate>
@property(nonatomic,strong) NSString *registerTokenStr;
@property(nonatomic,assign) BOOL      isLimitFactoryCode; //是否隐藏工场码
- (id)initWithPhoneNumber:(NSString*)phoneNum;


@end
