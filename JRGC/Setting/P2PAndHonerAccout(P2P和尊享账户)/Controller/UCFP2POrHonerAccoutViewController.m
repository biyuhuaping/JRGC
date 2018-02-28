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
#import "UCFInvitationRebateViewController.h"
//#import "UCFSession.h"
#import "MjAlertView.h"
//#import "UCFCalendarViewController.h"
#import "UCFCalendarModularViewController.h"
#import "UCFMyReservedViewController.h"
#import "UCFSettingFuncItem.h"
#import "UCFSecurityCell.h"

@interface UCFP2POrHonerAccoutViewController ()<UITableViewDelegate,UITableViewDataSource,UCFP2POrHornerTabHeaderViewDelete,UIAlertViewDelegate,MjAlertViewDelegate, UCFSecurityCellDelegate>
{
    UCFP2POrHornerTabHeaderView *_headerView;
    BOOL _isShowOrHideAccoutMoney;
    NSDictionary *_dataDict;
    int _openState;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *loadingView;
@property(strong,nonatomic) NSMutableArray *cellItemsData;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (strong, nonatomic) NSString *fromIntoVCStr;

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (strong, nonatomic) NSString *isCompanyAgent;//是否是机构用户
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (assign,nonatomic) int otherNum;//风险评估剩余次数
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel1;

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel2;
@property (strong,nonatomic) NSString *paymentDeadlineDate;//过期日期


- (IBAction)clickCashBtn:(UIButton *)sender;
- (IBAction)clickRechargeBtn:(UIButton *)sender;

@end

@implementation UCFP2POrHonerAccoutViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([self.fromIntoVCStr isEqualToString:@"riskAssessmentVC"]) {
        [self getP2POrHonerAccoutHttpRequest];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self createUIInfoView];//初始化UI
    [self addLeftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getP2POrHonerAccoutHttpRequest) name:RELOADP2PORHONERACCOTDATA object:nil];
//    if (self.accoutType == SelectAccoutTypeP2P) {
//        BOOL isFirstStep = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISFirstStepInP2PAccount"];
//        if (!isFirstStep) {
//            if ([UserInfoSingle sharedManager].enjoyOpenStatus < 3) {
//                MjAlertView *alertView = [[MjAlertView alloc] initSkipToHonerAccount:self];
//                alertView.tag = 1002;
//                [alertView show];
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISFirstStepInP2PAccount"];
//            } else {
//                MjAlertView *alertView = [[MjAlertView alloc] initSkipToMoneySwitchHonerAccout:self];
//                alertView.tag = 1001;
//                [alertView show];
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISFirstStepInP2PAccount"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//        }
//    }
}
-(void)removeLoadingView
{
    for (UIView *view in self.loadingView.subviews) {
        [view removeFromSuperview];
    }
    [self.loadingView removeFromSuperview];
    [self addRightButton];
    [self.tableView.header beginRefreshing];
    self.tableView.userInteractionEnabled = YES;
    baseTitleLabel.text =  self.accoutType==SelectAccoutTypeHoner ? @"尊享账户":@"微金账户";
}
-(void)createUIInfoView{
    [self addLeftButton];
//     baseTitleLabel.text = @"正在跳转";
    baseTitleLabel.text =  self.accoutType==SelectAccoutTypeHoner ? @"尊享账户":@"微金账户";
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getP2POrHonerAccoutHttpRequest)];
    self.loadingView.userInteractionEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
    self.loadingView.hidden = YES;
    [self.view bringSubviewToFront:self.loadingView];
    [self removeLoadingView];
//    [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.0f];
    if (self.accoutType ==  SelectAccoutTypeHoner) {
//        [self.view bringSubviewToFront:self.loadingView];
//        [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.0f];
//       self.loadingLabel1.text = @"即将跳转工场尊享";
//        self.loadingLabel2.text = @"可直接访问www.gongchangzx.com";
         _isShowOrHideAccoutMoney = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowHonerAccoutMoney"];
    }else{
//        [self.view sendSubviewToBack:self.loadingView];
//        self.loadingView.hidden = YES;
//        [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.0f];
//        self.loadingLabel1.text = @"即将跳转工场微金";
//        self.loadingLabel2.text = @"可直接访问www.gongchangp2p.cn";
        _isShowOrHideAccoutMoney = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowP2PAccoutMoney"];
    }
    //添加阴影图片
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    self.shadowImageView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0);
    self.cashButton.backgroundColor = UIColorWithRGB(0x7D9EC5);
    self.rechargeButton.backgroundColor = UIColorWithRGB(0xFA4F4C );
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
    UCFAccountDetailViewController *accountDetailVC = [[UCFAccountDetailViewController alloc] initWithNibName:@"UCFAccountDetailViewController" bundle:nil];
    accountDetailVC.selectedSegmentIndex = 1;
    accountDetailVC.accoutType = self.accoutType;
    [self.navigationController pushViewController:accountDetailVC animated:YES];
}


