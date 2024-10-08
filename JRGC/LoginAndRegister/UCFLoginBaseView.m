//
//  UCFLoginBaseView.m
//  JRGC
//
//  Created by 张瑞超 on 2017/9/21.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFLoginBaseView.h"
#import "AppDelegate.h"
#import "UCFRegisterStepOneViewController.h"
#import "UCFMoreViewController.h"
@interface UCFLoginBaseView ()
{
    
}
@property (nonatomic, strong) UIImageView *baseImageView;
@property (nonatomic, strong) UIButton    *registButton;
@property (nonatomic, strong) UIButton    *moreButton;
@property (nonatomic, strong) UIButton    *loginButton;
@end

@implementation UCFLoginBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseImageView = [[UIImageView alloc] initWithFrame:frame];
        _baseImageView.backgroundColor = [UIColor whiteColor];
        _baseImageView.userInteractionEnabled = YES;
        
        
         NSString *imageName = @"";
//        if ([UserInfoSingle sharedManager].isSubmitTime)
//        {
//            if (ScreenHeight == 480) {
//                imageName = @"appleLogin_bg_iphone4_default.png";
//            } else if (ScreenHeight == 812) {
//                imageName = @"appleLogin_bg_iphoneX.png";
//            } else {
//                imageName = @"appleLogin_bg_default.png";
//            }
//
//            UIImage *imageData = [UIImage imageNamed:imageName];
//            _baseImageView.image = imageData;
//        }
//        else{
                NSString *imageURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginImageUrl"];
    
                if (ScreenHeight == 480) {
                    imageName = @"login_bg_phone4_default.png";
                } else if (ScreenHeight == 812) {
                    imageName = @"login_bg_iphoneX.png";
                } else {
                    imageName = @"login_bg_default.png";
                }

                UIImage *imageData = [UIImage imageNamed:imageName];
                [_baseImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:imageData];
            
//        }
        [self addSubview:_baseImageView];
            
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login:)];
//        [_baseImageView addGestureRecognizer:tap];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(0, [self getMoreBtnOrginY] ,ScreenWidth, [self getMoreBtnSizeHeight]);
        _moreButton.backgroundColor = [UIColor clearColor];
//        _moreButton.backgroundColor = [UIColor redColor];
        [_moreButton addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
        [_baseImageView addSubview:_moreButton];
        
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.frame = CGRectMake(0, 0 ,ScreenWidth/2.0f, CGRectGetMinY(_moreButton.frame));
        _registButton.backgroundColor = [UIColor clearColor];
        [_registButton addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _registButton.backgroundColor = [UIColor blueColor];
        [_baseImageView addSubview:_registButton];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(ScreenWidth/2.0f, 0 ,ScreenWidth/2.0f, CGRectGetMinY(_moreButton.frame));
        _loginButton.backgroundColor = [UIColor clearColor];
        [_loginButton addTarget:self action:@selector(shouLoginView) forControlEvents:UIControlEventTouchUpInside];
//        _loginButton.backgroundColor = [UIColor yellowColor];
        [_baseImageView addSubview:_loginButton];
        
    }
    return self;
}
- (CGFloat)getMoreBtnOrginY
{
    //iphone5 高度568以下
    if (ScreenHeight < 569) {
        return ScreenHeight - (55 + [self getMoreBtnSizeHeight]);
    } else {
        return ScreenHeight -  (55 * ScreenHeight /568.0f + [self getMoreBtnSizeHeight]);
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
- (CGFloat)getMoreBtnSizeHeight
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
    if ([UserInfoSingle sharedManager].isSubmitTime) {
        nav = (UINavigationController *)app.window.rootViewController;
    }
    [nav presentViewController:loginNaviController animated:YES completion:nil];
}
- (void)login:(UITapGestureRecognizer *)tap
{
    [self shouLoginView];
}
- (void)shouLoginView
{
    [SingleUserInfo loadLoginViewController];
}
- (void)showMoreView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UCFMoreViewController" bundle:nil];
    UCFMoreViewController *moreVC = [storyboard instantiateViewControllerWithIdentifier:@"more_main"];
    moreVC.title = @"更多";
    moreVC.sourceVC = @"UCFSecurityCenterViewController";
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = app.tabBarController.selectedViewController;
    if ([UserInfoSingle sharedManager].isSubmitTime)
    {
       UITabBarController *tabBar = (UITabBarController *)app.window.rootViewController;
       nav= [tabBar.viewControllers objectAtIndex:3];
    }
    [nav pushViewController:moreVC  animated:YES];
}
@end
