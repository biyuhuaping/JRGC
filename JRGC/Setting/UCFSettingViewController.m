//
//  UCFSettingViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/8.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingViewController.h"
#import "SettingMainButton.h"
#import "UCFSettingMainCell.h"
#import "UCFSettingGroup.h"
#import "UCFSettingArrowItem.h"
#import "NZLabel.h"
#import "UCFPersonalInfoModel.h"
#import "UCFMenuTableCell.h"
#import "UCFToolsMehod.h"
#import "UCFAccountDetailViewController.h"
#import "UCFBackMoneyDetailViewController.h"
#import "UCFCouponViewController.h"
#import "UCFFeedBackViewController.h"
#import "UCFFacCodeViewController.h"
#import "UCFMyFacBeanViewController.h"
#import "MyViewController.h"
#import "UCFRedEnvelopeViewController.h"
#import "UCFSecurityCenterViewController.h"
#import "UCFTopUpViewController.h"
#import "UCFCashViewController.h"
#import "AppDelegate.h"
//#import "BindBankCardViewController.h"

#import "UCFGuaPopViewController.h"
#import "ToolSingleTon.h"
#import "Touch3DSingle.h"
#import "UITabBar+TabBarBadge.h"
#import "MjAlertView.h"
#import "HWWeakTimer.h"
#import "PraiseAlert.h"
#import "UCFLoginViewController.h"
#import "UCFMessageCenterViewController.h"
#import "PromptView.h"
#import "UCFRegisterStepOneViewController.h"
#import "UCFMoreViewController.h"
#import "UCFCashAndTopUp.h"
#import "UCFMenuItemModel.h"
#import "UCFWorkPointsViewController.h"
#import "Common.h"
#import "UCFContributionValueViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"

// 提示按钮
#import "UCFTipButton.h"
//徽商存管账户
#import "UCFHuiShangBankViewController.h"
#import "UCFOldUserGuideViewController.h"
#import "UCFBankDepositoryAccountViewController.h" //微商存管资金账户专题页面
#import "FullWebViewController.h"

#import "UCFSession.h"

@interface UCFSettingViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,PraiseAlertDelegate,PromptViewDelegate, UCFCashAndTopUpDelegate, UCFMenuTableCellDelegate>
{
    CGFloat                  preScreenLight;    //原始屏幕亮度
    CGFloat                  fixedScreenLight;  //原始屏幕亮度记录值 不变
    BOOL                     isAddScreenLight;  //YES 增加屏幕亮度 No 降低屏幕亮度
    PraiseAlert              *alertTool;
    NSString                 *signDays;
    BOOL                      checkRedPoint;
    BOOL                      isShowTip; //是否显示提示按钮
    CGFloat                  mnueViewShowRate;
}

@property (strong, nonatomic) UCFGuaPopViewController *popView;
@property (weak, nonatomic) IBOutlet UIButton *signButton;  //签到按钮
@property (weak, nonatomic) IBOutlet UILabel *signLabel;    //签到标签
@property (weak, nonatomic) IBOutlet UIImageView *userImage;       // 用户头像
@property (weak, nonatomic) IBOutlet UILabel *userName;  //用户姓名
@property (weak, nonatomic) IBOutlet UIImageView *userLevel;    //会员等级
@property (weak, nonatomic) IBOutlet NZLabel *totalLabel;                   // 总资产
@property (weak, nonatomic) IBOutlet NZLabel *arrivingPrinAndInterestLabel; // 累计收益
@property (weak, nonatomic) IBOutlet UILabel *blanceLabel;                  // 账户余额
- (IBAction)signedButton:(UIButton *)sender; // 签到
- (IBAction)assetDetail:(UIButton *)sender; // 资金流水
@property (weak, nonatomic) IBOutlet UIImageView *messageWarningPoint;  // 未读消息标志
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segLineW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLevelCenterY;
//  vip的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameXCenter;

@property (nonatomic, weak) UCFCashAndTopUp *cashAndTopUp; // 提现和充值的view
// 九宫格的标题和图片数组
@property (nonatomic, strong) NSMutableArray *item_images;
@property (nonatomic, strong) NSMutableArray *item_names;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) NSMutableArray *actMenuItems;


@property (strong, nonatomic) NSString *sex;//性别
@property (strong, nonatomic) NSString *gcm;//工场码

// 底部选项表
@property (weak, nonatomic) IBOutlet UITableView *itemsTableview;
// 选项表数据
@property (nonatomic, strong) NSMutableArray *itemsData;

//@property (strong, nonatomic) UCFCashViewController *crachViewController;

@property (strong, nonatomic) UIView *alertView;
@property (strong, nonatomic) UIView *background;
// 调节亮度计时器
@property (nonatomic, weak) NSTimer *cycleTimer;

@property (strong, nonatomic) id signflags;                 //是否已签到
@property (assign, nonatomic) BOOL isHaveNewestPayment;     //是否有回款
@property (assign, nonatomic) BOOL isHaveFriendsPayBack;    //是否有邀请返利
@property (assign, nonatomic) BOOL isHaveUnReadMsg;         //消息中心是否有更新

@property (assign, nonatomic) BOOL isCompanyAgent;          //是否为机构	string	true：是机构 false:不是机构
@property (assign, nonatomic)  NSInteger openStatus;	    //资管状态 1:未开户 2:已开户 3:已绑卡 4:已经设置交易密码 5:特殊用户
//@property (strong,nonatomic) NSString *tipsDes;    //tip提示信息

@property (weak,nonatomic) IBOutlet UCFTipButton *tipButton;

@property (assign,nonatomic) BOOL isClickCashBtn; //是否点击提现按钮 ---hqy添加

@property (assign, nonatomic)BOOL isComeTabbar;   //是否通过tabbar过来的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipButtonH;  //提示按钮高度
@end

@implementation UCFSettingViewController
- (NSMutableArray *)menuItems {
    if (!_menuItems) {
        _menuItems = [NSMutableArray array];
    }
    return _menuItems;
}

- (void)viewDidLoad {
    
    isShowTip = NO;
    
    mnueViewShowRate = (320.0/300.0);
    
    self.isHideNavigationBar = YES;
    self.baseTitleType = @"personnalCenter";
    
    // 注册请求通知
    [self addTimerNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShadowView:) name:@"popPersonCenterShadowView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultViewData) name:@"setDefaultViewData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonalCenterNetData:) name:@"getPersonalCenterNetData" object:nil];
    //如果从3DTouch进来，就调用 responds3DTouchClick 方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responds3DTouchClick) name:@"responds3DTouchClick" object:nil];

