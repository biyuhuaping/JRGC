//
//  UCFMicroMoneyViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMicroMoneyViewController.h"
#import "UCFMicroMoneyHeaderView.h"

#import "UCFHomeListHeaderSectionView.h"
#import "UCFHomeListCell.h"

#import "UCFInvestAPIManager.h"
#import "UCFMicroMoneyGroup.h"
#import "UCFMicroMoneyModel.h"

@interface UCFMicroMoneyViewController () <UITableViewDataSource, UITableViewDelegate, UCFInvestAPIWithMicroMoneyManagerDelegate, UCFHomeListCellHonorDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UCFMicroMoneyHeaderView *microMoneyHeaderView;
@property (strong, nonatomic) UCFInvestAPIManager *apiManager;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation UCFMicroMoneyViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - 设置界面
- (void)createUI {
    UCFMicroMoneyHeaderView *microMoneyHeaderView = (UCFMicroMoneyHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMicroMoneyHeaderView" owner:self options:nil] lastObject];
    microMoneyHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 120);
    self.tableview.tableHeaderView = microMoneyHeaderView;
    self.microMoneyHeaderView = microMoneyHeaderView;
    
    UCFInvestAPIManager *apiManager = [[UCFInvestAPIManager alloc] init];
    apiManager.microMoneyDelegate = self;
    self.apiManager = apiManager;
    [apiManager getMicroMoneyFromNet];
}

#pragma mark - tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
    return group.prdlist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0.001;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* viewId = @"homeListHeader";
    UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
    }
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
    view.headerTitleLabel.text = group.title;
    [view.headerImageView sd_setImageWithURL:[NSURL URLWithString:group.iconUrl]];
    view.homeListHeaderMoreButton.hidden = !group.showMore;
    [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
    [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
    [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    view.frame = CGRectMake(0, 0, ScreenWidth, 30);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeListCell";
    UCFHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFHomeListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListCell" owner:self options:nil] lastObject];
        cell.tableView = tableView;
        cell.honorDelegate = self;
    }
    cell.indexPath = indexPath;
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.prdlist objectAtIndex:indexPath.row];
    if ([group.type isEqualToString:@"13"]) {
        model.modelType = UCFMicroMoneyModelTypeNew;
    }
    else if ([group.type isEqualToString:@"14"]) {
        model.modelType = UCFMicroMoneyModelTypeBatchBid;
    }
    else if ([group.type isEqualToString:@"11"]) {
        model.modelType = UCFMicroMoneyModelTypeNormal;
    }
    cell.microMoneyModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark - tableview 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.prdlist objectAtIndex:indexPath.row];
    
}

#pragma mark - 网络请求代理

- (void)investApiManager:(UCFInvestAPIManager *)apiManager didSuccessedReturnMicroMoneyResult:(id)result withTag:(NSUInteger)tag
{
    self.dataArray = (NSMutableArray *)result;
    [self.tableview reloadData];
}

#pragma mark - cell的代理

- (void)homelistCell:(UCFHomeListCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath
{
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.prdlist objectAtIndex:indexPath.row];
}

@end
