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
#import "UCFGetBindingBankCardListApi.h"
#import "UCFMallProductApi.h"
#import "UCFQueryBannerByTypeAPI.h"
#import "UCFQueryBannerByTypeModel.h"

#import "UCFMineTableViewHead.h"
#import "UCFMineActivitiesCell.h"
#import "UCFMineItemCell.h"
#import "UCFMineShopDiscountCell.h"
#import "UCFMineCellAccountModel.h"
#import "CellConfig.h"
#import "NSString+Misc.h"

#import "UCFSecurityCenterViewController.h"
#import "UCFRegisterInputPassWordViewController.h"
#import "UCFMineServiceViewController.h"
#import "UCFRechargeAndWithdrawalViewController.h"
#import "UCFMessageCenterViewController.h"
#import "UCFInvitationRebateViewController.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UCFMyFacBeanViewController.h"
#import "UCFCalendarViewController.h"
#import "UCFCalendarModularViewController.h"
#import "UCFMineShopPromotionCell.h"
#import "UCFMinePromotionCell.h"
#import "UCFAssetAccountViewController.h"

#import "BaseNavigationViewController.h"
#import "UCFP2POrHonerAccoutViewController.h"
#import "UCFMicroBankDepositoryAccountHomeViewController.h"

#import "UCFMicroBankOpenAccountViewController.h"
#import "AccountSuccessVC.h"
#import "UCFNewResetPassWordViewController.h"
#import "UCFCouponViewController.h"
#import "UCFGoldAccountViewController.h"
#import "HSHelper.h"
#import "UCFNewRechargeViewController.h"
#import "UCFRechargeOrCashViewController.h"
#import "UCFNewAiLoanViewController.h"
#import "UCFRechargeViewController.h"
#import "UCFRegisterdSucceedViewController.h"

#import "UCFHighQualityContainerViewController.h"
#import "UCFTelAlertView.h"

@interface UCFNewMineViewController ()<UITableViewDelegate, UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UCFMineTableViewHead *tableHead;

@property (nonatomic, strong) NSMutableArray *arryData;

@property (nonatomic, strong) NSMutableArray *cellConfigData;

@property (nonatomic, assign) BOOL nmAccountIsShow;//黄金账户是否显示

@property (nonatomic, assign) BOOL zxAccountIsShow;//尊享账户是否显示

@property (nonatomic, copy)   NSString *outBoundMess;

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
    [self.tableView beginRefresh];
    [self blindUserStatue];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_tableHead.userMesageLayout addGestureRecognizer:tapGesturRecognizer];
    }
    return _tableHead;
}
#pragma mark - tableviewdelegate

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

            UCFCalendarViewController *backMoneyCalendarVC = [[UCFCalendarViewController alloc] initWithNibName:@"UCFCalendarViewController" bundle:nil];
            [self.navigationController pushViewController:backMoneyCalendarVC animated:YES];
        }
        else if ([cellConfig.title isEqualToString:@"优质债权"])
        {
            UCFHighQualityContainerViewController *vc = [[UCFHighQualityContainerViewController alloc] init];
            vc.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellConfig.title isEqualToString:@"智能出借"])
        {
            UCFNewAiLoanViewController *vc = [[UCFNewAiLoanViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellConfig.title isEqualToString:@"尊享项目"])
        {
            UCFHighQualityContainerViewController *vc = [[UCFHighQualityContainerViewController alloc] init];
            vc.accoutType = SelectAccoutTypeHoner;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([cellConfig.title isEqualToString:@"持有黄金"])
        {
            UCFGoldAccountViewController *subVC = [[UCFGoldAccountViewController alloc] initWithNibName:@"UCFGoldAccountViewController" bundle:nil];
            [self.navigationController pushViewController:subVC animated:YES];
        }
        else if ([cellConfig.title isEqualToString:@"商城订单"])
        {
            UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
            web.url  = [NSString stringWithFormat:@"%@",DougeMallOrderListURL];
            web.isHideNativeNav = NO;
            [self.rt_navigationController pushViewController:web animated:YES];
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
            UCFTelAlertView *view = [[UCFTelAlertView alloc] initWithNotiMessage:self.outBoundMess];
            [view show];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 10)];
    view.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    return view;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 10)];
    view.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 ||section == 2 ) {
        return 10;
    }
    else
    {
        return 0.01;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //设置尾视图高度为0.01
    return 0.001;
}

