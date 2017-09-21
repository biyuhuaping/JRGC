//
//  UCFLoginBaseView.m
//  JRGC
//
//  Created by 张瑞超 on 2017/9/21.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFLoginBaseView.h"
#import "UCFLoginViewController.h"
#import "AppDelegate.h"
#import "UCFRegisterStepOneViewController.h"
@interface UCFLoginBaseView ()
{
    
}
@property (nonatomic, strong) UIImageView *baseImageView;
@property (nonatomic, strong) UIButton    *registButton;
@end

@implementation UCFLoginBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseImageView = [[UIImageView alloc] initWithFrame:frame];
        _baseImageView.backgroundColor = [UIColor whiteColor];
        _baseImageView.userInteractionEnabled = YES;
        _baseImageView.image = [UIImage imageNamed:@"登录页标注.jpg"];
        [self addSubview:_baseImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login:)];
        [_baseImageView addGestureRecognizer:tap];
        
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.frame = CGRectMake((ScreenWidth - [self getRegistBtnSizeWidth])/2.0f, [self getRegistBtnOrginY] ,[self getRegistBtnSizeWidth], [self getRegistBtnSizeHeight]);
        _registButton.backgroundColor = [UIColor lightGrayColor];
        _registButton.alpha = 0.5;
        [_registButton addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseImageView addSubview:_registButton];
    }
    return self;
}
- (CGFloat)getRegistBtnOrginY
{
    //iphone5 高度568以下
    if (ScreenHeight < 569) {
        return ScreenHeight - (55 + [self getRegistBtnSizeHeight]);
    } else {
        return ScreenHeight -  (55 * ScreenHeight /568.0f + [self getRegistBtnSizeHeight]);
    }
}
- (CGFloat)getRegistBtnSizeWidth
{
    //iphone5 高度以下
    if (ScreenHeight < 569) {
        return 150;
    } else {
        return (150 * ScreenHeight /568.0f);
    }
}
- (CGFloat)getRegistBtnSizeHeight
{
    //iphone5 高度以下
    if (ScreenHeight < 569) {
        return 50;
    } else {
        return (50 * ScreenHeight /568.0f);
    }
}
- (void)getShowImage:(UIImage *)image
{
    _baseImageView.image = image;
}
- (void)registBtnClick:(UIButton *)btn
{
    UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
    registerControler.sourceVC = @"fromPersonCenter";
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:registerControler] ;
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = app.tabBarController.selectedViewController ;
    [nav presentViewController:loginNaviController animated:YES completion:nil];
}
- (void)login:(UITapGestureRecognizer *)tap
{
    [self shouLoginView];
}
- (void)shouLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController] ;
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = app.tabBarController.selectedViewController ;
    [nav presentViewController:loginNaviController animated:YES completion:nil];
}
@end
