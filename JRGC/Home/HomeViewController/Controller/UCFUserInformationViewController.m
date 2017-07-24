//
//  UCFUserInformationViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInformationViewController.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
#import "UCFPurchaseBidViewController.h"

#import "UCFUserPresenter.h"
#import "UITabBar+TabBarBadge.h"

#import "UCFHomeUserInfoCell.h"
#import "SDCycleScrollView.h"
#import "MjAlertView.h"
#import "UCFSignView.h"
#import "UCFNoticeView.h"
#import "MjAlertView.h"
#import "UCFAssetTipView.h"

#import "UCFCycleModel.h"
#import "UCFUserInfoModel.h"
#import "UCFSignModel.h"
#import "AppDelegate.h"
#import "UCFUserInfoListItem.h"
#import "HSHelper.h"
#define UserInfoViewHeight  327

@interface UCFUserInformationViewController () <UCFUserPresenterUserInfoCallBack, UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UIAlertViewDelegate, UCFNoticeViewDelegate, UCFAssetTipViewDelegate>
@property (strong, nonatomic) UCFUserPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) SDCycleScrollView *cycleImageView;

@property (copy, nonatomic) ViewControllerGenerator personInfoVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator messageVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator beansVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator couponVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator workPointInfoVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator myLevelVCGenerator;

@property (weak, nonatomic) IBOutlet UIView *cycleImageBackView;
@property (weak, nonatomic) IBOutlet UIButton *sign;

- (IBAction)visible:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *visibleBtn;

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *addedProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *availableBalance;
@property (copy, nonatomic) NSString *userTicket;
@property (weak, nonatomic) IBOutlet UILabel *beanLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLevelLabel;
@property (weak, nonatomic) IBOutlet UIView *noticeBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeBackViewHeight;
@property (weak, nonatomic) UCFNoticeView *noticeView;
@property (weak, nonatomic) IBOutlet UIImageView *messageTipImageView;

@property (copy, nonatomic) NSString *beanCount;
@property (strong, nonatomic) NSNumber *couponNumber;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *memLevel;
@property (copy, nonatomic) NSString *addProfit;
@property (copy, nonatomic) NSString *asset;
@property (copy, nonatomic) NSString *availableBanlance;
@property (weak, nonatomic) IBOutlet UIButton *personInformationBtn;

@property (weak, nonatomic) MjAlertView *assetTipview;

@end

@implementation UCFUserInformationViewController