//    [self initData];
    [self initUI];
    //登录状态才请求数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        [self getPersonalCenterNetData:nil];
    }
    [self.itemsTableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(tmpGetUserData)];
    
    alertTool = [[PraiseAlert alloc]init];
    alertTool.delegate = self;
    self.openStatus = [UserInfoSingle sharedManager].openStatus;
    
}
- (void)tmpGetUserData
{
    [self getPersonalCenterNetData:nil];
}
#pragma mark -promptViewDelegate

- (void)handlePromptViewRemovedEvent:(PromptView *)promptView
{
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (checkRedPoint && _checkedFeedBack) {
        [self showGoodCommentsAlert];
    }
}
#pragma mark PraiseAlertDelegate
- (void)popYouMengFeedBackViewController
{
//    UMFeedbackViewController *modalViewController = [[UMFeedbackViewController alloc] init];
//    modalViewController.modalStyle = YES;
//    for (UIView *view in modalViewController.view.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            view.hidden = YES;
//        }
//        if (view.frame.origin.y == 62) {
//            view.hidden = YES;
//        }
//    }
//    [self presentViewController:modalViewController animated:YES completion:nil];
}
#pragma ------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:!_isComeTabbar];
    _isComeTabbar = NO;
    [self.itemsTableview setContentOffset:CGPointZero animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        [self hideShadowView];
        [PromptView addGuideViewWithKey:@"personerCenter1" isHorizontal:NO delegate:self imageBlock:^NSString *{
            NSString *imageName = @"mask4s_4.jpg";
            if (ScreenHeight > 480) {
                imageName = @"mask56_4.jpg";
            }
            return imageName;
        } isFirstPage:NO];
        [PromptView addGuideViewWithKey:@"personerCenter2" isHorizontal:NO delegate:self imageBlock:^NSString *{
            NSString *imageName = @"mask4s_5.jpg";
            if (ScreenHeight > 480) {
                imageName = @"mask56_5.jpg";
            }
            return imageName;
        } isFirstPage:NO];
    } else {
        [self addShadowViewAndLoginBtn];
    }
}
- (void)popShadowView:(NSNotification*)info
{
    [self setDefaultViewData];
    [self addShadowViewAndLoginBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

// 初始化界面
- (void)initUI
{
    UIView *cashAndTopBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57)];
    UCFCashAndTopUp *cashAndTop = [[[NSBundle mainBundle] loadNibNamed:@"UCFCashAndTopUp" owner:self options:nil] lastObject];
    cashAndTop.frame = cashAndTopBackView.bounds;
    cashAndTop.delegate = self;
    [cashAndTopBackView addSubview:cashAndTop];
    self.itemsTableview.tableHeaderView = cashAndTopBackView;
//    self.itemsTableview.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.segLineW.constant = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserIcon:)];
    [self.userImage addGestureRecognizer:tap];
    
//    self.cashAndTopUp = cashAndTop;
    
    NSArray *menuItems = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MenuList" ofType:@"plist"]];
    if (self.menuItems) {
        [self.menuItems removeAllObjects];
    }
    
    for (NSDictionary *dict in menuItems) {
        UCFMenuItemModel *model = [[UCFMenuItemModel alloc] init];
        model.hasWarningNum = NO;
        model.name = [dict objectForKey:@"name"];
        model.image = [dict objectForKey:@"image"];
        model.itemId = [dict objectForKey:@"itemId"];
        [self.menuItems addObject:model];
    }
    
    self.actMenuItems = [[NSMutableArray alloc] initWithArray:(NSArray *)self.menuItems];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isShowFacPoint"]) {
        for (UCFMenuItemModel *model in self.menuItems) {
            if ([model.itemId integerValue] == 7) {
                [self.actMenuItems removeObject:model];
            }
        }
    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isShowFacPoint"]) {
//        self.item_images = [[NSMutableArray alloc] initWithObjects:@"user_icon_safe", @"uesr_icon_investment", @"uesr_icon_detail", @"uesr_icon_rabate",@"uesr_icon_class",
//                            @"uesr_icon_coupon", @"uesr_icon_score",@"uesr_icon_bean",
//                         @"uesr_icon_number",@"uesr_icon_redbag",
//                       @"uesr_icon_scratchcard", @"uesr_icon_more", nil];
//        self.item_names = [[NSMutableArray alloc] initWithObjects:@"徽商存管账户", @"我的投资", @"回款明细", @"邀请返利",@"会员等级", @"优惠券", @"工分",@"工豆",  @"工场码",@"红包", @"刮刮卡",@"更多", nil];
//    }
//    else {
//        self.item_images = [[NSMutableArray alloc] initWithObjects:@"user_icon_safe", @"uesr_icon_investment", @"uesr_icon_detail", @"uesr_icon_rabate",@"uesr_icon_class",
//                       @"uesr_icon_coupon", @"uesr_icon_bean",
//                @"uesr_icon_number",@"uesr_icon_redbag",@"uesr_icon_scratchcard",@"uesr_icon_more", nil];
//        self.item_names = [[NSMutableArray alloc] initWithObjects:@"徽商存管账户", @"我的投资", @"回款明细", @"邀请返利",@"会员等级",  @"优惠券", @"工豆", @"工场码", @"红包",  @"刮刮卡",@"更多", nil];
//    }
//    
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i=0; i<self.item_images.count; i++) {
//        UCFMenuItemModel *model = [[UCFMenuItemModel alloc] init];
//        model.hasWarningNum = NO;
//        model.itemImageName = self.item_images[i];
//        model.itemName = self.item_names[i];
//        [array addObject:model];
//    }
    
//    UCFMenuView *menuView = [[UCFMenuView alloc] initWithItems:array];
//    menuView.delegate = self;
//    self.menuView = menuView;
    
//     设置用户头像
  //  self.userImage.layer.cornerRadius = CGRectGetHeight(self.userImage.frame)/2.0;
    //self.userImage.clipsToBounds = YES;
    
    self.userLevelCenterY.constant = -0.5;
    
    [self.tipButton addTarget:self action:@selector(tipClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置用户名阴影
//    self.userNameLabel.shadowOffset = CGSizeMake(0, 1);
    _itemsTableview.backgroundColor = UIColorWithRGB(0xebebee);
    
}

// 提示按钮点击
- (void)tipClicked:(UIButton *)btn
{
//    btn.selected = !btn.selected;
//    isShowTip = btn.selected;
//    [self.itemsTableview reloadData];
        switch ([UserInfoSingle sharedManager].openStatus) {// ***hqy添加
            case 1://未开户-->>>新用户开户
            case 2://已开户 --->>>老用户(白名单)开户
            {
                UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
                bankDepositoryAccountVC.openStatus = [UserInfoSingle sharedManager].openStatus;
                [self.navigationController pushViewController:bankDepositoryAccountVC animated:YES];
            }
                break;
            case 3://已绑卡 --->>>去设置交易密码页面
            {
                UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
}

//触发好评框
- (void)showGoodCommentsAlert
{
    [alertTool checkPraiseAlertIsEjectWithGoodCommentAlertType:PaymentStyle WithRollBack:^{
        _alertState = StateDefault;
        _checkedFeedBack = NO;
    }];
}

- (void)addTimerNotification
{
    //增加界面亮度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginAddTimer) name:AddBrightness object:nil];
    //降低亮度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginReduceTimer) name:ReduceBrightness object:nil];
    //结束亮度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endTimer) name:EndBrightnessTimer object:nil];
    //添加一个计时器，使亮度渐增亮
    _cycleTimer = [HWWeakTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeWindowBrightness) userInfo:nil repeats:YES];
    //让计时器停止运行
    [_cycleTimer setFireDate:[NSDate distantFuture]];
}

- (void)changeWindowBrightness
{
    if (isAddScreenLight) {
        preScreenLight += 0.003;
        if (preScreenLight >= 1) {
            [_cycleTimer setFireDate:[NSDate distantFuture]];
        }
    } else {
        preScreenLight -= 0.003;
        if (preScreenLight <= fixedScreenLight) {
            [_cycleTimer setFireDate:[NSDate distantFuture]];
        }
    }
    [[UIScreen mainScreen] setBrightness:preScreenLight];
}

//TODO:timer
- (void)endTimer
{
    [_cycleTimer setFireDate:[NSDate distantPast]];
}
- (void)beginAddTimer
{
    isAddScreenLight = YES;
    [_cycleTimer setFireDate:[NSDate distantPast]];
}
- (void)beginReduceTimer
{
    isAddScreenLight = NO;
    [_cycleTimer setFireDate:[NSDate distantPast]];
}

//刷新数据
- (void)beginShowLoading{
    if (![_itemsTableview.header isRefreshing]) {
        [_itemsTableview.header beginRefreshing];
    }
}

#pragma mark - tableView
//  选项表数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UCFMenuTableCell *cell = [UCFMenuTableCell cellWithTableView:tableView];
    cell.items = self.actMenuItems;
    cell.delegate = self;
    return cell;
    
//    UCFSettingMainCell *cell = [UCFSettingMainCell cellWithTableView:tableView];
//    UCFSettingGroup *group = self.itemsData[indexPath.section];
//    if (indexPath.row == 0) {
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
//        line.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        [cell.contentView addSubview:line];
//    }
//    else if (indexPath.row ==  group.items.count - 1) {
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 0.5)];
//        line.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        [cell.contentView addSubview:line];
//    }
//    cell.item = group.items[indexPath.row];
//    
//    if (indexPath.row == 0) {
//        cell.messegeImageView.hidden = NO;
//        // 红包二字加 红色
//        [cell.itemTitleLabel setFontColor:UIColorWithRGB(0xfa4d4c) string:@"红包"];
//        //让签到的天数加 红色
//        if(cell.item.subtitle){
//            NSString *totalStr = [NSString stringWithFormat:@"已经连续签到%@天",cell.item.subtitle];
//            cell.itemDetailLabel.text = totalStr;
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
//                cell.itemDetailLabel.text = @"";
//            }
//            [cell.itemDetailLabel setFontColor:UIColorWithRGB(0xfa4d4c) string:cell.item.subtitle];
//        }
//        if ([_signflags boolValue]) {
//            cell.messegeImageView.hidden = YES;
//            cell.itemTitleLabel.text = @"今日已签到";
//        }
//    } else if (indexPath.row == 2) {
//        if (_isHaveNewestPayment) {
//            cell.messegeImageView.hidden = NO;
//            cell.messegeImageView.image = [UIImage imageNamed:@"reward_piont"];
//        } else {
//            cell.messegeImageView.hidden = YES;
//        }
//    } else if (indexPath.row == 3) {
//        cell.messegeImageView.hidden = !_isHaveFriendsPayBack;
//        cell.messegeImageView.image = [UIImage imageNamed:@"reward_piont"];
//    } else if (indexPath.row == 4) {
//        cell.messegeImageView.hidden = !_isHaveUnReadMsg;
//        cell.messegeImageView.image = [UIImage imageNamed:@"reward_piont"];
//    } else {
//        cell.messegeImageView.hidden = YES;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * mnueViewShowRate;
}

