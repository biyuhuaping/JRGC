//
//  UCFUserInfoController.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInfoController.h"
#import "UCFPersonCenterModel.h"
#import "HWWeakTimer.h"
#import "UCFPersonAPIManager.h"
#import "MjAlertView.h"
#import "UCFSignView.h"
#import "UCFSignModel.h"
#import "UITabBar+TabBarBadge.h"
@interface UCFUserInfoController () <UserInfoViewPresenterCallBack>
@property (weak, nonatomic) IBOutlet UIView *userIconBackView;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (copy, nonatomic) ViewControllerGenerator userInfoVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator messageVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator beansVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator couponVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator workPointInfoVCGenerator;
@property (strong, nonatomic) UCFPCListViewPresenter *presenter;

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userLevelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *unreadMessageImageView;
@property (weak, nonatomic) IBOutlet UILabel *facBeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *workPointLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segLineView1_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segLineView2_width;

@property (nonatomic, weak) NSTimer *cycleTimer;
@property (nonatomic, assign) BOOL isAddScreenLight;
@property (nonatomic, assign) CGFloat preScreenLight;
@property (nonatomic, copy) NSString *token;


@end

@implementation UCFUserInfoController

+ (instancetype)instanceWithPresenter:(UCFPCListViewPresenter *)presenter {
    return [[UCFUserInfoController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFPCListViewPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.userInvoView = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
        
        
    }
    return self;
}

+ (CGFloat)viewHeight {
    return 177;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segLineView1_width.constant = 0.5;
    self.segLineView2_width.constant = 0.5;
    self.userIconImageView.layer.cornerRadius = self.userIconImageView.width*0.5;
    self.userIconImageView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserIcon:)];
    [self.userIconBackView addGestureRecognizer:tap];
    
    [lineViewAA removeFromSuperview];
    lineViewAA = nil;
    
}

- (void)tapUserIcon:(UIGestureRecognizer *)gesture
{
    if (self.userInfoVCGenerator) {
        
        UIViewController *targetVC = self.userInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)messageClicked:(UIButton *)sender {
    if (self.messageVCGenerator) {
        
        UIViewController *targetVC = self.messageVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)factoryBeanClicked:(UIButton *)sender {
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

- (IBAction)workPoint:(UIButton *)sender {
    if (self.workPointInfoVCGenerator) {
        
        UIViewController *targetVC = self.workPointInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (void)pcListViewPresenter:(UCFPCListViewPresenter *)presenter didRefreshUserInfoWithResult:(id)result error:(NSError *)error
{
    if (!error) {
        UCFPersonCenterModel *personCenter = result;
//        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:personCenter.headurl] placeholderImage:[UIImage imageNamed:@"password_icon_head"]];
        if ([personCenter.sex isEqualToString:@"0"]) {
            self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_female"];
        }
        else if ([personCenter.sex isEqualToString:@"1"]) {
            self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
        }
        else {
            self.userIconImageView.image = [UIImage imageNamed:@"password_icon_head"];
        }
        self.userNameLabel.text = personCenter.userName.length > 0 ? personCenter.userName : @"未实名";
        self.userLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercenter_vip%@_icon", personCenter.memberLever]];
        self.unreadMessageImageView.hidden = ([personCenter.unReadMsgCount integerValue] == 0) ? YES : NO;
        self.facBeanLabel.text = personCenter.beanAmount;
        self.couponLabel.text = [NSString stringWithFormat:@"%@", personCenter.couponNumber];
        self.workPointLabel.text = [NSString stringWithFormat:@"%@", personCenter.score];
        self.token = personCenter.userCenterTicket;
        self.signButton.hidden = personCenter.isCompanyAgent;
        
        if (personCenter.unReadMsgCount == 0) {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
        } else {
            [self.tabBarController.tabBar showBadgeOnItemIndex:4];
        }
    }
}

#pragma mrak - 签到按钮点击
- (IBAction)signClicked:(UIButton *)sender {
    NSString *userId  = [UserInfoSingle sharedManager].userId;
    if (!self.token) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.presenter fetchSignInfoWithUserId:userId withToken:self.token CompletionHandler:^(NSError *error, id result) {
        if (!error) {
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
        }
    }];
}

- (void)sign
{
    [self signClicked:nil];
}

#pragma mark - 恢复初始数据
- (void)setDefaultState
{
    self.userIconImageView.image = [UIImage imageNamed:@"password_icon_head"];
    self.userNameLabel.text = @"未实名";
    self.userLevelImageView.image = [UIImage imageNamed:@"usercenter_vip0_icon"];
    self.unreadMessageImageView.hidden = YES;
    self.facBeanLabel.text = @"0";
    self.couponLabel.text = @"0";
    self.workPointLabel.text = @"0";
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
    self.cycleTimer = [HWWeakTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeWindowBrightness) userInfo:nil repeats:YES];
    //让计时器停止运行
    [self.cycleTimer setFireDate:[NSDate distantFuture]];
}

- (void)changeWindowBrightness
{
    if (_isAddScreenLight) {
        _preScreenLight += 0.003;
        if (_preScreenLight >= 1) {
            [_cycleTimer setFireDate:[NSDate distantFuture]];
        }
    } else {
        _preScreenLight -= 0.003;
        if (_preScreenLight <= _fixedScreenLight) {
            [_cycleTimer setFireDate:[NSDate distantFuture]];
        }
    }
    [[UIScreen mainScreen] setBrightness:_preScreenLight];
}

//TODO:timer
- (void)endTimer
{
    [_cycleTimer setFireDate:[NSDate distantPast]];
}
- (void)beginAddTimer
{
    _isAddScreenLight = YES;
    [_cycleTimer setFireDate:[NSDate distantPast]];
}
- (void)beginReduceTimer
{
    _isAddScreenLight = NO;
    [_cycleTimer setFireDate:[NSDate distantPast]];
}


@end
