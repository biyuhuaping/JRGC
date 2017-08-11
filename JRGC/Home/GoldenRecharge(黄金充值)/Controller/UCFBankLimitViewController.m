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
#import "UCFGoldLimitedBankModel.h"

@interface UCFBankLimitViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation UCFBankLimitViewController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitleText = @"银行限额";
    [self addLeftButton];
    [self getLimitedBankForNet];
}

- (void)getLimitedBankForNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId": userId} tag:kSXTagGoldLimitedBankList owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableDictionary *dic = [(NSString *)result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagGoldLimitedBankList) {
        if ([rstcode intValue] == 1) {
            NSArray *bankLimitList = [[dic objectSafeDictionaryForKey:@"data"] objectSafeArrayForKey:@"bankLimitList"];
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in bankLimitList) {
                UCFGoldLimitedBankModel *bankModel = [UCFGoldLimitedBankModel getGoldLimitedBankModelByDataDict:dict];
                [self.dataArray addObject:bankModel];
            }
            [self.tableview reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldbanklimitcell";
    UCFGoldBankLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFGoldBankLimitCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldBankLimitCell" owner:self options:nil] lastObject];
    }
    cell.bankModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
@end