#pragma mark - menu代理方法
- (void)menuView:(UCFMenuTableCell *)menuView didClickedItems:(SettingMainButton *)item
{
    if ([item.customTitleLabel.text isEqualToString:@"徽商存管账户"]) {
        if ([UserInfoSingle sharedManager].openStatus < 3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1009;
            [alert show];
            return;
        }
        
        UCFHuiShangBankViewController *subVC = [[UCFHuiShangBankViewController alloc] initWithNibName:@"UCFHuiShangBankViewController" bundle:nil];
//        subVC.title = @"徽商存管账户";
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"我的投资"]) {
        MyViewController *subVC = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
        subVC.title = @"我的投资";
        subVC.selectedSegmentIndex = 0;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"回款明细"]) {
        UCFBackMoneyDetailViewController *vc = [[UCFBackMoneyDetailViewController alloc] initWithNibName:@"UCFBackMoneyDetailViewController" bundle:nil];
        vc.superViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"邀请返利"]) {
        UCFFeedBackViewController *subVC = [[UCFFeedBackViewController alloc] initWithNibName:@"UCFFeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"游戏中心"]) {
        UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        subVC.url = GAMECENTERURL;
        subVC.navTitle = @"游戏中心";
        [self.navigationController pushViewController:subVC animated:YES];
        
    }
    else if ([item.customTitleLabel.text isEqualToString:@"会员等级"]) {
//        UCFContributionValueViewController *subVC = [[UCFContributionValueViewController alloc]initWithNibName:@"UCFContributionValueViewController" bundle:nil];
//        subVC.title = @"我的贡献值";
//        [self.navigationController pushViewController:subVC animated:YES];
       UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        subVC.url = LEVELURL;
        subVC.navTitle = @"会员等级";
        [self.navigationController pushViewController:subVC animated:YES];

    }
    else if ([item.customTitleLabel.text isEqualToString:@"优惠券"]) {
        UCFCouponViewController *subVC = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"工豆"]) {
        UCFMyFacBeanViewController *subVC = [[UCFMyFacBeanViewController alloc] initWithNibName:@"UCFMyFacBeanViewController" bundle:nil];
        subVC.title = @"我的工豆";
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"工分"]) {
        UCFWorkPointsViewController *subVC = [[UCFWorkPointsViewController alloc]initWithNibName:@"UCFWorkPointsViewController" bundle:nil];
        subVC.title = @"我的工分";
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"工场码"]) {
        //我的工场码
        fixedScreenLight = [UIScreen mainScreen].brightness;
        UCFFacCodeViewController *subVC = [[UCFFacCodeViewController alloc] initWithNibName:@"UCFFacCodeViewController" bundle:nil];
        subVC.urlStr = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/mycode.jsp?pcode=%@&sex=%@",_gcm,_sex];
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"刮刮卡"]) {
        _popView = [[UCFGuaPopViewController alloc] init];
        _popView.delegate = self;
        [_popView showPopView:self];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"红包"]) {
        UCFRedEnvelopeViewController *subVC = [[UCFRedEnvelopeViewController alloc] initWithNibName:@"UCFRedEnvelopeViewController" bundle:nil];
        subVC.title = @"我的红包";
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.customTitleLabel.text isEqualToString:@"更多"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UCFMoreViewController" bundle:nil];
        UCFMoreViewController *moreVC = [storyboard instantiateViewControllerWithIdentifier:@"more_main"];
        moreVC.title = @"更多";
        moreVC.sourceVC = @"UCFSettingViewController";
        [self.navigationController pushViewController:moreVC animated:YES];
    }
}

