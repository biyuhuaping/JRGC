//
//  UCFProjectListController.m
//  JRGC
//
//  Created by NJW on 2016/11/16.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFProjectListController.h"
#import "UCFHonerPlanViewController.h"
#import "UCFP2PViewController.h"
#import "UCFTransferViewController.h"

@interface UCFProjectListController ()
@property (nonatomic, weak) UISegmentedControl *segmentedCtrl;

@property (nonatomic, strong) UCFHonerPlanViewController *hornerPlan;
@property (nonatomic, strong) UCFP2PViewController *p2p;
@property (nonatomic, strong) UCFTransferViewController *transfer;

@property (nonatomic, weak) UCFBaseViewController *currentViewController;

@end

@implementation UCFProjectListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加标题然选项卡
    UISegmentedControl *segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"尊享计划",@"P2P专区",@"转让专区"]];
    segmentContrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    [segmentContrl setTintColor:UIColorWithRGB(0x5b6993)];
    [segmentContrl setTitleTextAttributes:@{[UIFont systemFontOfSize:15]:NSFontAttributeName} forState:UIControlStateNormal];
    segmentContrl.selectedSegmentIndex = 0;
    [segmentContrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedCtrl = segmentContrl;
    self.navigationItem.titleView = segmentContrl;
    
    self.hornerPlan = [[UCFHonerPlanViewController alloc]initWithNibName:@"UCFHonerPlanViewController" bundle:nil];
    self.hornerPlan.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    [self addChildViewController:self.hornerPlan];
    
    self.p2p = [[UCFP2PViewController alloc]initWithNibName:@"UCFP2PViewController" bundle:nil];
    self.p2p.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    [self addChildViewController:self.p2p];
    
    self.transfer = [[UCFTransferViewController alloc]initWithNibName:@"UCFTransferViewController" bundle:nil];
    self.transfer.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    [self addChildViewController:self.transfer];
    
    if ([self.strStyle isEqualToString:@"11"]) {
        self.segmentedCtrl.selectedSegmentIndex = 1;
        self.currentViewController = self.hornerPlan;
        self.strStyle = @"";
    }
    else if ([self.strStyle isEqualToString:@"12"]) {
        self.segmentedCtrl.selectedSegmentIndex = 0;
        self.currentViewController = self.p2p;
        self.strStyle = @"";
    }
    else {
        self.currentViewController = self.hornerPlan;
    }
    
}

- (void)setStrStyle:(NSString *)strStyle
{
    _strStyle = strStyle;
    if ([self.strStyle isEqualToString:@"11"]) {
        self.segmentedCtrl.selectedSegmentIndex = 1;
        self.currentViewController = self.hornerPlan;
        self.strStyle = @"";
    }
    else if ([self.strStyle isEqualToString:@"12"]) {
        self.segmentedCtrl.selectedSegmentIndex = 0;
        self.currentViewController = self.p2p;
        self.strStyle = @"";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.view.subviews containsObject:self.currentViewController.view]) {
        [self.view addSubview:self.currentViewController.view];
        [self.currentViewController didMoveToParentViewController:self];//确定关系建立
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//
//    if ([self.strStyle isEqualToString:@"11"]) {
//        if (![self.view.subviews containsObject:self.p2p.view]) {
//            [self.view addSubview:self.p2p.view];
//            [self.p2p didMoveToParentViewController:self];//确定关系建立
//        }
//        self.segmentedCtrl.selectedSegmentIndex = 1;
//        [self segmentedValueChanged:self.segmentedCtrl];
//        self.strStyle = @"";
//    }
//    else if ([self.strStyle isEqualToString:@"12"]) {
//        if (![self.view.subviews containsObject:self.hornerPlan.view]) {
//            [self.view addSubview:self.hornerPlan.view];
//            [self.hornerPlan didMoveToParentViewController:self];//确定关系建立
//        }
//        
//        self.segmentedCtrl.selectedSegmentIndex = 0;
//        [self segmentedValueChanged:self.segmentedCtrl];
//        self.strStyle = @"";
//    }
}

#pragma mark - 选项条点击方法
- (void)segmentedValueChanged:(UISegmentedControl *)segmentCtrl
{
    switch (segmentCtrl.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.hornerPlan]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.hornerPlan duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.hornerPlan;
            }];
        }
            break;
            
        case 1: {
            if ([self.currentViewController isEqual:self.p2p]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.p2p duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.p2p;
            }];
        }
            break;
            
        case 2: {
            if ([self.currentViewController isEqual:self.transfer]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.transfer duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.transfer;
            }];
        }
            break;
    }
}

@end
