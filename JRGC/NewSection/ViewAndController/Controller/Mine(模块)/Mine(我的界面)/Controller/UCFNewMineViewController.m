//
//  UCFNewMineViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewMineViewController.h"

#import "UCFMineMyReceiptApi.h"
#import "UCFMineMyReceiptModel.h"
#import "UCFMineMySimpleInfoModel.h"
#import "UCFMineMySimpleInfoApi.h"
#import "UCFMineNewSignModel.h"
#import "UCFMineNewSignApi.h"
#import "UCFMineIntoCoinPageModel.h"
#import "UCFMineIntoCoinPageApi.h"

#import "UCFMineTableViewHead.h"
#import "UCFMineActivitiesCell.h"
#import "UCFMineItemCell.h"
#import "UCFMineCellAccountModel.h"
#import "CellConfig.h"

#import "UCFSecurityCenterViewController.h"
#import "UCFRegisterInputPassWordViewController.h"
#import "UCFMineServiceViewController.h"
#import "UCFRechargeAndWithdrawalViewController.h"
#import "UCFMessageCenterViewController.h"
#import "UCFInvitationRebateViewController.h"


#import "UCFLoginViewController.h"
#import "BaseNavigationViewController.h"
#import "UCFP2POrHonerAccoutViewController.h"
#import "UCFMicroBankDepositoryAccountHomeViewController.h"

#import "UCFMicroBankOpenAccountViewController.h"
#import "AccountSuccessVC.h"
#import "UCFNewResetPassWordViewController.h"
#import "UCFCouponViewController.h"

#import "UCFNewAiLoanViewController.h"
#import "UCFRechargeViewController.h"

@interface UCFNewMineViewController ()<UITableViewDelegate, UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UCFMineTableViewHead *tableHead;

@property (nonatomic, strong) NSMutableArray *arryData;

@property (nonatomic, strong) NSMutableArray *cellConfigData;

@end

