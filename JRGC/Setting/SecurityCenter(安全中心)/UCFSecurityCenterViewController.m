//
//  UCFSecurityCenterViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSecurityCenterViewController.h"
#import "UCFSettingMainCell.h"
#import "UCFSettingGroup.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingSwitchItem.h"
#import "SecurityCell.h"
#import "UITabBar+TabBarBadge.h"
//#import "BindBankCardViewController.h"
#import "BindPhoneNumViewController.h"
#import "ModifyPasswordViewController.h"
#import "UCFModifyIdAuthViewController.h"
#import "UCFBankCardInfoViewController.h"
#import "UCFModifyPhoneViewController.h"
#import "AppDelegate.h"
#import "AuxiliaryFunc.h"
#import "LLLockPassword.h"
#import "UCFToolsMehod.h"
#import "BlockUIAlertView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "UCFVerifyLoginViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "TradePasswordVC.h"
#import "UCFBankDepositoryAccountViewController.h"
#import "FullWebViewController.h"
#import "UCFSession.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "RiskAssessmentViewController.h"
#import "UCFBatchInvestmentViewController.h"
#import "HSHelper.h"
#import "UCFFacCodeViewController.h"
#import "UCFMoreViewController.h"
#import "UCFSignModel.h"
#import "MjAlertView.h"
#import "UCFSignView.h"
@interface UCFSecurityCenterViewController () <UITableViewDataSource, UITableViewDelegate, SecurityCellDelegate, UCFLockHandleDelegate>

// 选项表数据
@property (nonatomic, strong) NSMutableArray *itemsData;

@property (nonatomic,assign) BOOL  userGradeSwitch;//会员等级开关

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) UCFSettingItem *userLevel;

@property (nonatomic ,strong) UIImageView *userLevelImage;
@property (nonatomic,strong)UCFSettingItem *setChangePassword;

@property (assign, nonatomic) BOOL isCompanyAgent;//是否是机构用户

@property (nonatomic,assign)int sex;//性别

@end

@implementation UCFSecurityCenterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSecurityCenterNetData) name:@"getPersonalCenterNetData" object:nil];
       // 更新人脸识别开关状态查询网络请求 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFaceSwitchSwipNetData) name:@"updateFaceSwitchSwip" object:nil];
    }
    return self;
}

