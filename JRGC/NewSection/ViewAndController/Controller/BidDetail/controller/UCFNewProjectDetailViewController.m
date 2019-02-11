//
//  UCFNewProjectDetailViewController.m
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewProjectDetailViewController.h"
#import "UCFBidDetailNavView.h"
#import "UVFBidDetailViewModel.h"
#import "UCFNewBidDetaiInfoView.h"
#import "UCFRemindFlowView.h"
#import "MinuteCountDownView.h"
#import "UCFSettingArrowItem.h"
#import "UCFProjectInvestmentRecordViewController.h"
#import "UCFProjectSafetyGuaranteeViewController.h"
#import "UCFProjectBasicDetailViewController.h"
#import "UCFNewInvestBtnView.h"
@interface UCFNewProjectDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NetworkModuleDelegate,UCFBidDetailNavViewDelegate>
@property(nonatomic, strong)BaseTableView *showTableView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)UCFNewBidDetaiInfoView *bidinfoView;
@property(nonatomic, strong)UCFRemindFlowView *remind;
@property(nonatomic, strong)UCFBidDetailNavView *navView;
@property(nonatomic, strong)UVFBidDetailViewModel *VM;

@property(nonatomic, strong)MyRelativeLayout *contentLayout;
@property(nonatomic, strong)MinuteCountDownView *minuteCountDownView;
@property(nonatomic, strong)UCFNewInvestBtnView *investView;
@end

@implementation UCFNewProjectDetailViewController
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
    remind.backgroundColor = [UIColor clearColor];
    remind.subviewVSpace = 5;
    remind.subviewHSpace = 5;
    self.remind = remind;
    [self.contentLayout addSubview:remind];
   
    //是P2p 并且不是
//    if(_isP2P && _type != PROJECTDETAILTYPEBONDSRRANSFER){
    _minuteCountDownView = [[[NSBundle mainBundle] loadNibNamed:@"MinuteCountDownView" owner:nil options:nil] firstObject];

    _minuteCountDownView.topPos.equalTo(remind.bottomPos);
    _minuteCountDownView.myHorzMargin = 0;
    _minuteCountDownView.heightSize.equalTo(@45);
    _minuteCountDownView.isStopStatus = @"0";
    [_minuteCountDownView startTimer];
    _minuteCountDownView.sourceVC = @"UCFProjectDetailVC";//投资页面
    [self.contentLayout addSubview:self.minuteCountDownView];

//    }
    contentLayout.heightSize.equalTo(@(155 + 40 + 45));

    self.showTableView.topPos.equalTo(self.navView.bottomPos);
    self.showTableView.bottomPos.equalTo(@57);
    self.showTableView.myHorzMargin = 0;
    self.showTableView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
    [self.rootLayout addSubview:self.showTableView];
    
    self.showTableView.tableHeaderView = contentLayout;
    
    UCFNewInvestBtnView *investView = [[UCFNewInvestBtnView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 57)];
    investView.topPos.equalTo(self.showTableView.bottomPos);
    investView.myHorzMargin = 0;
    investView.rightPos.equalTo(@0);
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
    
    [self.navView blindVM:self.VM];
    
    [self.bidinfoView blindVM:self.VM];
    
    [self.remind blindVM:self.VM];
    
    [self.minuteCountDownView blindVM:self.VM];
    
    [self.investView blindVM:self.VM];
    
    [self blindVM:self.VM];
    
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

    [self.showTableView reloadData];
}
- (UVFBidDetailViewModel *)VM
{
    if (!_VM) {
        _VM = [UVFBidDetailViewModel new];
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
        footView.backgroundColor = [UIColor whiteColor];
        [Common addLineViewColor:[Color color:PGColorOptionCellSeparatorGray] WithView:footView isTop:NO];
        return footView;
    } else {
        return nil;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        headView.backgroundColor = [UIColor whiteColor];
        [Common addLineViewColor:[Color color:PGColorOptionCellSeparatorGray] WithView:headView isTop:YES];
        return headView;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        headView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        return nil;
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
            
            UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, ScreenWidth -15, 0.5)];
            bottomLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
            bottomLineView.tag = 1000;
            [cell addSubview:bottomLineView];
        }

        NSArray *arr =  self.dataArray[indexPath.section];
        UIView *bottomLineView = [cell viewWithTag:1000];
        if (indexPath.row == arr.count - 1) {
            bottomLineView.hidden = YES;
        } else {
            bottomLineView.hidden = NO;
        }
        
        UCFSettingArrowItem *model = arr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:model.icon];
        cell.textLabel.text = model.title;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
            NSString *prdClaimsIdStr = self.model.data.ID;
            NSDictionary *praramDic = @{@"userId":userid,@"prdClaimsId":prdClaimsIdStr};
            [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdDetailMess owner:self signature:YES Type:self.accoutType];
            
        } else if (indexPath.row == 1) {
            UCFProjectSafetyGuaranteeViewController *basicDetailVC = [[UCFProjectSafetyGuaranteeViewController alloc]initWithNibName:@"UCFProjectSafetyGuaranteeViewController" bundle:nil];
            NSMutableArray *dictArr = [NSMutableArray arrayWithCapacity:1];
            for (DetailSafetysecuritylist *safeModel in self.model.data.safetySecurityList) {
                NSDictionary *dict = @{@"title":safeModel.title,@"content":safeModel.content};
                [dictArr addObject:dict];
            }
            basicDetailVC.dataArray = dictArr;
            basicDetailVC.accoutType = self.accoutType;
            basicDetailVC.accoutType = self.accoutType;
            [self.navigationController  pushViewController:basicDetailVC animated:YES];
        } else {
            UCFProjectInvestmentRecordViewController *investmentRecordVC = [[UCFProjectInvestmentRecordViewController alloc]initWithNibName:@"UCFProjectInvestmentRecordViewController" bundle:nil];
            investmentRecordVC.accoutType = self.accoutType;
            if ([self.model.data.busType isEqualToString:@"1"]) {
                _detailType = PROJECTDETAILTYPERIGHTINTEREST;
            } else {
                _detailType = PROJECTDETAILTYPENORMAL;
            }
            investmentRecordVC.detailType = _detailType;
            investmentRecordVC.prdClaimsId = self.model.data.ID;
            [self.navigationController  pushViewController:investmentRecordVC animated:YES];
        }
    }
}
-(void)beginPost:(kSXTag)tag
{
    
}
-(void)endPost:(id)result tag:(NSNumber*)tag
{
    if(tag.intValue == kSXTagPrdClaimsGetPrdDetailMess) {
        NSDictionary * dic = [(NSString *)result objectFromJSONString];
        NSDictionary *dataDic = [dic objectSafeForKey:@"data"];
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode boolValue])
        {
            UCFProjectBasicDetailViewController *basicDetailVC = [[UCFProjectBasicDetailViewController alloc]initWithNibName:@"UCFProjectBasicDetailViewController" bundle:nil];
            basicDetailVC.dataDic = dataDic;
            basicDetailVC.detailType = _detailType;
            basicDetailVC.accoutType = self.accoutType;
            basicDetailVC.projectId = [NSString stringWithFormat:@"%@",self.model.data.ID];
            basicDetailVC.tradeMark = self.model.data.tradeMark;
            basicDetailVC.prdDesType= [self.model.data.prdDesType boolValue];
            [self.navigationController  pushViewController:basicDetailVC animated:YES];
        }else{
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    
}
- (void)dealloc
{
    
}
@end
