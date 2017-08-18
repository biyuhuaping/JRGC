//
//  UCFGoldCashViewController.m
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashViewController.h"
#import "UCFGoldCashFirstCell.h"
#import "UCFGoldCashSecondCell.h"
#import "UCFGoldCashThirdCell.h"
#import "UCFGoldCashFourthCell.h"
#import "UCFGoldCashButtonCell.h"
#import "UCFGoldCashTipCell.h"
#import "UCFGoldCashModel.h"

@interface UCFGoldCashViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation UCFGoldCashViewController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    
    [self.tableview setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.tableview addGestureRecognizer:tap];
    
    [self initData];
    [self getViewDataFromNet];
}

- (void)tapped:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)getViewDataFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId" : userId} tag:kSXTagGoldChangeCashInfo owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.integerValue == kSXTagGoldIncrease) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            //            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
            //            if ([self.tableview.header isRefreshing]) {
            //                [self.dataArray removeAllObjects];
            //            }
            //            for (NSDictionary *temp in resut) {
            //                UCFGoldRechargeHistoryModel *goldhistory = [UCFGoldRechargeHistoryModel goldRechargeHistoryModelWithDict:temp];
            //                [self.dataArray addObject:goldhistory];
            //            }
            //            BOOL hasNextPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            //            if (hasNextPage) {
            //                self.currentPage ++;
            //                self.tableview.footer.hidden = YES;
            //                [self.tableview.footer resetNoMoreData];
            //                self.dataArray = [self arrayGroupWithArray:self.dataArray];
            //            }
            //            else {
            //                if (self.dataArray.count > 0) {
            //                    [self.tableview.footer noticeNoMoreData];
            //                }
            //                else
            //                    self.tableview.footer.hidden = YES;
            //                self.dataArray = [self arrayGroupWithArray:self.dataArray];
            //            }
            //            if (!self.dataArray.count) {
            //                [self.noDataView showInView:self.tableview];
            //            }
            //            else {
            //                [self.noDataView hide];
            //            }
            [self.tableview reloadData];
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
        }
        if ([self.tableview.header isRefreshing]) {
            [self.tableview.header endRefreshing];
        }
        if ([self.tableview.footer isRefreshing]) {
            [self.tableview.footer endRefreshing];
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

- (void)initData {
    NSArray *tipsArray = [[NSArray alloc] initWithObjects:@"黄金价格实时波动，在0.50元的波动范围内成交，成交瞬间系统价格不低于276.50/克则立即为你变现", @"温馨提示:", @"每日可变现上限1,000.000克", @"工作日14:00前变现，当日24:00前到账；14:00后变现，T+1日24:00前到账", nil];
    [self.dataArray removeAllObjects];
    for (NSString *str in tipsArray) {
        UCFGoldCashModel *model = [[UCFGoldCashModel alloc] init];
        if (str == [tipsArray firstObject]) {
            model.tipString = str;
            model.isShowBlackDot = NO;
            CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
            model.cellHeight = size.height;
        }
        else if ([str isEqualToString:@"温馨提示:"]) {
            model.tipString = str;
            model.isShowBlackDot = NO;
            CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
            model.cellHeight = size.height+5;
        }
        else {
            model.tipString = str;
            model.isShowBlackDot = YES;
            CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
            model.cellHeight = size.height+5;
        }
        [self.dataArray addObject:model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }
    else if (section == 4) {
        return self.dataArray.count -1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 10;
    }
    else if (section == 2) {
        return 15;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 10;
    }
    else if (section == 3) {
        return 28;
    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldcashfirst";
    if (indexPath.section == 0) {
        UCFGoldCashFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashFirstCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashFirstCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                cellId = @"goldcashsecond";
                UCFGoldCashSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = (UCFGoldCashSecondCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashSecondCell" owner:self options:nil] lastObject];
                }
                return cell;
            }
                break;
                
            case 1: {
                cellId = @"goldcashthird";
                UCFGoldCashThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = (UCFGoldCashThirdCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashThirdCell" owner:self options:nil] lastObject];
                }
                return cell;
            }
                break;
                
            case 2: {
                cellId = @"goldcashforth";
                UCFGoldCashFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = (UCFGoldCashFourthCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashFourthCell" owner:self options:nil] lastObject];
                }
                return cell;
            }
                break;
        }
        
    }
    else if (indexPath.section == 2) {
        cellId = @"goldcashbutton";
        UCFGoldCashButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashButtonCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashButtonCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 3) {
        cellId = @"goldcashtip";
        UCFGoldCashTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashTipCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashTipCell" owner:self options:nil] lastObject];
        }
        cell.goldCashModel = [self.dataArray firstObject];
        return cell;
    }
    else if (indexPath.section == 4) {
        cellId = @"goldcashtip";
        UCFGoldCashTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashTipCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashTipCell" owner:self options:nil] lastObject];
        }
        cell.goldCashModel = [self.dataArray objectAtIndex:(indexPath.row + 1)];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }
    else if (indexPath.section == 2) {
        return 37;
    }
    else if (indexPath.section == 3)  {
        UCFGoldCashModel *model = [self.dataArray firstObject];
        return model.cellHeight;
    }
    else if (indexPath.section == 4) {
        UCFGoldCashModel *model = [self.dataArray objectAtIndex:(indexPath.row + 1)];
        return model.cellHeight;
    }
    return 44;
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize
{
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect stringRect = [string boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
    stringSize = stringRect.size;
    
    return stringSize;
}

@end
