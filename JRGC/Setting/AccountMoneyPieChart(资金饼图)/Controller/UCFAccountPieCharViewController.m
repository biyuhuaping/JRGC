//
//  UCFAccountPieCharViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFAccountPieCharViewController.h"
#import "UCFTotalAssetPieChartViewController.h"
#import "UCFTotalRevenuePieChartViewController.h"
@interface UCFAccountPieCharViewController ()
@property (nonatomic,strong)UISegmentedControl *segmentedCtrl;
@property (strong, nonatomic) UCFTotalAssetPieChartViewController *TotalAssetVC;//总资产
@property (strong, nonatomic) UCFTotalRevenuePieChartViewController *TotalRevenueVC;//累计收益
@property (weak, nonatomic)   UIViewController *currentController;//当前控制器

@end

@implementation UCFAccountPieCharViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createInfoUI];
}
-(void)createInfoUI
{
    [self addLeftButton];


    _segmentedCtrl = [[UISegmentedControl alloc]initWithItems:@[@"总资产", @"累计收益"]];

    DBLOG(@"%@",NSStringFromCGRect(self.view.frame));
    _segmentedCtrl.frame = CGRectMake(0, 0, ScreenWidth*0.5, 30);
    [_segmentedCtrl setTintColor:UIColorWithRGB(0x5b6993)];
    _segmentedCtrl.selectedSegmentIndex = _selectedSegmentIndex;
    [_segmentedCtrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedCtrl;
    
    self.TotalAssetVC = [[UCFTotalAssetPieChartViewController alloc]initWithNibName:@"UCFTotalAssetPieChartViewController" bundle:nil];
//    self.myInvest.accoutType = self.accoutType;
    self.TotalAssetVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    [self addChildViewController:self.TotalAssetVC];
    
    self.TotalRevenueVC = [[UCFTotalRevenuePieChartViewController alloc]initWithNibName:@"UCFTotalRevenuePieChartViewController" bundle:nil];
//    self.batchProject.accoutType = self.accoutType;
    self.TotalRevenueVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    [self addChildViewController:self.TotalRevenueVC];
    
    
    self.segmentedCtrl.selectedSegmentIndex = self.selectedSegmentIndex;
    switch (self.selectedSegmentIndex) {
        case 0: {
            [_TotalAssetVC didMoveToParentViewController:self];//确定关系建立
            self.currentController = self.TotalAssetVC;
            [self.view addSubview:_TotalAssetVC.view];
        }
            break;
        case 1: {
            [_TotalRevenueVC didMoveToParentViewController:self];//确定关系建立
            self.currentController = self.TotalRevenueVC;
            [self.view addSubview:_TotalRevenueVC.view];
        }
            break;
    }
}
- (void)viewWillLayoutSubviews
{
    [self.currentController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight - 64)];
}

-(void)segmentedValueChanged:(UISegmentedControl *)segControl
{
    switch (segControl.selectedSegmentIndex) {
        case 0: {
            [self transitionFromViewController:self.currentController toViewController:self.TotalAssetVC duration:0.25 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
                if (finished) {
                    [self.TotalAssetVC didMoveToParentViewController:self];//确认关系
                    self.currentController = self.TotalAssetVC;
                }
            }];
        }
            break;
        case 1: {
            [self transitionFromViewController:self.currentController toViewController:self.TotalRevenueVC duration:0.25 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
                if (finished) {
                    [self.TotalRevenueVC didMoveToParentViewController:self];//确认关系
                    self.currentController = self.TotalRevenueVC;
                }
            }];
        }
            break;
    }
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