#pragma mark - Navigation
// 资金账户、充值和提现
- (void)cashAndTopUp:(UCFCashAndTopUp *)cashAndTopUp didClickedCashButton:(UIButton *)cashButton
{
    self.isClickCashBtn = YES;
    if ([self checkIDAAndBankBlindState]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      NSString *userSatues = [NSString stringWithFormat:@"%ld",(long)[UserInfoSingle sharedManager].openStatus];
        NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userId",userSatues,@"userSatues",nil];
//        NSString *strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
//        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagCashAdvance owner:self];
        [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES];
    }
}

- (void)cashAndTopUp:(UCFCashAndTopUp *)cashAndTopUp didClickedTopUpButton:(UIButton *)topUpButton
{
    self.isClickCashBtn = NO;//是否点击提现按钮
    if ([self checkIDAAndBankBlindState]) {
//        if ([UserInfoSingle sharedManager].openStatus == 5) { //***需求取消
//            FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:RECHARGERUL title:@"特殊用户充值提醒"];
//            webController.baseTitleType = @"specialUser";
//            [self.navigationController pushViewController:webController animated:YES];
//        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
            UCFTopUpViewController * vc1 = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
            vc1.title = @"充值";
            vc1.uperViewController = self;
            [self.navigationController pushViewController:vc1 animated:YES];
//        }
    }
}

