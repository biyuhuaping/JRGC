//
//  MoreViewController_V2.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "MoreViewController_V2.h"
#import "MoreViewModel.h"
#import "MoreHeadView.h"
#import "Masonry.h"
#import "NormalCell.h"
#import "UIViewController+Nav.h"
@interface MoreViewController_V2 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView     *showTableView;
@property(nonatomic, strong)MoreHeadView    *headView;
@property(nonatomic, strong)MoreViewModel   *vm;
@end

@implementation MoreViewController_V2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackButton];
    [self setTitleText:@"更多"];
    [self initData];
    [self initLayout];
}
- (void)initData
{
    self.vm = [[MoreViewModel alloc] init];
    self.vm.currentVC = self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.vm getSectionHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    view.backgroundColor = UIColorWithRGB(0xebebee);
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.vm getSectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vm getSectionCount:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellStr";
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NormalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        cell.vm = self.vm;
    }
    cell.indexPath = indexPath;
    [cell layoutMoreView];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.vm cellSelectedClicked:[self.vm getSectionData:indexPath]];
}
- (void)initLayout
{
    self.showTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame))];
    self.showTableView.delegate = self;
    self.showTableView.dataSource = self;
    self.showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showTableView];
    
    self.headView = [MoreHeadView getView];
    _showTableView.tableHeaderView = _headView;
    [_headView blindViewModel:_vm];

    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(220);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [self.showTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top);
        }
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}


@end
