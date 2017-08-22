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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:@"userisloginandcheckgrade" object:nil];
    
    [self addLeftButton];
    
    // 添加标题然选项卡
    self.isShowHornor = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowHornor"];
    UISegmentedControl *segmentContrl = nil;
    
//    NSString *userId = [UserInfoSingle sharedManager].userId;
//    if (userId) {
//        NSInteger userLevel = [[UserInfoSingle sharedManager].userLevel integerValue];
//        BOOL isShowHornor = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowHornor"];
//        if (userLevel>1 || isShowHornor) {
//            self.isShowHornor = YES;
//        }
//        else
//            self.isShowHornor = NO;
//    }
//    else {
//        self.isShowHornor = NO;
//    }
    self.isShowHornor = NO;
    
    if (self.isShowHornor) {
        segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"P2P专区",@"尊享专区",@"转让专区"]];
    }
    else {
        segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"P2P专区",@"转让专区"]];
    }
    
    segmentContrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    [segmentContrl setTintColor:UIColorWithRGB(0x5b6993)];
//    [segmentContrl setTitleTextAttributes:@{[UIFont systemFontOfSize:15]:NSFontAttributeName} forState:UIControlStateNormal];
    segmentContrl.selectedSegmentIndex = 0;
    [segmentContrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedCtrl = segmentContrl;
    self.navigationItem.titleView = segmentContrl;
    
    self.p2p = [[UCFP2PViewController alloc]initWithNibName:@"UCFP2PViewController" bundle:nil];
    self.p2p.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.p2p.viewType = self.viewType;
    [self.p2p setCurrentViewForBatchBid];
    [self addChildViewController:self.p2p];
    
    self.hornerPlan = [[UCFHonerPlanViewController alloc]initWithNibName:@"UCFHonerPlanViewController" bundle:nil];
    self.hornerPlan.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    [self addChildViewController:self.hornerPlan];
    
    self.transfer = [[UCFTransferViewController alloc]initWithNibName:@"UCFTransferViewController" bundle:nil];
    self.transfer.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
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
        self.segmentedCtrl.selectedSegmentIndex = self.isShowHornor ? 2 : 1;
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
    
//    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSLog(@"object === %@",object);
//}
- (void)changeViewWithConfigure:(NSString *)config
{
    if ([self.strStyle isEqualToString:@"11"]) {
        self.segmentedCtrl.selectedSegmentIndex = 0;
        if (self.currentViewController != self.p2p) {
            [self transitionFromViewController:self.currentViewController toViewController:self.p2p duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.p2p;
                self.p2p.viewType = self.viewType;
                if ([self.p2p isViewLoaded]) {
                    [self.p2p setCurrentViewForBatchBid];
                }
            }];
        }
        else {
            self.p2p.viewType = self.viewType;
            [self.p2p setCurrentViewForBatchBid];
        }
        
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
    [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
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

- (void)reloadView:(NSNotification *)noty
{
    BOOL islogin = [noty.object boolValue];
    UISegmentedControl *segmentCtrl = nil;
    if (islogin) {
        BOOL isShowHornor = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowHornor"];
        if (isShowHornor) {
            self.isShowHornor = YES;
            segmentCtrl = [[UISegmentedControl alloc]initWithItems:@[@"P2P专区",@"尊享专区",@"转让专区"]];
        }
        else {
            self.isShowHornor = NO;
            segmentCtrl = [[UISegmentedControl alloc]initWithItems:@[@"P2P专区",@"转让专区"]];
        }
    }
    else {
        self.isShowHornor = NO;
        segmentCtrl = [[UISegmentedControl alloc]initWithItems:@[@"P2P专区",@"转让专区"]];
    }
    NSInteger preSelectedIndex = self.segmentedCtrl.selectedSegmentIndex;
    self.segmentedCtrl = segmentCtrl;
    self.segmentedCtrl.selectedSegmentIndex = preSelectedIndex;
    segmentCtrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    [segmentCtrl setTintColor:UIColorWithRGB(0x5b6993)];
    [segmentCtrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentCtrl;
    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
