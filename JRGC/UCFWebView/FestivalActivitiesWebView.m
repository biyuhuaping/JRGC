//
//  FestivalActivitiesWebView.m
//  JRGC
//
//  Created by 金融工场 on 2016/12/27.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "FestivalActivitiesWebView.h"

@interface FestivalActivitiesWebView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation FestivalActivitiesWebView
//需要加上这个 要不初始化不了webView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initChildViews];
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    [self.webView setOpaque:NO];
    self.webView.hidden = NO;
}

- (void)initChildViews
{
    // Shadow View
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.shadowView.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *shadowTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowClicked:)];
    [_shadowView addGestureRecognizer:shadowTapGes];
    
}
- (void)shadowClicked:(UITapGestureRecognizer *)tap
{
    [self hideView];
}
- (void)hideView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0;
        self.view.alpha = 0;
    } completion:^(BOOL completed) {
        [self.shadowView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showPopView:(UIViewController *)controller
{
    self.view.alpha = 0;
    //self.rootViewController = controller;
    
    // Add subviews
    //[self.rootViewController addChildViewController:self];
    self.shadowView.frame = [[UIApplication sharedApplication].keyWindow bounds];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:_shadowView];
    
    //[self.rootViewController.view addSubview:self.shadowView];
    //[self.rootViewController.view addSubview:self.view];
    
    // Animate in the alert view
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0.75;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        //        [UIView animateWithDuration:0.2f animations:^{
        //            self.view.center = self.rootViewController.view.center;
        //        }];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