#pragma mark- 点击事件
- (void)signInButtonClick:(NSInteger )tag
{
    if (tag == 1001) {
        //每日签到
        
        if(SingleUserInfo.loginData.userInfo.isCompanyAgent)//如果是机构用户
        {//吐司：此活动暂时未对企业用户开放
            [MBProgressHUD displayHudError:@"此活动暂时未对企业用户开放"];
        }
        else{
            
            UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
            web.url  = [NSString stringWithFormat:@"%@",@"https://coin.9888keji.com/static/jh/index.html#/task/sign"];
            web.isHideNativeNav = NO;
            web.rootVc = @"UCFSecurityCenterVC";
            [self.rt_navigationController pushViewController:web animated:YES];
        }
    }
    else if (tag == 1002){
        //我的工贝
        [self requestMyCoin:nil];//请求工贝地址
    }
    else if (tag == 1003){
        //我的工豆
        
        UCFMyFacBeanViewController *bean = [[UCFMyFacBeanViewController alloc] initWithNibName:@"UCFMyFacBeanViewController" bundle:nil];
        bean.title = @"我的工豆";
        [self.rt_navigationController pushViewController:bean animated:YES];
    }
    else if (tag == 1004){
        //优惠券
        UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        [self.navigationController pushViewController:coupon animated:YES];
    }
    else if (tag == 1005){
        //邀请返利
        UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
        feedBackVC.title = @"邀请获利";
        feedBackVC.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }
}

