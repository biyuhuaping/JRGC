//
//  GlobalView.h
//  JRGC
//
//  Created by zrc on 2019/1/17.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFLoginModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GlobalView : NSObject
+ (GlobalView *)sharedManager;
@property(nonatomic,weak) UITabBarController *tabBarController;
@property(nonatomic,strong) RTRootNavigationController *rootNavController;
@property(nonatomic,strong) UCFLoginData *loginData;
@end

NS_ASSUME_NONNULL_END
