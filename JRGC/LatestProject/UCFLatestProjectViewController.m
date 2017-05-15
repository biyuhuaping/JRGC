//
//  UCFLatestProjectViewController.m
//  JRGC
//  首页标列表
//  Created by qinyy on 15/4/8.
//  Copyright (c) 2015年 qinyangyue. All rights reserved.
//

#import "UCFLatestProjectViewController.h"
#import "InvestmentCell.h"
#import "UCFProjectDetailViewController.h"//标详情
#import "UCFCompleteBidViewCtrl.h"
#import "UCFPurchaseBidViewController.h"//投资页面
#import "UCFLoginViewController.h"
#import "FullWebViewController.h"
#import "UCFCycleModel.h"//bander
#import "UCF404ErrorView.h"
#import "UCFNoPermissionViewController.h"
#import "UCFToolsMehod.h"
#import "CycleView.h"
#import <ImageIO/ImageIO.h>
#import "ToolSingleTon.h"
#import "AppDelegate.h"
#import "UILabel+Misc.h"
#import "PraiseAlert.h"
#import "PromptView.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
#import "UCFWebViewJavascriptBridgeBBS.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "BeansFamilyViewController.h"//工友之家
#import "UCFOldUserGuideViewController.h"//升级存管账户
#import "UCFBankDepositoryAccountViewController.h" //微商银行存管专题页面
#import "TradePasswordVC.h"//设置交易密码
#import "UCFLatesProjectTableViewCell.h"

#import "UCFCollectionBidCell.h"
#import "UCFCollectionBidModel.h"

#import "UCFProjectListController.h"        //项目列表
#import "RiskAssessmentViewController.h"    //风险评估

#import "UCFProjectListController.h"
#import "UCFHonerViewController.h"
#import "UCFP2PViewController.h"

#import "UCFCollectionDetailViewController.h" //集合详情
#import "MjAlertView.h"
#import "NSDate+IsBelongToToday.h"
#import "HSHelper.h"
#import "MongoliaLayerCenter.h"
#import "MaskView.h"
#import "UCFSecurityCenterViewController.h"
#import "UCFProductListCell.h"
#import "UCFProductListModel.h"
@interface UCFLatestProjectViewController ()<InvestmentCellDelegate,FourOFourViewDelegate,CycleViewDelegate,PromptViewDelegate,homeButtonPressedCellDelegate, UITableViewDataSource, UITableViewDelegate, UCFCollectionBidCellDelegate,MjAlertViewDelegate,PraiseAlertDelegate>
{
    UIView *_clickView;
    BOOL _refreshHead;
    BOOL _bringFooterToClick;
    BJGridItem *_dragBtn;
//    PraiseAlert     *alertTool;
    NSString *_colPrdClaimIdStr;//集合标Id
}

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet CycleView *bannerView;

@property (strong, nonatomic) NSMutableArray *banderArr;
@property (strong, nonatomic) NSMutableArray *actionArr;
@property (strong, nonatomic) NSMutableArray *investmentArr;
@property (strong, nonatomic) NSMutableArray *groupArray;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSIndexPath *indexPath;//选中了哪一行
@property (assign, nonatomic) int pageNum;

@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;//提示label
@property (strong, nonatomic) IBOutlet UILabel *noticLabel;//左右滚动Lab 公告
@property (strong, nonatomic) NSString *noticId;//公告id
@property (assign, nonatomic) CGFloat noticLabWidth;//公告label的宽
@property (strong, nonatomic) NSTimer *timer2;
@property (assign, nonatomic) BOOL isHiddenNoticLab;//是否隐藏公告栏

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineHigh1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineHigh2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noticBottomDistance;//公告栏距离banner底部的距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipsViewHeight;//提示View的身高

@property (nonatomic, copy)   NSString *wapActToken;
@property (nonatomic, assign) NSInteger scrollViewIndex;

//四个功能图标
@property (strong, nonatomic) IBOutlet UIImageView *imgView1;
@property (strong, nonatomic) IBOutlet UIImageView *imgView2;
@property (strong, nonatomic) IBOutlet UIImageView *imgView3;
@property (strong, nonatomic) IBOutlet UIImageView *imgView4;

@property (strong, nonatomic) IBOutlet UILabel *titleLab1;
@property (strong, nonatomic) IBOutlet UILabel *titleLab2;
@property (strong, nonatomic) IBOutlet UILabel *titleLab3;
@property (strong, nonatomic) IBOutlet UILabel *titleLab4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *p2POrZxViewHeight;

@property (weak, nonatomic) IBOutlet UIView *p2POrZxView;

@property (strong, nonatomic) UCFCollectionBidModel *collectionBidModel;

@property (nonatomic, copy) NSString *totalCount;

@end

@implementation UCFLatestProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self drawPullingView];//点击加载更多
    _investmentArr = [NSMutableArray new];
    self.groupArray = [NSMutableArray arrayWithCapacity:2];
