//
//  UCFNewRechargeViewController.m
//  JRGC
//
//  Created by 金融工场 on 2018/11/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFNewRechargeViewController.h"
#import "UCFTransRechargeViewController.h"
#import "UCFQuickRechargeViewController.h"
#import "PagerView.h"
@interface UCFNewRechargeViewController ()
@property(strong, nonatomic)PagerView *pagerView;
@property(strong, nonatomic)UCFTransRechargeViewController *transVC;
@property(strong, nonatomic)UCFQuickRechargeViewController *quickVC;
@end

@implementation UCFNewRechargeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    self.pagerView = [[PagerView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight - 20 - 49)
                                SegmentViewHeight:44
                                           titleArray:@[@"快捷充值",@"转帐充值"]
                                       Controller:self
                                        lineWidth:70
                                       lineHeight:3];
    [self.view addSubview:_pagerView];
    [self addQuickVC];
    [self addTransVC];
}
- (void)addTransVC {
    [self addChildViewController:self.transVC];
}
- (void)addQuickVC {
    [self addChildViewController:self.quickVC];
}
- (UCFTransRechargeViewController *)transVC
{
    if (!_transVC) {
        _transVC = [[UCFTransRechargeViewController alloc] initWithNibName:@"UCFTransRechargeViewController" bundle:nil];
    }
    return _transVC;
}
- (UCFQuickRechargeViewController *)quickVC {
    if (!_quickVC) {
        _quickVC = [[UCFQuickRechargeViewController alloc] initWithNibName:@"UCFQuickRechargeViewController" bundle:nil];
    }
    return _quickVC;
}


























@end
