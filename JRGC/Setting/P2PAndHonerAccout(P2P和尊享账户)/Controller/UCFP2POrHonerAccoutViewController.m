//
//  UCFP2POrHonerAccoutViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFP2POrHonerAccoutViewController.h"
#import "UCFP2POrHornerTabHeaderView.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingGroup.h"
#import "UCFBankCardInfoViewController.h"
#import "TradePasswordVC.h"
#import "RiskAssessmentViewController.h"
#import "Common.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFAccountDetailViewController.h"
#import "MyViewController.h"
#import "UCFBackMoneyDetailViewController.h"
#import "UCFCashViewController.h"
#import "ToolSingleTon.h"
#import "UCFTopUpViewController.h"
#import "UCFHuiShangBankViewController.h"
#import "UCFHuiBuinessDetailViewController.h"
@interface UCFP2POrHonerAccoutViewController ()<UITableViewDelegate,UITableViewDataSource,UCFP2POrHornerTabHeaderViewDelete>
{
    UCFP2POrHornerTabHeaderView *_headerView;
    BOOL _isShowOrHideAccoutMoney;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *cellItemsData;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (strong, nonatomic) NSString *isCompanyAgent;//是否是机构用户
- (IBAction)clickCashBtn:(UIButton *)sender;
- (IBAction)clickRechargeBtn:(UIButton *)sender;

@end

@implementation UCFP2POrHonerAccoutViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self addLeftButton];
    [self createUIInfoView];//初始化UI
}
-(void)removeLoadingView
{
    for (UIView *view in self.loadingView.subviews) {
        [view removeFromSuperview];
    }
    [self.loadingView removeFromSuperview];
    [self addRightButton];
}
-(void)createUIInfoView{
 
    if (self.accoutType ==  SelectAccoutTypeHoner) {
        [self.view bringSubviewToFront:self.loadingView];
        [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:3];
        baseTitleLabel.text = @"尊享账户";
         _isShowOrHideAccoutMoney = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowHonerAccoutMoney"];
    }else{
        self.loadingView.hidden = YES;
        [self.view sendSubviewToBack:self.loadingView];
        [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.0];
        baseTitleLabel.text = @"P2P账户";
        _isShowOrHideAccoutMoney = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowP2PAccoutMoney"];
    }
    //添加阴影图片
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    self.shadowImageView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    self.tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableView.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0);
}
-(void)addRightButton{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 65, 35);
    [rightbutton setTitle:@"查看流水" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -点击查看流水页面
-(void)rightClicked
{
    UCFHuiBuinessDetailViewController *buinessDetail = [[UCFHuiBuinessDetailViewController alloc] initWithNibName:@"UCFHuiBuinessDetailViewController" bundle:nil];
    buinessDetail.title = @"徽商资金流水";
    buinessDetail.accoutType = self.accoutType;
    [self.navigationController pushViewController:buinessDetail animated:YES];
}


#pragma mark -
#pragma mark 懒加载
// 初始化选项数组
- (NSMutableArray *)cellItemsData
{
    if (_cellItemsData == nil) {
        
        UCFSettingItem *myInVest = [UCFSettingArrowItem itemWithIcon:nil title:@"我的投资" destVcClass:nil];
        UCFSettingItem *backMoneyDetail = [UCFSettingArrowItem itemWithIcon:nil title:@"回款明细" destVcClass:nil];
        UCFSettingItem *p2pOrHonerAccout = nil;

        if (self.accoutType == SelectAccoutTypeHoner) {
            p2pOrHonerAccout = [UCFSettingArrowItem itemWithIcon:nil title:@"尊享徽商银行存管账户" destVcClass:nil];
        }else{
            p2pOrHonerAccout = [UCFSettingArrowItem itemWithIcon:nil title:@"P2P徽商银行存管账户" destVcClass:nil];
        }
        UCFSettingItem *bundleCard = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_bankcard" title:@"修改银行卡" destVcClass:[UCFBankCardInfoViewController class]];
        
        UCFSettingItem *setChangePassword = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_transaction" title:@"修改交易密码" destVcClass:[TradePasswordVC class]];
        
        UCFSettingItem *riskAssessment = nil;
        if (self.accoutType == SelectAccoutTypeHoner) {
            riskAssessment= [UCFSettingArrowItem itemWithIcon:nil title:@"尊享风险承担能力" destVcClass:[RiskAssessmentViewController class]];
        }else{
            riskAssessment = [UCFSettingArrowItem itemWithIcon:nil title:@"P2P风险承担能力" destVcClass:[RiskAssessmentViewController class]];
        }
        UCFSettingItem *batchInvest = [UCFSettingArrowItem itemWithIcon:nil title:@"自动投标" destVcClass:[UCFBatchInvestmentViewController class]];
        
        
        UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];//用户信息
        group1.items = [[NSMutableArray alloc]initWithArray: @[myInVest,backMoneyDetail ]];
        
        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];//账户安全
        
        if (self.accoutType == SelectAccoutTypeHoner) {
            group2.items = [[NSMutableArray alloc]initWithArray:@[p2pOrHonerAccout, bundleCard ,setChangePassword,riskAssessment]];
        }else{
            group2.items = [[NSMutableArray alloc]initWithArray:@[p2pOrHonerAccout, bundleCard ,setChangePassword,riskAssessment,batchInvest]];
        }
        _cellItemsData = [[NSMutableArray alloc] initWithObjects:group1,group2,nil];
    }
    return _cellItemsData;
}
#pragma mark -
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 155;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"UCFP2POrHornerTabHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 155);
        _headerView.delegate = self;
        _headerView.accoutTpye = self.accoutType;
        _headerView.isShowOrHideAccoutMoney = _isShowOrHideAccoutMoney;
        if(self.accoutType == SelectAccoutTypeHoner){
            _headerView.totalIncomeTitleLab.text = @"尊享总资产";
        }else{
            _headerView.totalIncomeTitleLab.text = @"P2P总资产";
        }
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_headerView isTop:NO];
        return _headerView;
    }else{
        UIView *headerView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, 10)];
        headerView.backgroundColor = [UIColor clearColor];
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:headerView isTop:NO];
        return headerView;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, 0.5)];
    footView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    return footView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.cellItemsData.count > 0) {
        return self.cellItemsData.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.cellItemsData.count > 0) {
        UCFSettingGroup* obj = self.cellItemsData[section];
            return [obj.items count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.textLabel.textColor =  UIColorWithRGB(0x5555555);
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.detailTextLabel.textColor =  UIColorWithRGB(0x999999);
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UCFSettingGroup * group = self.cellItemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    UCFSettingGroup * group = self.cellItemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    
    NSString *titleStr = item.title;
    
    if ([titleStr isEqualToString:@"我的投资"]) {
        MyViewController *myInvestVC = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
        myInvestVC.title = @"我的投资";
        myInvestVC.selectedSegmentIndex = 0;
        myInvestVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:myInvestVC animated:YES];
    }
    else if ([titleStr isEqualToString:@"回款明细"]) {
        UCFBackMoneyDetailViewController *backMoneyDetailVC = [[UCFBackMoneyDetailViewController alloc] initWithNibName:@"UCFBackMoneyDetailViewController" bundle:nil];
//        backMoneyDetailVC.superViewController = self;
        backMoneyDetailVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:backMoneyDetailVC animated:YES];
    }
    else if([titleStr hasSuffix:@"徽商银行存管账户"]){//
        UCFHuiShangBankViewController *huiShangBankVC = [[UCFHuiShangBankViewController alloc] initWithNibName:@"UCFHuiShangBankViewController" bundle:nil];
        //        subVC.title = @"徽商存管账户";
        huiShangBankVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:huiShangBankVC animated:YES];
    }
    else if([titleStr isEqualToString:@"修改银行卡"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
         UCFBankCardInfoViewController *bankCardInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"bankcardinfo"];
         bankCardInfoVC.accoutType = self.accoutType;
         [self.navigationController pushViewController:bankCardInfoVC animated:YES];
    }
    else if([titleStr hasSuffix:@"交易密码"]){
         NSInteger openStatus = [UserInfoSingle sharedManager].openStatus;
        if(openStatus < 3){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 10005;
            [alert show];
        }else if(openStatus == 3){//设置交易密码
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //修改交易密码
            TradePasswordVC * tradePasswordVC = [[TradePasswordVC alloc]initWithNibName:@"TradePasswordVC" bundle:nil];
            tradePasswordVC.title = titleStr;
            tradePasswordVC.isCompanyAgent = [self.isCompanyAgent boolValue];
            tradePasswordVC.site = [NSString stringWithFormat:@"%d",self.accoutType];
            [self.navigationController pushViewController:tradePasswordVC  animated:YES];
        }
    }
    else if([titleStr hasSuffix:@"风险承担能力"]){
      RiskAssessmentViewController *riskAssessmentVC = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
        riskAssessmentVC.title = titleStr;
        riskAssessmentVC.url = GRADELURL;
        riskAssessmentVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:riskAssessmentVC  animated:YES];
    }
    else if([titleStr isEqualToString:@"自动投标"]){
        if ([self checkHSIsLegitimate]) {
            UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
            batchInvestment.sourceType = @"personCenter";
            batchInvestment.isStep = [item.subtitle isEqualToString:@"未开启"] ? 1 : 2;
            batchInvestment.accoutType = self.accoutType;
            [self.navigationController pushViewController:batchInvestment animated:YES];
        }
    }
}
- (BOOL) checkHSIsLegitimate {
    NSInteger openStatus = [UserInfoSingle sharedManager].openStatus;
    if(openStatus < 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10005;
        [alert show];
        return NO;
    }else if(openStatus == 3){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10003;
        [alert show];
        return NO;
    }else{
        return YES;
    }
    
}
//-(void)is {
//    [urlStr rangeOfString:@"toReturnMoneyList.shtml"].location != NSNotFound
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark  UCFP2POrHornerTabHeaderViewDelete代理
//查看P2P或者尊享账户
- (void)checkP2POrHonerAccout
{
    UCFAccountDetailViewController *accountDetailVC = [[UCFAccountDetailViewController alloc] initWithNibName:@"UCFAccountDetailViewController" bundle:nil];
    accountDetailVC.accoutType = self.accoutType;
    [self.navigationController pushViewController:accountDetailVC animated:YES];
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
#pragma mark -
#pragma mark 提现点击事件
- (IBAction)clickCashBtn:(UIButton *)sender {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userSatues = [NSString stringWithFormat:@"%ld",(long)[UserInfoSingle sharedManager].openStatus];
    NSDictionary *parametersDict = @{};
      parametersDict = @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userSatues":userSatues};
    [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:self.accoutType];
}
#pragma mark 充值点击事件
- (IBAction)clickRechargeBtn:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
    UCFTopUpViewController * rechargeVC = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
    rechargeVC.title = @"充值";
    rechargeVC.uperViewController = self;
    rechargeVC.accoutType = self.accoutType;
    [self.navigationController pushViewController:rechargeVC animated:YES];

}
#pragma mark -
#pragma mark  网络请求
-(void)getP2POrHonerAccoutHttpRequest{
    
    
    
}
#pragma mark - 网络请求结果
-(void)beginPost:(kSXTag)tag{
    
}