// 按钮点击方法
- (BOOL)checkIDAAndBankBlindState
{
    NSUInteger openStatus = self.openStatus;
    if (openStatus == 1 || openStatus == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1009;
        [alert show];
        return NO;
    }else if(openStatus == 3){
        if (self.isClickCashBtn) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1010;
            [alert show];
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

#pragma mark - 按钮点击方法

- (IBAction)assetDetail:(UIButton *)sender {
    UCFAccountDetailViewController *vc = [[UCFAccountDetailViewController alloc] initWithNibName:@"UCFAccountDetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
// 签到
- (IBAction)signedButton:(UIButton *)sender {
   
    [self getSinanApptzticket];
}
-(void)requestSignHttpData:(NSString *)apptzticketStr{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&apptzticket=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID],apptzticketStr];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagSingMenthod owner:self];
}

// 跳转至个人信息界面
- (void)tapUserIcon:(UITapGestureRecognizer *)gesture {
    
    UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
    personMessageVC.title = @"个人信息";
    [self.navigationController pushViewController:personMessageVC animated:YES];
}

// 消息中心
- (IBAction)messageCenter:(UIButton *)sender {
    
    UCFMessageCenterViewController *messagecenterVC = [[UCFMessageCenterViewController alloc]initWithNibName:@"UCFMessageCenterViewController" bundle:nil];
    messagecenterVC.title =@"消息中心";
    [self.navigationController pushViewController:messagecenterVC animated:YES];
}

#pragma mark - 获取网络数据
- (void)getPersonalCenterNetData:(NSNotification *)noti
{
    if (noti.object) {
        _isComeTabbar = YES;
    } else {
        _isComeTabbar = NO;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPersonCenter owner:self];
    }
}
-(void)getSinanApptzticket{
    NSString *parStr = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:parStr tag:kSXTagSignDaysAndIsSign owner:self];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    DBLOG(@"UCFSettingViewController : %@",dic);
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    int isSucess = [rstcode intValue];

    if (tag.intValue == kSXTagPersonCenter) {
        if (isSucess == 1) {
            NSDictionary *result = dic[@"data"];
            _signflags = dic[@"signflags"];
            NSString *gcmCode = [result objectSafeForKey: @"gcm"]; //用户工场码
            [[NSUserDefaults standardUserDefaults] setValue:gcmCode forKey:@"gcmCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UCFSession sharedManager] transformBackgroundWithUserInfo:@{} withState:UCFSessionStateUserRefresh];
            NSString *memberL = [NSString stringWithFormat:@"%@", dic[@"memberLever"]];
            if (memberL.length>0) {
                self.userLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercenter_vip%@_icon", memberL]];
            }
            else {
                self.userLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercenter_vip1_icon"]];
            }
//
            NSString *openStatusStr = [dic objectSafeForKey:@"openStatus"];
            NSString *userName = result[@"userName"];
            NSString *mobile = result[@"mobile"];
            
            //个人中心接口添加开户装填
            [UserInfoSingle sharedManager].openStatus = [openStatusStr integerValue];
            self.openStatus = [openStatusStr integerValue];
            [UserInfoSingle sharedManager].realName = [UCFToolsMehod isNullOrNilWithString:userName];
            [UserInfoSingle sharedManager].mobile = [UCFToolsMehod isNullOrNilWithString:mobile];

            BOOL isShowFacPoints = [dic[@"isOpen"] boolValue];
//            BOOL isShowFacPoints = [@"0" boolValue];
            self.userLevel.hidden = !isShowFacPoints;
            
            NSString *isCompanyAgentStr = [NSString stringWithFormat:@"%@",[dic objectSafeForKey:@"isCompanyAgent"]];
            _isCompanyAgent = [isCompanyAgentStr boolValue];
            if (_isCompanyAgent) {
                self.signButton.hidden = YES;
                self.signLabel.hidden = YES;
                self.vipWidth.constant = 40;
                self.userNameXCenter.constant = -19;
                [self.actMenuItems removeAllObjects];
                for (UCFMenuItemModel *model in self.menuItems) {
                    if (([model.itemId integerValue] == 3) || ([model.itemId integerValue] == 8)) {
                        
                    }
                    else {
                        [self.actMenuItems addObject:model];
                    }
                }
//                self.item_images = [[NSMutableArray alloc] initWithObjects:@"user_icon_safe", @"uesr_icon_investment", @"uesr_icon_detail", @"uesr_icon_class",
//                                    @"uesr_icon_coupon", @"uesr_icon_score",@"uesr_icon_bean",
//                                    @"uesr_icon_redbag",
//                                    @"uesr_icon_scratchcard", @"uesr_icon_more", nil];
//                self.item_names = [[NSMutableArray alloc] initWithObjects:@"徽商存管账户", @"我的投资", @"回款明细", @"会员等级", @"优惠券",@"工分", @"工豆",  @"红包",@"刮刮卡",  @"更多", nil];
//                NSMutableArray *array = [NSMutableArray array];
//                for (int i=0; i<self.item_images.count; i++) {
//                    UCFMenuItemModel *model = [[UCFMenuItemModel alloc] init];
//                    model.hasWarningNum = NO;
//                    model.itemImageName = self.item_images[i];
//                    model.itemName = self.item_names[i];
//                    [array addObject:model];
//                }
//                
//                self.menuView = [[UCFMenuView alloc] initWithItems:array];
//                self.menuView.delegate = self;
                [self.itemsTableview reloadData];
            }
            else {
                self.signButton.hidden = NO;
                self.signLabel.hidden = NO;
                if (isShowFacPoints) {
                    self.vipWidth.constant = 40;
                    self.userNameXCenter.constant = -19;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowFacPoint"];
                    self.actMenuItems = [[NSMutableArray alloc] initWithArray:(NSArray *)self.menuItems];
//                    self.item_images = [[NSMutableArray alloc] initWithObjects:@"user_icon_safe", @"uesr_icon_investment", @"uesr_icon_detail", @"uesr_icon_rabate",@"uesr_icon_class",
//                                        @"uesr_icon_coupon", @"uesr_icon_score",@"uesr_icon_bean",
//                                          @"uesr_icon_number",@"uesr_icon_redbag",
//                                        @"uesr_icon_scratchcard", @"uesr_icon_more", nil];
//                    self.item_names = [[NSMutableArray alloc] initWithObjects:@"徽商存管账户", @"我的投资", @"回款明细", @"邀请返利",@"会员等级", @"优惠券",@"工分", @"工豆",  @"工场码", @"红包",@"刮刮卡",  @"更多", nil];
//                    NSMutableArray *array = [NSMutableArray array];
//                    for (int i=0; i<self.item_images.count; i++) {
//                        UCFMenuItemModel *model = [[UCFMenuItemModel alloc] init];
//                        model.hasWarningNum = NO;
//                        model.itemImageName = self.item_images[i];
//                        model.itemName = self.item_names[i];
//                        [array addObject:model];
//                    }
//                    
//                    self.menuView = [[UCFMenuView alloc] initWithItems:array];
//                    self.menuView.delegate = self;
                    [self.itemsTableview reloadData];
                    if ([UserInfoSingle sharedManager].openStatus == 5) {
                        if ([self isVisible]) {
                            [MBProgressHUD displayHudError:@"特殊用户禁止同步刷新账户余额"];
                        }
                    }
                }
                else if (!isShowFacPoints) {
                    self.vipWidth.constant = 0;
                    self.userNameXCenter.constant = 0;
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowFacPoint"];
                    self.actMenuItems = [[NSMutableArray alloc] initWithArray:(NSArray *)self.menuItems];
                    
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isShowFacPoint"]) {
                        for (UCFMenuItemModel *model in self.menuItems) {
                            if ([model.itemId integerValue] == 6) {
                                [self.actMenuItems removeObject:model];
                            }
                        }
                    }
//                    self.item_images = [[NSMutableArray alloc] initWithObjects:@"user_icon_safe", @"uesr_icon_investment", @"uesr_icon_detail", @"uesr_icon_rabate",@"uesr_icon_class",
//                                        @"uesr_icon_coupon", @"uesr_icon_bean", @"uesr_icon_number", @"uesr_icon_redbag",@"uesr_icon_scratchcard",  @"uesr_icon_more", nil];
//                    self.item_names = [[NSMutableArray alloc] initWithObjects:@"徽商存管账户", @"我的投资", @"回款明细", @"邀请返利",@"会员等级", @"优惠券", @"工豆", @"工场码", @"红包",@"刮刮卡",  @"更多", nil];
//                    NSMutableArray *array = [NSMutableArray array];
//                    for (int i=0; i<self.item_images.count; i++) {
//                        UCFMenuItemModel *model = [[UCFMenuItemModel alloc] init];
//                        model.hasWarningNum = NO;
//                        model.itemImageName = self.item_images[i];
//                        model.itemName = self.item_names[i];
//                        [array addObject:model];
//                    }
//                    
//                    self.menuView = [[UCFMenuView alloc] initWithItems:array];
//                    self.menuView.delegate = self;
                    [self.itemsTableview reloadData];
                }
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ToolSingleTon sharedManager].apptzticket = dic[@"apptzticket"];
            UCFPersonalInfoModel *model = [UCFPersonalInfoModel personalInfoModelWithDict:result];
            
            
            NSString *tipsDesStr = [dic objectSafeForKey:@"tipsDes"];
            
            
            if (self.openStatus  <= 3) {
                isShowTip = YES;
                if (self.tipButtonH.constant==0) {
                    self.tipButtonH.constant = 37;
//                    self.itemsTableview.contentInset = UIEdgeInsetsMake(0, 0, 37, 0);
                    self.tipButton.hidden = NO;
                }
                
            }else{
                isShowTip = NO;
                self.tipButtonH.constant = 0;
                self.tipButton.hidden = YES;
            }
            [self.tipButton setTitle:@"" forState:UIControlStateNormal];
            if (![tipsDesStr isEqualToString:@""] && isShowTip) {//设置tipView的标题
                [self.tipButton setTitle:tipsDesStr forState:UIControlStateNormal];
            }
            
            [self showUserInfoWithPersonalInfo:model];
            [self.itemsTableview reloadData];
        }
        else {
            if (rsttext.length > 0) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            } else {
                [AuxiliaryFunc showToastMessage:@"服务器繁忙,请稍后再试" withView:self.view];
            }
        }
        if (self.itemsTableview.header.isRefreshing) {
            [self.itemsTableview.header endRefreshing];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self responds3DTouchClick];//响应3DTouch点击
        });
    } else if (tag.intValue == kSXTagSingMenthod){
        NSString *flag = dic[@"flag"];
        __weak UCFSettingViewController * weakSelf = self;
        if ([flag isEqualToString:@"success"]) {//签到成功
            [self showSignSuccessWithResult:dic];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //签完到之后重新加载 用户数据
//                [weakSelf  getPersonalCenterNetData:nil];
            });
        } else if ([flag isEqualToString:@"already"]) {//已签到
            [AuxiliaryFunc showToastMessage:@"今日已签到" withView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //签完到之后重新加载 用户数据
                [weakSelf  getPersonalCenterNetData:nil];
            });
        } else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    } else if (tag.integerValue == kSXTagCashAdvance) {
        rstcode = dic[@"ret"];
        rsttext = dic[@"message"];
        isSucess = [rstcode intValue];
        if (isSucess == 1) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TopUpAndCash" bundle:nil];
            UCFCashViewController *crachViewController  = [storyboard instantiateViewControllerWithIdentifier:@"cash"];
                [ToolSingleTon sharedManager].apptzticket = dic[@"apptzticket"];
                crachViewController.title = @"提现";
                crachViewController.isCompanyAgent = _isCompanyAgent;
                crachViewController.cashInfoDic = dic;
                [self.navigationController pushViewController:crachViewController animated:YES];
                return;
        } else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }

    } else if (tag.intValue == kSXTagGuaGuaPost) {
        if ([rstcode intValue] == 1) {
            [_popView hideView];
            NSString *message = @"请到个人中心-优惠券中查看返现券投资即可使用";
            if ([dic[@"cardType"] isEqualToString:@"5"]) {
                message = @"请到个人中心-工豆中查看工豆投资即可使用";
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"兑换成功" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"立即查看", nil];
            if ([dic[@"cardType"] isEqualToString:@"5"]) {
                alertView.tag = 9998;
            } else {
                alertView.tag = 9999;
            }
            [alertView show];
            [self getPersonalCenterNetData:nil];
        } else {
            NSString *errorStr = rsttext;
            _popView.errorInfoLbl.text = errorStr;
        }
    }else if (tag.intValue == kSXTagSignDaysAndIsSign) {
      NSString * apptzticket =  [dic objectSafeForKey:@"apptzticket"];
        [self requestSignHttpData:apptzticket];
    }

}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (self.itemsTableview.header.isRefreshing) {
        [self.itemsTableview.header endRefreshing];
    }
}
//判断当前viewController 是否显示
- (BOOL)isVisible
{
    return (self.isViewLoaded && self.view.window);
}
//显示用户信息
- (void)showUserInfoWithPersonalInfo:(UCFPersonalInfoModel *)personalInfo
{
    UCFPersonalInfoModel *model = personalInfo;
    //设置用户名
    if (model.userName.length == 0) {
        self.userName.text = @"未实名";
    }else
        self.userName.text = model.userName;
    //设置总资产
    [self.totalLabel setText:[NSString stringWithFormat:@"%@", model.total]];
    //设置累计收益
    [self.arrivingPrinAndInterestLabel setText:[NSString stringWithFormat:@"%@", model.interests]];
    //设置账户余额
    [self.blanceLabel setText:[NSString stringWithFormat:@"%@", model.cashBalance]];
    
    self.messageWarningPoint.hidden = ![model.unReadMsgCount boolValue];
    for (UCFMenuItemModel *menuItem in self.actMenuItems) {
        if ([menuItem.name isEqualToString:@"我的投资"]) {
            
        }
        else if ([menuItem.name isEqualToString:@"回款明细"]) {
            menuItem.hasWarningNum = ([model.refundCount isEqualToString:@"1"]) ? YES : NO;
        }
        else if ([menuItem.name isEqualToString:@"邀请返利"]) {
            //邀请返利和消息中心的数据
            menuItem.hasWarningNum = [model.financialCount boolValue];
        }
        else if ([menuItem.name isEqualToString:@"优惠券"]) {
            if ([model.couponCount boolValue]) {
                menuItem.hasWarningNum = YES;
            }else{
                menuItem.hasWarningNum = NO;
            }
            //zhangruichao fixed
//            if ([model.beanRecordCount boolValue] || [model.interestCount boolValue]) {
//                menuItem.hasWarningNum = YES;
//            }else{
//                menuItem.hasWarningNum = NO;
//            }
        }
        else if ([menuItem.name isEqualToString:@"工豆"]) {
            menuItem.hasWarningNum = [model.beanCount boolValue];
        }
        else if ([menuItem.name isEqualToString:@"红包"]) {
            menuItem.hasWarningNum = [model.redPackageCount boolValue];
        }
    }
    // 是否有未读消息
    _isHaveUnReadMsg = [model.unReadMsgCount isEqualToString:@"1"] ? YES: NO;
    // 红点是否显示
     _isHaveNewestPayment = ([model.refundCount isEqualToString:@"1"]) ? YES : NO;
    // 红点 邀请返利
    _isHaveFriendsPayBack = ([model.financialCount isEqualToString:@"1"]) ? YES : NO;
    if (_isHaveNewestPayment) {
        //拥有回款的状态
        _alertState = StateHavePayment;
        checkRedPoint = YES;
    } else {
        _alertState = StateDefault;
    }

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!_isHaveUnReadMsg && !_isHaveFriendsPayBack && !_isHaveNewestPayment && ![model.beanCount boolValue] && ![model.couponCount boolValue] && ![model.interestCount boolValue] && ![model.redPackageCount boolValue]) {
        // 删除tabBar 红点
        [app.tabBarController.tabBar hideBadgeOnItemIndex:3];
    } else {
        // 添加tabBar 红点
        [app.tabBarController.tabBar showBadgeOnItemIndex:3];
    }
    
