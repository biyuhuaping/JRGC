//
//  GuideViewController.m
//  JRGC
//
//  Created by 张瑞超 on 14-11-5.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "GuideViewController.h"
#import "UCFMainTabBarController.h"
@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIScrollView *guideScrollView;
//    UIPageControl *pageControl;
}
@end

@implementation GuideViewController
@synthesize delegate;

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    self.view.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    
    guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.showsVerticalScrollIndicator = NO;
    guideScrollView.pagingEnabled = YES;
    guideScrollView.delegate = self;
    guideScrollView.bounces = NO;
    [self.view addSubview:guideScrollView];
    
    adjustsScrollViewInsets(guideScrollView);
    int version = 7;
    if(ScreenHeight == 480){
        version = 6;
    } else if (ScreenHeight == 812) {
        version = 8;  //iphonex
    }
    for (int i = 0; i < 1; i++) {
        UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth,ScreenHeight)];
        adImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideImage%d_%d",version,i+1]];
        [guideScrollView addSubview:adImageView];
        if (i == 0) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (ScreenHeight == 480 ) {
                button.frame = CGRectMake((ScreenWidth - 210)/2, ScreenHeight - 49 - 38, 210, 38);
            } else if (ScreenHeight == 812) {
                button.frame = CGRectMake((ScreenWidth - 210)/2, ScreenHeight - 130 - 38, 210, 38);
            }
            else {
                button.frame = CGRectMake((ScreenWidth - 210)/2, ScreenHeight - 85 - 38, 210, 38);
            }
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"page_btn.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(skipToMainWorkView) forControlEvents:UIControlEventTouchUpInside];
            [adImageView addSubview:button];
            adImageView.userInteractionEnabled = YES;
        }
    }
    guideScrollView.contentSize = CGSizeMake(ScreenWidth * 1, ScreenHeight);
}

- (void)skipToMainWorkView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeRootView:)]) {
        [self.delegate changeRootView:self];
    }
//    [self showTabbarController];
}

- (void)showTabbarController
{
    UCFMainTabBarController *tabBarController = [[UCFMainTabBarController alloc] init];
    [GlobalView sharedManager].tabBarController = tabBarController;
    [self.rt_navigationController pushViewController:tabBarController animated:NO complete:^(BOOL finished) {
        [self.rt_navigationController removeViewController:self];
    }];
}
+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:@"currentversion"];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [self saveCurrentVersion];
        return YES;
    }else
    {
        return NO;
    }
}
// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:@"currentversion"];
    [user synchronize];
}


@end
