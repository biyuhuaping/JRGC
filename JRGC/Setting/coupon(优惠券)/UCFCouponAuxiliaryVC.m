//
//  UCFCouponAuxiliaryVC.m
//  JRGC
//
//  Created by biyuhuaping on 2016/11/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFCouponAuxiliaryVC.h"
#import "UCFSelectedView.h"

#import "UCFCouponReturn.h"
#import "UCFCouponInterest.h"

@interface UCFCouponAuxiliaryVC ()<UCFSelectedViewDelegate>

@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSelectView;   // 选项条
@property (assign, nonatomic) NSInteger currentSelectedState;           //当前选中状态

@property (strong, nonatomic) UCFCouponReturn   *couponReturnView;      //返现券
@property (strong, nonatomic) UCFCouponInterest *couponInterestView;    //返息券
@property (strong, nonatomic) UIViewController  *currentViewController; //当前viewCotl

@end

@implementation UCFCouponAuxiliaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    _currentSelectedState = 0;
    self.itemSelectView.sectionTitles = @[@"返现券", @"返息券"];
    self.itemSelectView.delegate = self;
    [self initViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initViewController{
    //返现券
    _couponReturnView = [[UCFCouponReturn alloc]initWithNibName:@"UCFCouponReturn" bundle:nil];
    _couponReturnView.status = _status;
    _couponReturnView.sourceVC = 1;
    _couponReturnView.view.frame = CGRectMake(0, 44, CGRectGetWidth(super.view.bounds), CGRectGetHeight(super.view.bounds) - 44);
    [self addChildViewController:_couponReturnView];
    
    //返息券
    _couponInterestView = [[UCFCouponInterest alloc]initWithNibName:@"UCFCouponInterest" bundle:nil];
    _couponInterestView.status = _status;
    _couponInterestView.sourceVC = 1;
    _couponInterestView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponInterestView];
    
    // 需要显示的子ViewController，要将其View添加到父View中
    [self.view addSubview:_couponReturnView.view];
    _currentViewController = _couponReturnView;
}

// 选项的点击事件
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender{
    _currentSelectedState = sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case 0:{
            [self transitionFromViewController:_currentViewController toViewController:_couponReturnView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = _couponReturnView;
            }];
        }
            break;
            
        case 1: {
            [self transitionFromViewController:_currentViewController toViewController:_couponInterestView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = _couponInterestView;
            }];
        }
            break;
    }
}

@end
