//
//  UCFBankLimitViewController.m
//  JRGC
//
//  Created by njw on 2017/8/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBankLimitViewController.h"
#import "UCFGoldBankLimitHeader.h"
#import "UCFGoldBankLimitCell.h"

@interface UCFBankLimitViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation UCFBankLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitleText = @"银行限额";
    [self addLeftButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* viewId = @"goldBankLimitHeader";
    UCFGoldBankLimitHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = (UCFGoldBankLimitHeader *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldBankLimitHeader" owner:self options:nil] lastObject];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldbanklimitcell";
    UCFGoldBankLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFGoldBankLimitCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldBankLimitCell" owner:self options:nil] lastObject];
    }
    
    return cell;
}
@end