//    _dataArr = [NSMutableArray new];
    self.baseTitleType = @"list";
    _pageNum = 1;
    _refreshHead = NO;
    _bringFooterToClick = NO;

    _bannerView.delegate = self;
    
    _lineHigh1.constant = 0;
    _lineHigh2.constant = 0;
    
    baseTitleLabel.text = @"产品列表";
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:footerView isTop:YES];
    self.tableView.tableFooterView = footerView;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 20)];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.text = @"市场有风险  投资需谨慎";
    tipLabel.textColor = UIColorWithRGB(0x999999);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:tipLabel];
//    tipLabel.center = footerView.center;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomeData:) name:@"userisloginandcheckgrade" object:nil];
        
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
//    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableView.separatorInset = UIEdgeInsetsMake(0,15, 0, 0);
    _isHiddenNoticLab = YES;
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
//    [_tableView addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [weakSelf getPrdClaimsDataList];
//    }];
    
    [_tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getPrdClaimsDataList)];
    
    // 添加上拉加载更多
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getPrdClaimsDataList];
    }];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    _tableView.footer.hidden = YES;
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choicePrdDetailCon2:) name:@"choiceCon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginShowLoading) name:@"LatestProjectUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewInviteFriendsVC) name:@"CheckInviteFriendsAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGoodCommentAlert:) name:CHECK_GOOD_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlatformUpgradeNotice) name:CHECK_UPDATE_ALERT object:nil];
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateLabH) userInfo:nil repeats:YES];
    //[self addDragBtn];
}

//此版本第一次投标成功后需要弹框引导用户去给好评
- (void)showGoodCommentAlert:(NSNotification *)noti
{
//    if (!alertTool) {
//        alertTool = [[PraiseAlert alloc]init];
//        alertTool.delegate = self;
//    }
//    [alertTool checkPraiseAlertIsEjectWithGoodCommentAlertType:FirstInvestSuceess WithRollBack:^{
//    }];
    NSNumber *boolNum = noti.object;
    NSInteger   selectIndex = 0;
    if ([boolNum boolValue]) {
        selectIndex = 2;
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.tabBarController setSelectedIndex:selectIndex];
    }
}

- (void)addDragBtn
{
    _dragBtn = [[BJGridItem alloc] initWithTitle:nil withImageName:@"package_1.png" atIndex:0 editable:NO];
    
    [_dragBtn setFrame:CGRectMake(20, 20, 64, 64)];
    _dragBtn.delegate = self;
    [self.view addSubview: _dragBtn];
}

- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}

#pragma mark - BJGridIremDelegate
- (void)gridItemDidMoved:(BJGridItem *)gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer *)recognizer{
    CGRect frame = _dragBtn.frame;
    CGPoint curPoint = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            DLog(@"press long began");
            break;
        case UIGestureRecognizerStateEnded:
            DLog(@"press long ended");
            break;
        case UIGestureRecognizerStateFailed:
            DLog(@"press long failed");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            frame.origin.x = curPoint.x - point.x;
            frame.origin.y = curPoint.y - point.y;
            _dragBtn.frame = frame;
            break;
        default:
            DLog(@"press long else");
            break;
    }
}

- (void) gridItemDidEndMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer{
    CGPoint _point = [recognizer locationInView:self.view];
    if (_point.x < ScreenWidth / 2) {
        _point.x = 0;
    } else {
        _point.x = ScreenWidth - gridItem.frame.size.width;
    }
    
    if (_point.y < 0) {
        _point.y = 0;
    }
    
    CGFloat yPoint = _point.y - point.y;
    if (yPoint < 0) {
        yPoint = 0;
    } else if (yPoint > ScreenHeight - 64 - 44 - 64) {
        yPoint = ScreenHeight - 64 - 44 - 64;
    }
    [UIView animateWithDuration:0.2 animations:^{
        gridItem.frame = CGRectMake(_point.x, yPoint, gridItem.frame.size.width, gridItem.frame.size.height);
    }];
}

- (void) gridItemDidEnterEditingMode:(BJGridItem *) gridItem
{
   
}

- (void) gridItemDidDeleted:(BJGridItem *) gridItem atIndex:(NSInteger)index
{
    
}

- (void) gridItemDidClicked:(BJGridItem *) gridItem
{
  
}

#pragma mark -promptViewDelegate

- (void)handlePromptViewRemovedEvent:(PromptView *)promptView
{
    
}
- (void)handlePromptViewEndView
{
//    用户未加载过引导页 去检测2017年邀请好友弹框提示
    [self alertViewInviteFriendsVC];
}
- (UIView*)drawguildView :(UIImage*)image
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    baseView.backgroundColor = [UIColor clearColor];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - image.size.height)];
    upView.alpha = 0.7;
    upView.backgroundColor = [UIColor blackColor];
    [baseView addSubview:upView];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - image.size.height, ScreenWidth, image.size.height)];
    imgv.backgroundColor = [UIColor blackColor];
    imgv.image = image;
    [baseView addSubview:imgv];
    return baseView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     [self activitiesAction:NO];
