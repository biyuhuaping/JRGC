//
//  UINavigationController+Layout.h
//  XJDS
//
//  Created by 张瑞超 on 2017/11/9.
//  Copyright © 2017年 张瑞超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Layout)

//设置左测按钮
- (void)setLeftBackButton;
//设置右侧按钮
- (void)setRightButton;

- (void)setBackImage:(UIImage *)image;
    
- (void)setDefaultNavBackColor;
    
- (void)setNavTitle:(NSString *)title;
- (void)setNavTitleColor:(UIColor *)color;
@end
