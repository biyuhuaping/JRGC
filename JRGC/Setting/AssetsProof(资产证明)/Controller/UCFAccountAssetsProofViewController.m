//
//  UCFAccountAssetsProofViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/30.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFAccountAssetsProofViewController.h"
#import "UCFAssetProofApplyFirstCell.h"
#import "UCFAssetProofApplyViewController.h"
#import "UCFAssetProofListModel.h"
@interface UCFAccountAssetsProofViewController ()<UITableViewDataSource,UITableViewDelegate,UCFAssetProofApplyFirstCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@end

@implementation UCFAccountAssetsProofViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    baseTitleLabel.text = @"资产证明";
    [self addLeftButton];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self assetProofListHttpRequset];
}
#pragma  去资产身份申请页面
- (void)gotoAssetProofApplyVC
{
    UCFAssetProofApplyViewController * assetProofApplyVC = [[UCFAssetProofApplyViewController alloc]initWithNibName:@"UCFAssetProofApplyViewController" bundle:nil];
    assetProofApplyVC.assetProofApplyStep = 1;
    [self.navigationController pushViewController:assetProofApplyVC animated:YES];
    
}
#pragma 查看资产证明模板页面
- (void)seeAssetProofModel
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return  348;
    }
    return 75;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSString *cellindifier = @"UCFAssetProofApplyFirstCell";
        UCFAssetProofApplyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFAssetProofApplyFirstCell" owner:nil options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSString *cellindifier = @"UCFAssetProofApplyFirstCell";
        UCFAssetProofApplySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFAssetProofApplyFirstCell" owner:nil options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row < _dataArray.count)
        {
            cell.assetProofModel = _dataArray[indexPath.row];
        }
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(void)assetProofListHttpRequset
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    NSDictionary *dic = @{@"userId":userId,
                          @"page":@"1",
                          @"pageSize":@"20"
                          };
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagAssetProofList owner:self signature:YES Type:self.accoutType];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    //       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagAssetProofList) {
        if ([ret boolValue])
        {
            
            NSDictionary *dataDic  = [dic objectSafeDictionaryForKey:@"data"];
            NSArray *resultListArr = [[dataDic objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            BOOL hasNextP = [[[[dataDic objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"hasNextPage"] boolValue];
            for (NSDictionary *data in resultListArr)
            {
                UCFAssetProofListModel *listModel = [UCFAssetProofListModel assetProofListModelWithDict:data];
                [_dataArray addObject:listModel];
            }
            
            [self.tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [AuxiliaryFunc showToastMessage:err.userInfo[@"NSLocalizedDescription"] withView:self.view];
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
