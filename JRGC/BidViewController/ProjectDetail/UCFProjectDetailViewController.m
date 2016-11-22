//
//  UCFProjectDetailViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/10.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//  标详情页面

#import "UCFProjectDetailViewController.h"
#import "UCFPurchaseBidViewController.h"
#import "UCFLoginViewController.h"
#import "FullWebViewController.h"
#import "UCFToolsMehod.h"
#import "UCFPurchaseTranBidViewController.h"

//#import "BindBankCardViewController.h"
#import "AppDelegate.h"
#import "UCFInvestmentView.h"
#import "UIImage+Misc.h"
#import "UCFBankDepositoryAccountViewController.h"
#import "UCFOldUserGuideViewController.h"
@interface UCFProjectDetailViewController ()
{
    UCFNormalNewMarkView *_normalMarkView;// 普通标
    UCFMarkOfBondsRransferNewView *_markOfBondsRransferView;//债转标
    UCFRightInterestNewView *_normalMarkOfRightsInterestView; // 权益标
    NSDictionary *_dataDic;
    BOOL _isTransfer;//是否债权转让
    NSArray *_prdLabelsList;
    NSArray *_contractMsgArray;
    
    NSTimer *updateTimer;
    CGFloat Progress;
    CGFloat curProcess;
    BOOL _isP2P;//YES 为P2P标，NO为尊享标
}


@property(nonatomic,strong)UIImageView *navigationStyleBar;

@end

@implementation UCFProjectDetailViewController

- (id)initWithDataDic:(NSDictionary *)dic isTransfer:(BOOL)isTransfer withLabelList:(NSArray *)labelList
{
    self = [super init];
    if (self) {
        self.baseTitleType = @"detail";
        _dataDic = dic;
        curProcess = 0;
        _isTransfer = isTransfer;
        if (isTransfer) {
            self.baseTitleType = @"Transdetail";
        }
        _prdLabelsList = [[dic objectForKey:@"prdClaims"] objectForKey:@"prdLabelsList"];
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}

- (void)setNavTitleView
{
    UIView *titleBkView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *baseTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    baseTitleLabel1.textAlignment = NSTextAlignmentCenter;
    [baseTitleLabel1 setTextColor:[UIColor whiteColor]];
    [baseTitleLabel1 setBackgroundColor:[UIColor clearColor]];
    baseTitleLabel1.font = [UIFont systemFontOfSize:18];
    
    UILabel *baseChildTitleLabel1 = [[UILabel alloc] init];
    baseChildTitleLabel1.textAlignment = NSTextAlignmentCenter;
    [baseChildTitleLabel1 setTextColor:[UIColor whiteColor]];
    [baseChildTitleLabel1 setBackgroundColor:UIColorWithRGB(0x28335c)];
    baseChildTitleLabel1.layer.borderColor = [UIColor whiteColor].CGColor;
    baseChildTitleLabel1.layer.borderWidth = 1.0;
    baseChildTitleLabel1.layer.cornerRadius = 2.0;
    baseChildTitleLabel1.font = [UIFont systemFontOfSize:12];
    
    [titleBkView addSubview:baseTitleLabel1];
    [titleBkView addSubview:baseChildTitleLabel1];
    
    NSString *titleStr = @"";
    NSString *childLabelStr = @"";
    
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER){
        titleStr = [[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"name"];
    } else {
        titleStr = [[_dataDic objectForKey:@"prdClaims"] objectForKey:@"prdName"];
        //取得一级标签
        if (![_prdLabelsList isEqual:[NSNull null]]) {
            for (NSDictionary *dic in _prdLabelsList) {
                NSString *labelPriority  = [dic objectForKey:@"labelPriority"];
                if ([labelPriority isEqual:@"1"]) {
                    childLabelStr = [dic objectForKey:@"labelName"];
                }
            }
        }
    }
    
    CGFloat stringWidth = [titleStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}].width;
    CGFloat childStringWidth = [childLabelStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].width;
    
    CGRect bkFrame = titleBkView.frame;
    CGFloat bkTitleWidth;
    if (childStringWidth != 0) {
        bkTitleWidth = stringWidth + childStringWidth + TitleXDistance + MarkInSpacing;
        baseTitleLabel1.frame = CGRectMake(0, 0, stringWidth, 18);
        baseChildTitleLabel1.frame = CGRectMake(stringWidth + TitleXDistance, 0, childStringWidth + MarkInSpacing, 18);
    } else {
        bkTitleWidth = stringWidth;
        baseTitleLabel1.frame = CGRectMake(0, 0, stringWidth, 18);
        baseChildTitleLabel1.frame = CGRectMake(stringWidth, 0, childStringWidth, 18);
    }
    bkFrame.size.width = bkTitleWidth;
    bkFrame.size.height = 18;
    
    titleBkView.frame = bkFrame;
    baseTitleLabel1.text = titleStr;
    baseChildTitleLabel1.text = childLabelStr;
    
    [_navigationStyleBar addSubview:titleBkView];
    titleBkView.center = _navigationStyleBar.center;
    CGRect tempRect = titleBkView.frame;
    tempRect.origin.y = 28;
    titleBkView.frame = tempRect;
}
//自定义navigationbar
- (void) addnavigationBar
{
    CGFloat scaleFlot = 1;
    if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        scaleFlot = 1.171875;
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        scaleFlot =  1.29375;
    }
    _navigationStyleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight)];
    _navigationStyleBar.image = [UIImage imageNamed:@"particular_bg_1"];
    [self.view addSubview:_navigationStyleBar];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 24, 25, 25)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    //[leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationStyleBar addSubview:leftButton];
    _navigationStyleBar.userInteractionEnabled = YES;
}

