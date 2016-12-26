//
//  UCFSecurityCenterViewController.h
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFSecurityCenterViewController : UCFBaseViewController<UIAlertViewDelegate>
//检测系统touchID 开关是否开启，退到后台，启动的时候调用
- (void)checkSystemTouchIdisOpen;
@end
