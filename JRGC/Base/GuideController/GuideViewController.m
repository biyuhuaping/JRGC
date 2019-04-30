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
@property(nonatomic,strong)    UIView *baseView;
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

//    self.view.backgroundColor = [UIColor blueColor];
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
    NSString *imageNamePre = @"X_";
    if(ScreenHeight/ ScreenWidth > 2){
        imageNamePre = @"X_";
    } else  {
        imageNamePre = @"Y_";
    }
    for (int i = 0; i < 4; i++) {
        UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth,ScreenHeight)];
        NSString *imageName = [NSString stringWithFormat:@"%@guide0%d.png",imageNamePre,i + 1];
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *resourcePath = [bundle resourcePath];
        NSString *filePath = [resourcePath stringByAppendingPathComponent:imageName];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        adImageView.image = image;
        [guideScrollView addSubview:adImageView];
    }
    guideScrollView.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight);
    [self createPageControllView];
}
- (void)createPageControllView
{
    CGFloat bottom = 135;
    if (ScreenWidth < 321) {
        bottom = 120;
    } else if (ScreenWidth < 414 && ScreenHeight < 737) {
        bottom = 135;
    } else {
        bottom = 185;
    }
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - bottom, ScreenWidth, 135)];
    baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:baseView];
   self.baseView = baseView;
    for (int i = 0; i < 4; i ++) {
        UIView *pageView = [[UIView alloc] init];
        pageView.frame = CGRectMake((ScreenWidth - 90)/2 + (15 + 10) * i,2, 15, 4);
        pageView.tag = 700 + i;
        pageView.clipsToBounds = YES;
        pageView.layer.cornerRadius = 2.0f;
        
        if (i == 0) {
            pageView.backgroundColor = [Color color:PGColorOptionTitlerRead];
        } else {
            pageView.backgroundColor = UIColorWithRGB(0xfbeeee);
        }
        [baseView addSubview:pageView];
    }
    
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registButton setBackgroundColor:[UIColor whiteColor]];
    [registButton setTitle:@"立即注册" forState:UIControlStateNormal];
    registButton.clipsToBounds = YES;
    [registButton setTitleColor:[Color color:PGColorOptionTitlerRead] forState:UIControlStateNormal];
    registButton.layer.cornerRadius = 20.0f;
    registButton.titleLabel.font = [UIFont systemFontOfSize:16];
    registButton.layer.borderColor = [Color color:PGColorOptionTitlerRead].CGColor;
    registButton.layer.borderWidth = 1.0f;
    registButton.frame = CGRectMake((ScreenWidth - 270)/2, 33, 270, 40);
    [baseView addSubview:registButton];
    [registButton addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipBtn setTitle:@"先转转" forState:UIControlStateNormal];
    skipBtn.frame = CGRectMake((ScreenWidth - 270)/2, 75, 270, 40);
    [skipBtn addTarget:self action:@selector(skipToMainWorkView) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [baseView addSubview:skipBtn];
}
- (void)regist
{
    [self skipToMainWorkView];
    [SingleUserInfo loadRegistViewController];
}
- (void)skipToMainWorkView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeRootView:)]) {
        [self.delegate changeRootView:self];
    }
//    [self showTabbarController];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int i = scrollView.contentOffset.x /ScreenWidth;

    UIView *pageView1 = [self.baseView viewWithTag:700];
    UIView *pageView2 = [self.baseView viewWithTag:701];
    UIView *pageView3 = [self.baseView viewWithTag:702];
    UIView *pageView4 = [self.baseView viewWithTag:703];
    pageView1.backgroundColor = pageView2.backgroundColor = pageView3.backgroundColor =pageView4.backgroundColor = UIColorWithRGB(0xfbeeee);
    
    UIView *pageView = [self.baseView viewWithTag:700 + i];
    [pageView setBackgroundColor:[Color color:PGColorOptionTitlerRead]];
    
    
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
