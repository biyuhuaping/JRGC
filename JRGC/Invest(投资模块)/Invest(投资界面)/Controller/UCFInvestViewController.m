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
#import "UCFGoldenViewController.h"
#import "PagerView.h"
#import "UCFSelectedView.h"

@interface UCFInvestViewController () <UCFSelectedViewDelegate>
{
    PagerView *_pagerView;

}
@property (weak, nonatomic) UCFSelectedView *itemSelectedView;
@property (strong, nonatomic) UCFHonorInvestViewController *honorInvest;
@property (strong, nonatomic) UCFMicroMoneyViewController *microMoney;
@property (strong, nonatomic) UCFGoldenViewController *golden;
@property (strong, nonatomic) UCFInvestTransferViewController *investTransfer;

@property (strong, nonatomic) UCFBaseViewController *currentViewController;
@end

@implementation UCFInvestViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewControllers];
    //设置UI
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentControllerUpdate) name:@"reloadHonerPlanData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentControllerUpdate) name:@"reloadP2PTransferData" object:nil];
    
}

- (void)refresh {
    [self currentControllerUpdate];
}

- (void)currentControllerUpdate
{
    if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
        [self.microMoney.tableview.header beginRefreshing];
    }
    else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
        [self.honorInvest.tableView.header beginRefreshing];
    }
    else if ([_pagerView.selectIndexStr isEqualToString:@"3"]) {
        [self.investTransfer.tableview.header beginRefreshing];
    }
    else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
        [self.golden.tableview.header beginRefreshing];
    }
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - 设置界面
- (void)addChildViewControllers
{
    self.microMoney = [[UCFMicroMoneyViewController alloc]initWithNibName:@"UCFMicroMoneyViewController" bundle:nil];
    self.microMoney.rootVc = self;
    [self addChildViewController:self.microMoney];
    
    self.honorInvest = [[UCFHonorInvestViewController alloc]initWithNibName:@"UCFHonorInvestViewController" bundle:nil];
    self.honorInvest.rootVc = self;
    [self addChildViewController:self.honorInvest];
    
    self.golden = [[UCFGoldenViewController alloc] initWithNibName:@"UCFGoldenViewController" bundle:nil];
    self.golden.rootVc = self;
    [self addChildViewController:self.golden];
    
    self.investTransfer = [[UCFInvestTransferViewController alloc]initWithNibName:@"UCFInvestTransferViewController" bundle:nil];
    self.investTransfer.rootVc = self;
    [self addChildViewController:self.investTransfer];

}
- (void)createUI {
    _pagerView = [[PagerView alloc] initWithFrame:CGRectMake(0,20,ScreenWidth,ScreenHeight - 20 - 49)
                               SegmentViewHeight:44
                                      titleArray:@[@"微金", @"尊享", @"黄金", @"债转"]
                                      Controller:self
                                       lineWidth:44
                                      lineHeight:3];
    
    [self.view addSubview:_pagerView];
    
    if ([self.selectedType isEqualToString:@"P2P"]) {
        self.currentViewController = self.microMoney;
        [_pagerView setSelectIndex:0];
    }
    else if ([self.selectedType isEqualToString:@"ZX"]) {
        self.currentViewController = self.honorInvest;
        [_pagerView setSelectIndex:1];
        
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        self.currentViewController = self.investTransfer;
        [_pagerView setSelectIndex:3];
    }
    else if ([self.selectedType isEqualToString:@"Gold"]) {
        self.currentViewController = self.golden;
        [_pagerView setSelectIndex:2];
    }
    else {
        self.currentViewController = self.honorInvest;
        [_pagerView setSelectIndex:0];
    }
}

- (void)changeView {
    if ([self.selectedType isEqualToString:@"P2P"]) {
        [_pagerView setSelectIndex:0];
        self.currentViewController = self.microMoney;
    }
    else if ([self.selectedType isEqualToString:@"ZX"]) {
        [_pagerView setSelectIndex:1];
        self.currentViewController = self.honorInvest;
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        [_pagerView setSelectIndex:3];
        self.currentViewController = self.investTransfer;
    }
    else if ([self.selectedType isEqualToString:@"Gold"]) {
        [_pagerView setSelectIndex:2];
        self.currentViewController = self.golden;
    }
}

@end