#pragma mark - button点击方法
- (IBAction)beanClicked:(UIButton *)sender {
    if (self.beansVCGenerator) {
        UIViewController *targetVC = self.beansVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}
- (IBAction)assetDetail:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    MjAlertView *alertView = [[MjAlertView alloc] initCustomAlertViewWithBlock:^(id blockContent) {
        UIView *view = (UIView *)blockContent;
        view.frame = CGRectMake(0, 0, 265, 250);
        
        UCFAssetTipView *tipview = (UCFAssetTipView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFAssetTipView" owner:self options:nil] lastObject];
        tipview.assetLabel.text = [NSString stringWithFormat:@"%@=%@+%@+%@", weakSelf.presenter.userInfoOneModel.total, weakSelf.presenter.userInfoOneModel.cashTotal, weakSelf.presenter.userInfoOneModel.goldMarketAmount, weakSelf.presenter.userInfoOneModel.nmCashBalance];
        tipview.frame = view.bounds;
        view.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
        tipview.delegate = weakSelf;
        [view addSubview:tipview];
    }];
    [alertView show];
    self.assetTipview = alertView;
//    if ([self.delegate respondsToSelector:@selector(userInfoClickAssetDetailButton:withInfomation:)]) {
//        [self.delegate userInfoClickAssetDetailButton:sender withInfomation:self.presenter.userInfoOneModel];
//    }
}

- (void)assetTipViewDidClickedCloseButton:(UIButton *)button
{
    [self.assetTipview hide];
}

- (IBAction)couponClicked:(UIButton *)sender {
    if (self.couponVCGenerator) {
        
        UIViewController *targetVC = self.couponVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)workPointClicked:(UIButton *)sender {
    if (self.workPointInfoVCGenerator) {
        
        UIViewController *targetVC = self.workPointInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)myLevelClicked:(UIButton *)sender {
    if (self.myLevelVCGenerator) {
        
        UIViewController *targetVC = self.myLevelVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    
    [self.view setBackgroundColor:UIColorWithRGB(0xebebee)];
    
    UCFNoticeView *noticeView = (UCFNoticeView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFNoticeView" owner:self options:nil] lastObject];
    noticeView.delegate = self;
    [self.noticeBackView addSubview:noticeView];
    self.noticeView = noticeView;
    
    self.visibleBtn.selected = ![[NSUserDefaults standardUserDefaults] boolForKey:@"isVisible"];
    
    self.userIconImageView.layer.cornerRadius = CGRectGetWidth(self.userIconImageView.frame) * 0.5;
    self.userIconImageView.clipsToBounds = YES;
    
    NSArray *images = @[[UIImage imageNamed:@"banner_default.png"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self.cycleImageBackView addSubview:cycleScrollView];
    self.cycleImageView = cycleScrollView;
    
    [self.personInformationBtn setTitle:@"个人信息" forState:UIControlStateNormal];
    [self performSelector:@selector(getNormalBannerData) withObject:nil afterDelay:0.5];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.cycleImageView.frame = self.cycleImageBackView.bounds;
    self.noticeView.frame = self.noticeBackView.bounds;
}

- (void)setNoticeStr:(NSString *)noticeStr
{
    _noticeStr = noticeStr;
    if (noticeStr.length > 0) {
        [_noticeView.noticeArray removeAllObjects];
        [_noticeView.noticeArray addObject:noticeStr];
    }
}

#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFUserPresenter *)presenter {
    return [[UCFUserInformationViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFUserPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.userInfoViewDelegate = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
    }
    return self;
}

#pragma mark - 计算用户信息页高度
+ (CGFloat)viewHeight
{
    CGFloat height = [UIScreen mainScreen].bounds.size.width / 3.2;
    return UserInfoViewHeight + height + 45;
}

#pragma mark - 个人信息
- (IBAction)personInfo:(UIButton *)sender {
    if (self.personInfoVCGenerator) {
        
        UIViewController *targetVC = self.personInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)message:(UIButton *)sender {
    if (self.messageVCGenerator) {
        UIViewController *targetVC = self.messageVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

#pragma mark - tableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presenter.allDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeUserInfo";
    UCFHomeUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil==cell) {
        cell = (UCFHomeUserInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeUserInfoCell" owner:self options:nil] lastObject];
    }
    cell.item = [self.presenter.allDatas objectAtIndex:indexPath.row];
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.presenter.canClicked) {
        return;
    }
    
    UCFUserInfoListItem *item = [self.presenter.allDatas objectAtIndex:indexPath.row];
    
    SelectAccoutType accoutType = SelectAccoutDefault;
    
    if ([item.title isEqualToString:@"微金账户"]) {
        accoutType =  SelectAccoutTypeP2P;
    }
    else if ([item.title isEqualToString:@"尊享账户"]) {
        accoutType = SelectAccoutTypeHoner;
    }
    
    HSHelper *helper = [HSHelper new];
    //检查企业老用户是否开户
    NSString *messageStr =  [helper checkCompanyIsOpen:accoutType];
    if (![messageStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if (![helper checkP2POrWJIsAuthorization:accoutType]) {//先授权
        [helper pushP2POrWJAuthorizationType:accoutType nav:self.parentViewController.navigationController];
        return;
    }

    
    if (indexPath.row == 0) {
        item.isShow = [self.presenter checkIDAAndBankBlindState:SelectAccoutTypeHoner];
    }
    else if (indexPath.row == 1) {
        item.isShow = [self.presenter checkIDAAndBankBlindState:SelectAccoutTypeP2P];
    }
    if ([self.delegate respondsToSelector:@selector(userInfotableView:didSelectedItem:)]) {
        [self.delegate userInfotableView:self.tableview didSelectedItem:item];
    }
}

- (IBAction)visible:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:@"isVisible"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (sender.selected) {
        self.beanLabel.text = self.beanCount;
        self.couponLabel.text = [NSString stringWithFormat:@"%@", self.couponNumber];
        self.scoreLabel.text = self.score;
        self.myLevelLabel.text = self.memLevel;
        
        self.addedProfitLabel.text = self.addProfit;
        self.totalMoney.text = self.asset;
        self.availableBalance.text = self.availableBanlance;
    }
    else {
        self.beanLabel.text = @"****";
        self.couponLabel.text = @"****";
        self.scoreLabel.text = @"****";
        self.myLevelLabel.text = @"****";
        
        self.addedProfitLabel.text = @"****";
        self.totalMoney.text = @"****";
        self.availableBalance.text = @"****";
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    id model = [cycleScrollView.imagesGroup objectAtIndex:index];
    if ([model isKindOfClass:[UCFCycleModel class]]) {
        UCFCycleModel *modell = model;
        UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        webView.baseTitleType = @"lunbotuhtml";
        webView.url = modell.url;
        webView.navTitle = modell.title;
        webView.dicForShare = modell;
        [self.parentViewController.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData
{
    __weak typeof(self) weakSelf = self;
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
            NSDictionary *modelDic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *temp = [NSMutableArray new];
            for (NSDictionary *dict in modelDic[@"banner"]) {
                UCFCycleModel *model = [UCFCycleModel getCycleModelByDataDict:dict];
                [temp addObject:model];
            }
            weakSelf.cycleImageView.imagesGroup = temp;
            [weakSelf.cycleImageView refreshImage];
        });
    });
}

#pragma mark - presenter的代理方法
- (void)userInfoPresenter:(UCFUserPresenter *)presenter didRefreshUserInfoOneWithResult:(id)result error:(NSError *)error
{
    if (!error) {
        if ([result isKindOfClass:[UCFUserInfoModel class]]) {
            [self.tableview reloadData];
            UCFUserInfoModel *userInfo = result;
            self.addProfit = [NSString stringWithFormat:@"¥%@", userInfo.interests];
            self.asset = [NSString stringWithFormat:@"¥%@", userInfo.total];
            self.availableBanlance = [NSString stringWithFormat:@"¥%@", userInfo.cashBalance];
//            self.sign.hidden = userInfo.isCompanyAgent;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self refreshUI];
            });
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
        
    } else if (self.presenter.allDatas.count == 0) {
        //        show error view
    }
}

- (void)userInfoPresenter:(UCFUserPresenter *)presenter didRefreshUserInfoTwoWithResult:(id)result error:(NSError *)error
{
    if (!error) {
        
        
        if ([result isKindOfClass:[UCFUserInfoModel class]]) {
            UCFUserInfoModel *userInfo = result;
            switch ([userInfo.sex integerValue]) {
                case 0:
                    self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_female"];
                    break;
                    
                case 1:
                    self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
                    break;
                    
                default:
                    self.userIconImageView.image = [UIImage imageNamed:@"password_icon_head"];
                    break;
            }
            if([[NSUserDefaults standardUserDefaults] boolForKey: @"isCompanyAgentType"]){
                self.userIconImageView.image = [UIImage imageNamed:@"company_head"];
                [self.personInformationBtn setTitle:@"企业信息" forState:UIControlStateNormal];
            }else{
                [self.personInformationBtn setTitle:@"个人信息" forState:UIControlStateNormal];
            }
//            [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.hurl] placeholderImage:[UIImage imageNamed:@""]];
            self.userTicket = userInfo.userCenterTicket;
            self.beanCount = userInfo.beanAmount;
            self.couponNumber = userInfo.couponNumber;
            self.score = userInfo.score;
            [UserInfoSingle sharedManager].gender = userInfo.sex;
            if (userInfo.unReadMsgCount.integerValue > 0) {
                self.messageTipImageView.hidden = NO;
            }
            else {
                self.messageTipImageView.hidden = YES;
            }
            switch ([userInfo.memberLever intValue]) {
                case 1:
                    self.memLevel = @"普通会员";
                    break;
                    
                case 2:
                    self.memLevel = @"VIP1";
                    break;
                    
                case 3:
                    self.memLevel = @"VIP2";
                    break;
                    
                case 4:
                    self.memLevel = @"VIP3";
                    break;
                    
                case 5:
                    self.memLevel = @"VIP4";
                    break;
            }
            if ([userInfo.unReadMsgCount intValue] == 0) {
                
                [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
            } else {
                [self.tabBarController.tabBar showBadgeOnItemIndex:0];
            }
            [self refreshUI];
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
    } else if (self.presenter.allDatas.count == 0) {
//        show error view
    }
}

- (void)refreshUI
{
    if (self.visibleBtn.selected) {
        self.beanLabel.text = self.beanCount ? self.beanCount : @"--";
        self.couponLabel.text = self.couponNumber ? [NSString stringWithFormat:@"%@", self.couponNumber] : @"--";
        self.scoreLabel.text = self.score ? self.score : @"--";
        
        self.addedProfitLabel.text = self.addProfit ? self.addProfit : @"--";
        self.totalMoney.text = self.asset ? self.asset : @"--";
        self.availableBalance.text = self.availableBanlance ? self.availableBanlance : @"--";
        self.myLevelLabel.text = self.memLevel ? self.memLevel : @"--";
    }
    else {
        self.beanLabel.text = @"****";
        self.couponLabel.text = @"****";
        self.scoreLabel.text = @"****";
        
        self.addedProfitLabel.text = @"****";
        self.totalMoney.text = @"****";
        self.availableBalance.text = @"****";
        self.myLevelLabel.text = @"****";
    }
}

- (void)setDefaultState
{
    self.visibleBtn.selected = YES;
    self.beanCount = nil;
    self.couponNumber = nil;
    self.score = nil;
    
    self.addProfit = nil;
    self.asset = nil;
    self.availableBanlance = nil;
    self.memLevel  = nil;
    [self refreshUI];
    
    [self.presenter setDefault];
    [self.tableview reloadData];
}

- (void)userInfoPresenter:(UCFUserPresenter *)presenter didReturnPrdClaimsDealBidWithResult:(id)result error:(NSError *)error
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.parentViewController;
    [MBProgressHUD hideAllHUDsForView:baseVC.view animated:YES];
    NSString *rstCode = [result objectForKey:@"status"];
    NSString *rsttext = [result objectForKey:@"statusdes"];
    if ([rstCode integerValue] == 21 || [rstCode integerValue] == 22){
        [self checkUserCanInvestIsDetail:NO];
    } else {
        if ([rstCode integerValue] == 15) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else if ([rstCode integerValue] == 19) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag =7000;
            [alert show];
        }else if ([rstCode integerValue] == 30) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
            alert.tag = 9000;
            [alert show];
        }else if ([rstCode integerValue] == 40) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
            alert.tag = 9001;
            [alert show];
        } else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
}

- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.parentViewController;
    NSString *tipStr1 = baseVC.accoutType == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = baseVC.accoutType == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;
    
    NSInteger openStatus = baseVC.accoutType == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus :[UserInfoSingle sharedManager].enjoyOpenStatus;
    
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
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.parentViewController;
    alert.tag = baseVC.accoutType == SelectAccoutTypeP2P ?  8000 :8010 ;
    [alert show];
}


#pragma mark - sign 签到
- (IBAction)sign:(UIButton *)sender {
    NSString *userId  = [UserInfoSingle sharedManager].userId;
    if (!self.userTicket) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [self.presenter fetchSignDataWithUserId:userId withToken:self.userTicket completionHandler:^(NSError *error, id result) {
                    if ([result isKindOfClass:[UCFSignModel class]]) {
                        MjAlertView *alert = [[MjAlertView alloc] initRedBagAlertViewWithBlock:^(id blockContent) {
                            UIView *view = (UIView *)blockContent;
                            view.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
                            UCFSignView *signView = [[UCFSignView alloc] initWithFrame:view.bounds];
                            [view addSubview:signView];
                            [view sendSubviewToBack:signView];
                            signView.signModel = result;
                            DBLOG(@"---->%@", view.subviews);
                            [weakSelf.presenter refreshData];
                        } delegate:self cancelButtonTitle:@"关闭"];
                        alert.showViewbackImage = [UIImage imageNamed:@"checkin_bg"];
                        [alert show];
                    }
                    else if ([result isKindOfClass:[NSString class]]) {
                        [AuxiliaryFunc showToastMessage:result withView:weakSelf.parentViewController.view];
                    }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(proInvestAlert:didClickedWithTag:withIndex:)]) {
        [self.delegate proInvestAlert:alertView didClickedWithTag:alertView.tag withIndex:buttonIndex];
    }
}
#pragma mark - 签到
- (void)signForRedBag
{
    [self sign:self.sign];
}

#pragma mark - 刷新公告
- (void)refreshNotice
{
    BOOL isShowNotice = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowNotice"];
    self.noticeBackViewHeight.constant = isShowNotice ? 35 : 0;
}

#pragma mark - noticeView 的代理
- (void)noticeView:(UCFNoticeView *)noticeView didClickedCloseButton:(UIButton *)closeBtn
{
    self.noticeBackViewHeight.constant = 0;
    if ([self.delegate respondsToSelector:@selector(closeNotice)]) {
        [self.delegate closeNotice];
    }
}
@end
