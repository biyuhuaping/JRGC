//
//  UCFTotalAssetPieChartViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTotalAssetPieChartViewController.h"

@interface UCFTotalAssetPieChartViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation UCFTotalAssetPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getHeaderInfoRequest];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellindifier = @"twoSectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        }else{
            
        }
    }
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
    
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