- (void)reloadUI
{
    [self.tableview reloadData];
}
// 初始化选项数组
- (NSMutableArray *)itemsData
{
    if (_itemsData == nil) {
        
        UCFSettingItem *idauth = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_id" title:@"身份认证" destVcClass:[UCFModifyIdAuthViewController class]];
        UCFSettingItem *bundlePhoneNum = [UCFSettingArrowItem itemWithIcon:@"login_icon_phone" title:@"绑定手机号" destVcClass:[BindPhoneNumViewController class]];
        UCFSettingItem *facCode = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_code" title:@"工场码" destVcClass:[UCFFacCodeViewController class]];
       
        self.userLevel = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_vip" title:@"会员等级" destVcClass:[UCFWebViewJavascriptBridgeLevel class]];//***qyy
        self.userLevel.isShowOrHide = YES;//不显示

        UCFSettingItem *activeGestureCode  = [UCFSettingSwitchItem itemWithIcon:@"safecenter_icon_gesture" title:@"启用手势密码"];
        UCFSettingItem *activeFaceValid  = [UCFSettingSwitchItem itemWithIcon:@"uesr_icon_face" title:@"启用刷脸登录" withSwitchType:2];
        UCFSettingItem *modifyPassword = [UCFSettingArrowItem itemWithIcon:@"login_icon_password" title:@"修改登录密码" destVcClass:[ModifyPasswordViewController class]];//***qyy

        UCFSettingItem *moreVc = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_more" title:@"更多" destVcClass:[UCFMoreViewController class]];
        UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];//用户信息
        group1.items = [[NSMutableArray alloc]initWithArray: @[idauth, bundlePhoneNum,self.userLevel,facCode]];//qyy

        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];//账户安全
        
        if ([self checkTouchIdIsOpen]) {
            UCFSettingItem *zhiWenSwith  = [UCFSettingSwitchItem itemWithIcon:@"safecenter_icon_touch" title:@"启用指纹解锁" withSwitchType:1];
             group2.items = [[NSMutableArray alloc]initWithArray:@[activeGestureCode,zhiWenSwith, activeFaceValid,modifyPassword,moreVc]];
        } else {
             group2.items =[[NSMutableArray alloc]initWithArray: @[activeGestureCode,activeFaceValid,modifyPassword,moreVc]];

        }
        _itemsData = [[NSMutableArray alloc] initWithObjects:group1,group2,nil];
    }
    return _itemsData;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self reloadUI];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    [self addRightButtonWithImage:[UIImage imageNamed:@"ic_step_one"]];

    baseTitleLabel.text =  [[NSUserDefaults standardUserDefaults] boolForKey: @"isCompanyAgentType" ]  ? @"企业信息" : @"个人信息";
    self.tableview.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableview.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableview.separatorInset = UIEdgeInsetsMake(0,15, 0, 0);
    self.tableview.backgroundColor = [UIColor clearColor];
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
    self.tableview.tableFooterView = footerview;
    [footerview setBackgroundColor:UIColorWithRGB(0xebebee)];
    
    UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOutButton addTarget:self action:@selector(logOutClicked:) forControlEvents:UIControlEventTouchUpInside];
    logOutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [logOutButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [footerview addSubview:logOutButton];

    // 添加约束
    NSArray *constraints1H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[logOutButton]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logOutButton)];
    NSArray *constraints1V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[logOutButton]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logOutButton)];
    [footerview addConstraints:constraints1H];
    [footerview addConstraints:constraints1V];
    
    [logOutButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [logOutButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    self.tableview.separatorColor = UIColorWithRGB(0xe3e5ea);
    
    // 获取网络数据
    [self getSecurityCenterNetData];
    
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
    _userLevelImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 63, 9, 25, 25)];
    if ([UserInfoSingle sharedManager].openStatus == 4) {
        _setChangePassword.title = @"修改交易密码";
    } else {
        _setChangePassword.title = @"设置交易密码";
    }
}
//  退出登录按钮点击事件
- (void)logOutClicked:(UIButton *)btn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"确定退出登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 10000;
    [alertView show];
}
- (void)clickRightBtn
{
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
//        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId, @"apptzticket":token} tag:kSXTagSingMenthod owner:self signature:YES Type:SelectAccoutDefault];
//    }
}
#pragma mark alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            NSString *useridstr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
            NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:useridstr,@"userId",nil];
            [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagUserLogout owner:self signature:YES Type:SelectAccoutDefault];
            
            [[UCFSession sharedManager] transformBackgroundWithUserInfo:nil withState:UCFSessionStateUserLogout];
            [[UserInfoSingle sharedManager] removeUserInfo];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isVisible"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
            //安全退出后去首页
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate.tabBarController setSelectedIndex:0];
            [delegate.tabBarController.tabBar hideBadgeOnItemIndex:4];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
            
            //退出时清cookis
            [Common deleteCookies];
            [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
            //通知首页隐藏tipView
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_COUPON_CENTER object:nil];
        }

    }else if(alertView.tag == 10005){
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
    }else if(alertView.tag == 10003){
        if (buttonIndex == 1) {
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//获取 人脸识别开关状态查询网络请求
-(void)getFaceSwitchStatusNetData
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFaceSwitchStatus owner:self Type:SelectAccoutDefault];
}
//更新 人脸识别开关状态查询网络请求 注意更新请求上传 当前刷脸状态
-(void)updateFaceSwitchSwipNetData
{
    BOOL faceSwichSwip = ![[NSUserDefaults standardUserDefaults] boolForKey:FACESWITCHSTATUS];
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&status=%d", [[NSUserDefaults standardUserDefaults] objectForKey:UUID],faceSwichSwip];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFaceSwitchSwip owner:self Type:SelectAccoutDefault];
}
// 获取网络数据
- (void)getSecurityCenterNetData
{
//    NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    if (nil == userId) {
        return;
    }
    
    [[NetworkModule sharedNetworkModule] newPostReq:[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil] tag:kSXTagAccountSafe owner:self signature:YES Type:SelectAccoutDefault];

