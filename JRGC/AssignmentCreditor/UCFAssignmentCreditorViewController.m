//
//  UCFAssignmentCreditorViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/8.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFAssignmentCreditorViewController.h"
#import "AssignmentCell.h"
#import "UCFProjectDetailViewController.h"
#import "UCFLoginViewController.h"
#import "UCFPurchaseTranBidViewController.h"
//#import "IDAuthViewController.h"
//#import "BindBankCardViewController.h"
#import "UCF404ErrorView.h"
#import "UCFNoPermissionViewController.h"
#import "UCFToolsMehod.h"
#import "UIImageView+NetImageView.h"

#import "UCFOldUserGuideViewController.h"//升级存管账户
#import "UCFBankDepositoryAccountViewController.h" //微商银行存管专题页面
#import "FullWebViewController.h"
@interface UCFAssignmentCreditorViewController ()<AssignmentCellDelegate,FourOFourViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *imaView;
@property (strong, nonatomic) NSMutableArray *investmentArr;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSIndexPath *indexPath;//选中了哪一行
@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;//提示label
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipsViewHeight;//提示View的身高


// 404错误界面
//@property (strong, nonatomic) UCF404ErrorView *errorView;

@end

@implementation UCFAssignmentCreditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _investmentArr = [NSMutableArray new];
    _dataArr = [NSMutableArray new];
    _pageNum = 1;
    self.navigationController.navigationBar.translucent = NO;
    
    // Do any additional setup after loading the view.
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*5/16);
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    

    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
//    [_tableView addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [weakSelf getPrdClaimsDataList];
//    }];
    
    // 添加上拉加载更多
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getPrdClaimsDataList];
    }];
    
    [_tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getPrdClaimsDataList)];

    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
//    [self getPrdClaimsDataList];
    _tableView.footer.hidden = YES;
    
//    _errorView = [[UCF404ErrorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44) errorTitle:nil];
//    _errorView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginShowLoading) name:@"AssignmentUpdate" object:nil];

    _imaView.contentMode = UIViewContentModeScaleToFill;
    [_imaView getBannerImageStyle:BidTransfer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)beginShowLoading {
    [_tableView.header beginRefreshing];
}