//    [self showPlatformUpgradeNotice];
//    [[MongoliaLayerCenter sharedManager] showLogic];
//    // 该标识为首页是否加载过有引导页，Yes为 加载过，NO为 未加载过
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"fistPage1"]) {
//        [self alertViewInviteFriendsVC];// 加载过  去检测2017年邀请好友弹框提示
//    }
    // 首页引导页去掉的情况，
//    [self alertViewInviteFriendsVC];//去检测2017年邀请好友弹框提示
//    
//    [PromptView addGuideViewWithKey:@"fistPage1" isHorizontal:NO delegate:self imageBlock:^NSString *{
//        NSString *imageName = @"mask4s_2.jpg";
//        if (ScreenHeight > 480) {
//            imageName = @"mask56_2.jpg";
//        }
//        return imageName;
//    } isFirstPage:YES];
//    [PromptView addGuideViewWithKey:@"fistPage2" isHorizontal:NO delegate:self imageBlock:^NSString *{
//        NSString *imageName = @"mask4s_1.jpg";
//        if (ScreenHeight > 480) {
//            imageName = @"mask56_1.jpg";
//        }
//        return imageName;
//    } isFirstPage:YES];
//    [PromptView addGuideViewWithKey:@"fistPage3" isHorizontal:NO delegate:self imageBlock:^NSString *{
//        NSString *imageName = @"mask4s_3.jpg";
//        if (ScreenHeight > 480) {
//            imageName = @"mask56_3.jpg";
//        }
//        return imageName;
//    } isFirstPage:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)alertViewInviteFriendsVC {
    MjAlertView *alertView = [[MjAlertView alloc]initInviteFriendsToMakeMoneyDelegate:self];
    [alertView show];
}
- (void)showPlatformUpgradeNotice
{
    MjAlertView *alertView = [[MjAlertView alloc] initPlatformUpgradeNotice:self];
    alertView.tag = 1000;
    [alertView show];
}
#pragma 去邀请奖励页面
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index {
    if (alertview.tag == 1000) {
        //请求接口已经阅读
        MaskView *view = [MaskView makeViewWithMask:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    } else {
        if (index == 1) { //点击了立即查看详情
            for (int i = 0; i < _actionArr.count; i++) {
                if ([_actionArr[i][@"title"] isEqualToString:@"邀请返利"]) {
                    NSDictionary *dataDict = _actionArr[i];
                    [self gotoInviteFriendsWebVC:dataDict];
                    break;
                }
            }
        }
    }
}
-(void)gotoInviteFriendsWebVC:(NSDictionary *)dataDict{
    UCFCycleModel *banInfo = [UCFCycleModel getCycleModelByDataDict:dataDict];
    FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:banInfo.url title:banInfo.title];
    webView.flageHaveShareBut = @"分享";
    webView.sourceVc = @"UCFLatestProjectViewController";
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - bander


//刷新数据
- (void)beginShowLoading{
    [_tableView.header beginRefreshing];

//    _pageNum = 1;
//    NSString *strParameters = [NSString stringWithFormat:@"page=%d&rows=20&userId=%@",_pageNum,[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaims owner:self];
}

- (void)choicePrdDetailCon2:(NSNotification *)note{
    NSDictionary *dict = note.userInfo;
    //    NSString *url = dict[@"rankurl"];
    NSString *url = [dict objectForKey:@"rankurl"];
    if (!url) {
        NSString * prdId   = dict[@"prdclaimsid"];// 标id
        // 权益标
        NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
        NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@",prdId,userid];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:SelectAccoutDefault];
    }
}
//***qyy 标类型type cell按钮的回调方法delegate
-(void)homeButtonPressed:(UIButton *)button withCelltypeSellWay:(NSString *)strSellWay
{
//    if ([strSellWay isEqualToString:@"12"]) {
//        UCFHonerPlanViewController *horner = [[UCFHonerPlanViewController alloc] initWithNibName:@"UCFHonerPlanViewController" bundle:nil];
//        horner.baseTitleText = @"工场尊享";
//        horner.accoutType = SelectAccoutTypeHoner;
//        [self.navigationController pushViewController:horner animated:YES];
//        return;
//    }
//    UCFProjectListController *project = [[UCFProjectListController alloc] initWithNibName:@"UCFProjectListController" bundle:nil];
//    project.strStyle = strSellWay;
//    project.viewType = @"1";
//    [self.navigationController pushViewController:project animated:YES];
}
//- (IBAction)homeButtonPressedP2PButton:(UIButton *)sender {
//    UCFProjectListController *projectList = [[UCFProjectListController alloc] initWithNibName:@"UCFProjectListController" bundle:nil];
//    //    p2p.baseTitleText = @"工场P2P";
//    [self.navigationController pushViewController:projectList animated:YES];
//}
//
////- (void)homeButtonPressedP2PButton:(UIButton *)button
////{
////    
////}
//- (IBAction)homeButtonPressedHornorButton:(UIButton *)sender {
//    UCFHonerPlanViewController *horner = [[UCFHonerPlanViewController alloc] initWithNibName:@"UCFHonerPlanViewController" bundle:nil];
//    horner.baseTitleText = @"工场尊享";
//    horner.accoutType = SelectAccoutTypeHoner;
//    [self.navigationController pushViewController:horner animated:YES];
//}

//- (void)homeButtonPressedHornorButton:(UIButton *)button
//{
//    
//}

- (void)investBtnClicked:(UIButton *)button withType:(NSString *)type{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        
        if([type isEqualToString:@"2"])
        {
            self.accoutType  = SelectAccoutTypeHoner;
        }else{
            self.accoutType  = SelectAccoutTypeP2P;
        }

        if ([self checkUserCanInvestIsDetail:NO]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSInteger tag = button.tag - 100;
            if (tag < self.investmentArr.count) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                InvestmentItemInfo *info = [self.investmentArr objectAtIndex:tag];
                //普通表
                NSString *projectId = info.idStr;
                //方法
                NSString *strParameters = nil;
                strParameters = [NSString stringWithFormat:@"userId=%@&id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],projectId];//101943
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self Type:self.accoutType];
            }
        }
    }
}

