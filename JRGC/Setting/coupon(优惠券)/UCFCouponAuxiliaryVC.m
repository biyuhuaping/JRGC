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
//#import "UCFGoldCouponReturn.h"
#import "UCFPageControlTool.h"
#import "UCFPageHeadView.h"
@interface UCFCouponAuxiliaryVC ()



@property (strong, nonatomic) UCFCouponReturn   *couponReturnView;      //返现券
@property (strong, nonatomic) UCFCouponInterest *couponInterestView;    //返息券
//@property (strong, nonatomic) UCFGoldCouponReturn   *couponGoldView;      //返现券
@property (strong, nonatomic) UIViewController  *currentViewController; //当前viewCotl
@property(nonatomic, strong)UCFPageControlTool *pageController;
@property(nonatomic, strong)UCFPageHeadView    *pageHeadView;
@end

@implementation UCFCouponAuxiliaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];

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
    
    //返息券
    _couponInterestView = [[UCFCouponInterest alloc]initWithNibName:@"UCFCouponInterest" bundle:nil];
    _couponInterestView.status = _status;
    _couponInterestView.sourceVC = 1;
    
    [self.view addSubview:self.pageController];

    
    //返金券
//    _couponGoldView = [[UCFGoldCouponReturn alloc]initWithNibName:@"UCFGoldCouponReturn" bundle:nil];
//    _couponGoldView.status = _status;
//    _couponGoldView.sourceVC = 1;
//    _couponGoldView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
//    [self addChildViewController:_couponGoldView];
    
    
    // 需要显示的子ViewController，要将其View添加到父View中
//    [self.view addSubview:_couponReturnView.view];
//    _currentViewController = _couponReturnView;
//    [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
//    switch (_currentSelectedState) {
//        case 0:
//        {
//            [self.view addSubview:_couponReturnView.view];
//            _currentViewController = _couponReturnView;
//
//        }
//            break;
//        case 1:
//        {
//            [self.view addSubview:_couponInterestView.view];
//            _currentViewController = _couponInterestView;
//        }
//            break;
////        case 2:
////        {
////            [self.view addSubview:_couponGoldView.view];
////            _currentViewController = _couponGoldView;
////        }
////            break;
//        default:
//            break;
//    }
}
#pragma mark ViewInIt 返息券
- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        NSString *title1 = [NSString stringWithFormat:@"返现券"];
        NSString *title2 = [NSString stringWithFormat:@"返息券"];
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) WithTitleArray:@[title1,title2]];
        [_pageHeadView reloaShowView];
    }
    return _pageHeadView;
}
- (UCFPageControlTool *)pageController
{
    if (nil == _pageController) {
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1) WithChildControllers:@[_couponReturnView,_couponInterestView] WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}


@end
