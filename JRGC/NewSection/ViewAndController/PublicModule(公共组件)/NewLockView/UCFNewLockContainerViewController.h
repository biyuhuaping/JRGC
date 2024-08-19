//
//  UCFNewLockContainerViewController.h
//  JRGC
//
//  Created by zrc on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"
#import "UCFLockConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewLockContainerViewController : UCFNewBaseViewController
@property(nonatomic, assign)BOOL isFromRegist; //是否注册
@property(nonatomic, copy)NSString *souceVc;
- (id)initWithType:(RCLockViewType)type;
- (void)childControlerCallShow:(UIViewController *)controller;


@end

NS_ASSUME_NONNULL_END
