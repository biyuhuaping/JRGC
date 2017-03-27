//
//  UCFPCListViewController.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPCListViewController.h"
#import "MJRefresh.h"
#import "UCFPCListCell.h"
#import "UCFPCFunctionCell.h"
#import "UCFPCGroupPresenter.h"

@interface UCFPCListViewController () <PCListViewPresenterCallBack>

@property (strong, nonatomic) UCFPCListViewPresenter *presenter;
@end

#define RowHeight0 65
#define RowHeight1 44
#define ReuseIdentifier1 @"UCFPCListCell"
#define ReuseIdentifier2 @"UCFPCFunctionCell"
@implementation UCFPCListViewController
+ (instancetype)instanceWithPresenter:(UCFPCListViewPresenter *)presenter {
    return [[UCFPCListViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFPCListViewPresenter *)presenter {
    if (self = [super init]) {
        
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.presenter = presenter;
        self.presenter.view = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
        
//        __weak typeof(self) weakSelf = self;
//        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf.presenter refreshData];
//        }];
//         [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf.presenter loadMoreData];
//        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.presenter.allDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
        return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [view setBackgroundColor:[UIColor grayColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.width-30, view.height)];
    label.text = @"常用工具";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorWithRGB(0x333333);
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.presenter.allDatas.count;
    UCFPCGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
    return groupPresenter.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return RowHeight0;
    }
    else
        return RowHeight1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UCFPCListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:ReuseIdentifier1 owner:self options:nil] lastObject];
        }
        UCFPCGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
        cell.presenter = [groupPresenter.items objectAtIndex:indexPath.row];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        UCFPCFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:ReuseIdentifier2 owner:self options:nil] lastObject];
        }
        UCFPCGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
        cell.presenter = [groupPresenter.items objectAtIndex:indexPath.row];
        return cell;
    }
    
    return nil;
//    BlogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
//    cell.presenter = self.presenter.allDatas[indexPath.row];//PV绑定
//    
//    __weak typeof(cell) weakCell = cell;
//    [cell setDidLikeHandler:^{//这里用一个handler是因为点赞失败需要弹框提示, 这个弹框是什么样式或者弹不弹框cell是不知道, 所以把事件传出来在C层处理, 或者你也可以再传到Scene层处理, 这个看具体的业务场景.
//        
//        //实际的点赞逻辑调用的还是P层实现
//        [weakCell.presenter likeBlogWithCompletionHandler:^(NSError *error, id result) {
//            !error ?: [weakCell showToastWithText:error.domain];
//        }];
//    }];
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(pcListViewControllerdidSelectItem:)]) {
        UCFPCGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
        UCFPCListCellPresenter *cellPresenter = [groupPresenter.items objectAtIndex:indexPath.row];
        [self.delegate pcListViewControllerdidSelectItem:cellPresenter.item];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - BlogViewPresenterCallBack

- (void)pcListViewPresenter:(UCFPCListViewPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error{
//    [self.tableView.header endRefreshing];
    
    if (!error) {
        
        [self.tableView reloadData];
//        [self.tableView.footer resetNoMoreData];
    } else if (self.presenter.allDatas.count == 0) {
        //        show error view
    }
}

@end
