//
//  UCFNewTransProjectDetailViewController.m
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewTransProjectDetailViewController.h"
#import "UCFBidDetailNavView.h"
#import "UCFTransBidDetailViewModel.h"
#import "UCFNewBidDetaiInfoView.h"
#import "UCFRemindFlowView.h"
#import "MinuteCountDownView.h"
#import "UCFSettingArrowItem.h"
#import "UCFProjectInvestmentRecordViewController.h"
#import "UCFProjectSafetyGuaranteeViewController.h"
#import "UCFProjectBasicDetailViewController.h"
#import "UCFNewInvestBtnView.h"
#import "UCFNewPureTransBidViewController.h"
#import "UCFPureTransBidRootModel.h"
#import "UCFNewPureTransBidViewController.h"
#import "HSHelper.h"
#import "RiskAssessmentViewController.h"
@interface UCFNewTransProjectDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NetworkModuleDelegate,UCFBidDetailNavViewDelegate,UCFNewInvestBtnViewDelegate>
@property(nonatomic, strong)BaseTableView *showTableView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)UCFNewBidDetaiInfoView *bidinfoView;
@property(nonatomic, strong)UCFRemindFlowView *remind;
@property(nonatomic, strong)UCFBidDetailNavView *navView;
@property(nonatomic, strong)UCFTransBidDetailViewModel *VM;

@property(nonatomic, strong)MyRelativeLayout *contentLayout;
@property(nonatomic, strong)UCFNewInvestBtnView *investView;
@end

@implementation UCFNewTransProjectDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)loadView
{
    [super loadView];
    
    UCFBidDetailNavView *navView = [[UCFBidDetailNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight1)];
    self.navView = navView;
    navView.delegate = self;
    [self.rootLayout addSubview:navView];
    
    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.myHorzMargin = 0; //同时指定左右边距为0表示宽度和父视图一样宽
    self.contentLayout = contentLayout;
    
    UCFNewBidDetaiInfoView *bidinfoView = [[UCFNewBidDetaiInfoView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight1, ScreenWidth, 155)];
    self.bidinfoView = bidinfoView;
    [self.contentLayout addSubview:bidinfoView];
    
    UCFRemindFlowView *remind = [UCFRemindFlowView new];
    remind.topPos.equalTo(bidinfoView.bottomPos);
    remind.myHorzMargin = 0;
    remind.heightSize.equalTo(@40);
    remind.subviewVSpace = 5;
    remind.subviewHSpace = 10;
    self.remind = remind;
    [self.contentLayout addSubview:remind];

    contentLayout.heightSize.equalTo(@(155 + 40));
    
    self.showTableView.topPos.equalTo(self.navView.bottomPos);
    self.showTableView.bottomPos.equalTo(@50);
    self.showTableView.myHorzMargin = 0;
    self.showTableView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
    [self.rootLayout addSubview:self.showTableView];
    
    self.showTableView.tableHeaderView = contentLayout;
    
    UCFNewInvestBtnView *investView = [[UCFNewInvestBtnView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    investView.topPos.equalTo(self.showTableView.bottomPos);
    investView.myHorzMargin = 0;
    investView.rightPos.equalTo(@0);
    investView.delegate = self;
    investView.bottomPos.equalTo(@0);
    [self.rootLayout addSubview:investView];
    self.investView = investView;
}
- (void)topLeftButtonClick:(UIButton *)button
{
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self blindData];
    
    [self.navView blindTransVM:self.VM];
    
    [self.bidinfoView blindTransVM:self.VM];

    [self.remind blindTransVM:self.VM];

    [self.investView blindTransVM:self.VM];
//
//    [self blindVM:self.VM];
}
- (void)blindVM:(UVFBidDetailViewModel *)vm
{
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"bidInfoModel"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"bidInfoModel"]) {
            id model = [change objectForKey:NSKeyValueChangeNewKey];
            if([model isKindOfClass:[UCFBidModel class]]) {
                [selfWeak dealInvestInfoData:model];
            }
        }
    }];
}
- (void)dealInvestInfoData:(UCFBidModel *)model
{
    NSInteger code = model.code;
    NSString *message = model.message;
    if (model.ret) {
        NewPurchaseBidController *vc = [[NewPurchaseBidController alloc] init];
        vc.bidDetaiModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (code == 21 || code == 22){
        //        [self checkUserCanInvest];
    } else if (code == 15) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else if (code == 19) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
        alert.tag =7000;
        [alert show];
    } else if (code == 30) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
        alert.tag = 9000;
        [alert show];
    }else if (code == 40) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
        alert.tag = 9001;
        [alert show];
    } else {
        [MBProgressHUD displayHudError:model.message withShowTimes:3];
    }
}
- (void)blindData
{
    [self.VM blindModel:self.model];
    [self.dataArray addObject:[self.VM getTableViewData]];
    [self.dataArray addObject:[self.VM getTableViewData1]];
    self.accoutType =  [self.model.prdTransferFore.type isEqualToString:@"1"] ? SelectAccoutTypeP2P : SelectAccoutTypeHoner;
    _detailType = PROJECTDETAILTYPEBONDSRRANSFER;
    [self.showTableView reloadData];
}
- (UCFTransBidDetailViewModel *)VM
{
    if (!_VM) {
        _VM = [UCFTransBidDetailViewModel new];
        _VM.view = self.view;
    }
    return _VM;
}

