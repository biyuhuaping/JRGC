//
//  UCFGoldRechargeHistoryController.m
//  JRGC
//
//  Created by njw on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeHistoryController.h"
#import "UCFGoldReCashHisCell.h"

@interface UCFGoldRechargeHistoryController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation UCFGoldRechargeHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
}

#pragma mark - tableview 的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldRechargeAndCash";
    UCFGoldReCashHisCell *hisCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == hisCell) {
        hisCell = (UCFGoldReCashHisCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldReCashHisCell" owner:self options:nil] lastObject];
        hisCell.tableview = tableView;
    }
    hisCell.indexPath = indexPath;
    return hisCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

@end