//获取正式环境的banner图
- (void)getNormalBannerData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:CMS_BANNER]];
        [request setHTTPMethod:@"GET"];
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (EnvironmentConfiguration == 2 || (app.isSubmitAppStoreTestTime && [[[NSUserDefaults standardUserDefaults] valueForKey:UUID] isEqualToString:@"108027"])) {
            [request setValue:@"1" forHTTPHeaderField:@"jrgc-umark"];
        }
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!recervedData) {
                return ;
            }
//            NSArray * modelArr = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *modelDic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];

            [_banderArr removeAllObjects];
            [_actionArr removeAllObjects];
            for (NSDictionary *dict in modelDic[@"banner"]) {
                UCFCycleModel *model = [UCFCycleModel getCycleModelByDataDict:dict];
                if (!_banderArr) {
                    _banderArr = [NSMutableArray array];
                }
                [_banderArr addObject:model];
            }
            [self.bannerView  setContentImages:_banderArr];
            
            self.actionArr  = [NSMutableArray arrayWithArray:modelDic[@"icon"]];
            
            
            [self setActionStyle];
        });
    });
}

//根据用户是否首投重新排序banderArr
- (NSMutableArray*)reSortbanderArr:(NSMutableArray*)banderArr
{
    NSMutableArray *returnMutableArr = [NSMutableArray array];
    
    return returnMutableArr;
}


/**
 *  轮播图点击
 *  通过位置拿到数据model，拿到数据model通过dumps判断是否活动页，活动页请求接口，免登录，非1则直接加载网页
 *  @param index 点击索引
 */