-(void)layoutClick:(UIGestureRecognizer *)sender
{
    UCFAssetAccountViewController *vc = [[UCFAssetAccountViewController alloc] init];
    vc.zxAccountIsShow = self.zxAccountIsShow;
    vc.nmAccountIsShow = self.nmAccountIsShow;
    [self.rt_navigationController pushViewController:vc animated:YES];
}
- (void)headCellButtonClick:(UIButton *)btn
{
    if (btn.tag == 10001) {
        //个人账户信息
        UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
        personMessageVC.title = @"基础详情";
        personMessageVC.zxAccountIsShow = self.zxAccountIsShow;
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
        btn.selected = !btn.selected;
        [self.tableHead hiddenMoney:btn.selected];
    }
    else if (btn.tag == 10004){
        //只进入微金的充值
        self.accoutType = SelectAccoutTypeP2P;
        HSHelper *helper = [HSHelper new];
        //检查企业老用户是否开户
        NSString *messageStr =  [helper checkCompanyIsOpen:self.accoutType];
        if (![messageStr isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (![helper checkP2POrWJIsAuthorization:self.accoutType]) {//先授权
            [helper pushP2POrWJAuthorizationType:self.accoutType nav:self.navigationController];
            return;
        }
        
        if ([self checkUserCanInvestIsDetail:NO type:self.accoutType]) {
            
            UCFNewRechargeViewController *vc = [[UCFNewRechargeViewController alloc] initWithNibName:@"UCFNewRechargeViewController" bundle:nil];
            vc.accoutType = SelectAccoutTypeP2P;
            vc.uperViewController = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (btn.tag == 10005){
        //各个账户的充值与提现,尊享、黄金账户已经不允许充值,只能提现
        UCFRechargeAndWithdrawalViewController *vc = [[UCFRechargeAndWithdrawalViewController alloc] init];
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 10006){
        //个人等级页面
        if(SingleUserInfo.loginData.userInfo.isCompanyAgent)//如果是机构用户
        {//吐司：此活动暂时未对企业用户开放
            [MBProgressHUD displayHudError:@"此活动暂时未对企业用户开放"];
        }
        else{
            if([self checkUserCanInvestIsDetail:YES type:SelectAccoutTypeP2P])//判断是否开户
            {
                [self requestMyCoin:@"vip"];//请求工贝地址
            }
        }
    }
}

#pragma mark - CellConfig
- (void)loadCellConfig
{
    self.arryData = [NSMutableArray array];
    
    [self.arryData addObject:[NSArray arrayWithObjects:[NSArray array], nil]]; //签到
    [self.arryData addObject:[self getCellAccountArrayData]]; //回款,债权,出借,商城
    [self.arryData addObject:[self getCellAccountCentreArrayData]];//客服,服务中心
    
    self.cellConfigData = [NSMutableArray array];
    //第一组内容
    CellConfig *cellConfigTicket = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineActivitiesCell class]) title:@"签到" showInfoMethod:@selector(showInfo:) heightOfCell:95];
    [self.cellConfigData addObject:[NSArray arrayWithObjects:cellConfigTicket, nil]];
    //第二组内容
    [self.cellConfigData addObject:[self loadingAccountCellConfig]];
    //第三组内容
    [self.cellConfigData addObject:[self getCellAccountCentreArray]];
    
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

- (NSArray *)getCellAccountCentreArray
{
    CellConfig *cellConfigCentre = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"服务中心" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    
    CellConfig *cellConfigService = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"客服热线" showInfoMethod:@selector(showInfo:) heightOfCell:50];
    return [NSArray arrayWithObjects:cellConfigCentre,cellConfigService, nil];
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
        [accountCellConfigArray insertObject:cellConfigRespect atIndex:accountCellConfigArray.count -1];
        
        UCFMineCellAccountModel *cellAccountRespect = [[UCFMineCellAccountModel alloc]init];//尊享项目
        cellAccountRespect.cellAccountTitle = @"尊享项目";
        cellAccountRespect.cellAccountImage = @"mine_icon_respect.png";
        [accountCellData insertObject:cellAccountRespect atIndex:accountCellData.count -1];
    }
    if (model.data.nmAccountIsShow) {
        //黄金账户是否显示
        CellConfig *cellConfigGold = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineItemCell class]) title:@"持有黄金" showInfoMethod:@selector(showInfo:) heightOfCell:50];
        [accountCellConfigArray insertObject:cellConfigGold atIndex:accountCellConfigArray.count -1];
       
        UCFMineCellAccountModel *cellAccountGold = [[UCFMineCellAccountModel alloc]init];//持有黄金
        cellAccountGold.cellAccountTitle = @"持有黄金";
        cellAccountGold.cellAccountImage = @"mine_icon_gold.png";
        [accountCellData insertObject:cellAccountGold atIndex:accountCellData.count -1];
    }
    //新的数据直接添加第二组内容
    [self.cellConfigData addObject:[accountCellConfigArray copy]];
    [self.arryData addObject:[accountCellData copy]];
    
    
    //第三组内容
    [self.arryData addObject:[self getCellAccountCentreArrayData]];//客服,服务中心
    [self.cellConfigData addObject:[self getCellAccountCentreArray]];
}

#pragma mark - 请求

- (void)refreshTableViewHeader
{
    [self requestMineMessage];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];
}

- (void)refreshPageData
{
    [self.tableView beginRefresh];
}

- (void)requestMyCoin:(NSString *)vip//请求我的工贝
{
    UCFMineIntoCoinPageApi * request = [[UCFMineIntoCoinPageApi alloc] initWithPageType:vip];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMineIntoCoinPageModel *model = [request.responseJSONModel copy];
        //        DDLogDebug(@"---------%@",model);
        if (model.ret == YES)
        {
            UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
            [data setValue:[NSString urlEncodeStr:model.data.coinRequest.param.encryptParam ] forKey:@"encryptParam"];
            [data setObject:[NSString stringWithFormat:@"%zd",model.data.coinRequest.param.fromApp] forKey:@"fromApp"];
            [data setObject:model.data.coinRequest.param.userId forKey:@"userId"];
            NSString * requestStr = [Common getParameterByDictionary:data];
            if ([vip isEqualToString:@"vip"])
            {
                web.url  = [NSString stringWithFormat:@"%@?%@",model.data.coinRequest.urlPath,requestStr];
            }
            else
            {
                web.url  = [NSString stringWithFormat:@"%@/#/?%@",model.data.coinRequest.urlPath,requestStr];
            }
            web.isHidenNavigationbar = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        else{
            ShowCodeMessage(model.code, model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
    
}

- (void)showMySimpleInfo:(UCFMineMySimpleInfoModel *)model
{
    //查询工豆优惠券信息 和未读消息
    [self.arryData addObject:[NSArray arrayWithObjects:model, nil]];
    CellConfig *cellConfigTicket = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineActivitiesCell class]) title:@"签到" showInfoMethod:@selector(showInfo:) heightOfCell:95];
    [self.cellConfigData addObject:[NSArray arrayWithObjects:cellConfigTicket, nil]];
}