//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagAccountSafe owner:self Type:SelectAccoutDefault];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    if (tag == kSXTagFaceSwitchStatus) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    NSString *data = (NSString *)result;
    DBLOG(@"个人信息数据：%@",data);
    
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
//    NSString *rsttext = dic[@"statusdes"];
    
    if (tag.intValue == kSXTagAccountSafe) {
        
        BOOL ret = dic[@"ret"];
        NSString *message = dic[@"message"];
        
        if (ret) {
            NSDictionary *result = dic[@"data"][@"data"];
            UCFSettingGroup *group = [self.itemsData firstObject];
            NSString *memberLever = [result objectSafeForKey:@"memberLever"];
            NSString *authId = [result objectSafeForKey:@"state"];
            NSString *bindPhone = [result objectSafeForKey:@"bindMobile"];
            self.sex = [[result objectSafeForKey:@"sex"] intValue];
            NSString *oldPhone = [[NSUserDefaults standardUserDefaults] valueForKey:PHONENUM];
            self.isCompanyAgent = [[[dic objectForKey:@"data"] objectForKey:@"isCompanyAgent"] boolValue];
            //新请求的手机号和本地存储手机号不一样则更新本地
            if (![oldPhone isEqualToString:bindPhone]) {
                [[NSUserDefaults standardUserDefaults] setValue:bindPhone forKey:PHONENUM];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSString *realName = [result objectForKey:@"realName"];
            self.userGradeSwitch = [dic[@"data"][@"isOpen"]  boolValue];
            //保存 刷脸登录开关
          
            if( [[dic[@"data"] objectSafeForKey:@"faceIsOpen"] isEqualToString:@"0"]){
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FACESWITCHSTATUS];
            }else{
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACESWITCHSTATUS];
            }
            
            if ([UserInfoSingle sharedManager].openStatus == 4) {
                _setChangePassword.title = @"修改交易密码";
            }else{
                _setChangePassword.title = @"设置交易密码";
            }

            [[NSUserDefaults standardUserDefaults] setObject:realName forKey:REALNAME];
            [[NSUserDefaults standardUserDefaults] synchronize];

            for (UCFSettingItem *userItem in group.items) {
                NSInteger index = [group.items indexOfObject:userItem];
                switch (index) {
//
                    case 0:{
                        userItem.title = _isCompanyAgent ? @"企业认证":@"身份认证";
                        userItem.subtitle = [authId isEqualToString:@"未认证"] ? @"未认证" : authId;
                    }
                        break;
                    case 1:
                        userItem.subtitle = [bindPhone isEqualToString:@""] ? @"未绑定" : bindPhone;
                        break;
                    
                    case 2:{
                        if ([memberLever isEqualToString:@"1"]) {
                            _userLevelImage.image =[UIImage imageNamed:@"no_vip_icon.png"];
                            
                        }else{
                            _userLevelImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"vip%d_icon.png",[memberLever intValue]-1]];
                        }
                    }
                        break;
                    case 3:
                    {
                        userItem.subtitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"gcmCode"];
                    }
                        break;
                    default:
                        break;
                }
            }
            [self.tableview reloadData];
        }else
            [AuxiliaryFunc showToastMessage:message withView:self.view];
    }  else if (tag.integerValue == kSXTagUserLogout) {

    }else if(tag.integerValue == kSXTagFaceSwitchStatus){//刷脸登录状态开关
        if ([rstcode intValue] == 1) {
            NSString * faceIsOpen = [dic objectSafeForKey:@"isOpen"];// 1：关闭 0：开启
            [self validFaceLogin:faceIsOpen];
        }else{
//            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [self.tableview reloadData];
        }
    }else if(tag.integerValue == kSXTagFaceSwitchSwip){//刷脸登录状态更新
        if ([rstcode intValue] == 1) {
            [AuxiliaryFunc showToastMessage:@"刷脸登录关闭成功" withView:self.view];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACESWITCHSTATUS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableview reloadData];
        }else{
//            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FACESWITCHSTATUS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableview reloadData];
        }
    } else if (tag.intValue == kSXTagSingMenthod) {
        if (dic[@"ret"]) {
            NSDictionary *data = [dic objectForKey:@"data"];
            UCFSignModel *signModel = [UCFSignModel signWithDict:data];
            MjAlertView *alert = [[MjAlertView alloc] initRedBagAlertViewWithBlock:^(id blockContent) {
                UIView *view = (UIView *)blockContent;
                view.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
                UCFSignView *signView = [[UCFSignView alloc] initWithFrame:view.bounds];
                [view addSubview:signView];
                [view sendSubviewToBack:signView];
                signView.signModel = signModel;
            } delegate:self cancelButtonTitle:@"关闭"];
            alert.showViewbackImage = [UIImage imageNamed:@"checkin_bg"];
            [alert show];
        } else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagAccountSafe) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
