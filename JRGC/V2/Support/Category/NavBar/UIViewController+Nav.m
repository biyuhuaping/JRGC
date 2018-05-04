//
//  UIViewController+Nav.m
//  XJDS
//
//  Created by 张瑞超 on 2017/11/15.
//  Copyright © 2017年 张瑞超. All rights reserved.
//

#import "UIViewController+Nav.h"

#import "ColorTheme.h"

@implementation UIViewController (Nav)
//设置导航栏的背景图
- (void)setNavImage:(UIImage *)baseImage
{
    [self.navigationController.navigationBar setBackgroundImage:baseImage forBarMetrics:UIBarMetricsCompact];
}
//设置导航栏背景
- (void)setNavBackColor:(UIColor *)color
{
    [self.navigationController.navigationBar setBarTintColor:color];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)setLeftBackButton
{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 60,40);
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 7.5, 35);
    [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back"]forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)setTitleText:(NSString *)title {
    UILabel *baseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200)/2.0f, 0, 200, 30)];
    baseTitleLabel.textAlignment = NSTextAlignmentCenter;
    [baseTitleLabel setTextColor:[ColorTheme textColor_333333]];
    [baseTitleLabel setBackgroundColor:[UIColor clearColor]];
    baseTitleLabel.font = [UIFont systemFontOfSize:18];
    baseTitleLabel.text = title;
    self.navigationItem.titleView = baseTitleLabel;
}


- (void)setRightButton
{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 60,30);
    [leftBtn setBackgroundColor:[ColorTheme textColor_333333]];
    leftBtn.clipsToBounds = YES;
    leftBtn.layer.cornerRadius = 15.0f;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [leftBtn setTitleColor:[ColorTheme textColor_333333] forState:UIControlStateNormal];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
}
- (void)rightButtonClick
{
    
}
- (void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hideLeftBackButton {
    [self.navigationItem setHidesBackButton:YES];
}
@end
