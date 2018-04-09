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
#import "UCFGoldCouponReturn.h"
@interface UCFCouponAuxiliaryVC ()<UCFSelectedViewDelegate>

@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSelectView;   // 选项条


@property (strong, nonatomic) UCFCouponReturn   *couponReturnView;      //返现券
@property (strong, nonatomic) UCFCouponInterest *couponInterestView;    //返息券
@property (strong, nonatomic) UCFGoldCouponReturn   *couponGoldView;      //返现券
@property (strong, nonatomic) UIViewController  *currentViewController; //当前viewCotl

@end

@implementation UCFCouponAuxiliaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    
    if([UserInfoSingle sharedManager].superviseSwitch && [UserInfoSingle sharedManager].level < 2 && [UserInfoSingle sharedManager].goldIsNew)
    {
         self.itemSelectView.sectionTitles = @[@"返现券", @"返息券"];
    }
    else
    {
        self.itemSelectView.sectionTitles = @[@"返现券", @"返息券",@"返金券"];
    }
    self.itemSelectView.delegate = self;
    self.itemSelectView.segmentedControl.selectedSegmentIndex =_currentSelectedState;
    [self initViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initViewController{
    //返现券
    _couponReturnView = [[UCFCouponReturn alloc]initWithNibName:@"UCFCouponReturn" bundle:nil];
    _couponReturnView.status = _status;
    _couponReturnView.sourceVC = 1;
    _couponReturnView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);;
    [self addChildViewController:_couponReturnView];
    
    //返息券
    _couponInterestView = [[UCFCouponInterest alloc]initWithNibName:@"UCFCouponInterest" bundle:nil];
    _couponInterestView.status = _status;
    _couponInterestView.sourceVC = 1;
    _couponInterestView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponInterestView];
    //返金券
    _couponGoldView = [[UCFGoldCouponReturn alloc]initWithNibName:@"UCFGoldCouponReturn" bundle:nil];
    _couponGoldView.status = _status;
    _couponGoldView.sourceVC = 1;
    _couponGoldView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponGoldView];
    
    
    // 需要显示的子ViewController，要将其View添加到父View中
//    [self.view addSubview:_couponReturnView.view];
//    _currentViewController = _couponReturnView;
    [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    switch (_currentSelectedState) {
        case 0:
        {
            [self.view addSubview:_couponReturnView.view];
            _currentViewController = _couponReturnView;
            
        }
            break;
        case 1:
        {
            [self.view addSubview:_couponInterestView.view];
            _currentViewController = _couponInterestView;
        }
            break;
        case 2:
        {
            [self.view addSubview:_couponGoldView.view];
            _currentViewController = _couponGoldView;
        }
            break;
        default:
            break;
    }
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
        case 2:{
            [self transitionFromViewController:_currentViewController toViewController:_couponGoldView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = _couponGoldView;
            }];
        }
            break;
    }
}

@end