- (void) getBack
{
    if (kIS_IOS7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = YES;
    
    if (_isTransfer) {
        _detailType = PROJECTDETAILTYPEBONDSRRANSFER;
    } else {
        NSInteger busType = [[[_dataDic objectForKey:@"prdClaims"] objectForKey:@"busType"]integerValue];
        if (busType == 1) {
            _detailType = PROJECTDETAILTYPERIGHTINTEREST;
        } else {
            _detailType = PROJECTDETAILTYPENORMAL;
        }
    }
    NSString *type = [[_dataDic objectSafeDictionaryForKey:@"prdClaims"] objectSafeForKey:@"type"];
    if ([type isEqualToString:@"1"]) {
        _isP2P = YES;
    }else{
        _isP2P = NO;
    }
    [self addnavigationBar];
    [self setNavTitleView];
    
    
    NSString *tansType = @"1";
    switch (_detailType) {
        case PROJECTDETAILTYPENORMAL://普通标详情
            [self makeContractMsg:[_dataDic objectForKey:@"contractMsg"] tp:@"1"];
            _normalMarkView = [[UCFNormalNewMarkView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, ScreenWidth, ScreenHeight - NavigationBarHeight) withDic:_dataDic prdList:_prdLabelsList contractMsg:_contractMsgArray souceVc:_sourceVc isP2P:_isP2P];
            _normalMarkView.delegate = self;
            [self.view addSubview:_normalMarkView];
            break;
        case PROJECTDETAILTYPERIGHTINTEREST://RightInterestNewView 权益表详情
            [self makeContractMsg:[_dataDic objectForKey:@"contractMsg"] tp:@"2"];
            _normalMarkOfRightsInterestView = [[UCFRightInterestNewView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - NavigationBarHeight) withDic:_dataDic prdList:_prdLabelsList contractMsg:_contractMsgArray souceVc:_sourceVc isP2P:_isP2P];
            _normalMarkOfRightsInterestView.delegate = self;
            [self.view addSubview:_normalMarkOfRightsInterestView];
            break;
        case PROJECTDETAILTYPEBONDSRRANSFER://债转标详情  tansType 债权转让原标类型 1 普通标 2 权益标
            if ([[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"busType"] isEqualToString:@"1"]) {
                tansType = @"2";
                [self makeContractMsg:[_dataDic objectForKey:@"contractMsg"] tp:@"4"];
            } else {
                [self makeContractMsg:[_dataDic objectForKey:@"contractMsg"] tp:@"3"];
            }
            _markOfBondsRransferView = [[UCFMarkOfBondsRransferNewView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, ScreenWidth, ScreenHeight - NavigationBarHeight) withDic:_dataDic prdList:_prdLabelsList contractMsg:_contractMsgArray souceVc:_sourceVc type:tansType];
            _markOfBondsRransferView.delegate = self;
            [self.view addSubview:_markOfBondsRransferView];
            break;
        default:
            break;
    }
    //进度条的动画
    [self progressAnimiation];
}



- (void)progressAnimiation
{
    double borrowAmount;
    double completeLoan;
    //债权转让和其他2种标获取不一样
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER) {
        borrowAmount = [[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"planPrincipalAmt"] doubleValue];
        completeLoan = [[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"realPrincipalAmt"] doubleValue];
        CGFloat prors = [[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"completeRate"] doubleValue] / 100;
        Progress = prors;
    } else {
        borrowAmount = [[[_dataDic objectForKey:@"prdClaims"] objectForKey:@"borrowAmount"] doubleValue];
        completeLoan = [[[_dataDic objectForKey:@"prdClaims"] objectForKey:@"completeLoan"] doubleValue];
        Progress = completeLoan / borrowAmount;
    }
    if (Progress > 0.98 && Progress < 1.0) {
        Progress = 0.98;
    } else if (Progress > 0.97 && Progress < 0.98) {
        Progress = 0.97;
    }
    [self performSelector:@selector(beginUpdatingProgressView) withObject:nil afterDelay:0.1];
}

