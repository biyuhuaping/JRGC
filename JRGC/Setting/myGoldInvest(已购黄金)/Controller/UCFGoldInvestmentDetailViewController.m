//
//  UCFGoldInvestmentDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldInvestmentDetailViewController.h"

#import "UCFGoldInvestDetailCell.h"
#import "UILabel+Misc.h"
#import "UCFGoldDetailViewController.h"
@interface UCFGoldInvestmentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UCFGoldInvestDetailCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSDictionary *dataDict;
@property (nonatomic,strong)NSArray *dataDetailArray;
//@property (strong, nonatomic) NSDictionary *tableView;
@end

@implementation UCFGoldInvestmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"已购详情";
    [self getGoldInvestmentDetailDataHTTPRequst];
    self.tableView.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
             return 1;
        }
            break;
        case 1:
        {
             return 1;
        }
            break;
        case 2:
        {
             return 1;
        }
            break;
        case 3:
        {
             return self.dataDetailArray.count + 1;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
     return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 120;
        }
            break;
        case 1:
        {
            return 118;
        }
            break;
        case 2:
        {
            return 44;
        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                return 64;
            }else{
                return 27;
            }
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
   indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellId = @"UCFGoldInvestDetailCell";
            UCFGoldInvestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            cell.dataDict = self.dataDict;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *cellId = @"UCFGoldInvestDetailSecondCell";
            UCFGoldInvestDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] objectAtIndex:1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.dataDict = self.dataDict;
            return cell;
        }
            break;
        case 2:
        {
            NSString *cellindifier = @"thirdSectionCell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = UIColorWithRGB(0x555555);
                UILabel *acessoryLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 100, (cell.contentView.frame.size.height - 12) / 2, 70, 12) text:@"" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
                acessoryLabel.tag = 100;
                acessoryLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:acessoryLabel];
            }
            UILabel *acessoryLabel = (UILabel*)[cell.contentView viewWithTag:100];
//            UCFConstractModel *constract = self.investDetailModel.contractClauses[indexPath.row];
            cell.textLabel.text = @"黄金合同名称（未返回）";
//            switch ([constract.signStatus integerValue]) {
            switch (0) {
                case 0:
                        acessoryLabel.text = @"未签署";
                    break;
                    
                default: acessoryLabel.text = @"已签署";
                    break;
            }
            [self addLineViewColor:UIColorWithRGB(0xd8d8d8) With:cell isTop:YES];
            [self addLineViewColor:UIColorWithRGB(0xd8d8d8) With:cell isTop:NO];
            return cell;

        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                static NSString *cellId = @"UCFGoldInvestDetailFourCell";
                UCFGoldInvestDetailFourCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] objectAtIndex:2];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.paymentType.text = [self.dataDict objectSafeForKey:@"paymentType"];
                return cell;
            }else{
                
                
                static NSString *cellId = @"UCFGoldInvestDetailFiveCell";
                UCFGoldInvestDetailFiveCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
                }
                
                if (indexPath.row -1 < self.dataDetailArray.count)
                {
                    cell.dataDict = [self.dataDetailArray objectAtIndex:indexPath.row - 1];
                }
                return cell;
            }
           
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    return cell;
}
-(void)addLineViewColor:(UIColor *)color With:(UIView *)view isTop:(BOOL)top
{
    CGFloat height = 0.0f;
    if (!top) {
        height = CGRectGetHeight(view.frame);
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = color;
    [view addSubview:lineView];
}
#pragma 去标详情页面
-(void)gotoGoldDetialVC
{
    
    NSString *nmProClaimIdStr = [self.dataDict objectSafeForKey:@"nmPrdClaimId"];
    
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldPrdClaimDetail owner:self signature:YES Type:SelectAccoutDefault];
}
-(void)getGoldInvestmentDetailDataHTTPRequst
{
    
    
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[UserInfoSingle sharedManager].userId, @"orderId":self.orderId, } tag:kSXTagGetGoldTradeDetail owner:self signature:YES Type:self.accoutType];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    //    DBLOG(@"新用户开户：%@",data);
    
    BOOL ret = [dic[@"ret"] boolValue];
    if (tag.intValue == kSXTagGetGoldTradeDetail) {
        if (ret)
        {
            self.dataDict = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
            
            self.dataDetailArray = [self.dataDict objectSafeArrayForKey:@"refunddetail"];
            [self.tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    } else if (tag.integerValue == kSXTagGetGoldPrdClaimDetail){
        
        NSMutableDictionary *dic = [result objectFromJSONString];
        NSString *rsttext = dic[@"message"];
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue]) {
            UCFGoldDetailViewController*goldDetailVC = [[UCFGoldDetailViewController alloc]initWithNibName:@"UCFGoldDetailViewController" bundle:nil];
            goldDetailVC.dataDict = dataDict;
            [self.navigationController pushViewController:goldDetailVC  animated:YES];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }


}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [AuxiliaryFunc showToastMessage:err.userInfo[@"NSLocalizedDescription"] withView:self.view];
    //    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