- (void)showShopUrl:(UCFHomeMallDataModel *)model
{
    //当前没有活动内容
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:5];
    
    if (model.data.mallRecommends.count >0)
    {
        CellConfig *cellConfigCentre = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineShopPromotionCell class]) title:@"mallRecommends" showInfoMethod:@selector(showInfo:) heightOfCell:215];
        [cellArray addObject:cellConfigCentre];
        [dataArray addObject:model.data];
    }
    if (model.data.mallSale.count >0)
    {
        CellConfig *cellConfigCentre = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMineShopDiscountCell class]) title:@"mallSale" showInfoMethod:@selector(showInfo:) heightOfCell:215];
        [cellArray addObject:cellConfigCentre];
        [dataArray addObject:model.data];
    }
        //没有活动这组数据,就直接插入
        [self.arryData addObject:dataArray];
        [self.cellConfigData addObject:cellArray];
}

- (void)showBannerUrl:(UCFQueryBannerByTypeModel *)model
{
    //当前没有活动内容
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:5];
    if (model.data.bannerList.count)
    {
        //当前banner有数据
        CellConfig *cellConfigCentre = [CellConfig cellConfigWithClassName:NSStringFromClass([UCFMinePromotionCell class]) title:@"banner" showInfoMethod:@selector(showInfo:) heightOfCell:108];
        [cellArray addObject:cellConfigCentre];
        [dataArray addObject:model.data];
    }
    [self.cellConfigData addObject:cellArray];
    [self.arryData addObject:dataArray];
}

//登录或者注册
- (void)monitorUserLogin
{
    [self.tableView beginRefresh];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];
}
//退出登录，或者切换账户
- (void)monitorUserGetOut
{
    //清空数据
    [self.tableHead removeHeadViewUserData];
    self.zxAccountIsShow = NO;
    self.nmAccountIsShow = NO;
    [self.arryData replaceObjectAtIndex:0 withObject:[NSArray arrayWithObjects:[UCFMineMySimpleInfoModel new], nil]];
    //第二组内容
    [self.cellConfigData replaceObjectAtIndex:1 withObject:[self loadingAccountCellConfig]];
    [self.arryData replaceObjectAtIndex:1 withObject:[self getCellAccountArrayData]]; //回款,债权,出借,商城
    
    [self.tableView cyl_reloadData];
}
//用户在登录的情况下，更改用户状态的时候，请求数据
- (void)monitorOpenStatueChange
{
   [self.tableView beginRefresh];
}

#pragma mark - 用户状态检测
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail type:(SelectAccoutType)accout;
{
    
    NSString *tipStr1 = accout == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = accout == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;
    
    NSInteger openStatus = accout == SelectAccoutTypeP2P ? [SingleUserInfo.loginData.userInfo.openStatus integerValue]:[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue];
    
    switch (openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:tipStr1];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:tipStr2];
                return NO;
            }
        }
            break;
        default:
            return YES;
            break;
    }
}
- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag =  self.accoutType == SelectAccoutTypeP2P ? 8000 :8010;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[SingleUserInfo.loginData.userInfo.openStatus integerValue] nav:self.navigationController];
        }
    }else if (alertView.tag == 8010) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] nav:self.navigationController];
        }
    }
}

