//
//  UCFHonerContainerViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/5.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHonerContainerViewController.h"
#import "UCFSelectedView.h"
#import "UCFHonerPlanViewController.h"
#import "UCFHornerTransferViewController.h"
@interface UCFHonerContainerViewController ()<UCFSelectedViewDelegate>
@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSeletedView;
@property (strong, nonatomic)UCFHonerPlanViewController *horner;
@property (strong, nonatomic)UCFHornerTransferViewController *hornerTransfer;
@property (weak, nonatomic) UCFBaseViewController *currentViewController;

@end

@implementation UCFHonerContainerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.view.subviews containsObject:self.currentViewController.view]) {
        [self.view addSubview:self.currentViewController.view];
        self.itemSeletedView.segmentedControl.selectedSegmentIndex = 0;
        [self.currentViewController didMoveToParentViewController:self];//确定关系建立
        [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
        [self.currentViewController.view setFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-49 - 44)];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"工场尊享";
    [self addLeftButton];
    // add SegmentControl
    [self addSegmentControl];
    // add child controllers
    [self addChildControllers];
    
    self.currentViewController = self.horner;

}
- (void)addSegmentControl
{
    self.itemSeletedView.sectionTitles = @[@"尊享计划", @"转让专区"];
    self.itemSeletedView.delegate = self;
}
- (void)addChildControllers
{
    
    self.horner = [[UCFHonerPlanViewController alloc] initWithNibName:@"UCFHonerPlanViewController" bundle:nil];
    _horner.accoutType = SelectAccoutTypeHoner;
    self.horner.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 -44);
    [self addChildViewController:_horner];

    self.hornerTransfer = [[UCFHornerTransferViewController alloc]initWithNibName:@"UCFHornerTransferViewController" bundle:nil];
    self.hornerTransfer.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64-44);
    [self addChildViewController:self.hornerTransfer];
}
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.horner]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.horner duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.horner;
            }];
        }
            break;
            
        case 1: {
            if ([self.currentViewController isEqual:self.hornerTransfer]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.hornerTransfer duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.hornerTransfer;
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