//    [self.userPhotoImageView sd_setImageWithURL:[NSURL URLWithString:model.headurl] placeholderImage:[UIImage imageNamed:@"user_icon_head_male"]];
    _sex = model.sex;
    _gcm = model.gcm;
    if ([model.sex isEqualToString:@"0"]) {
        self.userImage.image = [UIImage imageNamed:@"user_icon_head_female"];
    }
    else if ([model.sex isEqualToString:@"1"]) {
        self.userImage.image = [UIImage imageNamed:@"user_icon_head_male"];
    }
    else {
        self.userImage.image = [UIImage imageNamed:@"password_icon_head"];
    }
    
    [self.itemsTableview reloadData];
//    UCFSettingGroup *group1 = [self.itemsData firstObject];
//    //设置连续签到的天数
//    UCFSettingItem *item0 = [group1.items objectAtIndex:0];
//    item0.subtitle = [NSString stringWithFormat:@"%@",model.signDays];
//
//    //设置我的投资数
//    UCFSettingItem *item1 = [group1.items objectAtIndex:1];
//    item1.subtitle = [NSString stringWithFormat:@"共%@笔正在进行", model.prdOrderCount];
//    //设置下一回款日
//    UCFSettingItem *item2 = [group1.items objectAtIndex:2];
//    if (model.repayPerDate.length>0) {
//        item2.subtitle = [NSString stringWithFormat:@"最近回款日%@", model.repayPerDate];
//    }
//    else item2.subtitle = @"";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [baseTitleLabel setText:@"个人中心"];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.alpha = 0;
//    [UIView animateWithDuration:1.0 animations:^{
//        self.navigationController.navigationBar.alpha = 1;
//        
//    }];
//    
//    DLog(@"%@", self.navigationController.navigationBar);
}

