//
//  UCFUserInformationViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInformationViewController.h"
#import "UCFWebViewJavascriptBridgeBanner.h"

#import "UCFUserPresenter.h"

#import "UCFHomeUserInfoCell.h"
#import "SDCycleScrollView.h"
#import "MjAlertView.h"
#import "UCFSignView.h"

#import "UCFCycleModel.h"
#import "UCFUserInfoModel.h"
#import "UCFSignModel.h"
#import "AppDelegate.h"

#define UserInfoViewHeight  327

@interface UCFUserInformationViewController () <UCFUserPresenterUserInfoCallBack, UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
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

- (IBAction)visible:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *addedProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *availableBalance;
@property (copy, nonatomic) NSString *userTicket;

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
    
    self.userIconImageView.layer.cornerRadius = CGRectGetWidth(self.userIconImageView.frame) * 0.5;
    self.userIconImageView.clipsToBounds = YES;
    
    NSArray *images = @[[UIImage imageNamed:@"banner_default.png"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 2.0;
    [self.cycleImageBackView addSubview:cycleScrollView];
    self.cycleImageView = cycleScrollView;
    
    [self performSelector:@selector(getNormalBannerData) withObject:nil afterDelay:0.5];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.cycleImageView.frame = self.cycleImageBackView.bounds;
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
    return UserInfoViewHeight + height;
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCFUserInfoListItem *item = [self.presenter.allDatas objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(userInfotableView:didSelectedItem:)]) {
        [self.delegate userInfotableView:self.tableview didSelectedItem:item];
    }
}

- (IBAction)visible:(UIButton *)sender {
    sender.selected = !sender.selected;
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
            UCFUserInfoModel *userInfo = result;
//            if ([personCenter.sex isEqualToString:@"0"]) {
//                self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_female"];
//            }
//            else if ([personCenter.sex isEqualToString:@"1"]) {
//                self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
//            }
//            else {
//                self.userIconImageView.image = [UIImage imageNamed:@"password_icon_head"];
//            }
//            self.userNameLabel.text = personCenter.userName.length > 0 ? personCenter.userName : @"未实名";
//            self.userLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercenter_vip%@_icon", personCenter.memberLever]];
//            self.unreadMessageImageView.hidden = ([personCenter.unReadMsgCount integerValue] == 0) ? YES : NO;
//            self.facBeanLabel.text = personCenter.beanAmount ==nil ?@"0":personCenter.beanAmount;
//            self.couponLabel.text = [NSString stringWithFormat:@"%@", personCenter.couponNumber == nil ? @"0":personCenter.couponNumber];
//            self.workPointLabel.text = [NSString stringWithFormat:@"%@", personCenter.score == nil ?@"0":personCenter.score];
//            self.token = personCenter.userCenterTicket;
//            self.signButton.hidden = personCenter.isCompanyAgent;
//            
//            if ([personCenter.unReadMsgCount intValue] == 0) {
//                [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
//            } else {
//                [self.tabBarController.tabBar showBadgeOnItemIndex:4];
//            }
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
            [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.hurl] placeholderImage:[UIImage imageNamed:@"password_icon_head"]];
            self.userTicket = userInfo.userCenterTicket;
//            self.userNameLabel.text = personCenter.userName.length > 0 ? personCenter.userName : @"未实名";
//            self.userLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercenter_vip%@_icon", personCenter.memberLever]];
//            self.unreadMessageImageView.hidden = ([personCenter.unReadMsgCount integerValue] == 0) ? YES : NO;
//            self.facBeanLabel.text = personCenter.beanAmount ==nil ?@"0":personCenter.beanAmount;
//            self.couponLabel.text = [NSString stringWithFormat:@"%@", personCenter.couponNumber == nil ? @"0":personCenter.couponNumber];
//            self.workPointLabel.text = [NSString stringWithFormat:@"%@", personCenter.score == nil ?@"0":personCenter.score];
//            self.token = personCenter.userCenterTicket;
//            self.signButton.hidden = personCenter.isCompanyAgent;
//            
//            if ([personCenter.unReadMsgCount intValue] == 0) {
//                [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
//            } else {
//                [self.tabBarController.tabBar showBadgeOnItemIndex:4];
//            }
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
    } else if (self.presenter.allDatas.count == 0) {
        //        show error view
    }
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


@end
