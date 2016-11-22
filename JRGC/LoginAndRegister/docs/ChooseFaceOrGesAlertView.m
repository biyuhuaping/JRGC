//
//  ChooseFaceOrGesAlertView.m
//  JRGC
//
//  Created by Qnwi on 16/2/23.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "ChooseFaceOrGesAlertView.h"

@interface ChooseFaceOrGesAlertView ()
{
    
}

@property (nonatomic, strong) UIImageView *backImageView;//背景
@property (nonatomic, strong) UIButton *notUseBtn;
@property (nonatomic, strong) UIButton *useFaceBtn;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *shadowView;//灰色遮罩
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ChooseFaceOrGesAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Shadow View
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.shadowView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0;
        self.view.alpha = 0;
    } completion:^(BOOL completed) {
        [self.shadowView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showAlert:(UIViewController *)controller
{
    self.view.alpha = 0;
    self.rootViewController = controller;
    
    // Add subviews
    [self.rootViewController addChildViewController:self];
    self.shadowView.frame = controller.view.bounds;
    [self.rootViewController.view addSubview:self.shadowView];
    [self.rootViewController.view addSubview:self.view];
    
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

- (void)useBtnClicked:(id)sender
{
    [self hideView];
    [_delegate useBtnClicked:sender];
}

- (void)notUseBtnClick:(id)sender
{
    [self hideView];
    [_delegate notUseBtnClick:sender];
}

@end