//  选项表数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemsData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = UIColorWithRGB(0xf9f9f9);

    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 80, 15)];
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = UIColorWithRGB(0x333333);
    if (section == 0) {
        titleLab.text = @"我的信息";
    }else{
        titleLab.text = @"账户安全";
    }
    [headerView addSubview:titleLab];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFSettingGroup *group = self.itemsData[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecurityCell *cell = [SecurityCell cellWithTableView:tableView];
    UCFSettingGroup *group = self.itemsData[indexPath.section];
    if(indexPath.row == 0) {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        topLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell addSubview:topLine];
    }
    if (indexPath.row == group.items.count-1) {
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,43.5, ScreenWidth, 0.5)];
          bottomLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:bottomLine];
    }
    cell.item = group.items[indexPath.row];
    cell.delegate = self;
    
    if ([cell.item.title isEqualToString:@"会员等级"]) {
        [cell.contentView addSubview:_userLevelImage];
    }
    return cell;
}
//检查touchiID是否打开
- (void)checkSystemTouchIdisOpen
{
    if (![self checkTouchIdIsOpen]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_tableview reloadData];
}
// 安全中心cell的代理方法
- (void)securityCell:(SecurityCell *)securityCell changeGestureState:(BOOL)gestureState
{
    if ([securityCell.itemNameLabel.text isEqualToString:@"启用手势密码"]) {
        if (gestureState) {
            UCFVerifyLoginViewController *controller = [[UCFVerifyLoginViewController alloc] init];
            controller.sourceVC = @"securityCenter";
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            //关闭手势密码
            BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"取消设置手势密码会增加账户信息安全风险，确认关闭吗？" message:@"" cancelButtonTitle:@"确定" clickButton:^(NSInteger index){
                if (index == 0) {
                    //不做任何操作 并设置开启状态
                    [securityCell.switchView setOn:YES animated:YES];
                }
                else{
                    //关闭手势密码
                    
                    UCFVerifyLoginViewController *controller = [[UCFVerifyLoginViewController alloc] init];
                    controller.sourceVC = @"securityCenter";
                    [self.navigationController pushViewController:controller animated:YES];
                    //[LLLockPassword saveLockPassword:nil];
                }
            } otherButtonTitles:@"取消"];
            [alert show];
        }
    } else if ([securityCell.itemNameLabel.text isEqualToString:@"启用刷脸登录"]) {
        [self validFaceLogin:gestureState WithCell:securityCell];
    } else if (([securityCell.itemNameLabel.text isEqualToString:@"启用指纹解锁"])) {
        [self touchIDVerificationSwitchState:gestureState WithCell:securityCell];
    }
}

