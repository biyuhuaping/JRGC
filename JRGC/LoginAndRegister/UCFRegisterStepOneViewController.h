//
//  UCFRegisterStepOneViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFRegisterOneView.h"

@interface UCFRegisterStepOneViewController : UCFBaseViewController<RegisterOneViewDelegate,UIAlertViewDelegate>

//从哪儿来
@property(nonatomic,copy) NSString *sourceVC;

@end
