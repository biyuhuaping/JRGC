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
#import "UCFLoginBaseView.h"
#import "UCFCalendarViewController.h"
#import "UCFMineAPIManager.h"
#import "UCFUserAssetModel.h"
#import "UCFUserBenefitModel.h"

@interface UCFMineViewController () <UITableViewDelegate, UITableViewDataSource, UCFMineHeaderViewDelegate, UCFMineFuncCellDelegate, UCFMineAPIManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UCFMineHeaderView   *mineHeaderView;
@property (strong, nonatomic) UCFLoginBaseView  *loginView;
@property (strong, nonatomic) UCFMineAPIManager *apiManager;

@property (strong, nonatomic) UCFUserBenefitModel *benefitModel;
@property (strong, nonatomic) UCFUserAssetModel *assetModel;
@end

@implementation UCFMineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        if (_loginView) {
            [_loginView removeFromSuperview];
            _loginView = nil;
         }
    } else {
        if (!_loginView) {
            [self.view addSubview:self.loginView];
        }
    }
}
- (UCFLoginBaseView *)loginView
{
    if (!_loginView) {
        _loginView = [[UCFLoginBaseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return _loginView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self configure];
    
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mineHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 195);
}

#pragma mark - 设置界面
- (void)createUI {
    
    UCFMineHeaderView *mineHeader = (UCFMineHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineHeaderView" owner:self options:nil] lastObject];
    mineHeader.delegate = self;
    self.tableView.tableHeaderView = mineHeader;
    self.mineHeaderView = mineHeader;
    
    
}

- (void)refreshData {
    [self.apiManager getAssetFromNet];
    [self.apiManager getBenefitFromNet];
}

- (void)configure {
    UCFMineAPIManager *apiManager = [[UCFMineAPIManager alloc] init];
    apiManager.delegate = self;
    self.apiManager = apiManager;
    [self.apiManager getAssetFromNet];
    [self.apiManager getBenefitFromNet];
}

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedReturnAssetResult:(id)result withTag:(NSUInteger)tag
{
    [self.tableView.header endRefreshing];
    if ([result isKindOfClass:[UCFUserAssetModel class]]) {
        self.assetModel = result;
        [self.tableView reloadData];
        self.mineHeaderView.userAssetModel = result;
    }
}

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedReturnBenefitResult:(id)result withTag:(NSUInteger)tag
{
    [self.tableView.header endRefreshing];
    if ([result isKindOfClass:[UCFUserBenefitModel class]]) {
        self.benefitModel = result;
        [self.tableView reloadData];
        self.mineHeaderView.userBenefitModel = result;
    }
}

#pragma mark - tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
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
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_wj"];
            cell.titleDesLabel.text = @"微金账户";
            cell.valueLabel.text = self.assetModel.p2pCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.p2pCashBalance] : [NSString stringWithFormat:@"¥0.00"];
            cell.describeLabel.text = self.benefitModel.repayPerDateWJ.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.benefitModel.repayPerDateWJ] : @"最近无回款";
        }
        else if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_zx"];
            cell.titleDesLabel.text = @"尊享账户";
            cell.valueLabel.text = self.assetModel.zxCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.zxCashBalance] : [NSString stringWithFormat:@"¥0.00"];
            cell.describeLabel.text = self.benefitModel.repayPerDateZX.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.benefitModel.repayPerDateZX] : @"最近无回款";
        }
        else if (indexPath.row == 2) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_gold"];
            cell.titleDesLabel.text = @"黄金账户";
            cell.valueLabel.text = self.assetModel.nmCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.nmCashBalance] : [NSString stringWithFormat:@"¥0.00"];
            cell.describeLabel.text = self.benefitModel.repayPerDateNM.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.benefitModel.repayPerDateNM] : @"最近无回款";
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = @"minefunccell";
        UCFMineFuncCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineFuncCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineFuncCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *cellId = @"minefuncseccell";
        UCFMineFuncSecCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineFuncSecCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineFuncSecCell" owner:self options:nil] lastObject];
        }
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_bean"];
            cell.icon2ImageView.image = [UIImage imageNamed:@"uesr_icon_coupon"];
            cell.titleDesLabel.text = @"工豆";
            cell.title2DesLabel.text = @"优惠券";
            cell.valueLabel.text = [NSString stringWithFormat:@"¥%@", self.benefitModel.beanAmount];
            cell.value2Label.text = [NSString stringWithFormat:@"%@张可用", self.benefitModel.couponNumber];
        }
        else if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_score"];
            cell.icon2ImageView.image = [UIImage imageNamed:@"uesr_icon_rebate"];
            cell.titleDesLabel.text = @"工分";
            cell.valueLabel.text = [NSString stringWithFormat:@"¥%@", self.benefitModel.score];
            cell.title2DesLabel.text = @"邀请返利";
            cell.value2Label.text = self.benefitModel.promotionCode.length > 0 ? [NSString stringWithFormat:@"工场码%@", self.benefitModel.promotionCode] : @"";
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

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView tappedMememberLevelView:(UIView *)memberLevelView
{
    
}

#pragma mark - UCFMineFuncCell的代理方法

- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedCalendarButton:(UIButton *)button
{
    UCFCalendarViewController *backMoneyCalendarVC = [[UCFCalendarViewController alloc] initWithNibName:@"UCFCalendarViewController" bundle:nil];
//        backMoneyDetailVC.superViewController = self;
//    backMoneyCalendarVC.accoutType = self.accoutType;
    [self.navigationController pushViewController:backMoneyCalendarVC animated:YES];
}

- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedMyReservedButton:(UIButton *)button
{
    
}

@end