- (void)cycleViewClickIndex:(NSInteger)index{
    if (self.banderArr.count > index) {
        
        UCFCycleModel *banInfo = _banderArr[index];

        //NSHTTPCookie *cookie;
        //NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        //[storage cookies];
        
        UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        webView.baseTitleType = @"lunbotuhtml";
        webView.url = banInfo.url;
        webView.navTitle = banInfo.title;
        webView.dicForShare = banInfo;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

//设置四个按钮样式
- (void)setActionStyle{
    switch (_actionArr.count) {
        case 1: {
            [_imgView1 sd_setImageWithURL:[NSURL URLWithString:_actionArr[0][@"thumb"]]];
            _titleLab1.text = _actionArr[0][@"title"];
        }
            break;
        case 2: {
            [_imgView1 sd_setImageWithURL:[NSURL URLWithString:_actionArr[0][@"thumb"]]];
            [_imgView2 sd_setImageWithURL:[NSURL URLWithString:_actionArr[1][@"thumb"]]];
            
            _titleLab1.text = _actionArr[0][@"title"];
            _titleLab2.text = _actionArr[1][@"title"];
        }
            break;
        case 3: {
            [_imgView1 sd_setImageWithURL:[NSURL URLWithString:_actionArr[0][@"thumb"]]];
            [_imgView2 sd_setImageWithURL:[NSURL URLWithString:_actionArr[1][@"thumb"]]];
            [_imgView3 sd_setImageWithURL:[NSURL URLWithString:_actionArr[2][@"thumb"]]];
            
            _titleLab1.text = _actionArr[0][@"title"];
            _titleLab2.text = _actionArr[1][@"title"];
            _titleLab3.text = _actionArr[2][@"title"];
        }
            break;
        case 4: {
            [_imgView1 sd_setImageWithURL:[NSURL URLWithString:_actionArr[0][@"thumb"]]];
            [_imgView2 sd_setImageWithURL:[NSURL URLWithString:_actionArr[1][@"thumb"]]];
            [_imgView3 sd_setImageWithURL:[NSURL URLWithString:_actionArr[2][@"thumb"]]];
            [_imgView4 sd_setImageWithURL:[NSURL URLWithString:_actionArr[3][@"thumb"]]];
            
            _titleLab1.text = _actionArr[0][@"title"];
            _titleLab2.text = _actionArr[1][@"title"];
            _titleLab3.text = _actionArr[2][@"title"];
            _titleLab4.text = _actionArr[3][@"title"];
        }
            break;
    }
}

//四个功能图标
- (IBAction)functionBtn:(UIControl *)sender {
    UILabel *label = [sender viewWithTag:200];
    NSInteger index = sender.tag - 100;
    if ([label.text isEqualToString:@"邀请返利"]) {
        NSDictionary *dataDict = _actionArr[index];
        [self gotoInviteFriendsWebVC:dataDict];
    }
    else {
        UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc]initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        subVC.navTitle = _actionArr[index][@"title"];
        subVC.url      = _actionArr[index][@"url"];//请求地址;
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

#pragma mark - 公告栏
//刷新公告栏
- (void)updateLabH{
    static float i;
    if (_noticLabWidth <= ScreenWidth-25) {
        [_timer2 invalidate];
        return;
    }
    i = _noticLabel.frame.origin.x;//文字开始的位置
    CGFloat f = i + _noticLabWidth;//文字尾巴的位置
    if (f < 0) {
        i = ScreenWidth;
    }else{
        i -= 0.5;
    }
    _noticLabel.frame = CGRectMake(i, CGRectGetMinY(_noticLabel.frame), _noticLabWidth, CGRectGetMaxY(_noticLabel.frame));
}

//控制 活动/公告栏 显示/隐藏
- (void)activitiesAction:(BOOL)isShow{
    int labHight = isShow?35:0;//公告栏高度
    int functionBtnViewHight = 60;//功能按钮View高度
    _noticBottomDistance.constant = functionBtnViewHight;//功能按钮View高度
    
    self.p2POrZxViewHeight.constant = 0;
    
    if(self.p2POrZxViewHeight.constant == 0){
        for (UIView * view in self.p2POrZxView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (_isHiddenNoticLab) {
        labHight = 0;
    }
    
    // 2秒后刷新表格UI
    [UIView animateWithDuration:0.25 animations:^{
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_bannerView.frame) + _tipsViewHeight.constant + labHight + functionBtnViewHight+self.p2POrZxViewHeight.constant);
        _tableView.tableHeaderView = _headerView;
        DBLOG(@"===%@",NSStringFromCGRect(_headerView.frame));
    }];
}
//点击提示View调用方法
- (IBAction)touchTipsView:(id)sender {

}

//查看活动详情
- (IBAction)activitiesBtn:(id)sender {
//    [AuxiliaryFunc showAlertViewWithMessage:@"点击了查看活动详情"];
    [self activitiesAction:NO];
    _isHiddenNoticLab = YES;
}

#pragma mark - tableFooterView
//- (void)drawPullingView
//{
//    _clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
//    _clickView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 15) / 2, 10, 15, 15)];
//    iconView.image = [UIImage imageNamed:@"particular_icon_up.png"];
//    [_clickView addSubview:iconView];
//    
//    UILabel *pullingLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 5, ScreenWidth, 12) text:@"点击加载更多" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
//    [_clickView addSubview:pullingLabel];
//    
//    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    bottomBtn.frame = CGRectMake(0, 0, ScreenWidth, 42);
//    [_clickView addSubview:bottomBtn];
//    [_clickView setUserInteractionEnabled:YES];
//}

- (void)bottomBtnClicked:(id)sender
{
//    _pageNum++;
//    NSString *strParameters = [NSString stringWithFormat:@"page=%d&rows=20&userId=%@",_pageNum,[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaims owner:self];
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:view isTop:YES];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
//    if (indexPath.section == 1) {
//        return 204;
//    }
//    else {
//        //************************************************qyy 2016-11-17首页接口改造
//        InvestmentItemInfo *info = _investmentArr[indexPath.row];
//        if(![info.homeType isEqualToString:@""])
//        {
//            return 27;
//        }else{
//            return 100;
//        }
//    }
//    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArray.count;
}


// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = self.groupArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"UCFProductListCell";
    UCFProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFProductListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *sectionArray = self.groupArray[indexPath.section];
    UCFProductListModel *model = sectionArray[indexPath.row];
    if (sectionArray.count > 0) {
        cell.model  = model;
    }
    if (indexPath.row == 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:line];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == [sectionArray count] - 1) {
        self.tableView.separatorColor = UIColorWithRGB(0Xd8d8d8);
        cell.separatorInset =  UIEdgeInsetsMake(0,0, 0, 0);
    }

    return cell;

    
    
//    if (indexPath.section == 1) {
//        static NSString *cellId = @"collectionBidCell";
//        UCFCollectionBidCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFCollectionBidCell" owner:self options:nil] lastObject];
//            cell.delegate = self;
//        }
//        cell.collectionBidModel = self.collectionBidModel;
//        cell.moreValueLabel.text = self.totalCount;
//        return cell;
//    }
//    else {
//        //************************************************qyy 2016-11-17首页接口改造
//        InvestmentItemInfo *info = _investmentArr[indexPath.row];
//        if(![info.homeType isEqualToString:@""])
//        {
//            static NSString *cellStr = @"LatestCell";
//            UCFLatesProjectTableViewCell *cellt = [tableView dequeueReusableCellWithIdentifier:cellStr];
//            if (cellt == nil) {
//                cellt = [[NSBundle mainBundle]loadNibNamed:@"UCFLatesProjectTableViewCell" owner:self options:nil][0];
//                cellt.delegate = self;
//            }
//            cellt.but_press.tag = 100 + indexPath.row;
//            cellt.typeSellWay = info.homeType;
//            cellt.label_title.text = info.homeTile;
//            
//            if (![info.homeIconUrl isEqualToString:@""]) {
//                [cellt.image_ahead sd_setImageWithURL:[NSURL URLWithString:info.homeIconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//                    
//                }];
//            }else{
//                cellt.image_ahead.image = [UIImage imageNamed:@"tabbar_icon_project_normal.png"];
//            }
//            return cellt;
//        }else{
//            //************************************************qyy 2016-11-17首页接口改造
//            static  NSString *indentifier = @"LatestCell";
//            
//            InvestmentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
//            if (!cell) {
//                cell = [[NSBundle mainBundle]loadNibNamed:@"InvestmentCell" owner:self options:nil][0];
//                cell.delegate = self;
//                //        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
//                //        view.backgroundColor = [UIColorWithRGB(0x2b3655) colorWithAlphaComponent:0.2];
//                //        cell.selectedBackgroundView = view;//选中后cell的背景颜色
//            }
//            InvestmentItemInfo *info = [_investmentArr objectSafeAtIndex:indexPath.row];
//            cell.investButton.tag = 100 + indexPath.row;
//            [cell setItemInfo:info];
//            NSArray *prdLabelsList = [NSArray arrayWithArray:(NSArray*)info.prdLabelsList];
//            
//            if (![prdLabelsList isEqual:@""])
//            {
//                for (NSDictionary *dic in prdLabelsList)
//                {
//                    NSString *labelPriority = dic[@"labelPriority"];
//                    if ([labelPriority isEqual:@"1"])
//                    {
//                        cell.angleView.angleString = dic[@"labelName"];
//                    }
//                }
//            }
//            return cell;
//        }
//    }
//    return nil;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    NSArray *sectionArray = self.groupArray[indexPath.section];
    UCFProductListModel *model = sectionArray[indexPath.row];
    switch ([model.type intValue]) {
        case 1: //1尊享
        {
            UCFHonerViewController *horner = [[UCFHonerViewController alloc] initWithNibName:@"UCFHonerViewController" bundle:nil];
            horner.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            horner.baseTitleText = @"工场尊享";
            horner.viewType = @"1";
            horner.accoutType = SelectAccoutTypeHoner;
            [horner setCurrentViewForHornerTransferVC];
            [self.navigationController pushViewController:horner animated:YES];
            
        }
            break;
        case 2://2尊享转让
        {
            UCFHonerViewController *horner = [[UCFHonerViewController alloc] initWithNibName:@"UCFHonerViewController" bundle:nil];
            horner.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            horner.baseTitleText = @"工场尊享";
            horner.viewType = @"2";
            horner.accoutType = SelectAccoutTypeHoner;
            [horner setCurrentViewForHornerTransferVC];
            [self.navigationController pushViewController:horner animated:YES];

            
        }
            
            break;
        case 3://3微金

        {
            UCFP2PViewController *p2PVC = [[UCFP2PViewController alloc] initWithNibName:@"UCFP2PViewController" bundle:nil];
            p2PVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            p2PVC.viewType = @"1";
            [p2PVC setCurrentViewForBatchBid];
            [self.navigationController pushViewController:p2PVC animated:YES];

        }
            break;
        case 4://4微金转让
        {
            UCFP2PViewController *p2PVC = [[UCFP2PViewController alloc] initWithNibName:@"UCFP2PViewController" bundle:nil];
            p2PVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            p2PVC.viewType = @"3";
            [p2PVC setCurrentViewForBatchBid];
            [self.navigationController pushViewController:p2PVC animated:YES];

        }
            break;
        case 5://5批量
        {
            UCFP2PViewController *p2PVC = [[UCFP2PViewController alloc] initWithNibName:@"UCFP2PViewController" bundle:nil];
            p2PVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            p2PVC.viewType = @"2";
            [p2PVC setCurrentViewForBatchBid];
            [self.navigationController pushViewController:p2PVC animated:YES];
            
        }
            
            break;
            
        default:
            break;
    }
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        
//        UCFCollectionBidCell *cell = (UCFCollectionBidCell *)[tableView cellForRowAtIndexPath:indexPath];
//        if (cell.collectionBidModel) {
//           [self gotoCollectionDetailViewContoller:cell.collectionBidModel];
//        }
//    }
//    else {
//        if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
//            //如果未登录，展示登录页面
//            [self showLoginView];
//        } else {
//            
//            InvestmentItemInfo *info = _investmentArr[indexPath.row];
//            if([info.type isEqualToString:@"2"])
//            {
//                self.accoutType  = SelectAccoutTypeHoner;
//            }else{
//                 self.accoutType  = SelectAccoutTypeP2P;
//            }
//            if ([self checkUserCanInvestIsDetail:YES]) {
//                _indexPath = indexPath;
//                InvestmentItemInfo * info = [_investmentArr objectAtIndex:_indexPath.row];
//                NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
//                NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@",info.idStr,userid];
//                if ([info.status intValue ] != 2) {
//                    NSInteger isOrder = [info.isOrder integerValue];
//                    if (isOrder > 0) {
//                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:self.accoutType];
//                    } else {
//                        UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对投资人开放"];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }
//                } else {
//                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:self.accoutType];
//                }
//            }
//        }
//    }
}
#pragma mark - 请求网络及回调
//获取prdClaims/dataList
- (void)getPrdClaimsDataList
{
    if (_tableView.header.isRefreshing) {
        //获取bander图
        [self getNormalBannerData];
        if (_pageNum > 1) {
            _refreshHead = YES;
        }
        _pageNum = 1;
    }
    else if (_tableView.footer.isRefreshing){
        _pageNum++;
        _refreshHead = NO;
    }
//    NSString *strParameters = [NSString stringWithFormat:@"page=%d&rows=20&userId=%@",_pageNum,[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaims owner:self];
    
    // v2/home.json
    
    //************************************************qyy 2016-11-17首页接口改造
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults]valueForKey:UUID]],@"userId", nil];
    [[NetworkModule sharedNetworkModule]newPostReq:strParameters tag:kSXTagProductList owner:self signature:NO Type:SelectAccoutTypeP2P];

}