- (void)requestMineMessage
{
    UCFMineMySimpleInfoApi * simpleRequest = [[UCFMineMySimpleInfoApi alloc] init];
    UCFMineMyReceiptApi * receiptrRequest = [[UCFMineMyReceiptApi alloc] init];
    UCFQueryBannerByTypeAPI *bannerRequest = [[UCFQueryBannerByTypeAPI alloc] initWithBannerType:17];
    UCFMallProductApi *mallRequest = [[UCFMallProductApi alloc] initWithPageType:@"home"];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[simpleRequest, receiptrRequest ,bannerRequest ,mallRequest]];
    batchRequest.animatingView = self.view;
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSArray *requests = batchRequest.requestArray;
        
        NSInteger unReadMsgCount = 0;
        NSString *memberLever = @"";
        [self.arryData removeAllObjects];
        [self.cellConfigData removeAllObjects];
        
        UCFMineMySimpleInfoApi * simpleRequest = (UCFMineMySimpleInfoApi *)requests[0]; //请求我的工贝,工豆,优惠券,未读消息信息
        if ([simpleRequest isKindOfClass:[UCFMineMySimpleInfoApi class]])
        {
            UCFMineMySimpleInfoModel *model = [simpleRequest.responseJSONModel copy];
            self.outBoundMess = model.data.outBoundMess;
            DDLogDebug(@"---------%@",model);
            if (model.ret == YES) {
                
                unReadMsgCount = model.data.unReadMsgCount;
                memberLever = model.data.memberLever;
                [self setBatchTableViewArrayWithData:model];
            }
            else{
                ShowCodeMessage(model.code, model.message);
            }
        }
        
        UCFMineMyReceiptApi *receiptrRequest   = (UCFMineMyReceiptApi *)requests[1];//请求我总资产,列表尊享,黄金账户显隐
        if ([receiptrRequest isKindOfClass:[UCFMineMyReceiptApi class]])
        {
            UCFMineMyReceiptModel *model = [receiptrRequest.responseJSONModel copy];
            DDLogDebug(@"---------%@",model);
            if (model.ret == YES) {
                
                if (SingleUserInfo.loginData.userInfo.zxIsNew != !model.data.zxAccountIsShow)
                {
                    SingleUserInfo.loginData.userInfo.zxIsNew = !model.data.zxAccountIsShow;
                    [SingleUserInfo setUserData:SingleUserInfo.loginData];
                }
                self.zxAccountIsShow = model.data.zxAccountIsShow;
                self.nmAccountIsShow = model.data.nmAccountIsShow;
                model.data.memberLever = memberLever;
                model.data.unReadMsgCount = unReadMsgCount; //把请求工贝工豆的接口数据放到这
                [self setBatchTableViewArrayWithData:model];
            }
            else{
                ShowCodeMessage(model.code, model.message);
            }
        }

        UCFQueryBannerByTypeAPI *bannerRequest = (UCFQueryBannerByTypeAPI *)requests[2];
        if ([bannerRequest isKindOfClass:[UCFQueryBannerByTypeAPI class]])
        {
            UCFQueryBannerByTypeModel *model = bannerRequest.responseJSONModel;
            if (model.ret) {
                
                [self setBatchTableViewArrayWithData:model];
                
            } else {
                ShowCodeMessage(model.code, model.message);
            }
        }
        
        UCFMallProductApi *mallRequest         = (UCFMallProductApi *)requests[3];
        if ([mallRequest isKindOfClass:[UCFMallProductApi class]])
        {
            UCFHomeMallDataModel *model = mallRequest.responseJSONModel;
            if (model.ret) {
                
                [self setBatchTableViewArrayWithData:model];
                
            } else {
                ShowCodeMessage(model.code, model.message);
            }
        }
        // deal with requests result ...
        [self.tableView endRefresh];
        [self.tableView cyl_reloadData];
    } failure:^(YTKBatchRequest *batchRequest) {
//        NSLog(@"failed");
        [self.tableView endRefresh];
    }];
}
- (void)setBatchTableViewArrayWithData:(id)model
{
    if ([model isKindOfClass:[UCFMineMySimpleInfoModel class]]) {
        
        //查询工豆优惠券信息 和未读消息
        [self showMySimpleInfo:model];
    }
    if ([model isKindOfClass:[UCFMineMyReceiptModel class]]) {
        
        //赋值 账户信息
        [self.tableHead showMyReceipt:model];
        //查询账户信息
        [self getAccountCellConfig:model];
        
    }
    if ([model isKindOfClass:[UCFHomeMallDataModel class]]) {
        
        [self showShopUrl:model];
    }
    if ([model isKindOfClass:[UCFQueryBannerByTypeModel class]]) {
        
        [self showBannerUrl:model];
    }
}

@end
