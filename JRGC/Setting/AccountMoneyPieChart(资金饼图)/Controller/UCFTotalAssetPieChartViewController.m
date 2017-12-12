//
//  UCFTotalAssetPieChartViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTotalAssetPieChartViewController.h"
#import "UCFCustomPieViewCell.h"
#import "UCFCustomPieChartModel.h"
#import "UCFToolsMehod.h"
#import "UCFAccountAssetsProofViewController.h"
@interface UCFTotalAssetPieChartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalAssetLabel;
- (IBAction)gotoAssetProofVC:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *assetProofBtn;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation UCFTotalAssetPieChartViewController

- (void)viewDidLoad
{
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
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagTotalAssetsOverView owner:self signature:YES Type:SelectAccoutDefault];
}
-(void)beginPost:(kSXTag)tag
{
    
}
-(void)endPost:(id)result tag:(NSNumber *)tag
{
    /*
     accountBalance	账户余额	string
     goldAssets	黄金账户总资产	string
     p2pAssets	微金账户总资产	string
     totalAssets	总资产	string
     uncollectedPAndD	待收本息	string
     zxAssets	尊享账户总资产	string
    */
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = [dic objectSafeForKey:@"ret"];
    NSString *message = [dic objectSafeForKey:@"message"];
    if (tag.intValue == kSXTagTotalAssetsOverView)
    {
        if ([rstcode boolValue]) {
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            NSString * accountBalance = [dataDict objectSafeForKey:@"accountBalance"];
            NSString * goldAssets = [dataDict objectSafeForKey:@"goldAssets"];
            NSString * p2pAssets = [dataDict objectSafeForKey:@"p2pAssets"];
            NSString * totalAssets = [dataDict objectSafeForKey:@"totalAssets"];
            NSString * uncollectedPAndD = [dataDict objectSafeForKey:@"uncollectedPAndD"];
            NSString * zxAssets = [dataDict objectSafeForKey:@"zxAssets"];
            
            if ([totalAssets doubleValue] < 0) {
                totalAssets = [NSString stringWithFormat:@"%.2lf",-[totalAssets doubleValue]];
                 self.totalAssetLabel.text = [NSString stringWithFormat:@"¥-%@",[UCFToolsMehod AddComma:totalAssets]];
            }else{
              self.totalAssetLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:totalAssets]];
            }
            self.assetProofBtn.hidden = [totalAssets doubleValue] <= 0;
            UCFCustomPieChartModel *pieChatModel1 = [[UCFCustomPieChartModel alloc]init];
            pieChatModel1.pieChartTitle = @"按账户类型";
            pieChatModel1.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[p2pAssets,zxAssets,goldAssets]];
//             pieChatModel1.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[@"1000.00",@"5000.00",@"12000.00"]];
            pieChatModel1.pieChartTitleArray = [[NSMutableArray alloc]initWithArray:@[@"微金资产(元)",@"尊享资产(元)",@"黄金资产(元)"]];
            
            UCFCustomPieChartModel *pieChatModel2 = [[UCFCustomPieChartModel alloc]init];
            pieChatModel2.pieChartTitle = @"按金额类型";
            pieChatModel2.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[uncollectedPAndD,accountBalance]];
//             pieChatModel2.pieChartDataArray = [[NSMutableArray alloc]initWithArray:@[@"6000.00",@"12000.00"]];
            pieChatModel2.pieChartTitleArray = [[NSMutableArray alloc]initWithArray:@[@"待收本息(元)",@"账户余额(元)"]];

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

- (IBAction)gotoAssetProofVC:(UIButton *)sender
{
    UCFAccountAssetsProofViewController * assetProofVC = [[UCFAccountAssetsProofViewController alloc]initWithNibName:@"UCFAccountAssetsProofViewController" bundle:nil];
    [self.navigationController pushViewController:assetProofVC animated:YES];
}
@end
