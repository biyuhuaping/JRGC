//
//  UIViewController+Nav.h
//  XJDS
//
//  Created by 张瑞超 on 2017/11/15.
//  Copyright © 2017年 张瑞超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Nav)
//设置导航栏的背景图
- (void)setNavImage:(UIImage *)baseImage;
//设置导航栏背景
- (void)setNavBackColor:(UIColor *)color;

- (void)setLeftBackButton;

- (void)setTitleText:(NSString *)title;

- (void)goToBack;

- (void)setRightButton;


- (void)hideLeftBackButton;
@end