@implementation UCFNewMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.tableView];
 
    [self loadCellConfig];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (SingleUserInfo.loginData == nil) {
        [SingleUserInfo loadLoginViewController];
//        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
//        BaseNavigationViewController *loginNaviController = [[BaseNavigationViewController alloc] initWithRootViewController:loginViewController];
//        loginViewController.sourceVC = @"homePage";
//        [self presentViewController:loginNaviController animated:YES completion:nil];
    }
    else
    {
        [self requestMyReceipt];
        [self requestMySimpleInfo];
    }
}
- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]init];
        _tableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.tableHead;
        _tableView.tableRefreshDelegate= self;
        _tableView.enableRefreshFooter = NO;
        _tableView.topPos.equalTo(@0);
        _tableView.leftPos.equalTo(@0);
        _tableView.rightPos.equalTo(@0);
        _tableView.bottomPos.equalTo(@0);
        
    }
    return _tableView;
}
- (UCFMineTableViewHead *)tableHead
{
    if (nil == _tableHead) {
        _tableHead = [[UCFMineTableViewHead alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 285)];
        @PGWeakObj(self);
        _tableHead.callBack = ^(UIButton *btn){
            DDLogInfo(@"text is %@",btn);
            [selfWeak headCellButtonClick:btn];
        };
    }
    return _tableHead;
}
#pragma mark ---tableviewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellConfig *cellConfig = self.cellConfigData[indexPath.section][indexPath.row];
    return cellConfig.heightOfCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.cellConfigData objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellConfigData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellConfig *cellConfig = self.cellConfigData[indexPath.section][indexPath.row];
    // 拿到对应cell并根据模型显示
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModel:self.arryData[indexPath.section][indexPath.row] isNib:NO];
    ((BaseTableViewCell *)cell).bc = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellConfig *cellConfig = self.cellConfigData[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        if ([cellConfig.title isEqualToString:@"回款日历"])
        {
            
        }
        else if ([cellConfig.title isEqualToString:@"优质债权"])
        {
            
        }
        else if ([cellConfig.title isEqualToString:@"智能出借"])
        {
            UCFNewAiLoanViewController *vc = [[UCFNewAiLoanViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellConfig.title isEqualToString:@"尊享项目"])
        {
            
        }
        else if ([cellConfig.title isEqualToString:@"持有黄金"])
        {
            
        }
        else if ([cellConfig.title isEqualToString:@"商城订单"])
        {
            
        }
    }
    if (indexPath.section == 2) {
        if ([cellConfig.title isEqualToString:@"服务中心"])
        {
            UCFMineServiceViewController *vc = [[UCFMineServiceViewController alloc] init];
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
        else if ([cellConfig.title isEqualToString:@"客服热线"])
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 10)];
    view.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.01;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;//设置尾视图高度为0.01
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)headCellButtonClick:(UIButton *)btn
{
    if (btn.tag == 10001) {
        //个人账户信息
        UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
        personMessageVC.title = @"基础详情";
        [self.rt_navigationController pushViewController:personMessageVC animated:YES];
    }
    else if (btn.tag == 10002){
        //消息中心
        UCFMessageCenterViewController *messagecenterVC = [[UCFMessageCenterViewController alloc]initWithNibName:@"UCFMessageCenterViewController" bundle:nil];
        messagecenterVC.title =@"消息中心";
        [self.navigationController pushViewController:messagecenterVC animated:YES];
    }
    else if (btn.tag == 10003){
        //是否展示用户资金,关闭都是*****
    }
    else if (btn.tag == 10004){
        //只进入微金的充值
        UCFRechargeViewController *vc = [[UCFRechargeViewController alloc] init];
        vc.accoutType = SelectAccoutTypeP2P;
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 10005){
        //各个账户的充值与提现,尊享、黄金账户已经不允许充值,只能提现
        UCFRechargeAndWithdrawalViewController *vc = [[UCFRechargeAndWithdrawalViewController alloc] init];
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
}

- (void)signInButtonClick:(NSInteger )tag
{
    if (tag == 1001) {
        //每日签到
        
        UCFP2POrHonerAccoutViewController *subVC = [[UCFP2POrHonerAccoutViewController alloc] initWithNibName:@"UCFP2POrHonerAccoutViewController" bundle:nil];
        subVC.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:subVC animated:YES];
        

    }
    else if (tag == 1002){
        //我的工贝
        
        UCFNewResetPassWordViewController *vc= [[UCFNewResetPassWordViewController alloc] init];
                [self.rt_navigationController pushViewController:vc animated:YES];
//        UCFMicroBankOpenAccountViewController *vc= [[UCFMicroBankOpenAccountViewController alloc] init];
//        [self.rt_navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 1003){
        //我的工豆
        AccountSuccessVC *acVC = [[AccountSuccessVC alloc]initWithNibName:@"AccountSuccessVC" bundle:nil];
        //            acVC.site = self.site;
        acVC.accoutType = self.accoutType;
        acVC.fromVC = 2;
        //            acVC.db = self.db;
        //            self.db.isOpenAccount = YES;
        [self.rt_navigationController pushViewController:acVC animated:YES];
        
    }
    else if (tag == 1004){
        //优惠券
        UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        [self.navigationController pushViewController:coupon animated:YES];
    }
    else if (tag == 1005){
        //邀请返利
//        UCFMicroBankDepositoryAccountHomeViewController *ccc = [[UCFMicroBankDepositoryAccountHomeViewController alloc] init];
//        ccc.accoutType = SelectAccoutTypeP2P;
//        [self.rt_navigationController pushViewController:ccc animated:YES];
        
        UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
        feedBackVC.title = @"邀请获利";
        feedBackVC.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }
}
- (void)requestMyReceipt//请求总资产信息
{
    UCFMineMyReceiptApi * request = [[UCFMineMyReceiptApi alloc] init];
    
//    request.animatingView = self.view;
//    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMineMyReceiptModel *model = [request.responseJSONModel copy];
//        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            
           [self setTableViewArrayWithData:model];
        }
        else{
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
    
}
- (void)requestMySimpleInfo//查询用户工豆,工分,等信
{
    UCFMineMySimpleInfoApi * request = [[UCFMineMySimpleInfoApi alloc] init];
    
    //    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMineMySimpleInfoModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            
            [self setTableViewArrayWithData:model];
        }
        else{
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
    
}
- (void)setTableViewArrayWithData:(id)model
{
     @synchronized(self) {

         if ([model isKindOfClass:[UCFMineMyReceiptModel class]]) {

             //查询账户信息
             [self getAccountCellConfig:model];
             //赋值 账户信息
             [self.tableHead showMyReceipt:model];
         }
         if ([model isKindOfClass:[UCFMineMySimpleInfoModel class]]) {
             
             //查询工豆优惠券信息 和未读消息
             //赋值 未读消息
             [self.tableHead showMySimple:model];
             [self.arryData replaceObjectAtIndex:0 withObject:[NSArray arrayWithObjects:model, nil]];
         }
     }

    [self.tableView cyl_reloadData];
}

#pragma mark -   CellConfig
- (void)loadCellConfig
{
    //cellArrayData
    self.arryData = [NSMutableArray array];
    [self.arryData addObject:[NSArray arrayWithObjects:[NSArray array], nil]]; //签到
    [self.arryData addObject:[self getCellAccountArrayData]]; //回款,债权,出借,商城
    [self.arryData addObject:[self getCellAccountCentreArrayData]];//客服,服务中心
    
    
    //cellConfigData
    self.cellConfigData = [NSMutableArray array];
    
    //第一组内容
    
    CellConfig *cellConfigTicket = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineActivitiesCell class]) title:@"签到" showInfoMethod:@selector(showInfo:) heightOfCell:95];
    [self.cellConfigData addObject:[NSArray arrayWithObjects:cellConfigTicket, nil]];
    
    //第二组内容
    [self.cellConfigData addObject:[self loadingAccountCellConfig]];

    //第三组内容
    CellConfig *cellConfigCentre = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"服务中心" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    
    CellConfig *cellConfigService = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"客服热线" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    
    [self.cellConfigData addObject:[NSArray arrayWithObjects:cellConfigCentre,cellConfigService, nil]];
    
    [self.tableView cyl_reloadData];
}

