//
//  UCFInvestmentCouponController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFInvestmentCouponController.h"

@interface UCFInvestmentCouponController ()
@property (strong, nonatomic)  UIScrollView *scrollView;
@end

@implementation UCFInvestmentCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 141, 44)];
    navView.backgroundColor = [UIColor clearColor];
    [self.navigationItem.titleView addSubview:navView];
    
    UIButton *ctbutton = [UIButton buttonWithType:0];
    [ctbutton setBackgroundColor:[UIColor clearColor]];
    ctbutton.tag = 100;
    ctbutton.frame = CGRectMake(0, 0, 40, 44);
    [ctbutton addTarget:self action:@selector(transitionToViewController:) forControlEvents:UIControlEventTouchUpInside];
    [ctbutton setTitle:@"返现券" forState:UIControlStateNormal];
    [navView addSubview:ctbutton];
//
    UIButton *itbutton = [UIButton buttonWithType:0];
    [itbutton setBackgroundColor:[UIColor clearColor]];
    itbutton.tag = 101;
    itbutton.frame = CGRectMake(100, 0, 40, 44);
    [itbutton addTarget:self action:@selector(transitionToViewController:) forControlEvents:UIControlEventTouchUpInside];
    [itbutton setTitle:@"返息券" forState:UIControlStateNormal];
    [navView addSubview:itbutton];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1)];
    [self.view addSubview:self.scrollView];

    self.ctController = [[UCFInvestmentCouponCashTicketController alloc] init];//返现券
    self.ctController.db = self;
    [self addChildViewController:self.ctController];
    [self.scrollView addSubview:self.ctController.view];

    self.itController = [[UCFInvestmentCouponInterestTicketController alloc] init];//返息券
    self.itController.db = self;
    [self addChildViewController:self.itController];
    [self.scrollView addSubview:self.itController.view];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - NavigationBarHeight1);
    self.ctController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1);
    self.itController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1);
    [self.view layoutIfNeeded];
}

- (void)transitionToViewController:(UIButton *)btn
{
    
    if (btn.tag == 100)
    {
        [self transitionFromViewController:self.itController toViewController:self.ctController duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.25];
            [animation setFillMode:kCAFillModeForwards];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [animation setType:kCATransitionPush];
            [animation setSubtype:kCATransitionFromRight];
//            [toViewController.view.layer addAnimation:animation forKey:nil];
        } completion:^(BOOL finished) {
           
        }];
    }
    else
    {
        [self transitionFromViewController:self.ctController toViewController:self.itController duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.25];
            [animation setFillMode:kCAFillModeForwards];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [animation setType:kCATransitionPush];
            [animation setSubtype:kCATransitionFromRight];
            //            [toViewController.view.layer addAnimation:animation forKey:nil];
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
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
