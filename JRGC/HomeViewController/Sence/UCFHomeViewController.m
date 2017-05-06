//
//  UCFHomeViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeViewController.h"
#import "UCFCycleImageViewController.h"
#import "UCFUserInformationViewController.h"
#import "UCFHomeListViewController.h"

#import "UCFUserPresenter.h"
#import "UCFHomeListPresenter.h"
#import "UserInfoSingle.h"

//#import "UCFHomeListNavView.h"

@interface UCFHomeViewController () <UCFHomeListViewControllerDelegate>
@property (strong, nonatomic) UCFCycleImageViewController *cycleImageVC;
@property (strong, nonatomic) UCFUserInformationViewController *userInfoVC;
@property (strong, nonatomic) UCFHomeListViewController *homeListVC;

//@property (weak, nonatomic) UCFHomeListNavView *navView;
@end

@implementation UCFHomeViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - 设置
    [self configuration];
#pragma mark - 添加界面
    [self addUI];
}

#pragma mark - configuration 设置
- (void)configuration
{
    self.navigationController.navigationBar.hidden = YES;
    
//    UCFHomeListNavView *navView = [[UCFHomeListNavView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:navView];
//    self.navView = navView;
    
    UCFUserPresenter *userPresenter = [UCFUserPresenter presenter];
    
    self.cycleImageVC = [UCFCycleImageViewController instanceWithPresenter:userPresenter];
    self.userInfoVC = [UCFUserInformationViewController instanceWithPresenter:userPresenter];
    
    UCFHomeListPresenter *listViewPresenter = [UCFHomeListPresenter presenter];
    self.homeListVC = [UCFHomeListViewController instanceWithPresenter:listViewPresenter];
    self.homeListVC.delegate = self; //HomeListViewController走的是Protocol绑定方式

    [self addChildViewController:self.cycleImageVC];
    [self addChildViewController:self.userInfoVC];
}

#pragma mark - addUI 添加界面
- (void)addUI {
    
    
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        CGFloat userInfoViewHeight = [UCFUserInformationViewController viewHeight];
        self.userInfoVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, userInfoViewHeight);
        self.homeListVC.tableView.tableHeaderView = self.userInfoVC.view;
    }
    else {
        CGFloat cycleImageViewHeight = [UCFCycleImageViewController viewHeight];
        self.cycleImageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, cycleImageViewHeight);
        self.homeListVC.tableView.tableHeaderView = self.cycleImageVC.view;
    }
    
    self.homeListVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-49);
    [self.view addSubview:self.homeListVC.tableView];
    
//    self.navView.frame = CGRectMake(0, 0, self.view.width, 64);
//    [self.view bringSubviewToFront:self.navView];
}

#pragma mark - homelistVC的代理方法

//- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didScrollWithYOffSet:(CGFloat)offSet
//{
//    CGFloat alp = offSet / 64;
//    if (alp < 0) {
//        self.navView.alpha = 0;
//    }
//    else if (alp>=0 && alp<=0.9) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.navView.alpha = alp;
//        }];
//    }
//    else
//        self.navView.alpha = 0.9;
//}

@end