#pragma mark -
#pragma mark 懒加载
// 初始化选项数组
- (NSMutableArray *)cellItemsData
{
    if (_cellItemsData == nil) {
        
        UCFSettingItem *myInVest = [UCFSettingArrowItem itemWithIcon:nil title:@"我的出借" destVcClass:[MyViewController class]];
        
        NSString *calendarStr = nil;
        if (self.accoutType == SelectAccoutTypeP2P) {
            calendarStr = @"微金回款日历";
        }
        else if (self.accoutType == SelectAccoutTypeHoner) {
            calendarStr = @"尊享回款日历";
        }
        
        UCFSettingItem *backMoneyDetail = [UCFSettingArrowItem itemWithIcon:nil title:calendarStr destVcClass:[UCFCalendarModularViewController class]];
        UCFSettingItem *feedBackVC = [UCFSettingArrowItem itemWithIcon:nil title:@"邀请获利" destVcClass:[UCFInvitationRebateViewController class]];
        
        
        
        UCFSettingItem *bundleCard = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_bankcard" title:@"修改银行卡" destVcClass:[UCFBankCardInfoViewController class]];
        
        UCFSettingItem *setChangePassword = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_transaction" title:@"修改交易密码" destVcClass:[TradePasswordVC class]];
        
        UCFSettingItem *p2pOrHonerAccout = nil;
        UCFSettingItem *riskAssessment = nil;
        if (self.accoutType == SelectAccoutTypeHoner) {
              myInVest.title  = @"我的认购";
              p2pOrHonerAccout = [UCFSettingArrowItem itemWithIcon:nil title:@"尊享徽商银行存管账户" destVcClass:nil];
              riskAssessment= [UCFSettingArrowItem itemWithIcon:nil title:@"尊享风险承担能力" destVcClass:[RiskAssessmentViewController class]];
        }else{
            myInVest.title  = @"我的出借";
            if ([UserInfoSingle sharedManager].openStatus == 4) {
                setChangePassword.title = @"修改交易密码";
            }else{
                setChangePassword.title = @"设置交易密码";
            }
            p2pOrHonerAccout = [UCFSettingArrowItem itemWithIcon:nil title:@"微金徽商银行存管账户" destVcClass:nil];
            riskAssessment = [UCFSettingArrowItem itemWithIcon:nil title:@"微金风险承担能力" destVcClass:[RiskAssessmentViewController class]];
        }
        UCFSettingItem *batchInvest = [UCFSettingArrowItem itemWithIcon:nil title:@"批量出借" destVcClass:[UCFBatchInvestmentViewController class]];
        UCFSettingItem *myReserved = [UCFSettingArrowItem itemWithIcon:nil title:@"我的预约" destVcClass:[UCFMyReservedViewController class]];
        
        UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];//第一栏

        if (kIS_IOS8) {
            group1.items = [[NSMutableArray alloc]initWithArray: @[myInVest,backMoneyDetail,feedBackVC]];
        }
        else {
            group1.items = [[NSMutableArray alloc]initWithArray: @[myInVest,feedBackVC]];
        }
        
        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];//第二栏
        
        if (self.accoutType == SelectAccoutTypeHoner) {
            group2.items = [[NSMutableArray alloc]initWithArray:@[p2pOrHonerAccout, bundleCard ,setChangePassword,riskAssessment]];
        }else{
            group2.items = [[NSMutableArray alloc]initWithArray:@[p2pOrHonerAccout, bundleCard ,setChangePassword,riskAssessment, myReserved]];
        }
        
        UCFSettingFuncItem *batchLending = [UCFSettingFuncItem itemWithIcon:@"safecenter_icon_auto" title:@"批量出借" destVcClass:nil];
        batchLending.subtitle = @"到期日:xxxx-xx-xx";
        batchLending.batchLendingType = UCFSettingBatchLendingTypeUnopened;
        batchLending.paymentAuthType = UCFSettingPaymentAuthTypeNone;
        //先前是绑卡页面，因为删除绑卡页面，所以暂时用TradePasswordVC这个类替代，整体调试的时候改过来，zrc fixed
        UCFSettingFuncItem *paymentAuth = [UCFSettingFuncItem itemWithIcon:@"safecenter_icon_authorize" title:@"缴费授权" destVcClass:nil];//***qyy
        paymentAuth.batchLendingType = UCFSettingBatchLendingTypeNone;
        paymentAuth.paymentAuthType = UCFSettingPaymentAuthTypeUnAuth;
        paymentAuth.subtitle = @"到期日:xxxx-xx-xx";
        
        UCFSettingGroup *group3 = [[UCFSettingGroup alloc] init];//第三栏
        group3.items = [[NSMutableArray alloc]initWithArray:@[batchLending, paymentAuth]];
        
        if (self.accoutType == SelectAccoutTypeP2P) {
            _cellItemsData = [[NSMutableArray alloc] initWithObjects:group1,group2,group3,nil];
        }
        else {
            _cellItemsData = [[NSMutableArray alloc] initWithObjects:group1,group2,nil];
        }
    }
    return _cellItemsData;
}
#pragma mark -
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            if (self.accoutType == SelectAccoutTypeP2P && [UserInfoSingle sharedManager].enjoyOpenStatus < 3 && [UserInfoSingle sharedManager].level > 1) {
                return 208;
            } else {
                return 160;
            }
        }
        else {
            if (self.accoutType == SelectAccoutTypeP2P && [UserInfoSingle sharedManager].enjoyOpenStatus < 3) {
                return 208;
            } else {
                return 160;
            }
        }
        

        
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat headHeight = self.accoutType == SelectAccoutTypeP2P ? 208 : 160;
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"UCFP2POrHornerTabHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, headHeight);
        _headerView.upView.backgroundColor = UIColorWithRGB(0x5b6993);
        _headerView.downView.backgroundColor = [UIColor whiteColor];
        _headerView.delegate = self;
        _headerView.accoutTpye = self.accoutType;
        
        _headerView.isShowOrHideAccoutMoney = _isShowOrHideAccoutMoney;
        if(self.accoutType == SelectAccoutTypeHoner){
            _headerView.allGetInterLab.text = @"累计收益";
            _headerView.totalIncomeTitleLab.text = @"尊享总资产";
        }else{
            _headerView.allGetInterLab.text = @"累计利息";
            _headerView.totalIncomeTitleLab.text = @"微金总资产";
        }
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,headHeight - 0.5, ScreenWidth, 0.5)];
        lineView1.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [_headerView addSubview:lineView1];
        _headerView.dataDict = _dataDict;
        _headerView.clipsToBounds = YES;
        return _headerView;
    }else{
        UIView *headerView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, 10)];
        headerView.backgroundColor = [UIColor clearColor];
