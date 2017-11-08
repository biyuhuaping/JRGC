//
//  UCFExtractGoldViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFExtractGoldViewController.h"
#import "UCFNoDataView.h"
#import "PageView.h"
#import "UCFGoldAllViewController.h"
#import "UCFHandingInViewController.h"
#import "UCFDeliveryingViewController.h"
#import "UCFTakingDeliveryViewController.h"
#import "UCFCompleteViewController.h"

@interface UCFExtractGoldViewController ()
@property (nonatomic,strong)UCFNoDataView *noDataView;
@end

@implementation UCFExtractGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
//    if (!self.noDataView) {
//        self.noDataView = [[UCFNoDataView alloc] initGoldWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44 -44) errorTitle:@"你还没有订单" buttonTitle:@""];
////        self.noDataView.delegate = self;
//    }
//
//    [self.noDataView showInView:self.view];
    
    
    
}

- (void)createUI {
    baseTitleLabel.text = @"提金订单";
    [self addLeftButton];
    
    NSArray *titles = [NSArray arrayWithObjects:@"全部", @"待提交", @"待发货", @"待收货", @"完成", nil];
    UCFGoldAllViewController *all = [[UCFGoldAllViewController alloc] initWithNibName:@"UCFGoldAllViewController" bundle:nil];
    all.rootVc = self;
    UCFHandingInViewController *handin = [[UCFHandingInViewController alloc] initWithNibName:@"UCFHandingInViewController" bundle:nil];
    handin.rootVc = self;
    UCFDeliveryingViewController *delivery = [[UCFDeliveryingViewController alloc] initWithNibName:@"UCFDeliveryingViewController" bundle:nil];
    delivery.rootVc = self;
    UCFTakingDeliveryViewController *takeDelivery = [[UCFTakingDeliveryViewController alloc] initWithNibName:@"UCFTakingDeliveryViewController" bundle:nil];
    takeDelivery.rootVc = self;
    UCFCompleteViewController *complete = [[UCFCompleteViewController alloc] initWithNibName:@"UCFCompleteViewController" bundle:nil];
    complete.rootVc = self;
    NSArray *controllers = [NSArray arrayWithObjects:all, handin, delivery, takeDelivery, complete, nil];
    PageView *pageView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) withTitles:titles withControllers:controllers];
//    pageView.selectedIndex = 2;
    
    [self.view addSubview:pageView];
}

@end
