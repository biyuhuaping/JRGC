//
//  UCFInvestmentDetailViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/10.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFInvestmentDetailViewController.h"
#import "UCFInvestDetailModel.h"
#import "FullWebViewController.h"
#import "UCFProjectDetailViewController.h"
#import "UCFNoDataView.h"
#import "UCFPurchaseWebView.h"
#import <QuickLook/QuickLook.h>
#import "QLHeaderViewController.h"
#import "UCFBidDetailRequest.h"
#import "UCFNewProjectDetailViewController.h"
#import "UCFNewTransProjectDetailViewController.h"
@interface UCFInvestmentDetailViewController ()
{
    UCFInvestmentDetailView *_investmentDetailView;
    UCFNoDataView *_nodataView;
    UCF404ErrorView *_errorView;
    NSString *_contractTitle;
    
}
@property(nonatomic,copy)NSString *localFilePath;
@end

@implementation UCFInvestmentDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //zrc 8.24
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    if(self.flagGoRoot==NO)//***qyy
    {
     [self addLeftButton];
    }else{
     [self  addLeftButtonTypeTwoPopRootVC];
    }
    if ([_detailType intValue] == 2) {
        baseTitleLabel.text = self.accoutType == SelectAccoutTypeHoner ? @"购买详情": @"出借详情";
    }else{
        baseTitleLabel.text = self.accoutType == SelectAccoutTypeHoner ? @"认购详情": @"出借详情";
    }
    self.baseTitleType = @"investmentDetail";
    _investmentDetailView = [[UCFInvestmentDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight) detailType:_detailType];
    _investmentDetailView.delegate = self;
    _investmentDetailView.accoutType = self.accoutType;
    [self.view addSubview:_investmentDetailView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    [self.view addSubview:lineView];
    
    self.view.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    
    _errorView = [[UCF404ErrorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight) errorTitle:nil];
    _errorView.delegate = self;
    // 获取网络数据
    [self getInvestNetworkData];
}
//***需要退回到跟视图按钮qyy
- (void)addLeftButtonTypeTwoPopRootVC
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"]forState:UIControlStateNormal];
    
    //[leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getToBackHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem= leftItem;
}
//***需要退回到跟视图按钮qyy
-(void)getToBackHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// 获取网络数据
- (void)getInvestNetworkData
{
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    NSString *strParameters;
    if ([_detailType isEqualToString:@"1"]) {
        strParameters = [NSString stringWithFormat:@"userId=%@&id=%@", userId, self.billId];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdOrderInvestDetail owner:self Type:self.accoutType];
    } else {
        strParameters = [NSString stringWithFormat:@"userId=%@&orderId=%@",userId,self.billId];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdMyTransferDetail owner:self Type:self.accoutType];
    }
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (NSMutableDictionary*)dealwithClaimDic:(NSMutableDictionary*)dic
{
    NSMutableDictionary *retDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"status"] forKey:@"status"];//标状态
    [retDic setValue:dic[@"principalInterest"] forKey:@"allAmt"];//应收总额
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"transfereeYearRate"] forKey:@"annualRate"];//年化
    [retDic setValue:@"" forKey:@"awaitInterest"];//待收利息
    [retDic setValue:@"" forKey:@"awaitPrincipal"];//待收本金
    [retDic setValue:@"" forKey:@"claimsType"];//标类型
    [retDic setValue:dic[@"taotalIntrest"] forKey:@"taotalIntrest"];//预期收益
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"repayPerDate"] forKey:@"currentRepayPerDate"];//最近回款日
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"startInervestTime"] forKey:@"effactiveDate"];//起息日
    
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"prdOrderId"] forKey:@"id"];//订单id
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"tranId"] forKey:@"prdNum"];//转让id
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"totalInvestAmt"] forKey:@"investAmt"];//投资 金额
    [retDic setValue:@"" forKey:@"platformSubsidyExpense"];//平台补偿利率
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"name"] forKey:@"prdName"];//标名称
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"status"] forKey:@"prdClaimsId"];//标id
    [retDic setValue:dic[@"interestTotal"] forKey:@"refundInterest"];//应收利息
    [retDic setValue:dic[@"weiyueTotalAmt"] forKey:@"refundPrepaymentPenalty"];//应收违约金
    [retDic setValue:dic[@"principalTotal"] forKey:@"refundPrincipal"];//应收本金
    
    [retDic setValue:dic[@"refundSummarysCount"] forKey:@"refundSummarysCount"];//回款期数
    [retDic setValue:dic[@"refundSummarysNow"] forKey:@"refundSummarysNow"];//当前期数
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"repayModeText"] forKey:@"repayModeText"];//还款方式
    NSString *repayPeriod = [dic[@"oldPrdClaim"] objectForKey:@"repayPeriodtext"];
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"assigneeDay"] forKey:@"repayPeriod"];//标期限
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"repayPeriodtext"] forKey:@"repayPeriodtext"];//标期限文字
    
    [retDic setValue:[dic[@"transferOrderMess"] objectForKey:@"contributionAmt"] forKey:@"actualInvestAmt"];//shifujine
    // 原标年化收益
    [retDic setValue:[dic[@"oldPrdClaim"] objectForKey:@"annualRate"] forKey:@"oldPrdClaimAnnualRate"];
    // 原标剩余期限
    [retDic setValue:repayPeriod forKey:@"oldPrdClaimRepayPeriod"];
    // 原标还款方式
    [retDic setValue:[dic[@"oldPrdClaim"] objectForKey:@"repayModeText"] forKey:@"oldPrdClaimRepayModeText"];
    // 原标起息日期
    [retDic setValue:[dic[@"oldPrdClaim"] objectForKey:@"loanDate"] forKey:@"oldPrdClaimEffactiveDate"];
    
    NSMutableArray *contractInfoArr = [NSMutableArray arrayWithCapacity:3];
    NSArray *contractInfo = dic[@"transferContractMess"];
    for (NSDictionary *dic in contractInfo) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:5];
        [tempDic setValue:dic[@"contracttitle"] forKey:@"contracttitle"];
        [tempDic setValue:dic[@"signStatus"] forKey:@"signStatus"];
        [tempDic setValue:dic[@"contractContent"] forKey:@"contractContent"];
        [tempDic setValue:[dic objectSafeForKey:@"contractType"] forKey:@"contractType"];
        [tempDic setValue:[dic objectSafeForKey:@"contractDownUrl"] forKey:@"contractDownUrl"];
        [contractInfoArr addObject:tempDic];
    }
    
    [retDic setObject:dic[@"refundSummaryPlan"] forKey:@"refundSummarys"];//回款计划List
    [retDic setObject:contractInfoArr forKey:@"contractClauses"];//合同List
    [retDic setObject:[dic objectSafeForKey:@"buyCueDes"] forKey:@"buyCueDes"];//尊享二次债转提示信息
    return retDic;
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
//    DDLogDebug(@"首页获取最新项目列表：%@",data);
    NSMutableDictionary *dic = [data objectFromJSONString];

    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    DDLogDebug(@"首页获取最新项目列表：%@", dic);
    if (tag.intValue == kSXTagPrdOrderInvestDetail) {
        NSInteger sign = [rstcode integerValue];
        if (sign == 1) {
            UCFInvestDetailModel *model = [UCFInvestDetailModel investDetailWithDict:dic[@"data"]];
            _investmentDetailView.investDetailModel = model;
            //[_nodataView hide];
            [_errorView hide];
        }
        else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    } else  if (tag.intValue == kSXTagPrdMyTransferDetail) {
        NSInteger sign = [rstcode integerValue];
        if (sign == 1) {
            NSDictionary *inDic = [self dealwithClaimDic:dic];
            UCFInvestDetailModel *model = [UCFInvestDetailModel investDetailWithDict:inDic];
            _investmentDetailView.investDetailModel = model;
            //[_nodataView hide];
            [_errorView hide];
        }
        else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }else if (tag.intValue == kSXTagPrdClaimsGetPrdBaseDetail) {
        NSDictionary *dataDic = [dic objectSafeForKey:@"data"];
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode boolValue])
        {
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dataDic isTransfer:NO withLabelList:nil];
            controller.sourceVc = @"investmentDetail";
            controller.accoutType = self.accoutType;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    } else if (tag.intValue == kSXTagPrdTransferDetail) {
        if ([rstcode intValue] == 1) {
            
//            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:YES withLabelList:nil];
//            controller.sourceVc = @"investmentDetail";
//            //controller.detailType = PROJECTDETAILTYPEBONDSRRANSFER;
//            controller.accoutType = self.accoutType;
//            [self.navigationController pushViewController:controller animated:YES];
//            
//            return;
            UCFTransBidInfoModel *model = [UCFTransBidInfoModel yy_modelWithJSON:result];
            NSString *rsttext = model.statusdes;
            NSString *bidStatue = @"";
            switch ([_investmentDetailView.investDetailModel.status integerValue]) {
                case 0:
                    bidStatue = @"未审核";
                    break;
                case 1:
                    bidStatue = @"等待确认";
                    break;
                case 2:
                    bidStatue = @"招标中";
                    break;
                case 3:
                    bidStatue = @"流标";
                    break;
                case 4:
                    bidStatue = @"满标";
                    break;
                case 5:
                    bidStatue = @"回款中";
                    break;
                case 6:
                    bidStatue = @"已回款";
                    break;
            }
            
            
            if (model.status == 1) {
                UCFNewTransProjectDetailViewController *vc = [[UCFNewTransProjectDetailViewController alloc] init];
                vc.model = model;
                vc.model.prdTransferFore.modelStatue = bidStatue;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                if (![rsttext isEqualToString:@""] && rsttext) {
                    [AuxiliaryFunc showToastMessage:model.statusdes withView:self.view];
                }
            }
            
            

        }else {
            [AuxiliaryFunc showAlertViewWithMessage:@"产品标不存在，请检查(或者不能非法操作)"];
        }
    }else if(tag.intValue == kSXTagGetContractMsg) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSDictionary *dictionary =  [dic objectSafeDictionaryForKey:@"contractMess"];
        NSString *status = [dic objectSafeForKey:@"status"];
        if ([status intValue] == 1) {
            NSString *contractMessStr = [dictionary objectSafeForKey:@"contractMess"];
            [self showContractHtmlStr:contractMessStr withTitle:_contractTitle];
        }else{
            [self showHTAlertdidFinishGetUMSocialDataResponse];
        }
    } else if (tag.intValue == kSXTagContractDownLoad) {
        
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
//#pragma mark QLPreviewControllerDataSource
//- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
//    return 1;
//}
//- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
//    NSArray *arr = @[_localFilePath];
//    
//    return [NSURL fileURLWithPath:arr[index]];
//}
- (void)showHTAlertdidFinishGetUMSocialDataResponse
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录www.gongchangp2p.com相关页面查看" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagPrdOrderInvestDetail) {
        [_errorView showInView:self.view];
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)investmentDetailView:(UCFInvestmentDetailView *)investmentDetailView didSelectConstractDetailWithModel:(UCFConstractModel *)constract
{
//    if([constract.contractContent isEqualToString:@"" ] || constract.contractContent == nil){
//        //合同的内容为空时 弹框提示
//        UIAlertView *alerView =[[ UIAlertView alloc]initWithTitle:@"提示" message:@"请登录www.9888.cn相关页面查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alerView show];
//        return ;
//    }
    
    if (self.accoutType == SelectAccoutTypeP2P) {
        
        if ([constract.contractDownUrl isEqualToString:@""] || constract.contractDownUrl ==nil ) {//如果合同url不存在的情况
            if ([constract.signStatus boolValue]) {
                NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdOrderId=%@&contractType=%@&prdType=0",SingleUserInfo.loginData.userInfo.userId,self.billId,constract.contractType];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagContractDownLoad owner:self Type:self.accoutType];
                return;
            }else{
                _contractTitle = constract.contracttitle;
                NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdOrderId=%@&contractType=%@&prdType=0",SingleUserInfo.loginData.userInfo.userId,self.billId,constract.contractType];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetContractMsg owner:self Type:self.accoutType];
            }
        }
        if (![constract.contractDownUrl isEqualToString:@""] && constract.contractDownUrl !=nil ) {//如果合同url存在的情况
            [self showContractWebViewUrl:constract.contractDownUrl withTitle:constract.contracttitle];
            return;
        }

    }else{
        if (![constract.contractContent isEqualToString:@""] && constract.contractContent !=nil) {//如果合同内容 存在的情况
            [self showContractHtmlStr:constract.contractContent withTitle:constract.contracttitle];
            return;
        }
        _contractTitle = constract.contracttitle;
        NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdOrderId=%@&contractType=%@&prdType=0",SingleUserInfo.loginData.userInfo.userId,self.billId,constract.contractType];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagContractDownLoad owner:self Type:self.accoutType];
        return;
        
//        _contractTitle = constract.contracttitle;
//        NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdOrderId=%@&contractType=%@&prdType=0",SingleUserInfo.loginData.userInfo.userId,self.billId,constract.contractType];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetContractMsg owner:self Type:self.accoutType];
        
    }
}
-(void)showContractHtmlStr:(NSString *)content withTitle:(NSString *)title
{
    FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:content title:title];
    controller.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark H5URl加载方式
