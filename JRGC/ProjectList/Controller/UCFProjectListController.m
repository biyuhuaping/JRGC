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
@property (nonatomic, assign) BOOL isShowHornor;

@end

@implementation UCFProjectListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加标题然选项卡
    self.isShowHornor = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowHornor"];
    UISegmentedControl *segmentContrl = nil;
    if (self.isShowHornor) {
        segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"P2P专区",@"尊享专区",@"转让专区"]];
    }
    else {
        segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"P2P专区",@"债权转让"]];
    }
    
    segmentContrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    [segmentContrl setTintColor:UIColorWithRGB(0x5b6993)];
    [segmentContrl setTitleTextAttributes:@{[UIFont systemFontOfSize:15]:NSFontAttributeName} forState:UIControlStateNormal];
    segmentContrl.selectedSegmentIndex = 0;
    [segmentContrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedCtrl = segmentContrl;
    self.navigationItem.titleView = segmentContrl;
    
    self.p2p = [[UCFP2PViewController alloc]initWithNibName:@"UCFP2PViewController" bundle:nil];
    self.p2p.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    [self addChildViewController:self.p2p];
    
    self.hornerPlan = [[UCFHonerPlanViewController alloc]initWithNibName:@"UCFHonerPlanViewController" bundle:nil];
    self.hornerPlan.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    [self addChildViewController:self.hornerPlan];
    
    self.transfer = [[UCFTransferViewController alloc]initWithNibName:@"UCFTransferViewController" bundle:nil];
    self.transfer.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    [self addChildViewController:self.transfer];
    
    if ([self.strStyle isEqualToString:@"11"]) {
        if (self.isShowHornor) {
            self.segmentedCtrl.selectedSegmentIndex = 0;
            self.currentViewController = self.p2p;
            [self.view addSubview:self.p2p.view];
            _currentViewController = self.p2p;
        }
        else {
            self.segmentedCtrl.selectedSegmentIndex = 0;
            self.currentViewController = self.p2p;
            [self.view addSubview:self.p2p.view];
            _currentViewController = self.p2p;
        }
        
    }
    else if ([self.strStyle isEqualToString:@"12"]) {
        self.segmentedCtrl.selectedSegmentIndex = 1;
        self.currentViewController = self.hornerPlan;
        [self.view addSubview:self.hornerPlan.view];
        _currentViewController = self.hornerPlan;
    }
    else if ([self.strStyle isEqualToString:@"13"]){
        self.segmentedCtrl.selectedSegmentIndex = 2;
        self.currentViewController = self.transfer;
        [self.view addSubview:self.transfer.view];
        _currentViewController = self.transfer;
    }
    else {
        if (self.isShowHornor) {
            self.currentViewController = self.p2p;
            [self.view addSubview:self.p2p.view];
            _currentViewController = self.p2p;
        }
        else {
            self.currentViewController = self.p2p;
            [self.view addSubview:self.p2p.view];
            _currentViewController = self.p2p;
        }
    }
}

- (void)changeViewWithConfigure:(NSString *)config
{
    if ([self.strStyle isEqualToString:@"11"] && self.currentViewController != self.p2p) {
        self.segmentedCtrl.selectedSegmentIndex = 0;
        [self transitionFromViewController:self.currentViewController toViewController:self.p2p duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            self.currentViewController = self.p2p;
        }];
    }
    else if ([self.strStyle isEqualToString:@"12"]  && self.currentViewController != self.hornerPlan) {
        self.segmentedCtrl.selectedSegmentIndex = 1;
        [self transitionFromViewController:self.currentViewController toViewController:self.hornerPlan duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            self.currentViewController = self.hornerPlan;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.currentViewController.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
}

#pragma mark - 选项条点击方法
- (void)segmentedValueChanged:(UISegmentedControl *)segmentCtrl
{
    switch (segmentCtrl.selectedSegmentIndex) {
        case 0:{
            
            if (self.isShowHornor) {
                [self transitionFromViewController:self.currentViewController toViewController:self.p2p duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                    self.currentViewController = self.p2p;
                }];
                
            }
            else {
                if ([self.currentViewController isEqual:self.p2p]) {
                    return;
                }
                [self transitionFromViewController:self.currentViewController toViewController:self.p2p duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                    self.currentViewController = self.p2p;
                }];
            }
        }
            break;
            
        case 1: {
            
            if (self.isShowHornor) {
                [self transitionFromViewController:self.currentViewController toViewController:self.hornerPlan duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                    self.currentViewController = self.hornerPlan;
                }];
                
            }
            else {
                [self transitionFromViewController:self.currentViewController toViewController:self.transfer duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                    self.currentViewController = self.transfer;
                }];
            }
            
        }
            break;
            
        case 2: {
            [self transitionFromViewController:self.currentViewController toViewController:self.transfer duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.transfer;
            }];
        }
            break;
    }
}

@end