//开始请求
- (void)beginPost:(kSXTag)tag
{
//    [GiFHUD show];
    if (tag == kSXTagColPrdclaimsDetail){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DBLOG(@"首页获取最新项目列表：%@",result);

    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagPrdClaimsNewVersion) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
        //============ 新街口解析方法2016年11月16日qyy-123 ============
            _tableView.footer.hidden = YES;
            //        [_errorView hide];
            if ([rstcode intValue] == 1) {
                
                NSDictionary *collectionBid = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"colPrdClaim"];
                if (collectionBid) {
                    self.collectionBidModel = [UCFCollectionBidModel collectionBidWithDict:collectionBid];
                    self.totalCount = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"totalCount"];
                }
                else {
                    self.collectionBidModel = nil;
                    self.totalCount = @"0";
                }
                
                
                [_investmentArr removeAllObjects];
                NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                [tempArray addObjectsFromArray:dic[@"data"][@"group"]];
                for (int i = 0; i < tempArray.count; i++)
                {
                    NSMutableArray *tempArrayone = [[NSMutableArray alloc]init];
                    NSDictionary * diclow = [tempArray objectAtIndex:i];
                    NSString* strTitle = [diclow objectSafeForKey:@"title"];
                    NSString* iconUrlStr =[diclow objectSafeForKey:@"iconUrl"];
                    NSString* strType = [diclow objectSafeForKey:@"type"];
                    NSArray* arrylow = [diclow objectSafeForKey:@"prdlist"];
                    NSDictionary*dictemp = [NSDictionary dictionaryWithObjectsAndKeys:strType,@"homeType",strTitle,@"homeTile",iconUrlStr,@"homeIconUrl", nil];
                    if(arrylow.count>0)
                    {
                       for(int p = 0;p < arrylow.count; p++)
                      {
                          if(p==0)
                          {
                              InvestmentItemInfo *infoTitl = [[InvestmentItemInfo alloc]initWithDictionary:dictemp];
                              [tempArrayone addObject:infoTitl];
                          }
                          InvestmentItemInfo *info = [[InvestmentItemInfo alloc]initWithDictionary:arrylow[p]];
                         
                          if([info.prdLabelsList isKindOfClass:[NSString class]])
                          {
                              info.prdLabelsList =[(NSDictionary*)arrylow[p] objectSafeForKey:@"prdLabelsList"];
                          }
                          info.isAnim = YES;
                          [tempArrayone addObject:info];
                          
                         
                      }
                    }else{
                        InvestmentItemInfo *info = [[InvestmentItemInfo alloc]initWithDictionary:dictemp];
                        [tempArrayone addObject:info];
                    }
                    [_investmentArr addObjectsFromArray:tempArrayone];
                }
                 [_tableView reloadData];
            }

            //============ tips提示 ============
            if([[NSUserDefaults standardUserDefaults] objectForKey:UUID]){//登录状态下，显示tipView
                //个人中心接口添加开户装填
                NSString *openStatusStr = [[dic objectSafeForKey:@"data" ] objectSafeForKey:@"openStatus"];
                NSString *zxOpenStatusStr = [[dic objectSafeForKey:@"data" ] objectSafeForKey:@"zxOpenStatus"];
                [UserInfoSingle sharedManager].openStatus = [openStatusStr integerValue];
                [UserInfoSingle sharedManager].enjoyOpenStatus = [zxOpenStatusStr integerValue];
            }
            //============ 公告 ============
            _noticId = dic[@"data"][@"noticId"];
            _noticLabel.text = dic[@"data"][@"siteNotice"];
            if (_noticLabel.text.length > 0) {
                if (!_timer2.isValid) {
                    _timer2 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateLabH) userInfo:nil repeats:YES];
                }
                NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName,nil];
                _noticLabWidth = [_noticLabel.text boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
                [self activitiesAction:YES];
            }else
                [self activitiesAction:NO];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    } else if (tag.intValue == kSXTagPrdClaimsDetail) {
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        if ([rstcode intValue] == 1) {
            
            InvestmentItemInfo *info = [_investmentArr objectSafeAtIndex:_indexPath.row];
            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)info.prdLabelsList];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
            CGFloat platformSubsidyExpense = [info.platformSubsidyExpense floatValue];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    } else if (tag.intValue == kSXTagPrdClaimsDealBid) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] integerValue] == 1)
        {
            UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
            purchaseViewController.dataDict = dic;
            purchaseViewController.bidType = 0;
            purchaseViewController.baseTitleType = @"detail_heTong";
            purchaseViewController.accoutType = self.accoutType;
            [self.navigationController pushViewController:purchaseViewController animated:YES];
            
        }else if ([dic[@"status"] integerValue] == 21 || [dic[@"status"] integerValue] == 22){
            [self checkUserCanInvestIsDetail:NO];
        } else {
            if ([dic[@"status"] integerValue] == 15) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else if ([dic[@"status"] integerValue] == 19) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag =7000;
                [alert show];
            }else if ([dic[@"status"] integerValue] == 30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
                alert.tag = 9000;
                [alert show];
            }else if ([dic[@"status"] integerValue] == 40) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
                alert.tag = 9001;
                [alert show];
            } else {
                 [AuxiliaryFunc showAlertViewWithMessage:dic[@"statusdes"]];
            }
        }
    } else if (tag.intValue == kSXTagColPrdclaimsDetail) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            
            UCFCollectionDetailViewController *collectionDetailVC = [[UCFCollectionDetailViewController alloc]initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
            collectionDetailVC.souceVC = @"P2PVC";
            collectionDetailVC.colPrdClaimId = _colPrdClaimIdStr;
            collectionDetailVC.detailDataDict = [dic objectSafeDictionaryForKey:@"data"];
            collectionDetailVC.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:collectionDetailVC  animated:YES];
            
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }if (tag.intValue == kSXTagProductList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            //============ 新街口解析方法2016年11月16日qyy-123 ============
            _tableView.footer.hidden = YES;
            //        [_errorView hide];
            if ([rstcode intValue] == 1) {
                
                [self.groupArray removeAllObjects];
                NSArray *tempArray = [[dic objectSafeDictionaryForKey:@"data"] objectSafeArrayForKey:@"group"];
                for (int i = 0; i < tempArray.count; i++)
                {
                    NSMutableArray *tempArrayone = [[NSMutableArray alloc]init];
                    NSArray *arrylow = [tempArray objectAtIndex:i];
                    if(arrylow.count>0)
                    {
                        for(int p = 0;p < arrylow.count; p++)
                        {
                            NSDictionary *dataDic = [arrylow objectAtIndex:p];
                            UCFProductListModel *model = [[UCFProductListModel alloc]initWithDict:dataDic];
                            [tempArrayone addObject:model];
                        }
                    }
                    [self.groupArray addObject:tempArrayone];
                }
                [_tableView reloadData];
            }
            _isHiddenNoticLab = YES;
            [self activitiesAction:NO];
         
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    [_tableView.header endRefreshing];
//    [_tableView.footer endRefreshing];
}
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    
    NSString *tipStr1 = self.accoutType == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = self.accoutType == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;

    NSInteger openStatus = self.accoutType == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus :[UserInfoSingle sharedManager].enjoyOpenStatus;
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = self.accoutType == SelectAccoutTypeP2P ?  8000 :8010 ;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7000) {
        [self beginShowLoading];
    } else if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
    }else if (alertView.tag == 8010) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        }
    }
    else if (alertView.tag == 9000) {
        if(buttonIndex == 1){ //测试
            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            vc.accoutType = self.accoutType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(alertView.tag == 9001){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
        }
    }

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

#pragma mark - collectionBidCellDelegate
- (void)collectionCell:(UCFCollectionBidCell *)currentView didClickedBatchBidButton:(UIButton *)batchBidButton
{
    [self gotoCollectionDetailViewContoller:currentView.collectionBidModel];
}
//去批量投资集合详情
-(void)gotoCollectionDetailViewContoller:(UCFCollectionBidModel *)model{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    if (!uuid) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        self.accoutType = SelectAccoutTypeP2P;
        if ([self checkUserCanInvestIsDetail:NO]) {
            _colPrdClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
            NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", _colPrdClaimIdStr, @"colPrdClaimId", nil];
            [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagColPrdclaimsDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
        }
    }
}

- (void)collectionCell:(UCFCollectionBidCell *)currentView didClickedMoreButton:(UIButton *)MoreButton
{    
//    UCFProjectListController *project = [[UCFProjectListController alloc] initWithNibName:@"UCFProjectListController" bundle:nil];
//    project.strStyle = @"11";
//    project.viewType = @"2";
//    [self.navigationController pushViewController:project animated:YES];
    
    
    UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
    personMessageVC.title = @"个人信息";
    [self.navigationController pushViewController:personMessageVC animated:YES];
}

#pragma mark - 刷新首页数据
- (void)reloadHomeData:(NSNotification *)noty
{
    [self.tableView.header beginRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
