//
//  UCFP2PViewController.m
//  JRGC
//
//  Created by NJW on 2016/11/17.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFP2PViewController.h"
#import "UCFOrdinaryBidController.h"
#import "UCFBatchBidController.h"
#import "UCFSelectedView.h"

@interface UCFP2PViewController () <UCFSelectedViewDelegate>
@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSeletedView;

@property (weak, nonatomic) UCFBaseViewController *currentViewController;
@property (nonatomic, strong) UCFOrdinaryBidController *ordinaryBid;
@property (nonatomic, strong) UCFBatchBidController *batchBid;
@end

@implementation UCFP2PViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - create UI
    
    // add SegmentControl
    [self addSegmentControl];
    // add child controllers
    [self addChildControllers];
    // setting current controller
    self.currentViewController = self.ordinaryBid;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.view.subviews containsObject:self.currentViewController.view]) {
        [self.view addSubview:self.currentViewController.view];
        self.itemSeletedView.segmentedControl.selectedSegmentIndex = 0;
        [self.currentViewController didMoveToParentViewController:self];//确定关系建立
    }
}

#pragma mark - add child controllers
- (void)addChildControllers
{
    self.ordinaryBid = [[UCFOrdinaryBidController alloc]initWithNibName:@"UCFOrdinaryBidController" bundle:nil];
    self.ordinaryBid.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64-49 -44);
    [self addChildViewController:self.ordinaryBid];
    self.batchBid = [[UCFBatchBidController alloc]initWithNibName:@"UCFBatchBidController" bundle:nil];
    self.batchBid.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64-49 -44);
    [self addChildViewController:self.batchBid];
}

#pragma mark - add segmentcontrol and segmentcontrol clicked method

- (void)addSegmentControl
{
    self.itemSeletedView.sectionTitles = @[@"普通标", @"批量投资标"];
    self.itemSeletedView.delegate = self;
}

- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.ordinaryBid]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.ordinaryBid duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.ordinaryBid;
            }];
        }
            break;
            
        case 1: {
            if ([self.currentViewController isEqual:self.batchBid]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.batchBid duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.batchBid;
            }];
        }
            break;
            
    }
}

@end