#pragma mark - 弹出视图
//展示视图
-(void)showSignSuccessWithResult:(NSDictionary *)dic {
    
    NSString *returnAmount = dic[@"returnAmount"];//签到获得工豆数
    returnAmount = returnAmount?returnAmount:@"0";
    
    NSString *nextDayBeans = @"0";//明日签到获得工豆数
    if (dic[@"nextDayBeans"]) {
        if ([Common isNullValue:dic[@"nextDayBeans"]]) {
            nextDayBeans = [NSString stringWithFormat:@"0"];
        }
        else {
            nextDayBeans = dic[@"nextDayBeans"];
        }
    }
    
    signDays = dic[@"signDays"];//签到天数
    signDays = signDays?signDays:@"0";
    NSString *numDays = dic[@"numDays"];//活动规则的天数
    numDays = numDays?numDays:@"0";
    
    NSString *numBeans = dic[@"numBeans"];//活动规则的工豆数
    numBeans = numBeans?numBeans:@"0";
    
    //是否为工分
    NSString *isOpen = dic[@"isOpen"];
    
    BOOL win = NO;//是否获得红包 true/false
    if ([dic[@"win"] isEqualToString:@"true"]) {
        win = YES;
    }
    
    NSString *winAmount = dic[@"winAmount"];//获得红包金额
    winAmount = winAmount?winAmount:@"0";
    
    NSString *rewardAmt = dic[@"rewardAmt"];//抢光红包再奖励的钱数
    rewardAmt = rewardAmt?rewardAmt:@"0";
    
//    __weak UCFSettingViewController * weakSelf = self;
    
    MjAlertView *alert = [[MjAlertView alloc] initRedBagAlertViewWithBlock:^(id blockContent) {
        UIView *view = (UIView *)blockContent;
        NZLabel *lab1 = [[NZLabel alloc]initWithFrame:CGRectMake(0, 70, view.frame.size.width, 30)];
        lab1.font = [UIFont systemFontOfSize:25];
        lab1.textColor = UIColorWithRGB(0xffe65d);
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.text = [@"+" stringByAppendingString:returnAmount];
        [lab1 setFont:[UIFont boldSystemFontOfSize:25] string:returnAmount];
        
        
        NZLabel *lab2 = [[NZLabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2.0+10, CGRectGetWidth(view.frame), 30)];
        lab2.font = [UIFont systemFontOfSize:17];
        lab2.textAlignment = NSTextAlignmentCenter;
//        lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工豆",returnAmount];
        if ([isOpen isEqualToString:@"1"]) {
            lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工分",returnAmount];
        }
        else if ([isOpen isEqualToString:@"0"]) {
            lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工豆",returnAmount];
        }
        [lab2 setFontColor:[UIColor redColor] string:returnAmount];
        
        NZLabel *lab3 = [[NZLabel alloc]init];
        lab3.font = [UIFont systemFontOfSize:13];
        lab3.textColor = [UIColor darkGrayColor];
        lab3.textAlignment = NSTextAlignmentCenter;
        if ([isOpen isEqualToString:@"1"]) {
            lab3.text = [NSString stringWithFormat:@"明日奖励%@工分，已连续签到%@天",@"10",@"20"];
        }
        else if ([isOpen isEqualToString:@"0"]) {
            lab3.text = [NSString stringWithFormat:@"明日奖励%@工豆，已连续签到%@天",@"10",@"20"];
        }
        [view addSubview:lab3];
        if (win) {//有红包时
            lab3.frame = CGRectMake(0, CGRectGetHeight(view.frame)/2+73, CGRectGetWidth(view.frame), 30);
            
            NZLabel *lab = [[NZLabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2+32, CGRectGetWidth(view.frame), 20)];
            lab.font = [UIFont systemFontOfSize:17];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.numberOfLines = 0;
            lab.lineBreakMode = NSLineBreakByWordWrapping;
            lab.text = [NSString stringWithFormat:@"人品爆表！抽到%@元红包",winAmount];
            [lab setFontColor:[UIColor redColor] string:winAmount];
            [view addSubview:lab];
            
            if ([rewardAmt intValue] != 0) {
                NZLabel *lab11 = [[NZLabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2+50, CGRectGetWidth(view.frame), 20)];
                lab11.font = [UIFont systemFontOfSize:17];
                lab11.textAlignment = NSTextAlignmentCenter;
                lab11.numberOfLines = 0;
                lab11.lineBreakMode = NSLineBreakByWordWrapping;
                lab11.text = [NSString stringWithFormat:@"抢光红包再奖励%@元",rewardAmt];
                [lab11 setFontColor:[UIColor redColor] string:rewardAmt];
                [view addSubview:lab11];
            }
            
        }else{//没有红包时
            lab3.frame = CGRectMake(0, CGRectGetHeight(view.frame)/2+30, CGRectGetWidth(view.frame), 30);
            
            UILabel *lab22 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2+50, CGRectGetWidth(view.frame), 60)];
            lab22.font = [UIFont systemFontOfSize:13];
            lab22.textAlignment = NSTextAlignmentCenter;
            lab22.numberOfLines = 0;
            lab22.lineBreakMode = NSLineBreakByWordWrapping;
            lab22.textColor = [UIColor lightGrayColor];
            lab22.text = @"投资多多！好礼送不停\n签到就有机会抽到红包哟！";
            [view addSubview:lab22];
        }
        lab3.font = [UIFont systemFontOfSize:13];
        lab3.textColor = [UIColor darkGrayColor];
        lab3.textAlignment = NSTextAlignmentCenter;
        if ([isOpen isEqualToString:@"1"]) {
            lab3.text = [NSString stringWithFormat:@"明日签到奖励%@工分，已连续签到%@天",nextDayBeans,signDays];
        }
        else if ([isOpen isEqualToString:@"0"]) {
            lab3.text = [NSString stringWithFormat:@"明日签到奖励%@工豆，已连续签到%@天",nextDayBeans,signDays];
        }
        [lab3 setFontColor:[UIColor redColor] string:nextDayBeans];
        
        [view addSubview:lab1];
        [view addSubview:lab2];
        [view addSubview:lab3];
    } delegate:self cancelButtonTitle:@"关闭"];
    alert.showViewbackImage = [UIImage imageNamed:@"checkin_bg"];
    [alert show];
}
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index
{
    if (index == 0 && [signDays isEqualToString:@"7"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertTool checkPraiseAlertIsEjectWithGoodCommentAlertType:SingSevenDays WithRollBack:^{
            }];
        });
    }
}
#pragma mark -guaguaViewDelegate