//第二组内容展示,没有展示账户,需要请求
- (NSArray *)loadingAccountCellConfig
{
    CellConfig *cellConfigCalendar = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"回款日历" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    
    CellConfig *cellConfigCreditor = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"优质债权" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    
    CellConfig *cellConfigLend = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"智能出借" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    
    CellConfig *cellConfigMall = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"商城订单" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    
    NSMutableArray *accountArray = [NSMutableArray arrayWithCapacity:10];
    accountArray = [NSMutableArray arrayWithObjects:cellConfigCalendar,cellConfigCreditor,cellConfigLend,cellConfigMall, nil];
    return [accountArray copy];
}
- (NSArray *)getCellAccountArrayData
{
    UCFMineCellAccountModel *cellAccountCalendar = [[UCFMineCellAccountModel alloc]init];//回款日历
    cellAccountCalendar.cellAccountTitle = @"回款日历";
    cellAccountCalendar.cellAccountImage = @"mine_icon_calendar.png";
    
    UCFMineCellAccountModel *cellAccountCreditorr = [[UCFMineCellAccountModel alloc]init];//优质债权
    cellAccountCreditorr.cellAccountTitle = @"优质债权";
    cellAccountCreditorr.cellAccountImage = @"mine_icon_project.png";
    
    UCFMineCellAccountModel *cellAccountLend = [[UCFMineCellAccountModel alloc]init];//智能出借
    cellAccountLend.cellAccountTitle = @"智能出借";
    cellAccountLend.cellAccountImage = @"mine_icon_intelligent.png";
    
    UCFMineCellAccountModel *cellAccountMall = [[UCFMineCellAccountModel alloc]init];//商城订单
    cellAccountMall.cellAccountTitle = @"商城订单";
    cellAccountMall.cellAccountImage = @"mine_icon_shoplist.png";
    return [NSArray arrayWithObjects:cellAccountCalendar,cellAccountCreditorr,cellAccountLend,cellAccountMall, nil];
}


- (NSArray *)getCellAccountCentreArrayData{
    UCFMineCellAccountModel *cellAccountCentre = [[UCFMineCellAccountModel alloc]init];//服务中心
    cellAccountCentre.cellAccountTitle = @"服务中心";
    cellAccountCentre.cellAccountImage = @"mine_icon_service.png";
    
    UCFMineCellAccountModel *cellAccountService = [[UCFMineCellAccountModel alloc]init];//客服热线
    cellAccountService.cellAccountTitle = @"客服热线";
    cellAccountService.cellAccountImage = @"mine_icon_noble.png";
    return [NSArray arrayWithObjects:cellAccountCentre,cellAccountService, nil];
}


//账户是否展示
- (void)getAccountCellConfig:(UCFMineMyReceiptModel  *)model
{
    NSMutableArray  *accountCellConfigArray = [NSMutableArray arrayWithArray:[self loadingAccountCellConfig]];
    NSMutableArray  *accountCellData = [NSMutableArray arrayWithArray:[self getCellAccountArrayData]];
    
    if (model.data.zxAccountIsShow)//尊享账户是否显示
    {
        //尊享账户是否显示
        CellConfig *cellConfigRespect = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"尊享项目" showInfoMethod:@selector(showInfo:) heightOfCell:50];
        [accountCellConfigArray insertObject:cellConfigRespect atIndex:accountCellConfigArray.count -2];
        
        UCFMineCellAccountModel *cellAccountRespect = [[UCFMineCellAccountModel alloc]init];//尊享项目
        cellAccountRespect.cellAccountTitle = @"尊享项目";
        cellAccountRespect.cellAccountImage = @"mine_icon_gold.png";
        [accountCellData insertObject:cellConfigRespect atIndex:accountCellData.count -2];
    }
    if (model.data.nmAccountIsShow) {
        //黄金账户是否显示
        CellConfig *cellConfigGold = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"持有黄金" showInfoMethod:@selector(showInfo:) heightOfCell:50];
        [accountCellConfigArray insertObject:cellConfigGold atIndex:accountCellConfigArray.count -2];
       
        UCFMineCellAccountModel *cellAccountGold = [[UCFMineCellAccountModel alloc]init];//持有黄金
        cellAccountGold.cellAccountTitle = @"持有黄金";
        cellAccountGold.cellAccountImage = @"mine_icon_respect.png";
        [accountCellData insertObject:cellAccountGold atIndex:accountCellData.count -2];
    }
    //新的数据直接替换第二组内容
    [self.cellConfigData replaceObjectAtIndex:1 withObject:[accountCellConfigArray copy]];
    [self.arryData replaceObjectAtIndex:1 withObject:[accountCellData copy]];
}




@end