//        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,0.5, ScreenWidth, 0.5)];
//        lineView1.backgroundColor = UIColorWithRGB(0xd8d8d8);
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame)-0.5, ScreenWidth, 0.5)];
        lineView2.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        [headerView addSubview:lineView1];
        [headerView addSubview:lineView2];
        return headerView;
    }
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, 0.5)];
//    footView.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    return footView;
//}

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
    
    UCFSettingGroup * group = self.cellItemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    if ([item isKindOfClass:[UCFSettingFuncItem class]]) {
        UCFSecurityCell *securityCell = [tableView dequeueReusableCellWithIdentifier:@"securitycell2"];
        if (nil == securityCell) {
            securityCell = (UCFSecurityCell*)[[[NSBundle mainBundle] loadNibNamed:@"UCFSecurityCell" owner:self options:nil] lastObject];
        }
        securityCell.tableview = tableView;
        securityCell.indexPath = indexPath;
        securityCell.delegate = self;
        securityCell.funcItem = [group.items objectAtIndex:indexPath.row];
        return securityCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID"];
        cell.textLabel.textColor =  UIColorWithRGB(0x5555555);
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.detailTextLabel.textColor =  UIColorWithRGB(0x999999);
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//        cell.
        UIView *cellLineView = [[UIView alloc]initWithFrame:CGRectMake(15, 43.5, ScreenWidth-15, 0.5)];
        cellLineView.tag = 101;
        [cell.contentView addSubview:cellLineView];
    }
    UIView *cellLineView = (UIView *)[cell.contentView viewWithTag:101];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text =item.subtitle;
    if ([cell.textLabel.text rangeOfString:@"(开通后一次可投多个项目)"].location != NSNotFound ) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:13] string:@"(开通后一次可投多个项目)"];
        [cell.textLabel setFontColor:UIColorWithRGB(0x999999) string:@"(开通后一次可投多个项目)"];
    }
    if(indexPath.section == [self.cellItemsData indexOfObject:group] && indexPath.row == group.items.count-1){
       cellLineView.backgroundColor  = UIColorWithRGB(0xd8d8d8);
       cellLineView.frame =  CGRectMake(0, 43.5, ScreenWidth, 0.5);
    }else{
        cellLineView.backgroundColor  = UIColorWithRGB(0xe3e5ea);
        cellLineView.frame =  CGRectMake(15, 43.5, ScreenWidth-15, 0.5);
    }
    return cell;
}