- (void)submitBtnClicked:(id)sender
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&cardNum=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID],_popView.cardNumField.text,_popView.passwordField.text];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGuaGuaPost owner:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger alertTag = alertView.tag;
    if (buttonIndex == 1) {
        if (alertTag == 9998) {
            UCFMyFacBeanViewController *beanCtl = [[UCFMyFacBeanViewController alloc] init];
            beanCtl.title = @"我的工豆";
            [self.navigationController pushViewController:beanCtl animated:YES];
        }
        else if (alertTag == 1009) {
            UCFOldUserGuideViewController *vc = [[UCFOldUserGuideViewController alloc] initWithNibName:@"UCFOldUserGuideViewController" bundle:nil];
            vc.isStep     = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (alertTag == 1010) {
            UCFOldUserGuideViewController *vc = [[UCFOldUserGuideViewController alloc] initWithNibName:@"UCFOldUserGuideViewController" bundle:nil];
            vc.isStep     = 3;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            UCFCouponViewController *cpCtl = [[UCFCouponViewController alloc] init];
            [self.navigationController pushViewController:cpCtl animated:YES];
        }
    }
}

//响应3Dtouch点击
- (void)responds3DTouchClick{
    if ([Touch3DSingle sharedTouch3DSingle].isLoad) {
        [Touch3DSingle sharedTouch3DSingle].isLoad = NO;
    }else
        return;
    int type = [[Touch3DSingle sharedTouch3DSingle].type intValue];
    [self.navigationController popToRootViewControllerAnimated:NO];
    switch (type) {
        case 0:{//刮刮卡
            _popView = [[UCFGuaPopViewController alloc] init];
            _popView.delegate = self;
            [_popView showPopView:self];
        }
            break;
        case 1:{//邀请返利
            UCFFeedBackViewController *subVC = [[UCFFeedBackViewController alloc] initWithNibName:@"UCFFeedBackViewController" bundle:nil];
            subVC.title = @"邀请返利";
            [self.navigationController pushViewController:subVC animated:YES];
        }
            break;
        case 2:{//工场码
            fixedScreenLight = [UIScreen mainScreen].brightness;
            UCFFacCodeViewController *subVC = [[UCFFacCodeViewController alloc] init];
            subVC.title = @"我的工场码";
            subVC.urlStr = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/mycode.jsp?pcode=%@&sex=%@",_gcm,_sex];
            [self.navigationController pushViewController:subVC animated:YES];
        }
            break;
        case 3:{//签到
            [self signedButton:nil];
        }
            break;
    }
}

//设置为空时的用户信息
- (void)setDefaultViewData
{
   
    for (UCFMenuItemModel *item in self.actMenuItems) {
        item.hasWarningNum = NO;
    }
    _signflags = nil;
    _isHaveNewestPayment = NO;
    if (_isHaveNewestPayment) {
        //拥有回款的状态
        _alertState = StateHavePayment;
    }
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.tabBarController.tabBar hideBadgeOnItemIndex:3];
    
    _sex = @"2";
    if ([_sex isEqualToString:@"0"]) {
        self.userImage.image = [UIImage imageNamed:@"user_icon_head_female"];
    }
    else if ([_sex isEqualToString:@"1"]) {
        self.userImage.image = [UIImage imageNamed:@"user_icon_head_male"];
    }
    else {
        self.userImage.image = [UIImage imageNamed:@"password_icon_head"];
    }
    
    //设置用户名
    self.userName.text = @"未实名";
    //设置总资产
    [self.totalLabel setText:[NSString stringWithFormat:@"¥%@", @"0.00"]];
    //设置累计收益
    [self.arrivingPrinAndInterestLabel setText:[NSString stringWithFormat:@"%@", @"0.00"]];
    
    //设置账户余额
    [self.blanceLabel setText:[NSString stringWithFormat:@"¥%@", @"0.00"]];
    
    //设置消息提示
    self.messageWarningPoint.hidden = YES;
    
    self.userLevel.image = [UIImage imageNamed:@"usercenter_vip1_icon"];
    
     isShowTip = NO;
    
    //设置提示条
    self.tipButtonH.constant = 0;
    self.tipButton.hidden = YES;
    
    [self.itemsTableview reloadData];
}

//未登录状态添加阴影和登录按钮
- (void)addShadowViewAndLoginBtn
{
    BOOL hasHideView = NO;
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UCFLoginShaowView class]]) {
            hasHideView = YES;
        }
    }
    //遍历当前view的所有子view 没有loginshashow才add
    if (!hasHideView) {
        UCFLoginShaowView *shadowView = [[UCFLoginShaowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        shadowView.delegate = self;
        [self.view addSubview:shadowView];
    }
}

//移除shadowview
- (void)hideShadowView
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UCFLoginShaowView class]]) {
            [view setHidden:YES];
            [view removeFromSuperview];
        }
    }
}

#pragma mark -loginbtnClicked

- (void)btnShadowClicked:(id)sender
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    loginViewController.sourceVC = @"fromPersonCenter";
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}


- (void)regBtnclicked:(id)sender
{
    UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
    registerControler.sourceVC = @"fromPersonCenter";
    UINavigationController *regNaviController = [[UINavigationController alloc] initWithRootViewController:registerControler];
    [self presentViewController:regNaviController animated:YES completion:nil];
}

- (void)moreBtnclicked:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UCFMoreViewController" bundle:nil];
    UCFMoreViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"more_main"];
    controller.sourceVC = @"fromPersonCenter";
    UINavigationController *moreNaviController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:moreNaviController animated:YES completion:nil];
}
@end
