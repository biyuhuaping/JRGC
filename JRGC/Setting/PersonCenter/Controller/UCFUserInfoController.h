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
@property (nonatomic, assign) CGFloat fixedScreenLight;
- (UCFPCListViewPresenter *)presenter;
- (void)setUserInfoVCGenerator:(ViewControllerGenerator)userInfoVCGenerator;
- (void)setMessageVCGenerator:(ViewControllerGenerator)messageVCGenerator;
- (void)setBeansVCGenerator:(ViewControllerGenerator)beansVCGenerator;
- (void)setCouponVCGenerator:(ViewControllerGenerator)couponVCGenerator;
- (void)setWorkPointInfoVCGenerator:(ViewControllerGenerator)workPointInfoVCGenerator;
- (void)sign;
@end
