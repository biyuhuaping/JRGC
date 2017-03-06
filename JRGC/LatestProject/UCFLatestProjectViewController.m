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

#import "UCFCollectionDetailViewController.h" //集合详情
#import "MjAlertView.h"
#import "NSDate+IsBelongToToday.h"
@interface UCFLatestProjectViewController ()<InvestmentCellDelegate,FourOFourViewDelegate,CycleViewDelegate,PromptViewDelegate,homeButtonPressedCellDelegate, UITableViewDataSource, UITableViewDelegate, UCFCollectionBidCellDelegate,MjAlertViewDelegate>
{
    UIView *_clickView;
    BOOL _refreshHead;
    BOOL _bringFooterToClick;
    BJGridItem *_dragBtn;
    PraiseAlert     *alertTool;
    NSString *_colPrdClaimIdStr;//集合标Id
}

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet CycleView *bannerView;

@property (strong, nonatomic) NSMutableArray *banderArr;
@property (strong, nonatomic) NSMutableArray *actionArr;
@property (strong, nonatomic) NSMutableArray *investmentArr;
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


@property (strong, nonatomic) UCFCollectionBidModel *collectionBidModel;

@property (nonatomic, copy) NSString *totalCount;

@end

@implementation UCFLatestProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawPullingView];//点击加载更多
    _investmentArr = [NSMutableArray new];
//    _dataArr = [NSMutableArray new];
    self.baseTitleType = @"list";
    _pageNum = 1;
    _refreshHead = NO;
    _bringFooterToClick = NO;

    _bannerView.delegate = self;
    
    _lineHigh1.constant = 0.5;
    _lineHigh2.constant = 0.5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomeData:) name:@"userisloginandcheckgrade" object:nil];
        
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
    }

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
    
//    [ToolSingleTon sharedManager].checkIsInviteFriendsAlert = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choicePrdDetailCon2:) name:@"choiceCon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginShowLoading) name:@"LatestProjectUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewInviteFriendsVC) name:@"CheckInviteFriendsAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGoodCommentAlert:) name:CHECK_GOOD_COMMENT object:nil];

    _timer2 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateLabH) userInfo:nil repeats:YES];
    //[self addDragBtn];
}

//此版本第一次投标成功后需要弹框引导用户去给好评
- (void)showGoodCommentAlert:(NSNotification *)noti
{
    if (!alertTool) {
        alertTool = [[PraiseAlert alloc]init];
        alertTool.delegate = self;
    }
    [alertTool checkPraiseAlertIsEjectWithGoodCommentAlertType:FirstInvestSuceess WithRollBack:^{
    }];
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
    
    [PromptView addGuideViewWithKey:@"fistPage1" isHorizontal:NO delegate:self imageBlock:^NSString *{
        NSString *imageName = @"mask4s_2.jpg";
        if (ScreenHeight > 480) {
            imageName = @"mask56_2.jpg";
        }
        return imageName;
    } isFirstPage:YES];
    [PromptView addGuideViewWithKey:@"fistPage2" isHorizontal:NO delegate:self imageBlock:^NSString *{
        NSString *imageName = @"mask4s_1.jpg";
        if (ScreenHeight > 480) {
            imageName = @"mask56_1.jpg";
        }
        return imageName;
    } isFirstPage:YES];
    [PromptView addGuideViewWithKey:@"fistPage3" isHorizontal:NO delegate:self imageBlock:^NSString *{
        NSString *imageName = @"mask4s_3.jpg";
        if (ScreenHeight > 480) {
            imageName = @"mask56_3.jpg";
        }
        return imageName;
    } isFirstPage:YES];
    [self alertViewInviteFriendsVC];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)alertViewInviteFriendsVC{
    
    NSDate *lastFirstLoginTime = [[NSUserDefaults standardUserDefaults] objectForKey:FirstAlertViewShowTime];
    BOOL isBelongToToday = [NSDate isBelongToTodayWithDate:lastFirstLoginTime]; //是不是每天第一次弹
    
    BOOL policeOnOff = [ToolSingleTon sharedManager].checkIsInviteFriendsAlert ;
    if(!isBelongToToday && policeOnOff){
        
        MjAlertView *alertView = [[MjAlertView alloc]initInviteFriendsToMakeMoneyDelegate:self];
        [alertView show];
    }
}
#pragma 去邀请奖励页面
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    if (index == 1) { //点击了立即查看详情
        NSDictionary *dataDict = _actionArr[2];
        UCFCycleModel *banInfo = [UCFCycleModel getCycleModelByDataDict:dataDict];
        FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:banInfo.url title:banInfo.title];