-(void)showContractWebViewUrl:(NSString *)urlStr withTitle:(NSString *)title
{
    FullWebViewController *controller = [[FullWebViewController alloc] initWithWebUrl:urlStr    title:title];
    controller.baseTitleType = @"detail_heTong";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)headBtnClicked:(id)sender selectViewId:(NSString *)uuid state:(NSString *)state
{
    if ([_detailType isEqualToString:@"1"])
    {
        NSString *prdClaimsIdStr = [NSString stringWithFormat:@"%@",uuid];
//        NSDictionary *praramDic = @{@"userId":SingleUserInfo.loginData.userInfo.userId,@"prdClaimsId":prdClaimsIdStr};
//                [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdBaseDetail owner:self signature:YES Type:self.accoutType];
//        return;
        UCFBidDetailRequest *api = [[UCFBidDetailRequest alloc] initWithProjectId:prdClaimsIdStr];
        api.animatingView = self.parentViewController.view;
        @PGWeakObj(self);
        [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            UCFBidDetailModel *model =  request.responseJSONModel;
            NSString *message = model.message;
            if (model.ret) {
                UCFNewProjectDetailViewController *vc = [[UCFNewProjectDetailViewController alloc] init];
                vc.model = model;
                vc.accoutType = SelectAccoutTypeP2P;
                vc.sourceType = @"2";
                [selfWeak.navigationController pushViewController:vc animated:YES];
            } else {
                [AuxiliaryFunc showAlertViewWithMessage:message];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        [api start];
        
        
    } else {
        
        NSString *strParameters = [NSString stringWithFormat:@"tranid=%@&userId=%@",uuid,SingleUserInfo.loginData.userInfo.userId];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdTransferDetail owner:self Type:self.accoutType];
    }
}

#pragma mark _errorDelegate

- (void)refreshBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    [self getInvestNetworkData];
}

@end
