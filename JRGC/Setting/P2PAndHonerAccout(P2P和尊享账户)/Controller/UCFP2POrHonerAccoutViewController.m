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
#import "UILabel+Misc.h"
#import "HSHelper.h"
@interface UCFP2POrHonerAccoutViewController ()<UITableViewDelegate,UITableViewDataSource,UCFP2POrHornerTabHeaderViewDelete,UIAlertViewDelegate>
{
    UCFP2POrHornerTabHeaderView *_headerView;
    BOOL _isShowOrHideAccoutMoney;
    NSDictionary *_dataDict;
    int _openState;
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
    
    [self createUIInfoView];//初始化UI
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getP2POrHonerAccoutHttpRequest) name:RELOADP2PORHONERACCOTDATA object:nil];
}
-(void)removeLoadingView
{
    for (UIView *view in self.loadingView.subviews) {
        [view removeFromSuperview];
    }
    [self.loadingView removeFromSuperview];
    [self addRightButton];
    [self.tableView.header beginRefreshing];
}
-(void)createUIInfoView{
 
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getP2POrHonerAccoutHttpRequest)];
    if (self.accoutType ==  SelectAccoutTypeHoner) {
        [self.view bringSubviewToFront:self.loadingView];
        [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:3];
        baseTitleLabel.text = @"尊享账户";
         _isShowOrHideAccoutMoney = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowHonerAccoutMoney"];
     
    }else{
        [self addLeftButton];
        self.loadingView.hidden = YES;
        [self.view sendSubviewToBack:self.loadingView];
        [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.0];
        baseTitleLabel.text = @"P2P账户";
        _isShowOrHideAccoutMoney = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowP2PAccoutMoney"];
        [self.tableView.header beginRefreshing];
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
        
        UCFSettingItem *myInVest = [UCFSettingArrowItem itemWithIcon:nil title:@"我的投资" destVcClass:[MyViewController class]];
        UCFSettingItem *backMoneyDetail = [UCFSettingArrowItem itemWithIcon:nil title:@"回款明细" destVcClass:[MyViewController class]];
        UCFSettingItem *bundleCard = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_bankcard" title:@"修改银行卡" destVcClass:[UCFBankCardInfoViewController class]];
        
        UCFSettingItem *setChangePassword = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_transaction" title:@"修改交易密码" destVcClass:[TradePasswordVC class]];
        
        UCFSettingItem *p2pOrHonerAccout = nil;
        UCFSettingItem *riskAssessment = nil;
        if (self.accoutType == SelectAccoutTypeHoner) {
              p2pOrHonerAccout = [UCFSettingArrowItem itemWithIcon:nil title:@"尊享徽商银行存管账户" destVcClass:nil];
              riskAssessment= [UCFSettingArrowItem itemWithIcon:nil title:@"尊享风险承担能力" destVcClass:[RiskAssessmentViewController class]];
        }else{
            if ([UserInfoSingle sharedManager].openStatus == 4) {
                setChangePassword.title = @"修改交易密码";
            }else{
                setChangePassword.title = @"设置交易密码";
            }
            p2pOrHonerAccout = [UCFSettingArrowItem itemWithIcon:nil title:@"P2P徽商银行存管账户" destVcClass:nil];
            riskAssessment = [UCFSettingArrowItem itemWithIcon:nil title:@"P2P风险承担能力" destVcClass:[RiskAssessmentViewController class]];
        }
        UCFSettingItem *batchInvest = [UCFSettingArrowItem itemWithIcon:nil title:@"自动投标" destVcClass:[UCFBatchInvestmentViewController class]];
        
        
        UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];//第一栏
        group1.items = [[NSMutableArray alloc]initWithArray: @[myInVest,backMoneyDetail]];
        
        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];//第二栏
        
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
        _headerView.dataDict = _dataDict;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID"];
        cell.textLabel.textColor =  UIColorWithRGB(0x5555555);
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.detailTextLabel.textColor =  UIColorWithRGB(0x999999);
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UCFSettingGroup * group = self.cellItemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text =item.subtitle;
    if ([cell.textLabel.text rangeOfString:@"(开启后才可进行批量投资)"].location != NSNotFound ) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:13] string:@"(开启后才可进行批量投资)"];
        [cell.textLabel setFontColor:UIColorWithRGB(0x999999) string:@"(开启后才可进行批量投资)"];
    }
    
    DLog(@"item.subtitle----?>>>>%@", item.subtitle);
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
    UCFSettingArrowItem *item = group.items[indexPath.row];
    
    NSString *titleStr = item.title;