//        webView.baseTitleType = @"lunbotuhtml";
        webView.flageHaveShareBut = @"分享";
        webView.sourceVc = @"UCFLatestProjectViewController";
        [self.navigationController pushViewController:webView animated:YES];
        
    }
}

#pragma mark - bander
//- (void)updateLab{
//    static int i = 0;
//    if (_rollPrdOrderArr.count == 0) {
//        return;
//    }
//    if (i == _rollPrdOrderArr.count - 1) {
//        i = 0;
//    }else{
//        i ++;
//    }
//    NSDictionary *dic = _rollPrdOrderArr[i];
//    _lab.text = [NSString stringWithFormat:@"%@(%@) 投资%@   ¥%@   %@",dic[@"loginName"],dic[@"realName"],dic[@"prdName"],dic[@"investAmt"],dic[@"times"]];
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.duration = 0.7;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = @"cube";
//    animation.subtype = kCATransitionFromTop;
//    [[_lab layer] addAnimation:animation forKey:@"animation"];
//}

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
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self];
    }
}
//***qyy 标类型type cell按钮的回调方法delegate
-(void)homeButtonPressed:(UIButton *)button withCelltypeSellWay:(NSString *)strSellWay
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.tabBarController setSelectedIndex:1];
    UCFProjectListController *project = (UCFProjectListController *)[[appdelegate.tabBarController.viewControllers objectAtIndex:1].childViewControllers objectAtIndex:0];
    project.strStyle = strSellWay;
    BOOL isLoad = [project isViewLoaded];
    if (isLoad) {
        [project changeViewWithConfigure:strSellWay];
    }
}

- (void)investBtnClicked:(UIButton *)button{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
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
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self];
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
        if (EnvironmentConfiguration == 2 || (app.isSubmitAppStoreTestTime)) {
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
        
        //if ([banInfo.dumps isEqualToString:@"1"])
        //{    //活动 先获取toke
            //if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID])
            //{
                //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //_scrollViewIndex = index;
                //NSString *strParameters = nil;
                //strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];//101943
                //[[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetIgnorgeLogin owner:self];
            //} else {
                //FullWebViewController *webView = [[FullWebViewController alloc]initWithWebUrl:banInfo.url title:banInfo.title];
                //webView.baseTitleType = @"lunbotuhtml";
                //webView.flageHaveShareBut = @"分享";
                //webView.dicForShare = banInfo;
                //[self.navigationController pushViewController:webView animated:YES];
  
            //}
        //}
        //else
        //{
            //FullWebViewController *webView = [[FullWebViewController alloc]initWithWebUrl:banInfo.url title:banInfo.title];
            //webView.baseTitleType = @"lunbotuhtml";
            //webView.dicForShare = banInfo;
            //[self.navigationController pushViewController:webView animated:YES];
            
        //}
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
    for (UIView *view in sender.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)view;
            for (int i = 0; i < _actionArr.count; i++) {
                if ([lab.text isEqualToString:_actionArr[i][@"title"]]) {
                    UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc]initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
                    subVC.navTitle = _actionArr[i][@"title"];
                    subVC.url      = _actionArr[i][@"url"];//请求地址;
                    [self.navigationController pushViewController:subVC animated:YES];
                }
            }
        }
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
    int functionBtnViewHight = _actionArr.count?60:0;//功能按钮View高度
    _noticBottomDistance.constant = functionBtnViewHight;//功能按钮View高度
    
    if (_isHiddenNoticLab) {
        labHight = 0;
    }
    
    // 2秒后刷新表格UI
    [UIView animateWithDuration:0.25 animations:^{
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_bannerView.frame) + _tipsViewHeight.constant + labHight + functionBtnViewHight);
        _tableView.tableHeaderView = _headerView;
        DBLOG(@"===%@",NSStringFromCGRect(_headerView.frame));
    }];
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

//查看活动详情
- (IBAction)activitiesBtn:(id)sender {
//    [AuxiliaryFunc showAlertViewWithMessage:@"点击了查看活动详情"];
    [self activitiesAction:NO];
    _isHiddenNoticLab = YES;
}

#pragma mark - tableFooterView
- (void)drawPullingView
{
    _clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    _clickView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 15) / 2, 10, 15, 15)];
    iconView.image = [UIImage imageNamed:@"particular_icon_up.png"];
    [_clickView addSubview:iconView];
    
    UILabel *pullingLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 5, ScreenWidth, 12) text:@"点击加载更多" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
    [_clickView addSubview:pullingLabel];
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.frame = CGRectMake(0, 0, ScreenWidth, 42);
    [_clickView addSubview:bottomBtn];
    [_clickView setUserInteractionEnabled:YES];
}