-(void)endPost:(id)result tag:(NSNumber *)tag{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    DBLOG(@"UCFSettingViewController : %@",dic);
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    int isSucess = [rstcode intValue];
    
    switch (tag.integerValue) {
        case kSXTagCashAdvance://提现请求
        {
            rstcode = dic[@"ret"];
            rsttext = dic[@"message"];
            isSucess = [rstcode intValue];
            if (isSucess == 1) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TopUpAndCash" bundle:nil];
                UCFCashViewController *crachViewController  = [storyboard instantiateViewControllerWithIdentifier:@"cash"];
                [ToolSingleTon sharedManager].apptzticket = dic[@"apptzticket"];
                crachViewController.title = @"提现";
//                crachViewController.isCompanyAgent = _isCompanyAgent;
                crachViewController.cashInfoDic = dic;
                crachViewController.accoutType = self.accoutType;
                [self.navigationController pushViewController:crachViewController animated:YES];
                return;
            } else {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }

        }
            break;
//        case kSXTagCashAdvance://提现请求
//        {
//            rstcode = dic[@"ret"];
//            rsttext = dic[@"message"];
//            isSucess = [rstcode intValue];
//            if (isSucess == 1) {
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TopUpAndCash" bundle:nil];
//                UCFCashViewController *crachViewController  = [storyboard instantiateViewControllerWithIdentifier:@"cash"];
//                [ToolSingleTon sharedManager].apptzticket = dic[@"apptzticket"];
//                crachViewController.title = @"提现";
//                crachViewController.isCompanyAgent = _isCompanyAgent;
//                crachViewController.cashInfoDic = dic;
//                [self.navigationController pushViewController:crachViewController animated:YES];
//                return;
//            } else {
//                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//            }
//            
//        }
//            break;
            
        default:
            break;
    }
    
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (self.tableView.header.isRefreshing){
        [self.tableView.header endRefreshing];
    }
}
@end
