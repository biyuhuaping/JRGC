//
//  UCFGoldRaiseViewController.m
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRaiseViewController.h"
#import "UCFGoldRaiseView.h"
#import "UCFGoldRaiseSectionHeaderView.h"
#import "UCFGoldRaiseTransDetailController.h"

@interface UCFGoldRaiseViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation UCFGoldRaiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self createUI];
}

- (void)createUI {
    UCFGoldRaiseView *view = (UCFGoldRaiseView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRaiseView" owner:self options:nil] lastObject];
    CGFloat height = [UCFGoldRaiseView viewHeight];
    view.frame = CGRectMake(0, 0, ScreenWidth, height);
    self.tableview.tableHeaderView = view;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 88, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:@"交易详情" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clickRightBtn {
    UCFGoldRaiseTransDetailController *transDetail = [[UCFGoldRaiseTransDetailController alloc] initWithNibName:@"UCFGoldRaiseTransDetailController" bundle:nil];
    transDetail.baseTitleText = @"交易详情";
    [self.navigationController pushViewController:transDetail animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerId = @"goldraisesectionheader";
    UCFGoldRaiseSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (nil == header) {
        header = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRaiseSectionHeaderView" owner:self options:nil] lastObject];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