- (void)beginUpdatingProgressView
{
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}

- (void)updateProgress:(NSTimer *)timer
{
    if (fabs(curProcess - Progress) < 0.01) {
        if (_detailType == PROJECTDETAILTYPENORMAL) {
            [_normalMarkView setProcessViewProcess:Progress];
        } else if (_detailType == PROJECTDETAILTYPERIGHTINTEREST) {
            [_normalMarkOfRightsInterestView setProcessViewProcess:Progress];
        } else {
            [_markOfBondsRransferView setProcessViewProcess:Progress];
        }
        [timer invalidate];
    } else {
        if (_detailType == PROJECTDETAILTYPENORMAL) {
            [_normalMarkView setProcessViewProcess:curProcess + 0.01];
        } else if (_detailType == PROJECTDETAILTYPERIGHTINTEREST) {
            [_normalMarkOfRightsInterestView setProcessViewProcess:curProcess + 0.01];
        } else {
            [_markOfBondsRransferView setProcessViewProcess:curProcess + 0.01];
        }
        curProcess = curProcess + 0.01;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGFloat scaleFlot = 1;
    if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        scaleFlot = 1.171875;
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        scaleFlot =  1.29375;
    }
    if (_detailType == PROJECTDETAILTYPENORMAL) {
        [_normalMarkView cretateInvestmentView];
        UIScrollView *tempView = (UIScrollView*)[_normalMarkView viewWithTag:1001];
        if (tempView) {
            if (tempView.frame.origin.y == 0) {
                _navigationStyleBar.image = [UIImage imageNamed:@"particular_bg_1"];
            }
        }
        
    } else if (_detailType == PROJECTDETAILTYPERIGHTINTEREST) {
        [_normalMarkOfRightsInterestView cretateInvestmentView];
        UIScrollView *tempView = (UIScrollView*)[_normalMarkOfRightsInterestView viewWithTag:1001];
        if (tempView) {
            if (tempView.frame.origin.y == 0) {
                _navigationStyleBar.image = [UIImage imageNamed:@"particular_bg_1"];
            }
        }
    } else {
        [_markOfBondsRransferView cretateInvestmentView];
        UIScrollView *tempView = (UIScrollView*)[_markOfBondsRransferView viewWithTag:1001];
        if (tempView) {
            if (tempView.frame.origin.y == 0) {
                _navigationStyleBar.image = [UIImage imageNamed:@"particular_bg_1"];
            }
        }
    }
    //自定义Nav 放到最上面
    [self.view bringSubviewToFront:_navigationStyleBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)styleGetToBack
{
    if (kIS_IOS7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -友盟分享

//- (void)clickRightBtn
//{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"544b0681fd98c525ad0372f2"
//                                      shareText:@"test"
//                                     shareImage:nil
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToTencent,UMShareToRenren,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil]
//                                       delegate:self];
//}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    if (response.responseCode == UMSResponseCodeSuccess) {
//        NSLog(@"分享成功！");
//    }
//}

//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//    //根据url创建一个UMSocialUrlResource对象；resourceType：多媒体资源类型，图片、音乐或者视频；urlString：url字符串
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://img0.pcgames.com.cn/pcgames/1407/07/4057451_1_thumb.jpg"];
//    if (platformName == UMShareToSina) {
//        socialData.urlResource = urlResource;
//    }
//    else{
//        socialData.urlResource = urlResource;
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.9888.cn";
//    }
//}


- (void)makeContractMsg:(NSDictionary*)msg tp:(NSString*)tp
{
    DLog(@"%@",msg);
    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:3];
    if ([tp isEqualToString:@"1"] || [tp isEqualToString:@"2"]) {
        if ([UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"borrowContractName"]]) {
            NSMutableDictionary *tempdic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tempdic setValue:[UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"borrowContract"]] forKey:@"content"];
            
            NSString *title = [UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"borrowContractName"]];
            [tempdic setValue:title forKey:@"title"];
            if ([tp isEqualToString:@"2"]) {
                [tempdic setValue:@"particular_icon_transfer.png" forKey:@"image"];
            } else {
                [tempdic setValue:@"particular_icon_agreement.png" forKey:@"image"];
            }
            
            if (![title isEqualToString:@""]) {
                [returnArray addObject:tempdic];
            }
        }
        
        if ([UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"borrowerConsultingName"]]) {
            NSMutableDictionary *tempdic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tempdic setValue:[UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"borrowerConsulting"]] forKey:@"content"];
            
            NSString *title = [UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"borrowerConsultingName"]];
            [tempdic setValue:title forKey:@"title"];
            [tempdic setValue:@"particular_icon_protocol.png" forKey:@"image"];
            if (![title isEqualToString:@""]) {
                [returnArray addObject:tempdic];
            }
        }
        
        if ([UCFToolsMehod isNullOrNilWithString:[_dataDic valueForKey:@"insName"]]) {
            NSMutableDictionary *tempdic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tempdic setValue:[UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"entrustGuarantee"]] forKey:@"content"];
            
            //取出担保公司 担保方式
            NSString *insName = [UCFToolsMehod isNullOrNilWithString:[[_dataDic valueForKey:@"prdClaims"] valueForKey:@"guaranteeCompanyName"]];
            NSString *guaranteeCoverageNane = [UCFToolsMehod isNullOrNilWithString:[[_dataDic valueForKey:@"prdClaims"] valueForKey:@"guaranteeCoverageNane"]];
            [tempdic setValue:insName forKey:@"insName"];
            [tempdic setValue:guaranteeCoverageNane forKey:@"guaranteeCoverageNane"];
            [tempdic setValue:[UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"entrustGuaranteeName"]]forKey:@"title"];
            
            [tempdic setValue:@"particular_icon_guarantee.png" forKey:@"image"];
            if (tempdic && ![tempdic isEqual:[NSNull null]] && ![[tempdic valueForKey:@"insName"] isEqualToString:@""]) {
                [returnArray addObject:tempdic];
            }
        }
        
    } else {
        if ([UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"transferConsultName"]]) {
            NSMutableDictionary *tempdic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tempdic setValue:[UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"transferConsulting"]] forKey:@"content"];
            
            NSString *title = [UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"transferConsultName"]];
            [tempdic setValue:title forKey:@"title"];
            if ([tp isEqualToString:@"4"]) {
                [tempdic setValue:@"particular_icon_transfer.png" forKey:@"image"];
            } else {
                [tempdic setValue:@"particular_icon_agreement.png" forKey:@"image"];
            }
            
            if (![title isEqualToString:@""]) {
                [returnArray addObject:tempdic];
            }
        }
        
        if ([UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"buyerTransferConsultName"]]) {
            NSMutableDictionary *tempdic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tempdic setValue:[UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"buyerTransferConsulting"]] forKey:@"content"];
            
            NSString *title = [UCFToolsMehod isNullOrNilWithString:[msg valueForKey:@"buyerTransferConsultName"]];
            [tempdic setValue:title forKey:@"title"];
            [tempdic setValue:@"particular_icon_protocol.png" forKey:@"image"];
            if (![title isEqualToString:@""]) {
                [returnArray addObject:tempdic];
            }
        }
        
    }
    _contractMsgArray = [NSArray arrayWithArray:returnArray];
}