- (void)bottomBtnClicked:(id)sender
{
    _pageNum++;
    NSString *strParameters = [NSString stringWithFormat:@"page=%d&rows=20&userId=%@",_pageNum,[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaims owner:self];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 204;
    }
    else {
        //************************************************qyy 2016-11-17首页接口改造
        InvestmentItemInfo *info = _investmentArr[indexPath.row];
        if(![info.homeType isEqualToString:@""])
        {
            return 50;
        }else{
            return 100;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.collectionBidModel.colName.length > 0) {
            return 1;
        }
        return 0;
    }
    return _investmentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"collectionBidCell";
        UCFCollectionBidCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFCollectionBidCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        cell.collectionBidModel = self.collectionBidModel;
        cell.moreValueLabel.text = self.totalCount;
        return cell;
    }
    else {
        //************************************************qyy 2016-11-17首页接口改造
        InvestmentItemInfo *info = _investmentArr[indexPath.row];
        if(![info.homeType isEqualToString:@""])
        {
            static NSString *cellStr = @"LatestCell";
            UCFLatesProjectTableViewCell *cellt = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (cellt == nil) {
                cellt = [[NSBundle mainBundle]loadNibNamed:@"UCFLatesProjectTableViewCell" owner:self options:nil][0];
                cellt.delegate = self;
            }
            cellt.but_press.tag = 100 + indexPath.row;
            cellt.typeSellWay = info.homeType;
            cellt.label_title.text = info.homeTile;
            
            if (![info.homeIconUrl isEqualToString:@""]) {
                [cellt.image_ahead sd_setImageWithURL:[NSURL URLWithString:info.homeIconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                    
                }];
            }else{
                cellt.image_ahead.image = [UIImage imageNamed:@"tabbar_icon_project_normal.png"];
            }
            return cellt;
        }else{
            //************************************************qyy 2016-11-17首页接口改造
            static  NSString *indentifier = @"LatestCell";
            
            InvestmentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"InvestmentCell" owner:self options:nil][0];
                cell.delegate = self;
                //        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
                //        view.backgroundColor = [UIColorWithRGB(0x2b3655) colorWithAlphaComponent:0.2];
                //        cell.selectedBackgroundView = view;//选中后cell的背景颜色
            }
            InvestmentItemInfo *info = [_investmentArr objectSafeAtIndex:indexPath.row];
            cell.investButton.tag = 100 + indexPath.row;
            [cell setItemInfo:info];
            NSArray *prdLabelsList = [NSArray arrayWithArray:(NSArray*)info.prdLabelsList];
            
            if (![prdLabelsList isEqual:@""])
            {
                for (NSDictionary *dic in prdLabelsList)
                {
                    NSString *labelPriority = dic[@"labelPriority"];
                    if ([labelPriority isEqual:@"1"])
                    {
                        cell.angleView.angleString = dic[@"labelName"];
                    }
                }
            }
            return cell;
        }
    }
    return nil;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UCFCollectionBidCell *cell = (UCFCollectionBidCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.collectionBidModel) {
           [self gotoCollectionDetailViewContoller:cell.collectionBidModel];
        }
    }
    else {
        if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
            //如果未登录，展示登录页面
            [self showLoginView];
        } else {
            if ([self checkUserCanInvestIsDetail:YES]) {
                _indexPath = indexPath;
                InvestmentItemInfo * info = [_investmentArr objectAtIndex:_indexPath.row];
                NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
                NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@",info.idStr,userid];
                if ([info.status intValue ] != 2) {
                    NSInteger isOrder = [info.isOrder integerValue];
                    if (isOrder > 0) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self];
                    } else {
                        UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对投资人开放"];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                } else {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self];
                }
            }
        }
    }
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
    [[NetworkModule sharedNetworkModule]newPostReq:strParameters tag:kSXTagPrdClaimsNewVersion owner:self signature:YES];

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
            //============ 新街口解析方法2016年11月16日 ============
            //============ 新手活动 ============
