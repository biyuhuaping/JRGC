//
//  UCFNewProjectDetailViewController.m
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewProjectDetailViewController.h"
#import "UCFBidDetailNavView.h"
#import "UVFBidDetailViewModel.h"
#import "UCFNewBidDetaiInfoView.h"
#import "UCFRemindFlowView.h"
#import "MinuteCountDownView.h"
@interface UCFNewProjectDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)BaseTableView *showTableView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)UCFNewBidDetaiInfoView *bidinfoView;
@property(nonatomic, strong)UCFRemindFlowView *remind;
@property(nonatomic, strong)UCFBidDetailNavView *navView;
@property(nonatomic, strong)UVFBidDetailViewModel *VM;

@property(nonatomic, strong)MyLinearLayout *contentLayout;
@property(nonatomic, strong)MinuteCountDownView *minuteCountDownView;
@end

@implementation UCFNewProjectDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)loadView
{
    [super loadView];
    
    UCFBidDetailNavView *navView = [[UCFBidDetailNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight1)];
    self.navView = navView;
    [self.rootLayout addSubview:navView];
    

    self.showTableView.topPos.equalTo(self.navView.bottomPos);
    self.showTableView.bottomPos.equalTo(@57);
    self.showTableView.myHorzMargin = 0;
//    self.showTableView.backgroundColor = [UIColor redColor];
    [self.rootLayout addSubview:self.showTableView];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    contentLayout.myHorzMargin = 0;                       //同时指定左右边距为0表示宽度和父视图一样宽
    self.contentLayout = contentLayout;
    [self.rootLayout addSubview:contentLayout];
    
//    [contentLayout setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
//
//    }];
//    @PGWeakObj(self);
//    [self.contentLayout setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
//        selfWeak.showTableView.tableHeaderView = v;
//    }];
    
    UCFNewBidDetaiInfoView *bidinfoView = [[UCFNewBidDetaiInfoView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight1, ScreenWidth, 155)];
    self.bidinfoView = bidinfoView;
    [self.contentLayout addSubview:bidinfoView];
    
    
    UCFRemindFlowView *remind = [UCFRemindFlowView new];
    remind.myTop = 0;
    remind.myHorzMargin = 0;
    remind.heightSize.equalTo(@45);
    remind.backgroundColor = UIColorWithRGB(0xebebee);
    remind.subviewVSpace = 5;
    remind.subviewHSpace = 5;
    [self.contentLayout addSubview:remind];
    self.remind = remind;

    //是P2p 并且不是
//    if(_isP2P && _type != PROJECTDETAILTYPEBONDSRRANSFER){
    _minuteCountDownView = [[[NSBundle mainBundle] loadNibNamed:@"MinuteCountDownView" owner:nil options:nil] firstObject];

    _minuteCountDownView.topPos.equalTo(@0);
    _minuteCountDownView.myHorzMargin = 0;
    _minuteCountDownView.heightSize.equalTo(@45);
    _minuteCountDownView.isStopStatus = @"0";
    [_minuteCountDownView startTimer];
    _minuteCountDownView.sourceVC = @"UCFProjectDetailVC";//投资页面
    [self.contentLayout addSubview:self.minuteCountDownView];
    self.showTableView.tableHeaderView = self.contentLayout;

//    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.showTableView.tableHeaderView = self.contentLayout;
}
//- (void)viewWillAppear:(BOOL)animated
//{
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self blindData];
    
    [self.navView blindVM:self.VM];
    
    [self.bidinfoView blindVM:self.VM];
    
    [self.remind blindVM:self.VM];
    
    [self.minuteCountDownView blindVM:self.VM];
    
}
- (void)blindData
{
    [self.VM blindModel:self.model];

}
- (UVFBidDetailViewModel *)VM
{
    if (!_VM) {
        self.VM = [UVFBidDetailViewModel new];
    }
    return _VM;
}

#pragma mark tableView
- (UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.enableRefreshFooter = NO;
        _showTableView.enableRefreshHeader = NO;
    }
    return _showTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.VM getTableViewData] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSArray *arr = [self.VM getTableViewData];
    NSDictionary *dict = arr[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"value"];
    return cell;
}
- (void)dealloc
{
    
}
@end