#pragma mark -UMSocoalDelegate
//- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
//{
//    
//}
- (void)showHTAlertdidFinishGetUMSocialDataResponse
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录www.9888.cn相关页面查看" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
#pragma mark -viewDelegate
- (void)tableView:(UITableView *)tableView didSelectNormalMarkRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([indexPath section] == 1) {
            if([[_contractMsgArray objectAtIndex:[indexPath row]] objectForKey:@"content"]) {
                NSString *title = [[_contractMsgArray objectAtIndex:[indexPath row]] objectForKey:@"title"];
                FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:[[_contractMsgArray objectAtIndex:[indexPath row]] objectForKey:@"content"] title:title];
                controller.baseTitleType = @"detail_heTong";
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [self showHTAlertdidFinishGetUMSocialDataResponse];

            }
        }
}

- (void)tableView:(UITableView *)tableView didSelectNormalMarkOfRightRowAtIndexPath:(NSIndexPath *)indexPat
{
    if ([indexPat section] == 1) {
        if ([[_contractMsgArray objectAtIndex:[indexPat row]] objectForKey:@"content"]) {
            NSString *title = [[_contractMsgArray objectAtIndex:[indexPat row]] objectForKey:@"title"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:[[_contractMsgArray objectAtIndex:[indexPat row]] objectForKey:@"content"] title:title];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [self showHTAlertdidFinishGetUMSocialDataResponse];
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectMarkOfBondsRransferViewRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1) {
        if ([[_contractMsgArray objectAtIndex:[indexPath row]] objectForKey:@"content"]) {
            NSString *title = [[_contractMsgArray objectAtIndex:[indexPath row]] objectForKey:@"title"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:[[_contractMsgArray objectAtIndex:[indexPath row]] objectForKey:@"content"] title:title];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [self showHTAlertdidFinishGetUMSocialDataResponse];
        }
    }
}

#pragma mark MarkOfBondsRransferViewDelegate
- (void)investButtonClick:(id)sender
{
    // 获取购买接口
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginNaviController animated:YES completion:nil];
    } else {
        if ([self checkUserCanInvest]) {
            if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER) {
                //债券转让
                NSString *projectId = [[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"id"];
                NSString *strParameters = nil;
                strParameters = [NSString stringWithFormat:@"userId=%@&tranId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],projectId];//101943
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagDealTransferBid owner:self];
            } else {
                //普通表
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSString *projectId = [[_dataDic objectForKey:@"prdClaims"] objectForKey:@"id"];
                NSString *strParameters = nil;
                strParameters = [NSString stringWithFormat:@"userId=%@&id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],projectId];//101943
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self];
            }
        }
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
-(void)endPost:(id)result tag:(NSNumber*)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(tag.intValue == kSXTagPrdClaimsDealBid)
    {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
            purchaseViewController.dataDict = dic;
            purchaseViewController.bidType = 0;
            [self.navigationController pushViewController:purchaseViewController animated:YES];
            
        }else if ([[dic objectForKey:@"status"] integerValue] == 21 || [dic[@"status"] integerValue] == 22){
            [self checkUserCanInvest];

        } else {
            if ([[dic objectForKey:@"status"] integerValue] == 15) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else if ([[dic objectForKey:@"status"] integerValue] == 19) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"statusdes"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
                alert.tag =7000;
                [alert show];
            } else {
                [AuxiliaryFunc showAlertViewWithMessage:[dic objectForKey:@"statusdes"]];
            }
            
        }
    } else if(tag.intValue == kSXTagDealTransferBid) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            UCFPurchaseTranBidViewController *purchaseViewController = [[UCFPurchaseTranBidViewController alloc] initWithNibName:@"UCFPurchaseTranBidViewController" bundle:nil];
            purchaseViewController.dataDict = dic;
            [self.navigationController pushViewController:purchaseViewController animated:YES];
        }else if ([[dic objectForKey:@"status"] integerValue] == 21){
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

            
        }else if ([[dic objectForKey:@"status"] integerValue] == 3 || [[dic objectForKey:@"status"] integerValue] == 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"statusdes"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
            alert.tag =7001;
            [alert show];
        }
        else {
            [AuxiliaryFunc showAlertViewWithMessage:[dic objectForKey:@"statusdes"]];
        }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7000) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
        [self getToBack];
    }
    if (alertView.tag == 7001) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignmentUpdate" object:nil];
        [self getToBack];
    }
    if (alertView.tag == 8000) {
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

#pragma mark -normalviewrun

- (void)toDownView
{
    _navigationStyleBar.image = [UIImage createImageWithColor:UIColorWithRGB(0x28335c)];
}

- (void)toUpView
{
    CGFloat scaleFlot = 1;
    if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        scaleFlot = 1.171875;
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        scaleFlot =  1.29375;
    }
    _navigationStyleBar.image = [UIImage imageNamed:@"particular_bg_1"];
}
@end