//    && [NSStringFromClass(item.destVcClass) isEqualToString:@"MyViewController"]
    if ([titleStr isEqualToString:@"我的投资"]  ) {
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
        
        if([self checkIDAAndBankBlindState:self.accoutType]){
            //修改交易密码
            TradePasswordVC * tradePasswordVC = [[TradePasswordVC alloc]initWithNibName:@"TradePasswordVC" bundle:nil];
            tradePasswordVC.title = titleStr;
            tradePasswordVC.isCompanyAgent = [self.isCompanyAgent boolValue];
            tradePasswordVC.site = [NSString stringWithFormat:@"%d",self.accoutType];
            tradePasswordVC.accoutType = self.accoutType;
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
    else if([titleStr hasPrefix:@"自动投标"]){
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

#pragma mark - 无奈的代码
- (BOOL)checkIDAAndBankBlindState:(SelectAccoutType)type
{
 
    __weak typeof(self) weakSelf = self;
    if (_openState == 1 || _openState == 2) {
        NSString *message =  @"请先设置交易密码";
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonTitle:@"确定" clickButton:^(NSInteger index){
            if (index == 0) {
                HSHelper *helper = [HSHelper new];
                [helper pushOpenHSType:type Step:3 nav:weakSelf.navigationController];
            }
        } otherButtonTitles:@"取消"];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark 提现点击事件
- (IBAction)clickCashBtn:(UIButton *)sender {
    
    if (self.accoutType == SelectAccoutTypeHoner) { //尊享账户
        if(_openState < 3)//未设置交易密码
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1010;
            [alert show];
            return ;
        }
    }else {
        
        
    }
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1010) {
        UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
        vc.accoutType = self.accoutType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -
#pragma mark  网络请求
-(void)getP2POrHonerAccoutHttpRequest{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    if(userId){
       [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagUserAccountInfo owner:self signature:YES Type:self.accoutType];
    }
}
#pragma mark - 网络请求结果
-(void)beginPost:(kSXTag)tag{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


-(void)endPost:(id)result tag:(NSNumber *)tag{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    DBLOG(@"UCFP2POrHonerAccoutViewController : %@",dic);
    BOOL ret = [[dic objectSafeForKey:@"ret"] boolValue];
    NSString *rsttext =  [dic objectSafeForKey:@"message"];
    switch (tag.integerValue) {
        case kSXTagCashAdvance://提现请求
        {
            if (ret) {
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
        case kSXTagUserAccountInfo://账户信息请求
        {
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            if (ret)
            {
                _dataDict = dataDict;
                _openState = [[dataDict objectSafeForKey:@"openState"] intValue];
                _headerView.availableAmountLab.text = [NSString stringWithFormat:@"¥%@",[dataDict objectSafeForKey:@"cashBalance"]];//可用金额
                _headerView.accumulatedIncomeLab.text= [NSString stringWithFormat:@"¥%@",[dataDict objectSafeForKey:@"interests"]];//累计收益
                _headerView.totalIncomeLab.text= [NSString stringWithFormat:@"¥%@",[dataDict objectSafeForKey:@"total"]];//总收益
                NSString *bankCardNum = [dataDict objectSafeForKey:@"bankCardNum"];
                NSString *batchMaximum = [dataDict objectSafeForKey:@"batchMaximum"];
                NSString *prdOrderCount = [dataDict objectSafeForKey:@"prdOrderCount"];
                NSString *prdOrderCountStr = [NSString stringWithFormat:@"%@笔",[dataDict objectSafeForKey:@"prdOrderCount"] ];
                prdOrderCountStr = [prdOrderCount intValue] == 0 ? @"":prdOrderCountStr; //我的投
                
                NSString *repayPerDate = [dataDict objectSafeForKey:@"repayPerDate"];
               
                NSString *repayPerDateStr = [NSString stringWithFormat:@"最近回款日%@", repayPerDate];
                repayPerDateStr = [repayPerDate isEqualToString:@""] ? @"": repayPerDateStr; //回款日期
                NSString *riskLevel = [dataDict objectSafeForKey:@"riskLevel"];
                
                for (UCFSettingGroup *group in self.cellItemsData) {
                    NSInteger section =  [self.cellItemsData indexOfObject:group];
                    for (UCFSettingItem *item in group.items) {
                        NSInteger row = [group.items indexOfObject:item];
                        switch (section) {
                            case 0:
                            {
                                switch (row) {
                                    case 0:
                                        item.subtitle = prdOrderCountStr;
                                        break;
                                    case 1:
                                        item.subtitle = repayPerDateStr;
                                        break;
                                    default:
                                        break;
                                }
                            }
                                break;
                            case 1:
                            {
                                switch (row) {
                                    case 0:
                                        item.subtitle = @"";
                                        break;
                                    case 1:
                                        item.subtitle = [bankCardNum isEqualToString:@""] ? @"" : bankCardNum;
                                        break;
                                    case 2:
                                        item.subtitle = @"";
                                        break;
                                    case 3:
                                        item.subtitle = riskLevel;
                                        break;
                                    case 4:
                                    {
                                         item.subtitle = batchMaximum.length == 0 ? @"未开启" : batchMaximum;
                                         item.title = batchMaximum.length == 0 ? @"自动投标(开启后才可进行批量投资)" : @"自动投标";
                                    }
                                        break;
                                    default:
                                        break;
                                }
                            }
                            default:
                                break;
                        }
                       
                    }
                }
                [self.tableView reloadData];
            } else {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    if (self.tableView.header.isRefreshing){
        [self.tableView.header endRefreshing];
    }
    
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (self.tableView.header.isRefreshing){
        [self.tableView.header endRefreshing];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
