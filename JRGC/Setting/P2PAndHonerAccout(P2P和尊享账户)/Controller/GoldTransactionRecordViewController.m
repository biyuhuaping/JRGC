//
//  GoldTransactionRecordViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "GoldTransactionRecordViewController.h"
#import "UCFGoldTransCell.h"
#import "UCFGoldTransactionHeadView.h"
#import "UCFGoldTransactionDetailViewController.h"
@interface GoldTransactionRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;

@end

@implementation GoldTransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)initUI
{
    baseTitleLabel.text = @"交易记录";
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    [self addLeftButton];
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * identy = @"headFoot";
    UCFGoldTransactionHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    if (!view) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldTransactionHeadView" owner:self options:nil] lastObject];
    }
    view.backgroundColor = [UIColor redColor];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UCFGoldTransCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFGoldTransCell" owner:self options:nil][0];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFGoldTransactionDetailViewController *vc1 = [[UCFGoldTransactionDetailViewController alloc] initWithNibName:@"UCFGoldTransactionDetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