- (void)validFaceLogin:(BOOL)gestureState WithCell:(SecurityCell *)cell
{
    //修改刷脸登录之前，先去服务器 请求 刷脸登录开关
    [self getFaceSwitchStatusNetData];
}
-(void)validFaceLogin:(NSString *)faceIsOpen{
    if ([faceIsOpen intValue] == 1) {//关闭状态 由关----开
        
        UCFVerifyLoginViewController *controller = [[UCFVerifyLoginViewController alloc] init];
        controller.sourceVC = @"validFaceLogin";
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{ //开启状态 由开----关
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"关闭刷脸登录将清除保存的人脸信息，确认关闭吗？" message:@"" cancelButtonTitle:@"确定" clickButton:^(NSInteger index){
            if (index == 1) {
                //不做任何操作 并设置开启状态
//                [cell.switchView setOn:YES animated:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FACESWITCHSTATUS];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.tableview reloadData];
            }
            else{
                //关闭刷脸 需要验证登录密码 跳转至 验证登录密码页面
                UCFVerifyLoginViewController *controller = [[UCFVerifyLoginViewController alloc] init];
                controller.sourceVC = @"validFaceSwitchSwip";
                [self.navigationController pushViewController:controller animated:YES];
            }
        } otherButtonTitles:@"取消"];
        [alert show];
    }
}
- (void)touchIDVerificationSwitchState:(BOOL)gestureState WithCell:(SecurityCell *)cell
{

    LAContext *lol = [[LAContext alloc] init];
    lol.localizedFallbackTitle = @"";
    NSError *error = nil;
    NSString *showStr = @"";
    if (gestureState) {
        showStr = @"验证并开启指纹解锁";
    } else {
        showStr = @"验证并关闭指纹解锁";
    }
    
    //TODO:TOUCHID是否存在
    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //TODO:TOUCHID开始运作
        [lol evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:showStr reply:^(BOOL succes, NSError *error)
         {
             if (succes) {
                 NSLog(@"指纹验证成功");
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         //打开指纹手势
                     [[NSUserDefaults standardUserDefaults] setBool:gestureState forKey:@"isUserShowTouchIdLockView"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }];
             }
             else
             {
                 NSLog(@"%@",error.localizedDescription);
                 switch (error.code) {
                     case LAErrorSystemCancel:
                     {
                         NSLog(@"Authentication was cancelled by the system");
                         //切换到其他APP，系统取消验证Touch ID
                         break;
                     }
                     case LAErrorUserCancel:
                     {
                         NSLog(@"Authentication was cancelled by the user");
                         //用户取消验证Touch ID
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                             [cell.switchView setOn:!gestureState animated:YES];
                         }];
                         break;
                     }
                     case LAErrorUserFallback:
                     {
                         NSLog(@"User selected to enter custom password");
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                             //用户选择输入密码，切换主线程处理
                         }];
                         break;
                     }
                     default:
                     {
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                             //其他情况，切换主线程处理
                             [cell.switchView setOn:!gestureState animated:YES];
                         }];
                         break;
                     }
                 }
             }
         }];
        
    }
    else
    {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                //没有touchID 的报错
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
    }
        
    

}
- (BOOL)checkTouchIdIsOpen
{
    LAContext *lol = [[LAContext alloc] init];
    lol.localizedFallbackTitle = @"";
    NSError *error = nil;
    //TODO:TOUCHID是否存在
    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        return YES;
    } else {
        return NO;
    }
    return NO;
}
-(void)showGestureCode
{
    NSString *gode = [LLLockPassword loadLockPassword];
//    if (gode) {
//        [self showLLLockViewController:LLLockViewTypeCheck];
//    } else {
//        [self showLLLockViewController:LLLockViewTypeCreate];
//    }
    if (gode) {
        [self showLLLockViewController:LLLockViewTypeCheck];
    } else {
        [self showLLLockViewController:LLLockViewTypeModify];
    }
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.tableview reloadData];
    if(del.window.rootViewController.presentingViewController == nil){
        UCFLockHandleViewController *lockVc = [[UCFLockHandleViewController alloc] init];
        lockVc.delegate = self;
        lockVc.nLockViewType = type;
        lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [del.window.rootViewController presentViewController:lockVc animated:YES completion:^{
        }];
    }
}

// 手势界面的代理方法
- (void)lockHandleViewController:(UCFLockHandleViewController *)lockHandleVC didClickLeapWithSign:(BOOL)sign
{
    [self.tableview reloadData];
}

