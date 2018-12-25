//
//  UCFInvestmentCouponController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFInvestmentCouponController.h"
#import "PageControlView.h"
@interface UCFInvestmentCouponController ()
{
    PageControlView    * _pagerView;
}
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *currentVC;
@end

@implementation UCFInvestmentCouponController
- (void)addChildControllers
{
    self.ctController = [[UCFInvestmentCouponCashTicketController alloc] init];//返现券
    self.ctController.db = self;
    [self addChildViewController:self.ctController];

    self.itController = [[UCFInvestmentCouponInterestTicketController alloc] init];//返现券
    self.itController.db = self;
    [self addChildViewController:self.itController];

    
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];

    [titleArray addObject:@"返现券"];

    [titleArray addObject:@"返息券"];
    
    CGRect stateFrame = [[UIApplication sharedApplication] statusBarFrame];
    _pagerView = [[PageControlView alloc] initWithFrame:CGRectMake(0,stateFrame.size.height,ScreenWidth,ScreenHeight)
                                SegmentViewHeight:44
                                       titleArray:titleArray
                                       Controller:self
                                        lineWidth:70
                                       lineHeight:3];
    
    [self.view addSubview:_pagerView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];

    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"]forState:UIControlStateNormal];

    [leftButton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    
    [_pagerView.segmentView addSubview:leftButton];
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(ScreenWidth - 55,0, 44, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setImage:[UIImage imageNamed:@"icon_question.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
  
    [_pagerView.segmentView addSubview:rightbutton];
    

    [self changeView];
}
- (void)changeView
{
    [_pagerView setSelectIndex:_barSelectIndex];
}
- (void)clickRightBtn
{
    NSString *isP2PTipStr =  self.accoutType == SelectAccoutTypeP2P  ? @"出借":@"投资";
    NSString *messageStr = [NSString stringWithFormat:@"1.返现券和返息券可在一笔%@中共用\n2.返现券可叠加使用\n3.返息券只能使用一张,不可叠加",isP2PTipStr];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr  delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addChildControllers];
    
    return;

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
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - NavigationBarHeight1);
    [self.view addSubview:self.scrollView];

//    self.ctController = [[UCFInvestmentCouponCashTicketController alloc] init];//返现券
//    self.ctController.db = self;
//    self.ctController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1);
//    [self addChildViewController:self.ctController];
////    addChildViewController 会调用 [child willMoveToParentViewController:self] 方法，但是不会调用 didMoveToParentViewController:方法，官方建议显示调用
//    [self.ctController didMoveToParentViewController:self];
//    [self.scrollView addSubview:self.ctController.view];
//
//    self.currentVC = self.ctController;
    
    
    
    
    self.itController = [[UCFInvestmentCouponInterestTicketController alloc] init];//返息券
    self.itController.db = self;
    self.itController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1);
    //addChildViewController 会调用 [child willMoveToParentViewController:self] 方法，但是不会调用 didMoveToParentViewController:方法，官方建议显示调用
    [self.itController didMoveToParentViewController:self];
    [self addChildViewController:self.itController];
    [self.scrollView addSubview:self.itController.view];
    
    
    

    
    
    
    
    
    
}
//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//
//    [self.view layoutIfNeeded];
//}

- (void)transitionToViewController:(UIButton *)btn
{
//    if (btn.tag == 100) {
//        [self changeControllerFromOldController:self.itController toNewController:self.itControlle]
//    }
}
- (void)changeControllerFromOldController:(UIViewController *)oldController toNewController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    /**
     *  切换ViewController
     */
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        //做一些动画
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            //移除oldController，但在removeFromParentViewController：方法前不会调用willMoveToParentViewController:nil 方法，所以需要显示调用
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else
        {
            self.currentVC = oldController;
        }
        
    }];
    
    
    
    
    
    
    
    
    
//    if (btn.tag == 100)
//    {
//        [self transitionFromViewController:self.itController toViewController:self.ctController duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            CATransition *animation = [CATransition animation];
//            [animation setDuration:0.25];
//            [animation setFillMode:kCAFillModeForwards];
//            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//            [animation setType:kCATransitionPush];
//            [animation setSubtype:kCATransitionFromRight];
////            [toViewController.view.layer addAnimation:animation forKey:nil];
//        } completion:^(BOOL finished) {
//
//        }];
//    }
//    else
//    {
//        [self transitionFromViewController:self.ctController toViewController:self.itController duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            CATransition *animation = [CATransition animation];
//            [animation setDuration:0.25];
//            [animation setFillMode:kCAFillModeForwards];
//            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//            [animation setType:kCATransitionPush];
//            [animation setSubtype:kCATransitionFromRight];
//            //            [toViewController.view.layer addAnimation:animation forKey:nil];
//        } completion:^(BOOL finished) {
//
//        }];
//    }
//
    
}
- (void)confirmTheCouponOfYourChoice
{
    [self.ctController couponOfChoice];//返现券
    [self.itController couponOfChoic];//返息券
    [self backToTheInvestmentPage];
    
}
- (void)backToTheInvestmentPage
{
    [self.navigationController popViewControllerAnimated:YES];
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
