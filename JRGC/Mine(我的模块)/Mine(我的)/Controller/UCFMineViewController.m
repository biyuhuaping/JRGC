//
//  UCFMineViewController.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineViewController.h"
#import "UCFMineHeaderView.h"
#import "UCFMineCell.h"
#import "UCFMineFuncCell.h"
#import "UCFMineFuncSecCell.h"
#import "UCFSecurityCenterViewController.h"
@interface UCFMineViewController () <UITableViewDelegate, UITableViewDataSource, UCFMineHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UCFMineHeaderView *mineHeaderView;

@end

@implementation UCFMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mineHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 195);
}

#pragma mark - 设置界面
- (void)createUI {
    self.navigationController.navigationBar.hidden = YES;
    
    UCFMineHeaderView *mineHeader = (UCFMineHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineHeaderView" owner:self options:nil] lastObject];
    mineHeader.delegate = self;
    self.tableView.tableHeaderView = mineHeader;
    self.mineHeaderView = mineHeader;
}

#pragma mark - tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        
        case 1:
            return 1;
        
        case 2:
            return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"minecellfirst";
        UCFMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = @"minefunccell";
        UCFMineFuncCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineFuncCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineFuncCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *cellId = @"minefuncseccell";
        UCFMineFuncSecCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineFuncSecCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineFuncSecCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50;
    }
    return 60;
}

#pragma mark - 我的页面的头部视图代理方法
- (void)mineHeaderViewDidClikedUserInfoWithCurrentVC:(UCFMineHeaderView *)mineHeaderView
{
    UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
    personMessageVC.title = @"个人信息";
    [self.navigationController pushViewController:personMessageVC animated:YES];
}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedTopUpButton:(UIButton *)rechargeButton
{
    
}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedCashButton:(UIButton *)cashButton
{
    
}

@end