//            _activitiesList = dic[@"activitiesList"];
//            if (_activitiesList.count) {
//                _activitiesLab.text = _activitiesList[0][@"title"];
//                id oldActId = [[NSUserDefaults standardUserDefaults]objectForKey:@"activitiesId"];
//                id newActId = _activitiesList[0][@"id"];
//                if (![oldActId isEqual:newActId]) {
//                    [[NSUserDefaults standardUserDefaults]setObject:newActId forKey:@"activitiesId"];
//                    [self activitiesAction:YES];
//                }
//            }
            //============ tips提示 ============
            if([[NSUserDefaults standardUserDefaults] objectForKey:UUID]){//登录状态下，显示tipView
                //个人中心接口添加开户装填
                NSString *openStatusStr = [[dic objectSafeForKey:@"data" ] objectSafeForKey:@"openStatus"];
                [UserInfoSingle sharedManager].openStatus = [openStatusStr integerValue];
                //暂时添加，未调试接口 *** hqy
                if([openStatusStr intValue] > 3 ){
                    _tipsViewHeight.constant = 0;
                }else{
                    _tipsViewHeight.constant = 35.0f;
                }
                NSString *tipsDesStr = [[dic objectSafeForKey:@"data" ] objectSafeForKey:@"tipsDes"];//tips提示
                if (![tipsDesStr isEqualToString:@""]) {
                    _tipsLabel.text = tipsDesStr;
                }
            }else{
               _tipsViewHeight.constant = 0;
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
            } else {
                 [AuxiliaryFunc showAlertViewWithMessage:dic[@"statusdes"]];
            }
        }
    } else if(tag.intValue == kSXTagGetIgnorgeLogin) {
        if([dic[@"status"] integerValue] == 1) {
            self.wapActToken = dic[@"wapActToken"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:self.wapActToken forKey:@"token"];
            [dict setValue:[Common getIOSVersion] forKey:@"version"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:REALNAME] forKey:@"realName"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:UUID] forKey:@"userId"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:PHONENUM] forKey:@"mobile"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:LOGINNAME] forKey:@"username"];
            
            NSString *tmpfinalStr = @""; //仅仅就是为了获取验签串
            NSString *finalStr = @"";
            //加两个临时变量为了协调与服务之间的encryptParam这个是传给服务器，encryptParam1这个是用于加密验签的 直接给服务器 解析报错（注意！）
            
            //传递给服务器的AES把+号，转换为%2B;
            NSString * encryptParam  = [Common AESWithKey2:[Common getKeychain] WithDic:dict];
            //参与验签的AES加密串，不转换+号的
            NSString * encryptParam1 = [Common AESWithKeyWithNoTranscode2:[Common getKeychain] WithData:dict];
            
            tmpfinalStr = [NSString stringWithFormat:@"encryptParam=%@",encryptParam1];
            tmpfinalStr = [tmpfinalStr stringByAppendingString:@"&sourceType=1"];
            tmpfinalStr = [tmpfinalStr stringByAppendingString:[NSString stringWithFormat:@"&imei=%@",[Common getKeychain]]];
            NSString *signature = [Common getSinatureWithPar:[Common getParStr:tmpfinalStr]];
            
            finalStr = [NSString stringWithFormat:@"encryptParam=%@",encryptParam];
            finalStr = [finalStr stringByAppendingString:@"&sourceType=1"];
            finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"&imei=%@",[Common getKeychain]]];
            finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"&signature=%@",signature]];
            finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
            
            UCFCycleModel *banInfo = _banderArr[_scrollViewIndex];
            NSString *fin = [NSString stringWithFormat:@"%@?%@",banInfo.url,finalStr];
            FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:fin title:banInfo.title];
            webView.baseTitleType = @"lunbotuhtml";
            webView.flageHaveShareBut = @"分享";
            webView.dicForShare = banInfo;
            [self.navigationController pushViewController:webView animated:YES];
        }
    }else if (tag.intValue == kSXTagColPrdclaimsDetail) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            
            UCFCollectionDetailViewController *collectionDetailVC = [[UCFCollectionDetailViewController alloc]initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
            collectionDetailVC.souceVC = @"P2PVC";
            collectionDetailVC.colPrdClaimId = _colPrdClaimIdStr;
            collectionDetailVC.detailDataDict = [dic objectSafeDictionaryForKey:@"data"];
            [self.navigationController pushViewController:collectionDetailVC  animated:YES];
            
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    [_tableView.header endRefreshing];
//    [_tableView.footer endRefreshing];
}
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    switch ([UserInfoSingle sharedManager].openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:@"请先开通徽商存管账户"];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
              [self showHSAlert:@"请先设置交易密码"];
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
    }else if (alertView.tag == 9000) {
        if(buttonIndex == 1){ //测试
            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            vc.url = GRADELURL;
            [self.navigationController pushViewController:vc animated:YES];
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
        if ([self checkUserCanInvestIsDetail:NO]) {
            _colPrdClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
            NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", _colPrdClaimIdStr, @"colPrdClaimId", nil];
            [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagColPrdclaimsDetail owner:self signature:YES];
        }
    }
}

- (void)collectionCell:(UCFCollectionBidCell *)currentView didClickedMoreButton:(UIButton *)MoreButton
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.tabBarController setSelectedIndex:1];
    UCFProjectListController *project = (UCFProjectListController *)[[appdelegate.tabBarController.viewControllers objectAtIndex:1].childViewControllers objectAtIndex:0];
    project.strStyle = @"11";
    project.viewType = @"2";
    BOOL isLoad = [project isViewLoaded];
    if (isLoad) {
        [project changeViewWithConfigure:@"11"];
    }
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