//点击提示View调用方法
- (IBAction)touchTipsView:(id)sender {
    switch ([UserInfoSingle sharedManager].openStatus) {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
            bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
            [self.navigationController pushViewController:bankDepositoryAccountVC animated:YES];
        }
            break;
        case 3://已绑卡-->>>去设置交易密码页面
        {
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}
- (BOOL)checkUserCanInvest
{
    switch ([UserInfoSingle sharedManager].openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:@"请先开通徽商存管账户"];
            return NO;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            [self showHSAlert:@"请先设置交易密码"];
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
    if (alertView.tag == 7000) {
        [self beginShowLoading];
    } else if (alertView.tag == 8000) {
            if (buttonIndex == 1) {
                switch ([UserInfoSingle sharedManager].openStatus)
                {// ***hqy添加
                    case 1://未开户-->>>新用户开户
                    case 2://已开户 --->>>老用户(白名单)开户
                    {
                        UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
                        bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
                        [self.navigationController pushViewController:bankDepositoryAccountVC animated:YES];
                    }
                        break;
                    case 3://已绑卡-->>>去设置交易密码页面
                    {
                        UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                }
            }
        
    }
}

#pragma mark - UITableViewDelegate
// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _investmentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *indentifier = @"AssignmentCell";
    
    AssignmentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AssignmentCell" owner:self options:nil][0];
        cell.delegate = self;
    }
    cell.investButton.tag = 100 + indexPath.row;
    UCFTransterBid *info = _investmentArr[indexPath.row];
    [cell setTransterInfo:info];
    return cell;
}
- (BOOL)checkBidDetailCanCheck
{
    switch ([UserInfoSingle sharedManager].openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:@"请先开通徽商存管账户"];
            return NO;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            return YES;
        }
            break;
        case 5://特殊用户
        {
            return YES;
        }
            break;
        default:
            return YES;
            break;
    }
}
// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        if ([self checkBidDetailCanCheck]) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            _indexPath = indexPath;
            UCFTransterBid * info = [_investmentArr objectAtIndex:[indexPath row]];
            NSInteger status = [info.status integerValue];
            
            NSString *strParameters = [NSString stringWithFormat:@"tranid=%@&userId=%@",info.transtrId,[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
            if (status != 0) {
                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前债权转让的详情只对投资人开放"];
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdTransferDetail owner:self Type:SelectAccoutDefault];
            }
        }
    }
}
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
- (void)investBtnClicked:(UIButton *)button
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginNaviController animated:YES completion:nil];
    } else {
        if ([self checkUserCanInvest]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSInteger tag = button.tag - 100;
            if (tag < self.investmentArr.count) {
                UCFTransterBid * info = [_investmentArr objectAtIndex:tag];            //普通表
                NSString *projectId = info.transtrId;
                //方法
                NSString *strParameters = nil;
                strParameters = [NSString stringWithFormat:@"userId=%@&tranId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],projectId];//101943
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagDealTransferBid owner:self Type:SelectAccoutDefault];
            }
        }
    }
}
#pragma mark - 请求网络及回调
//获取prdClaims/dataList
- (void)getPrdClaimsDataList
{
    if (_tableView.header.isRefreshing) {
        _pageNum = 1;
    }else if (_tableView.footer.isRefreshing){
        _pageNum++;
    }
    NSString *strParameters = [NSString stringWithFormat:@"page=%d&rows=20&userId=%@",_pageNum,[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdTransfer owner:self Type:SelectAccoutDefault];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [GiFHUD show];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [GiFHUD dismiss];
    NSString *data = (NSString *)result;

    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    DBLOG(@"债权转让项目列表：%@",dic);

    if (tag.intValue == kSXTagPrdTransfer) {
        _tableView.footer.hidden = NO;
//        [_errorView hide];
        if ([rstcode intValue] == 1) {
            [_investmentArr removeAllObjects];
            if (_pageNum == 1) {
                _dataArr = [NSMutableArray arrayWithArray:dic[@"pageData"][@"result"]];
            }else{
                [_dataArr addObjectsFromArray:dic[@"pageData"][@"result"]];
            }
            for (int i = 0; i < _dataArr.count; i++) {
                UCFTransterBid *info = [[UCFTransterBid alloc]initWithDictionary:_dataArr[i]];
                info.isAnim = YES;
                [_investmentArr addObject:info];
            }
            [_tableView reloadData];
//            NSString *bannerUrl = dic[@"link"];
//            [_imaView sd_setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@"pic404"]];
//            if([bannerUrl hasPrefix:@"http://"]){
//                _imaView.contentMode = UIViewContentModeScaleToFill;
//            }else{
//                _imaView.contentMode = UIViewContentModeCenter;
//            }
            
            //============ tips提示 ============
            if([[NSUserDefaults standardUserDefaults] objectForKey:UUID]){//登录状态下，显示tipView
                //个人中心接口添加开户装填
                NSString *openStatusStr = [dic objectSafeForKey:@"openStatus"];
                [UserInfoSingle sharedManager].openStatus = [openStatusStr integerValue];
                //暂时添加，未调试接口 *** hqy
                if([openStatusStr intValue] > 3 ){
                    _tipsViewHeight.constant = 0;
                }else{
                    _tipsViewHeight.constant = 35.0f;
                }
                NSString *tipsDesStr = [dic objectSafeForKey:@"tipsDes"];//tips提示
                if (![tipsDesStr isEqualToString:@""]) {
                    _tipsLabel.text = tipsDesStr;
                }
            }else{
                _tipsViewHeight.constant = 0;
            }
            
            // 2秒后刷新表格UI
            [UIView animateWithDuration:0.25 animations:^{
                _headerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*5/16 + _tipsViewHeight.constant);
                _tableView.tableHeaderView = _headerView;
                DBLOG(@"===%@",NSStringFromCGRect(_headerView.frame));
            }];
            
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    } else if (tag.intValue == kSXTagPrdTransferDetail) {
        if ([rstcode intValue] == 1) {
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:YES withLabelList:nil];
            controller.sourceVc = @"transiBid";
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }else if(tag.intValue == kSXTagDealTransferBid) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] integerValue] == 1)
        {
            UCFPurchaseTranBidViewController *purchaseViewController = [[UCFPurchaseTranBidViewController alloc] initWithNibName:@"UCFPurchaseTranBidViewController" bundle:nil];
            purchaseViewController.dataDict = dic;
            purchaseViewController.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:purchaseViewController animated:YES];
        } else if ([dic[@"status"] integerValue] == 3 || [dic[@"status"] integerValue] == 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 7000;
            [alert show];
        } else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
//    [_errorView showInView:self.view];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    [GiFHUD dismiss];
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

// 404错误界面的代理方法
- (void)refreshBtnClicked:(id)sender fatherView:(UIView*)fhView{
    [self getPrdClaimsDataList];
}

@end
