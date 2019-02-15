//
//  UCFGoldInvestmentDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldInvestmentDetailViewController.h"
#import "FullWebViewController.h"
#import "UCFGoldInvestDetailCell.h"
#import "UILabel+Misc.h"
#import "UCFGoldDetailViewController.h"
#import "QLHeaderViewController.h"
@interface UCFGoldInvestmentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UCFGoldInvestDetailCellDelegate>
{
    NSString *_contractnameStr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSDictionary *dataDict;
@property (nonatomic,strong)NSArray *dataDetailArray;
@property (nonatomic,strong)NSArray *nmContractListArray;
//@property (strong, nonatomic) NSDictionary *tableView;
@end

@implementation UCFGoldInvestmentDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"已购详情";
    [self getGoldInvestmentDetailDataHTTPRequst];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.nmContractListArray.count == 0 ? 3 : 4;
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
            return self.nmContractListArray.count == 0  ?  self.dataDetailArray.count + 1 : self.nmContractListArray.count;
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
            if (_nmContractListArray.count == 0) {
                if (indexPath.row == 0) {
                    return 64;
                }else{
                    return 27;
                }
            }else{
                    return 44;
            }
  
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
    if (indexPath.section == 0) {
        static NSString *cellId = @"UCFGoldInvestDetailCell";
        UCFGoldInvestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.dataDict = self.dataDict;
        return cell;

    }else if(indexPath.section == 1){
        
        static NSString *cellId = @"UCFGoldInvestDetailSecondCell";
        UCFGoldInvestDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataDict = self.dataDict;
        return cell;
    }else if(indexPath.section == 2  && _nmContractListArray.count > 0){
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
        NSDictionary *dataDict  = [self.nmContractListArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dataDict objectSafeForKey:@"contractName"];
        acessoryLabel.text = @"已签署";
        [self addLineViewColor:UIColorWithRGB(0xd8d8d8) With:cell isTop:YES];
        [self addLineViewColor:UIColorWithRGB(0xd8d8d8) With:cell isTop:NO];
        return cell;
    }
    else if(indexPath.section == 3 || (indexPath.section == 2 && _nmContractListArray.count == 0) )
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
            
            
            if (indexPath.row < self.dataDetailArray.count) {
                cell.lineViewLeft.constant = 15;
                cell.lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
            }else{
                cell.lineViewLeft.constant = 0;
                cell.lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
            }
            return cell;
        }

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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.nmContractListArray.count > 0 && indexPath.section == 2) {
        
        NSDictionary *dataDict  = [self.nmContractListArray objectAtIndex:indexPath.row];
        NSString *prdOrderIdStr = [NSString stringWithFormat:@"%@",[self.dataDict objectSafeForKey:@"orderId"]];
        NSString *contractTypeStr = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"contractType"]];
        _contractnameStr = [dataDict objectSafeForKey:@"contractName"];
//        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",@"1", @"purchaseType",contractTemplateIdStr,@"contractTemplateId",nil];
        
//        [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldContractInfo owner:self signature:YES Type:SelectAccoutTypeGold];
        
        NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdOrderId=%@&contractType=%@&prdType=1",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],prdOrderIdStr,contractTypeStr];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagContractDownLoad owner:self Type:SelectAccoutTypeHoner];//**加载PDF格式合同 和尊享合同 共用一个链接
    }
}
#pragma 去标详情页面
-(void)gotoGoldDetialVC
{
    
    NSString *nmProClaimIdStr = [self.dataDict objectSafeForKey:@"nmPrdClaimId"];
    
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:SingleUserInfo.loginData.userInfo.userId, @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldPrdClaimDetail owner:self signature:YES Type:SelectAccoutDefault];
}
-(void)getGoldInvestmentDetailDataHTTPRequst
{
    
    
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":SingleUserInfo.loginData.userInfo.userId, @"orderId":self.orderId, } tag:kSXTagGetGoldTradeDetail owner:self signature:YES Type:self.accoutType];
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
    //    DDLogDebug(@"新用户开户：%@",data);
    
    BOOL ret = [dic[@"ret"] boolValue];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagGetGoldTradeDetail) {
        if (ret)
        {
            self.dataDict = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
            
            self.dataDetailArray = [self.dataDict objectSafeArrayForKey:@"refunddetail"];
            self.nmContractListArray = [self.dataDict objectSafeArrayForKey:@"nmContractModelList"];
            [self.tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    } else if (tag.integerValue == kSXTagGetGoldPrdClaimDetail){
        
        NSMutableDictionary *dic = [result objectFromJSONString];
       
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
    } else if (tag.intValue == kSXTagGetGoldContractInfo){
        NSDictionary *dataDict = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
        if ( [dic[@"ret"] boolValue])
        {
            NSString *contractContentStr = [dataDict objectSafeForKey:@"contractContent"];
//            NSString *contractTitle = [dataDict objectSafeForKey:@"contractName"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:contractContentStr title:_contractnameStr];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }else if (tag.intValue == kSXTagContractDownLoad) {
        
        QLHeaderViewController *vc = [[QLHeaderViewController alloc] init];
        vc.localFilePath = result;
        [self.navigationController pushViewController:vc animated:YES];
        //        self.localFilePath = result;
        //        QLPreviewController *QLPVC = [[QLPreviewController alloc] init];
        //        QLPVC.delegate = self;
        //        QLPVC.dataSource = self;
        //        QLPVC.title = @"合同";
        //        [self presentViewController:QLPVC animated:YES completion:nil];
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
