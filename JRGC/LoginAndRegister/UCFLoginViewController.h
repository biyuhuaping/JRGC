//
//  UCFLoginViewController.h
//  JRGC
//
//  Created by HeJing on 15/3/31.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBaseViewController.h"
#import "UCFLoginView.h"
#import "FMDeviceManager.h"

@interface UCFLoginViewController : UCFBaseViewController<UCFLoginViewDelegate,FMDeviceManagerDelegate>

//从哪儿来到得登录界面
@property(nonatomic,copy) NSString *sourceVC;
@property(nonatomic,assign) BOOL isForce;//是否是从强制登陆过来
@end
