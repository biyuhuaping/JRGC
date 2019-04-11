//
//  UCFBaseViewController.m
//  JRGC
//
//  Created by JasonWong on 14-9-9.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "Common.h"
#import "RTRootNavigationController.h"
#import "UIViewController+RTRootNavigationController.h"
#import "RTRootNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface UCFBaseViewController ()

@end

@implementation UCFBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    baseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200)/2.0f, 0, 200, 30)];
    baseTitleLabel.textAlignment = NSTextAlignmentCenter;
    [baseTitleLabel setTextColor:UIColorWithRGB(0x333333)];
    [baseTitleLabel setBackgroundColor:[UIColor clearColor]];
    baseTitleLabel.font = [UIFont systemFontOfSize:18];
    baseTitleLabel.text = _baseTitleText;
    [self setNavigationTitleView];
    
    if (!_isHideNavigationBar){
        lineViewAA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineViewAA.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self.view addSubview:lineViewAA];
    }
    [self.navigationController.navigationBar setHidden:_isHideNavigationBar];

    //self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
//    [GiFHUD setGifWithImageName:@"gif@3x.gif"];
}

- (void)setNavigationTitleView
{
    if ([_baseTitleType isEqualToString:@"detail"]) {
//        baseTitleLabel.frame = CGRectMake(0, 0, [Common calculateNewSizeBaseMachine:100], 30);
//        UIView *titleBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Common calculateNewSizeBaseMachine:170], 30)];
//        [titleBkView addSubview:baseTitleLabel];
//        baseTitleLabel.textAlignment = NSTextAlignmentCenter;
//        [baseTitleLabel setTextColor:[UIColor whiteColor]];
//        self.navigationItem.titleView = titleBkView;
//        [self.navigationController.navigationBar setBarTintColor:UIColorWithRGB(0xfd4d4c)];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else if ([_baseTitleType isEqualToString:@"list"]) {
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 183, 24)];
//        titleImage.image = [UIImage imageNamed:@"logo.png"];
        self.navigationItem.titleView = titleImage;
    } else if ([_baseTitleType isEqualToString:@"Transdetail"]) {
        self.navigationItem.titleView = baseTitleLabel;
        baseTitleLabel.textAlignment = NSTextAlignmentCenter;
        [baseTitleLabel setTextColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else if([_baseTitleType isEqualToString:@"camera"]){
        [self.navigationController.navigationBar setBarTintColor:[DBColor colorWithHexString:@"090b24" andAlpha:0.1]];
        self.navigationItem.titleView = baseTitleLabel;
        baseTitleLabel.textAlignment = NSTextAlignmentCenter;
        [baseTitleLabel setTextColor:[UIColor whiteColor]];
    }else if([_baseTitleType isEqualToString:@"NOcamera"]){
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationItem.titleView = baseTitleLabel;
        baseTitleLabel.textAlignment = NSTextAlignmentCenter;
        [baseTitleLabel setTextColor:[UIColor whiteColor]];
        [baseTitleLabel setTextColor:UIColorWithRGB(0x333333)];
        [baseTitleLabel setBackgroundColor:[UIColor clearColor]];
    } else {
        self.navigationItem.titleView = baseTitleLabel;
    }
}

- (void)addLeftButton
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    if ([_baseTitleType isEqualToString:@"detail"] || [_baseTitleType isEqualToString:@"Transdetail"]||[_baseTitleType isEqualToString:@"camera"]) {
        [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateHighlighted];
    }else {
        [leftButton setImage:[UIImage imageNamed:@"icon_left.png"]forState:UIControlStateNormal];
    }
    //[leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)hideLeftButton
{
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
}

- (void)addLeftButtons
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    if ([_baseTitleType isEqualToString:@"detail"] || [_baseTitleType isEqualToString:@"Transdetail"]||[_baseTitleType isEqualToString:@"camera"]) {
        [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateHighlighted];
    }else {
        [leftButton setImage:[UIImage imageNamed:@"icon_back.png"]forState:UIControlStateNormal];
    }
    //[leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton1 setFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton1 setBackgroundColor:[UIColor clearColor]];
    [leftButton1 setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [leftButton1 addTarget:self action:@selector(getToRoot) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:leftButton1];
    self.navigationItem.leftBarButtonItems = @[leftItem, leftItem1];
}

- (void)getToRoot
{
    [self.rt_navigationController popViewControllerAnimated:YES];
}

- (void)addLeftButtonWithName:(NSString *)leftButtonName
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 30)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    if (leftButtonName) {
        [leftButton setTitle:leftButtonName forState:UIControlStateNormal];
    }else{
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    }
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    
    if (![leftButtonName isEqualToString:@"取消"]) {
        [leftButton setImage:[UIImage imageNamed:@"icon_back.png"]forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [leftButton addTarget:self action:@selector(dismissBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -30, 0.0, 0.0)];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)addRightButtonWithName:(NSString *)rightButtonName
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 44, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.textColor = [UIColor whiteColor];
    [rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addRightButtonWithImage:(UIImage *)rightButtonimage;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 44, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
//    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    [rightbutton setImage:rightButtonimage forState:UIControlStateNormal];
//    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 20, 0.0, 0.0)];
//    rightbutton.titleLabel.textColor = [UIColor whiteColor];
//    [rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)getToBack {
    [self.rt_navigationController popViewControllerAnimated:YES];
}

- (void)dismissBack {
    
}

- (void)clickRightBtn {
    
}

#pragma mark NetMethod
- (void)beginPost:(kSXTag)tag{}
- (void)endPost:(id)result tag:(NSNumber*)tag{}
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag{}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refresh
{ }
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)blindUserStatue
{
    @PGWeakObj(self);
    [self.KVOController observe:[UserInfoSingle sharedManager] keyPaths:@[@"loginData"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"loginData"]) {
            UCFLoginData *oldUserData = [change objectSafeForKey:NSKeyValueChangeOldKey];
            UCFLoginData *newUserData = [change objectSafeForKey:NSKeyValueChangeNewKey];
            //登录或者注册
            if (!oldUserData.userInfo && newUserData.userInfo) {
                [selfWeak monitorUserLogin];
                return ;
            }
            //退出登录，或者切换账户
            if (oldUserData.userInfo && !newUserData.userInfo) {
                [selfWeak monitorUserGetOut];
                return ;
            }
            //用户在登录的情况下，更改用户状态的时候，请求数据
            if ( [oldUserData.userInfo.openStatus intValue] != [newUserData.userInfo.openStatus intValue]) {
                [selfWeak monitorOpenStatueChange];
            }
            //用户在登录的情况下，更改用户状态的时候，请求数据
            if (oldUserData.userInfo.isRisk != newUserData.userInfo.isRisk) {
                [selfWeak monitorRiskStatueChange];
            }
        }
    }];
}
//登录或者注册
- (void)monitorUserLogin
{
    
}
//退出登录，或者切换账户
- (void)monitorUserGetOut
{
    
}
//用户在登录的情况下，更改用户状态的时候，请求数据
- (void)monitorOpenStatueChange
{
    
}
//用户在登录的情况下，更改用户状态的时候，请求数据
- (void)monitorRiskStatueChange
{
    
}
- (void)setSetNavgationPopDisabled:(BOOL)setNavgationPopDisabled
{
    ((RTContainerController *) (self.rt_navigationController.viewControllers.lastObject)).fd_interactivePopDisabled = setNavgationPopDisabled;
}
@end
