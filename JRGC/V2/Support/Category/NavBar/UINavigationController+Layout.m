//
//  UINavigationController+Layout.m
//  XJDS
//
//  Created by 张瑞超 on 2017/11/9.
//  Copyright © 2017年 张瑞超. All rights reserved.
//

#import "UINavigationController+Layout.h"
#import "ColorTheme.h"
@implementation UINavigationController (Layout)
//设置左测按钮
- (void)setLeftBackButton
{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 32.5,32);
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [leftBtn setImage:[UIImage imageNamed:@"Nav_Left_Back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self.visibleViewController action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -20;
//    将两个BarButtonItem都返回给NavigationItem
    self.visibleViewController.navigationItem.leftBarButtonItems = @[spaceItem,leftItem1];
}
- (void)goToBack
{
    
}
//设置右侧按钮
- (void)setRightButton
{
    
}
    
- (void)setBackImage:(UIImage *)image
{
    
}
- (void)setNavTitleColor:(UIColor *)color
{
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}
- (void)setNavTitle:(NSString *)title
{
    self.title = title;
}
- (void)setDefaultNavBackColor
{
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor whiteColor];
}
@end