//  选项表代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    UCFSettingGroup *group = self.itemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    
    NSInteger openStatus = [UserInfoSingle sharedManager].openStatus;

    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[UCFSettingArrowItem class]]) { // 箭头
        UCFSettingArrowItem *arrowItem = (UCFSettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        UCFBaseViewController *vc ;
        //如果集成UCFWebViewJavascriptBridgeController 需要在这里添加
        if (!([NSStringFromClass(arrowItem.destVcClass) isEqualToString:@"UCFWebViewJavascriptBridgeLevel"] || [NSStringFromClass(arrowItem.destVcClass) isEqualToString:@"RiskAssessmentViewController"]))
        {
            vc = [[arrowItem.destVcClass alloc] init];
        }
        
        vc.title = arrowItem.title;
        if (indexPath.section == 0) {
        NSInteger  indexPathRow = indexPath.row;
        switch (indexPathRow) {
            case 0: {
                vc.rootVc = self;
                if ([item.subtitle isEqualToString:@"未认证"]) {
                    HSHelper *helper = [HSHelper new];
                    if (![helper checkP2POrWJIsAuthorization:SelectAccoutTypeP2P]) {//先授权
                        [helper pushP2POrWJAuthorizationType:SelectAccoutTypeP2P nav:self.navigationController];
                        return;
                    }
                    if (openStatus < 3) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:P2PTIP1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        alert.tag = 10005;
                        [alert show];
                        return;
                     }
                 }
                else{
                    vc = [[UCFModifyIdAuthViewController alloc] init];
                    vc.title = arrowItem.title;
                }
            }
                break;
                
            case 1: {
                if(self.isCompanyAgent){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前不支持企业用户修改手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                BindPhoneNumViewController *v = (BindPhoneNumViewController *)vc;
                v.authedPhone = item.subtitle;
                v.uperViewController = self;
                if ([item.subtitle isEqualToString:@"未绑定"]) {
                    
                    vc = [[UCFModifyPhoneViewController alloc] initWithNibName:@"UCFModifyPhoneViewController" bundle:nil];
                }
                v.rootVc = self;
            }
                break;
            case 2:{
                vc = [[arrowItem.destVcClass alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
                vc.title = arrowItem.title;
                ((UCFWebViewJavascriptBridgeLevel *)vc).url = LEVELURL;
                ((UCFWebViewJavascriptBridgeLevel *)vc).navTitle = @"会员等级";
            }
                break;
            case 3:
                {
                    UCFFacCodeViewController *subVC = [[UCFFacCodeViewController alloc] initWithNibName:@"UCFFacCodeViewController" bundle:nil];
                    subVC.urlStr = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/mycode.jsp?pcode=%@&sex=%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"gcmCode"],self.sex];
                    vc = subVC;
                }
                break;

          }
            [self.navigationController pushViewController:vc  animated:YES];
        }
        if (indexPath.section == 1) {
            
            if ([NSStringFromClass(arrowItem.destVcClass)  isEqualToString: @"ModifyPasswordViewController"]){//修改登录密码
                ModifyPasswordViewController * modifyPasswordVC = [[ModifyPasswordViewController alloc]initWithNibName:@"ModifyPasswordViewController" bundle:nil];
                modifyPasswordVC.title = arrowItem.title;
                modifyPasswordVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:modifyPasswordVC  animated:YES];
            } else if([NSStringFromClass(arrowItem.destVcClass)  isEqualToString: @"TradePasswordVC"]){ //设置交易密码或修改交易密码
                if(openStatus < 3){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 10005;
                    [alert show];
                }else if(openStatus == 3){
                    UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:3];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    TradePasswordVC * tradePasswordVC = [[TradePasswordVC alloc]initWithNibName:@"TradePasswordVC" bundle:nil];
                    tradePasswordVC.title = arrowItem.title;
                    tradePasswordVC.isCompanyAgent =_isCompanyAgent;
                    [self.navigationController pushViewController:tradePasswordVC  animated:YES];
                }
            } else if ([NSStringFromClass(arrowItem.destVcClass)  isEqualToString: @"UCFMoreViewController"]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UCFMoreViewController" bundle:nil];
                UCFMoreViewController *moreVC = [storyboard instantiateViewControllerWithIdentifier:@"more_main"];
                moreVC.title = @"更多";
                moreVC.sourceVC = @"UCFSecurityCenterViewController";
                vc = moreVC;
                [self.navigationController pushViewController:moreVC  animated:YES];
            }
        }
    }
}
- (BOOL) checkHSIsLegitimate {
    NSInteger openStatus = [UserInfoSingle sharedManager].openStatus;
    if(openStatus < 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:P2PTIP1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10005;
        [alert show];
        return NO;
    }else if(openStatus == 3){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10003;
        [alert show];
        return NO;
    }else{
        return YES;
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getPersonalCenterNetData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateFaceSwitchSwip" object:nil];
}
@end