- (void)securityCell:(UCFSecurityCell *)cell didClickButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.row == 0)
    {
        if ([button.titleLabel.text isEqualToString:@"开启"] || [button.titleLabel.text isEqualToString:@"重新开启"]) {
            if([self checkHSIsLegitimate]) {
                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                batchInvestment.sourceType = @"personCenter";
                batchInvestment.isStep = 1;
                [self.navigationController pushViewController:batchInvestment animated:YES];
            }
        }
        else if ([button.titleLabel.text isEqualToString:@"调整"]) {
            if([self checkHSIsLegitimate]) {
                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                batchInvestment.sourceType = @"personCenter";
                batchInvestment.isStep = 2;
                [self.navigationController pushViewController:batchInvestment animated:YES];
            }
        }
        else if ([button.titleLabel.text isEqualToString:@"解约"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"解约后将不能再出借批量出借项目" preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"解约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf batchLendingCancelContract];
            }];
            
            [alertController addAction:okAction];           // A
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
    else //
    {
        if([self checkHSIsLegitimate]) //授权前开户，并设置交易密码
        {
//            [self p2pAccoutPaymentAuthInfo:cell.funcItem];
        }
    }
    
}

//批量借款解约
- (void)batchLendingCancelContract {
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (nil == userId) {
        return;
    }
    NSDictionary *param = @{@"userId": userId};
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagCancelAContract owner:self signature:YES Type:SelectAccoutTypeP2P];
}

- (BOOL) checkHSIsLegitimate {
    NSInteger openStatus = [UserInfoSingle sharedManager].openStatus;
    if(openStatus < 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:P2PTIP1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCFSettingGroup *group = [self.cellItemsData objectAtIndex:indexPath.section];
    UCFSettingItem *item = [group.items objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[UCFSettingFuncItem class]]) {
        return 60.f;
    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    UCFSettingGroup * group = self.cellItemsData[indexPath.section];
    UCFSettingArrowItem *item = group.items[indexPath.row];
    
    NSString *titleStr = item.title;
//    && [NSStringFromClass(item.destVcClass) isEqualToString:@"MyViewController"]
    if ([titleStr isEqualToString:@"我的出借"]  || [titleStr isEqualToString:@"我的认购"] ) {
        MyViewController *myInvestVC = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
        myInvestVC.selectedSegmentIndex = 0;
        myInvestVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:myInvestVC animated:YES];
    }
    else if ([titleStr hasSuffix:@"回款日历"]) {
        UCFCalendarModularViewController *backMoneyCalendarVC = [[UCFCalendarModularViewController alloc] initWithNibName:@"UCFCalendarModularViewController" bundle:nil];
        backMoneyCalendarVC.accoutType = self.accoutType;
        backMoneyCalendarVC.baseTitleText = titleStr;
        [self.navigationController pushViewController:backMoneyCalendarVC animated:YES];
    }else if ([titleStr isEqualToString:@"邀请获利"]){
        
        UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
        feedBackVC.title = @"邀请获利";
        feedBackVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:feedBackVC animated:YES];
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
        
        if(_openState > 3){
            //修改交易密码
            TradePasswordVC * tradePasswordVC = [[TradePasswordVC alloc]initWithNibName:@"TradePasswordVC" bundle:nil];
            tradePasswordVC.title = titleStr;
            tradePasswordVC.isCompanyAgent = [[NSUserDefaults standardUserDefaults] boolForKey: @"isCompanyAgentType"];
//            tradePasswordVC.site = [NSString stringWithFormat:@"%d",self.accoutType];
            tradePasswordVC.accoutType = self.accoutType;
            [self.navigationController pushViewController:tradePasswordVC  animated:YES];
        }else{//设置交易密码
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:self.accoutType Step:3 nav:self.navigationController];

        }
    }
    else if([titleStr hasSuffix:@"风险承担能力"]){
            if (_otherNum <= 0) { //风险承担能力评估剩余次数
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的评估次数已用完" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else{
                RiskAssessmentViewController *riskAssessmentVC = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
                riskAssessmentVC.title = titleStr;
                riskAssessmentVC.accoutType = self.accoutType;
                riskAssessmentVC.sourceVC = @"P2POrHonerAccoutVC";
                self.fromIntoVCStr = @"riskAssessmentVC";
                [self.navigationController pushViewController:riskAssessmentVC  animated:YES];
            }
 
    }
