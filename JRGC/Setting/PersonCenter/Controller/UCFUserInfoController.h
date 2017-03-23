//
//  UCFUserInfoController.h
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

#import "UCFPCListViewPresenter.h"
@interface UCFUserInfoController : UCFBaseViewController
+ (instancetype)instanceWithPresenter:(UCFPCListViewPresenter *)presenter;
+ (CGFloat)viewHeight;

- (UCFPCListViewPresenter *)presenter;
- (void)setUserInfoVCGenerator:(ViewControllerGenerator)userInfoVCGenerator;
@end
