//
//  UCFInvestViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvestViewController.h"
#import "UCFHonorInvestViewController.h"
#import "UCFMicroMoneyViewController.h"
#import "UCFInvestTransferViewController.h"

#import "UCFSelectedView.h"

@interface UCFInvestViewController () <UCFSelectedViewDelegate>
@property (weak, nonatomic) UCFSelectedView *itemSelectedView;
@property (strong, nonatomic) UCFHonorInvestViewController *honorInvest;
@property (strong, nonatomic) UCFMicroMoneyViewController *microMoney;
@property (strong, nonatomic) UCFInvestTransferViewController *investTransfer;

@property (strong, nonatomic) UCFBaseViewController *currentViewController;
@end

@implementation UCFInvestViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([self.currentViewController isEqual:self.honorInvest]) {
        [self.honorInvest.tableView.header beginRefreshing];
    }
    else if ([self.currentViewController isEqual:self.microMoney]) {
        [self.microMoney.tableview.header beginRefreshing];
    }
    else if ([self.currentViewController isEqual:self.investTransfer]) {
        [self.investTransfer.tableview.header beginRefreshing];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self createUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.currentViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 -49);
    [self.view addSubview:self.currentViewController.view];
}

#pragma mark - 设置界面
- (void)createUI {
    UCFSelectedView *selectItemView = [[UCFSelectedView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    selectItemView.sectionTitles = @[@"尊享", @"微金", @"转让"];
    selectItemView.delegate = self;
    self.navigationItem.titleView = selectItemView;
    self.itemSelectedView = selectItemView;
    
    self.honorInvest = [[UCFHonorInvestViewController alloc]initWithNibName:@"UCFHonorInvestViewController" bundle:nil];
    self.honorInvest.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.honorInvest.rootVc = self;
    [self addChildViewController:self.honorInvest];
    
    self.microMoney = [[UCFMicroMoneyViewController alloc]initWithNibName:@"UCFMicroMoneyViewController" bundle:nil];
    self.microMoney.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.microMoney.rootVc = self;
    [self addChildViewController:self.microMoney];
    
    self.investTransfer = [[UCFInvestTransferViewController alloc]initWithNibName:@"UCFInvestTransferViewController" bundle:nil];
    self.investTransfer.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.investTransfer.rootVc = self;
    [self addChildViewController:self.investTransfer];
    
    if ([self.selectedType isEqualToString:@"P2P"]) {
        self.currentViewController = self.microMoney;
        self.itemSelectedView.segmentedControl.selectedSegmentIndex = 1;
    }
    else if ([self.selectedType isEqualToString:@"ZX"]) {
        self.currentViewController = self.honorInvest;
        self.itemSelectedView.segmentedControl.selectedSegmentIndex = 0;
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        self.currentViewController = self.investTransfer;
        self.itemSelectedView.segmentedControl.selectedSegmentIndex = 2;
    }
    else {
        self.currentViewController = self.honorInvest;
        self.itemSelectedView.segmentedControl.selectedSegmentIndex = 0;
    }
}

#pragma mark - 选项条的代理
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.honorInvest]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.honorInvest duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.honorInvest;
            }];
        }
            break;
            
        case 1: {
            
            if ([self.currentViewController isEqual:self.microMoney]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.microMoney duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.microMoney;
            }];
            
        }
            break;
            
        case 2: {
            if ([self.currentViewController isEqual:self.investTransfer]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.investTransfer duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.investTransfer;
            }];
        }
            break;
    }
}

- (void)changeView {
    if ([self.selectedType isEqualToString:@"P2P"]) {
        self.itemSelectedView.segmentedControl.selectedSegmentIndex = 1;
    }
    else if ([self.selectedType isEqualToString:@"ZX"]) {
        self.itemSelectedView.segmentedControl.selectedSegmentIndex = 0;
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        self.itemSelectedView.segmentedControl.selectedSegmentIndex = 2;
    }
    
    [self SelectedView:nil didClickSelectedItemWithSeg:self.itemSelectedView.segmentedControl];
}

@end
