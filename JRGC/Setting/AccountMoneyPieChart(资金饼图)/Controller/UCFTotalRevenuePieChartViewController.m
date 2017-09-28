//
//  UCFTotalRevenuePieChartViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTotalRevenuePieChartViewController.h"
#import "UCFCustomPieViewCell.h"
#import "UCFToolsMehod.h"
@interface UCFTotalRevenuePieChartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalRevenueLabel;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation UCFTotalRevenuePieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getHeaderInfoRequest];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellindifier = @"UCFCustomPieViewCell";
    UCFCustomPieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFCustomPieViewCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row <  self.dataArray.count)
    {
        UCFCustomPieChartModel * model = self.dataArray[indexPath.row];
        cell.pieChartModel = model;
    }
    return cell;
    
}
- (void)getHeaderInfoRequest
{
    
    NSDictionary *dataDict = @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagTotalEarningsOverview owner:self signature:YES Type:SelectAccoutDefault];
}
-(void)beginPost:(kSXTag)tag
{
    
}
-(void)endPost:(id)result tag:(NSNumber *)tag
{
    /*
     balanceInterest	余额利息	string
     goldEarnings	黄金累计收益	string
     goldProfitAndLoss	黄金累计盈亏	string
     p2pEarnings	微金累计收益	string
     receivedInterest	已收利息	string
     totalEarnings	累计收益	string
     uncollectedInterest	待收利息	string
     usedBean	已用工豆	string
     usedReturnCash	已用返现券	string
     zxEarnings	尊享累计收益	string
     */
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = [dic objectSafeForKey:@"ret"];
    NSString *message = [dic objectSafeForKey:@"message"];
    if (tag.intValue == kSXTagTotalEarningsOverview)
    {
        if ([rstcode boolValue]) {
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            NSString *balanceInterest = [dataDict objectSafeForKey:@"balanceInterest"];
            NSString *goldEarnings = [dataDict objectSafeForKey:@"goldEarnings"];
            NSString *goldProfitAndLoss = [dataDict objectSafeForKey:@"goldProfitAndLoss"];
            NSString *p2pEarnings = [dataDict objectSafeForKey:@"p2pEarnings"];
            NSString *receivedInterest = [dataDict objectSafeForKey:@"receivedInterest"];
            NSString *totalEarnings = [dataDict objectSafeForKey:@"totalEarnings"];
            NSString *uncollectedInterest = [dataDict objectSafeForKey:@"uncollectedInterest"];
            NSString *usedBean = [dataDict objectSafeForKey:@"usedBean"];
            NSString *usedReturnCash = [dataDict objectSafeForKey:@"usedReturnCash"];
            NSString *zxEarnings = [dataDict objectSafeForKey:@"zxEarnings"];
            self.totalRevenueLabel.text =  [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:totalEarnings]];
            UCFCustomPieChartModel *pieChatModel1 = [[UCFCustomPieChartModel alloc]init];
            pieChatModel1.pieChartTitle = @"按账户类型";
            pieChatModel1.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[p2pEarnings,zxEarnings,goldEarnings]];
//            pieChatModel1.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[@"1000.00",@"5000.00",@"30000.00"]];
            pieChatModel1.pieChartTitleArray = [[NSMutableArray alloc]initWithArray:@[@"微金收益",@"尊享收益",@"黄金收益"]];
            
            UCFCustomPieChartModel *pieChatModel2 = [[UCFCustomPieChartModel alloc]init];
            pieChatModel2.pieChartTitle = @"按收益类型";
            pieChatModel2.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[receivedInterest,uncollectedInterest,usedReturnCash,usedBean,balanceInterest,goldProfitAndLoss]];
//            pieChatModel2.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[@"2000.00",@"3000.00",@"4000.00",@"6000.00",@"9000.00", @"3000.00"]];
            pieChatModel2.pieChartTitleArray = [[NSMutableArray alloc]initWithArray:@[@"已收利息",@"待收利息",@"已用返现券",@"已用工豆",@"余额利息", @"黄金余额盈亏"]];
          
           
            self.dataArray = @[pieChatModel1,pieChatModel2];
            
            [self.tableView reloadData];
        }else{
             [AuxiliaryFunc showToastMessage:message withView:self.view];
        }
    }
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
     [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