#pragma mark tableView
- (UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.enableRefreshFooter = NO;
        _showTableView.enableRefreshHeader = NO;
    }
    return _showTableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        return _dataArray = [NSMutableArray arrayWithCapacity:2];
    }
    return _dataArray;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 30;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 0.001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        footView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        return footView;
    } else {
        return nil;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        headView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        return headView;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        headView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        return headView;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.detailTextLabel.textColor = [Color color:PGColorOptionTitleBlack];
        }
        
        NSArray *arr =  self.dataArray[indexPath.section];
        NSDictionary *dict = arr[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        cell.detailTextLabel.text = dict[@"value"];
        return cell;
    } else {
        static NSString *cellID = @"cellID2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 25, 25)];
            iconView.backgroundColor = [UIColor clearColor];
            iconView.tag = 1001;
            [cell addSubview:iconView];
            
            UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 10, 10, 130, 30)];
            textLab.backgroundColor = [UIColor clearColor];
            textLab.textColor = [UIColor blackColor];
            textLab.font = [Color gc_Font:15];
            textLab.tag = 1002;
            [cell addSubview:textLab];
            
            
            UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(45, 49.5, ScreenWidth -15, 0.5)];
            bottomLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
            bottomLineView.tag = 1000;
            [cell addSubview:bottomLineView];
        }
        
        UIView *bottomLineView = [cell viewWithTag:1000];
        UILabel *textLab = [cell viewWithTag:1002];
        UIImageView *iconView = [cell viewWithTag:1001];
        NSArray *arr =  self.dataArray[indexPath.section];
        
        UCFSettingArrowItem *model = arr[indexPath.row];
        iconView.image = [UIImage imageNamed:model.icon];
        textLab.text = model.title;
        if (indexPath.row == arr.count - 1) {
            bottomLineView.hidden = YES;
        } else {
            bottomLineView.hidden = NO;
        }
        bottomLineView.frame = CGRectMake(textLab.frame.origin.x, 49.5, ScreenWidth -15, 0.5);
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            UCFProjectBasicDetailViewController *basicDetailVC = [[UCFProjectBasicDetailViewController alloc]initWithNibName:@"UCFProjectBasicDetailViewController" bundle:nil];
            basicDetailVC.dataDic = [self.model yy_modelToJSONObject];
            basicDetailVC.detailType = _detailType;
            basicDetailVC.accoutType = self.accoutType;
            [self.navigationController  pushViewController:basicDetailVC animated:YES];
            
        } else if (indexPath.row == 1) {
            UCFProjectSafetyGuaranteeViewController *basicDetailVC = [[UCFProjectSafetyGuaranteeViewController alloc]initWithNibName:@"UCFProjectSafetyGuaranteeViewController" bundle:nil];
            NSMutableArray *dictArr = [NSMutableArray arrayWithCapacity:1];
            for (UCFTransSafetysecuritylist *safeModel in self.model.prdClaimsReveal.safetySecurityList) {
                NSDictionary *dict = @{@"title":safeModel.title,@"content":safeModel.content};
                [dictArr addObject:dict];
            }
            basicDetailVC.dataArray = dictArr;
            basicDetailVC.accoutType = self.accoutType;
            [self.navigationController  pushViewController:basicDetailVC animated:YES];
        } else {
            UCFProjectInvestmentRecordViewController *investmentRecordVC = [[UCFProjectInvestmentRecordViewController alloc]initWithNibName:@"UCFProjectInvestmentRecordViewController" bundle:nil];
            investmentRecordVC.dataDic = [self.model yy_modelToJSONObject];
            investmentRecordVC.accoutType = self.accoutType;
            investmentRecordVC.detailType = _detailType;
            [self.navigationController  pushViewController:investmentRecordVC animated:YES];
        }
    }
}
- (void)newInvestBtnView:(UCFNewInvestBtnView *)view clickButton:(UIButton *)button
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //债券转让
    NSString *projectId = self.model.prdTransferFore.ID;
    SelectAccoutType type = [self.model.prdTransferFore.type isEqualToString:@"1"] ? SelectAccoutTypeP2P : SelectAccoutTypeHoner;
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&tranId=%@",SingleUserInfo.loginData.userInfo.userId,projectId];//101943
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagDealTransferBid owner:self Type: type];
}
-(void)beginPost:(kSXTag)tag
{
    
}
-(void)endPost:(id)result tag:(NSNumber*)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(tag.intValue == kSXTagDealTransferBid) {
        UCFPureTransBidRootModel *model = [UCFPureTransBidRootModel yy_modelWithJSON:(NSString *)result];
        int statue = [model.status intValue];
        if (statue == 1)
        {
            UCFNewPureTransBidViewController *view = [[UCFNewPureTransBidViewController alloc] init];
            view.model = model;
            [self.navigationController pushViewController:view animated:YES];
        } else if (statue == 21 || statue == 7) {
            [self checkUserCanInvest];
        }else if (statue == 3 || statue == 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message: model.statusdes delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
            alert.tag =7001;
            [alert show];
        }else if (statue == 30 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message: model.statusdes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
            alert.tag = 9000;
            [alert show];
        }else if (statue == 40) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message: model.statusdes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
            alert.tag = 9001;
            [alert show];
        }
        else {
            [AuxiliaryFunc showAlertViewWithMessage: model.statusdes];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (BOOL)checkUserCanInvest
{
    BOOL isP2P = self.accoutType == SelectAccoutTypeP2P ? YES : NO;
    
    NSInteger step = isP2P  ? [SingleUserInfo.loginData.userInfo.openStatus intValue]: [SingleUserInfo.loginData.userInfo.zxOpenStatus intValue];
    switch (step)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:isP2P ? P2PTIP1 : ZXTIP1];
            return NO;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            [self showHSAlert:isP2P ? P2PTIP2 : ZXTIP2];
            return NO;
        }
            break;
        case 5://特殊用户
        {
            //            FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:[NSString stringWithFormat:@"%@staticRe/remind/withdraw.jsp",SERVER_IP] title:@""];
            //            webController.baseTitleType = @"specialUser";
            //            [self.navigationController pushViewController:webController animated:YES];
            return YES;
        }
            break;
        default:
            return YES;
            break;
    }
}
- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 8000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7001 || alertView.tag == 7000) {
        [self topLeftButtonClick:nil];
    } else if (alertView.tag == 9000) {
        if(buttonIndex == 1){
            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            vc.accoutType = self.accoutType;
            vc.sourceVC = @"ProjectDetailVC";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(alertView.tag == 9001){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
        }
    } else if(alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            NSInteger step = self.accoutType == SelectAccoutTypeP2P ? [SingleUserInfo.loginData.userInfo.openStatus integerValue]: [SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue];
            [helper pushOpenHSType:self.accoutType Step:step nav:self.navigationController];
        }
    }
    
}
- (void)dealloc
{
    
}
@end
