//
//  UCFMainTabBarController.h
//  JRGC
//
//  Created by JasonWong on 14-9-5.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterSuccessAlert.h"

@interface UCFMainTabBarController : UITabBarController<UITabBarControllerDelegate,RegSuccessDelegate>

- (void)initAllTabbarItems;
- (void)choiceConWithIndex:(int)index webview:(UIWebView*)webview;
- (void)showTabBar;
- (void)hideTabBar;
@end
