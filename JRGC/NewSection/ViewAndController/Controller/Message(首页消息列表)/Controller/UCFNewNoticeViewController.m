//
//  UCFNewNoticeViewController.m
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewNoticeViewController.h"
#import "UCFSimpleNoticeTableViewCell.h"
#import "UCFNoticeCenterApi.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
@interface UCFNewNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)BaseTableView    *showTableView;

@property(nonatomic, assign)NSInteger    pageIndex;

@end

@implementation UCFNewNoticeViewController

- (void)loadView
{
    [super loadView];
    
    self.showTableView.myVertMargin = 0;
    self.showTableView.myHorzMargin = 0;
    [self.rootLayout addSubview:self.showTableView];
    self.showTableView.backgroundColor = [UIColor whiteColor];
    
    [self.showTableView registerClass:[UCFSimpleNoticeTableViewCell class] forCellReuseIdentifier:@"message"];
//    if (@available(iOS 11.0, *)) {
//        self.showTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    UIView *headfootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    headfootView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
    self.showTableView.tableHeaderView = headfootView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlueLeftButton];
    [self setTitleViewText:@"平台公告"];
    [self.showTableView beginRefresh];

}
- (void)fetchData
{
    for (int i = 0; i < 10; i++) {
        NoticeResult *model = [NoticeResult new];
        model.title = @"豆哥商城|关于豆哥商城春节期间物流停 止发货时间的通知";
        model.sendTime = @"2018-09-09";
        [self.dataArray addObject:model];
    }
    [self.showTableView reloadData];
    return;
    UCFNoticeCenterApi *api = [[UCFNoticeCenterApi alloc] initWithPageSize:@"20" PageIndex:[NSString stringWithFormat:@"%ld",_pageIndex]];
    api.animatingView = [UIApplication sharedApplication].keyWindow;
    @PGWeakObj(self);
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NoticeCenterModel *model = request.responseJSONModel;
        if (model.data.noicePage.pagination.hasNextPage) {
            selfWeak.pageIndex++;
            [selfWeak.dataArray addObjectsFromArray:model.data.noicePage.result];
        } else {
            self.showTableView.enableRefreshFooter = YES;
        }
        [selfWeak.showTableView reloadData];
        [selfWeak.showTableView endRefresh];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [selfWeak.showTableView endRefresh];
    }];
    [api start];
}
- (void)refreshTableViewHeader
{
    _pageIndex = 0;
    self.showTableView.enableRefreshFooter = NO;
    [self fetchData];
    [self.showTableView endRefresh];
}

/**
 *  上提刷新完成的回调
 *
 */
- (void)refreshTableViewFooter
{
    [self fetchData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (BaseTableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.tableRefreshDelegate = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.estimatedRowHeight = 60;
        _showTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _showTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFSimpleNoticeTableViewCell *cell = nil;
    if ([UIDevice currentDevice].systemVersion.floatValue < 8)
    {
        //如果您的系统要求最低支持到iOS7那么需要通过-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 来评估高度，因此请不要使用- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath 这个方法来初始化UITableviewCell，否则可能造成系统崩溃！！！
        cell = (UCFSimpleNoticeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"message"];
    }
    else
    {
        //如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClass来注册UITableviewCell，否则可能会返回nil
        cell = (UCFSimpleNoticeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    }
    BOOL isEnd = NO;
    if (self.dataArray.count - 1 == indexPath.row) {
        isEnd = YES;
    }
    [cell setModel:[self.dataArray objectAtIndex:indexPath.row] isEndView:isEnd];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeResult*model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.noviceUrl.length > 0) {
        UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        webView.rootVc = self;
        webView.url = model.noviceUrl;
        webView.navTitle = model.title;
        webView.hidesBottomBarWhenPushed = YES;
        [self.rt_navigationController pushViewController:webView animated:YES];
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