//    else if([titleStr hasPrefix:@"批量出借"]){
//        if ([self checkIDAAndBankBlindState:self.accoutType]) {
//            UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
//            batchInvestment.isStep = [item.subtitle isEqualToString:@"未开启"] ? 1 : 2;
//            batchInvestment.accoutType = self.accoutType;
//            batchInvestment.sourceType = @"P2POrHonerAccoutVC";
//            [self.navigationController pushViewController:batchInvestment animated:YES];
//        }
//    }
    else if ([titleStr hasPrefix:@"我的预约"]) {
        UCFMyReservedViewController *myserved = [[UCFMyReservedViewController alloc] initWithNibName:@"UCFMyReservedViewController" bundle:nil];
//        myserved.url = [NSString stringWithFormat:@"https://m.9888.cn/static/wap/invest/index.html#/reserve/records"];
        myserved.url = [NSString stringWithFormat:@"https://m.9888.cn/static/wap/p2p/index.html#/reserve-bid/records"];
        
        myserved.navTitle = titleStr;
        [self.navigationController pushViewController:myserved animated:YES];
    }
}
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
//资金如何划转
- (void)changeP2POrHonerAccoutMoneyAlertView
{
    MjAlertView *alertView = [[MjAlertView alloc] initSkipToHonerAccount:self];
    alertView.tag = 1002;
    [alertView show];
}
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index
{
    if (alertview.tag == 1002 && [UserInfoSingle sharedManager].enjoyOpenStatus < 3) {
        HSHelper *helper = [HSHelper new];
        if (![helper checkP2POrWJIsAuthorization:SelectAccoutTypeHoner]) {
            [helper pushP2POrWJAuthorizationType:SelectAccoutTypeHoner nav:self.navigationController];
        } else {
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        }
    } else {
        [self clickCashBtn:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 是否设置交易密码
- (BOOL)checkIDAAndBankBlindState:(SelectAccoutType)type
{
 
    __weak typeof(self) weakSelf = self;
    if (_openState <= 3) {
        NSString *message = type == SelectAccoutTypeHoner ? ZXTIP2:P2PTIP2;
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
            if (index == 1) {
                HSHelper *helper = [HSHelper new];
                [helper pushOpenHSType:type Step:3 nav:weakSelf.navigationController];
            }
        } otherButtonTitles:@"确认"];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark 提现点击事件
- (IBAction)clickCashBtn:(UIButton *)sender {
    
    if( [self checkIDAAndBankBlindState:self.accoutType]){ //判断是否设置交易密码
        [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
        NSString *userSatues = [NSString stringWithFormat:@"%ld",(long)[UserInfoSingle sharedManager].openStatus];
        NSDictionary *parametersDict =  @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userSatues":userSatues};
        [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:self.accoutType];
    }
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
    else if(alertView.tag == 10005){
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
    }else if(alertView.tag == 10003){
        if (buttonIndex == 1) {
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
    
    [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
}


-(void)endPost:(id)result tag:(NSNumber *)tag{
    
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
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
//                if(self.accoutType == SelectAccoutTypeP2P){
//                    [[UCFSession sharedManager] transformBackgroundWithUserInfo:@{} withState:UCFSessionStateUserRefresh];
//                }
                _dataDict = dataDict;
                _otherNum = [[dataDict objectSafeForKey:@"otherNum"] intValue];
                _openState = [[dataDict objectSafeForKey:@"openState"] intValue];
                int  isRisk = [[dataDict objectSafeForKey:@"isRisk"] intValue];
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
                
                NSString *batchInvestStatus = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey: @"batchMaximum"]];
                
                self.paymentDeadlineDate =  [dataDict objectSafeForKey:@"paymentDeadline"];
                
                BOOL afterAutoBidDeadline = [[dataDict objectSafeForKey:@"afterAutoBidDeadline"] boolValue];
                UCFSettingGroup *settingGroup = [self.cellItemsData objectAtIndex:2];
                UCFSettingFuncItem *funcItem = [settingGroup.items firstObject];
                funcItem.paymentAuthType = UCFSettingPaymentAuthTypeNone;
                if (batchInvestStatus.length>0) {
                    if (afterAutoBidDeadline) {
                        funcItem.batchLendingType = UCFSettingBatchLendingTypeOverduring;
                        funcItem.title = @"批量出借";
                        //                    funcItem.subtitle = [NSString stringWithFormat:@"到期日:%@", [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"autoBidDeadline"]];
                        funcItem.subtitle =  @"到期日：已过期";
                        
                    }
                    else {
                        funcItem.batchLendingType = UCFSettingBatchLendingTypeOpenned;
                        funcItem.title = [NSString stringWithFormat:@"批量出借:%@",batchInvestStatus];
                        funcItem.subtitle = [NSString stringWithFormat:@"到期日:%@", [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"autoBidDeadline"]];
                    }
                }
                else {
                    funcItem.batchLendingType = UCFSettingBatchLendingTypeUnopened;
                    funcItem.title = @"批量出借";
                    funcItem.subtitle = @"";
                }
                
                BOOL isAuthPayment = [[dataDict objectSafeForKey:@"isAuthPayment"] boolValue];
                BOOL afterPaymentDeadline = [[dataDict objectSafeForKey:@"afterPaymentDeadline"] boolValue];
                UCFSettingFuncItem *funcItem2 = [settingGroup.items objectAtIndex:1];
                funcItem2.batchLendingType = UCFSettingBatchLendingTypeNone;
                if (isAuthPayment) {
                    if (afterPaymentDeadline) {
                        funcItem2.paymentAuthType = UCFSettingPaymentAuthTypeOverAuth;
                        funcItem2.title = @"缴费授权:已过期";
                        funcItem2.subtitle = @"";
                    }
                    else {
                        funcItem2.paymentAuthType = UCFSettingPaymentAuthTypeAuthed;
                        funcItem2.title = @"缴费授权:已授权";
                        funcItem2.subtitle = [NSString stringWithFormat:@"到期日:%@", self.paymentDeadlineDate];
                    }
                }
                else {
                    funcItem2.paymentAuthType = UCFSettingPaymentAuthTypeUnAuth;
                    funcItem2.title = @"缴费授权:未授权";
                    funcItem2.subtitle = @"";
                }
                
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
                                    {
                                        
                                        item.title = _openState <= 3 ? @"设置交易密码" : @"修改交易密码";
                                    }
                                        break;
                                    case 3:
                                    {
                                      NSString *riskLevelStr = [NSString stringWithFormat:@"%@(剩%d次)",riskLevel,_otherNum];
                                      item.subtitle = isRisk == 0 ? @"未评估":riskLevelStr;
                                    }
                                        break;
                                    case 4:
                                    {
                                         item.subtitle = batchMaximum.length == 0 ? @"未开启" : batchMaximum;
                                         item.title = batchMaximum.length == 0 ? @"批量出借(开通后一次可投多个项目)" : @"批量出借";
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
            
        case kSXTagCancelAContract: {
                [MBProgressHUD displayHudError:dic[@"message"]];
                [self performSelector:@selector(getP2POrHonerAccoutHttpRequest) withObject:nil afterDelay:0.25];
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
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    if (self.tableView.header.isRefreshing){
        [self.tableView.header endRefreshing];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
