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
@interface UCFSecurityCenterViewController () <UITableViewDataSource, UITableViewDelegate, SecurityCellDelegate, UCFLockHandleDelegate>

// 选项表数据
@property (nonatomic, strong) NSMutableArray *itemsData;

@property (nonatomic,assign) BOOL  userGradeSwitch;//会员等级开关

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) UCFSettingItem *userLevel;

@property (nonatomic ,strong) UIImageView *userLevelImage;
@property (nonatomic,strong)UCFSettingItem *setChangePassword;

@property (strong, nonatomic) NSString *isCompanyAgent;//是否是机构用户

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
//        UCFSettingItem *userName = [UCFSettingItem itemWithIcon:@"login_icon_name" title:@"用户名"];
         self.userLevel = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_vip" title:@"会员等级" destVcClass:[UCFWebViewJavascriptBridgeLevel class]];
        self.userLevel.isShowOrHide = NO;//不显示
        UCFSettingItem *idauth = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_id" title:@"身份认证" destVcClass:[UCFModifyIdAuthViewController class]];
        UCFSettingItem *bundlePhoneNum = [UCFSettingArrowItem itemWithIcon:@"login_icon_phone" title:@"绑定手机号" destVcClass:[BindPhoneNumViewController class]];
        //先前是绑卡页面，因为删除绑卡页面，所以暂时用TradePasswordVC这个类替代，整体调试的时候改过来，zrc fixed
        UCFSettingItem *bundleCard = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_bankcard" title:@"绑定银行卡" destVcClass:[UCFBankCardInfoViewController class]];
        
        UCFSettingItem *riskAssessment = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_assessment" title:@"风险承担能力" destVcClass:[RiskAssessmentViewController class]];
        
        UCFSettingItem *activeGestureCode  = [UCFSettingSwitchItem itemWithIcon:@"safecenter_icon_gesture" title:@"启用手势密码"];
        UCFSettingItem *activeFaceValid  = [UCFSettingSwitchItem itemWithIcon:@"uesr_icon_face" title:@"启用刷脸登录" withSwitchType:2];
        UCFSettingItem *modifyPassword = [UCFSettingArrowItem itemWithIcon:@"login_icon_password" title:@"修改登录密码" destVcClass:[ModifyPasswordViewController class]];
        self.setChangePassword = [UCFSettingArrowItem itemWithIcon:@"safecenter_icon_transaction" title:@"设置交易密码" destVcClass:[TradePasswordVC class]];
//        self.setChangePassword.isShowOrHide  = YES;//显示该信息 对应的cell可以点击
        
        UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];//用户信息
        group1.items = [[NSMutableArray alloc]initWithArray: @[self.userLevel,idauth, bundlePhoneNum, bundleCard,riskAssessment]];

        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];//账户安全
        
        if ([self checkTouchIdIsOpen]) {
            UCFSettingItem *zhiWenSwith  = [UCFSettingSwitchItem itemWithIcon:@"safecenter_icon_touch" title:@"启用指纹解锁" withSwitchType:1];
            group2.items = [[NSMutableArray alloc]initWithArray:@[activeGestureCode,zhiWenSwith, activeFaceValid,modifyPassword,_setChangePassword]];
        } else {
            group2.items =[[NSMutableArray alloc]initWithArray: @[activeGestureCode,activeFaceValid,modifyPassword,_setChangePassword]];

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
    
    baseTitleLabel.text = @"个人信息";
  
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
    }else{
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

#pragma mark alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagUserLogout owner:self];
            
            [[UCFSession sharedManager] transformBackgroundWithUserInfo:nil withState:UCFSessionStateUserLogout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
            [[UserInfoSingle sharedManager] removeUserInfo];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //安全退出后去首页
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate.tabBarController setSelectedIndex:0];
            [delegate.tabBarController.tabBar hideBadgeOnItemIndex:3];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
            
            //退出时清cookis
            [Common deleteCookies];
            [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
            //通知首页隐藏tipView
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
        }

    }else if(alertView.tag == 10005){
        if (buttonIndex == 1) {
            [self gotoBankDepositoryAccountVC];
        }
    }
}

//获取 人脸识别开关状态查询网络请求
-(void)getFaceSwitchStatusNetData
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFaceSwitchStatus owner:self];
}
//更新 人脸识别开关状态查询网络请求 注意更新请求上传 当前刷脸状态
-(void)updateFaceSwitchSwipNetData
{
    BOOL faceSwichSwip = ![[NSUserDefaults standardUserDefaults] boolForKey:FACESWITCHSTATUS];
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&status=%d", [[NSUserDefaults standardUserDefaults] objectForKey:UUID],faceSwichSwip];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFaceSwitchSwip owner:self];
}
// 获取网络数据
- (void)getSecurityCenterNetData
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagAccountSafe owner:self];
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
    NSString *rsttext = dic[@"statusdes"];
    
    if (tag.intValue == kSXTagAccountSafe) {
        if ([rstcode intValue] == 1) {
            NSDictionary *result = dic[@"data"];
            UCFSettingGroup *group = [self.itemsData firstObject];
            NSNumber *memberLever = [dic objectSafeForKey:@"memberLever"];
            NSString *authId = [result objectForKey:@"state"];
            NSString *bindPhone = [result objectForKey:@"bindMobile"];
            NSString *oldPhone = [[NSUserDefaults standardUserDefaults] valueForKey:PHONENUM];
            NSString *gradeResult = dic[@"gradeResult"];
            self.isCompanyAgent = dic[@"isCompanyAgent"];
            
            //新请求的手机号和本地存储手机号不一样则更新本地
            if (![oldPhone isEqualToString:bindPhone]) {
                [[NSUserDefaults standardUserDefaults] setValue:bindPhone forKey:PHONENUM];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSString *bindCard = [result objectForKey:@"card"];
            NSString *realName = [result objectForKey:@"realName"];
            self.userGradeSwitch = [dic[@"isOpen"]  boolValue];
            //保存 刷脸登录开关
          
            if([dic isExistenceforKey:@"faceIsOpen"] && ![[dic objectSafeForKey:@"faceIsOpen"] isEqualToString:@""]){
                 [[NSUserDefaults standardUserDefaults] setBool:![dic[@"faceIsOpen"]  boolValue] forKey:FACESWITCHSTATUS];
            }else{
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACESWITCHSTATUS];
            }
            
            
//            if (![[UCFToolsMehod isNullOrNilWithString:authId] isEqualToString:@"未认证"]) {
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IDCARD_STATE];
//            }
//            else {
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:IDCARD_STATE];
//            }
//            if (![[UCFToolsMehod isNullOrNilWithString:bindCard] isEqualToString:@"未绑定"]) {
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:BANKCARD_STATE];
//            }
//            else {
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:BANKCARD_STATE];
//            }
            [UserInfoSingle sharedManager].openStatus = [[dic objectSafeForKey: @"openStatus"] integerValue] ;
            if ([UserInfoSingle sharedManager].openStatus == 4) {
                _setChangePassword.title = @"修改交易密码";
            }else{
                _setChangePassword.title = @"设置交易密码";
            }
//            if ([UserInfoSingle sharedManager].openStatus == 5) { //特殊用户 设置交易密码不可的点击
//                _setChangePassword.isShowOrHide = NO;
//            }
            [[NSUserDefaults standardUserDefaults] setObject:realName forKey:REALNAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (self.userGradeSwitch) {
                self.userLevel.isShowOrHide = YES;//大开关开启时 会员等级 显示
            }
            for (UCFSettingItem *userItem in group.items) {
                NSInteger index = [group.items indexOfObject:userItem];
                switch (index) {
                    case 0:
                    {
                    userItem.subtitle = @"VIP";
                        if ([memberLever intValue] >= 2) {
                            _userLevelImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"vip%d_icon.png",[memberLever intValue]-1]];
                        }else{
                            _userLevelImage.image =[UIImage imageNamed:@"no_vip_icon.png"];
                        }
                    }
                        break;
                    case 1:{
                        userItem.subtitle = [authId isEqualToString:@"未认证"] ? @"未认证" : authId;
                    }
                        break;
                    case 2:
                        userItem.subtitle = [bindPhone isEqualToString:@""] ? @"未绑定" : bindPhone;
                        break;
                    
                    case 3:
                        userItem.subtitle = [bindCard isEqualToString:@""] ? @"未绑定" : bindCard;
                        break;
                    case 4:
                        userItem.subtitle = gradeResult;
                        break;
                    default:
                        break;
                }
            }
            [self.tableview reloadData];
        }else
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
    }  else if (tag.integerValue == kSXTagUserLogout) {
//        [[UCFSession sharedManager] transformBackgroundWithUserInfo:nil withState:UCFSessionStateUserLogout];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
//        [[UserInfoSingle sharedManager] removeUserInfo];
//        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        //安全退出后去首页
//        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        [delegate.tabBarController setSelectedIndex:0];
//        [delegate.tabBarController.tabBar hideBadgeOnItemIndex:3];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
//        
//        //退出时清cookis
//        [Common deleteCookies];
//        [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
//        //通知首页隐藏tipView
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
    }else if(tag.integerValue == kSXTagFaceSwitchStatus){//刷脸登录状态开关
        if ([rstcode intValue] == 1) {
            NSString * faceIsOpen = [dic objectSafeForKey:@"isOpen"];// 1：关闭 0：开启
            [self validFaceLogin:faceIsOpen];
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [self.tableview reloadData];
        }
    }else if(tag.integerValue == kSXTagFaceSwitchSwip){//刷脸登录状态更新
        if ([rstcode intValue] == 1) {
            [AuxiliaryFunc showToastMessage:@"刷脸登录关闭成功" withView:self.view];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACESWITCHSTATUS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableview reloadData];
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FACESWITCHSTATUS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableview reloadData];
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
    
    if (indexPath.section == 0 && indexPath.row == 0 ) { //判断会员等级一栏 是否隐藏
        if (self.userLevel.isShowOrHide && self.userGradeSwitch) {
            return 44.0f;
        }else{
            return 0.0f;
        }
    }
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
    if(indexPath.section == 0 && indexPath.row == 1) {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        topLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        topLine.tag = 10001;
        [cell addSubview:topLine];
        if (kIS_IOS8) {
            for (UIView *view  in cell.subviews) {
                if (view.tag == 10001) {
                    view.hidden = self.userGradeSwitch;
                }
            }
        }else{
            for (UIView *view in [cell subviews]) {
                for (UIView *viewsub in [view subviews]) {
                    if (viewsub.tag == 10001) {
                        viewsub.hidden = self.userGradeSwitch;
                    }
                }
            }
        }
    }
    if (indexPath.row == group.items.count-1) {
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,43.5, ScreenWidth, 0.5)];
          bottomLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:bottomLine];
    }
    if ( indexPath.section == 0  && indexPath.row == 0) {
        cell.itemSubTitleLabel.hidden = YES;
        [cell addSubview:_userLevelImage];
        cell.hidden = !self.userGradeSwitch;//此判断会员等级一栏 是否隐藏
    }
    cell.item = group.items[indexPath.row];
    cell.delegate = self;
    
//    if (indexPath.section == 1 ) {
//      NSInteger index = [group.items indexOfObject:_setChangePassword];
//        if (indexPath.row == index && !_setChangePassword.isShowOrHide &&  [UserInfoSingle sharedManager].openStatus == 5 ) {//如果是特殊用户，则设置交易密码 不可点击 --需求取消
//            cell.itemNameLabel.textColor = UIColorWithRGB(0xcccccc);
//            cell.userInteractionEnabled = NO ;
//        }
//    }
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
    NSIndexPath *indexPath = [_tableview indexPathForCell:securityCell];
    UCFSettingGroup *group = self.itemsData[1];
    if (indexPath.row == 0) {
        if (gestureState) {
            UCFVerifyLoginViewController *controller = [[UCFVerifyLoginViewController alloc] init];
            controller.sourceVC = @"securityCenter";
            [self.navigationController pushViewController:controller animated:YES];
            //[self showGestureCode];
        }
        else {
            //关闭手势密码
            BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"取消设置手势密码会增加账户信息安全风险，确认关闭吗？" message:@"" cancelButtonTitle:@"确定" clickButton:^(NSInteger index){
                if (index == 1) {
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
    } else {
        if ([group.items count] == 4) {
            [self validFaceLogin:gestureState WithCell:securityCell];
        } else {
            if (indexPath.row == 1) {
            [self touchIDVerificationSwitchState:gestureState WithCell:securityCell];
            } else {
                [self validFaceLogin:gestureState WithCell:securityCell];
            }
        }
        
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
                if ([item.subtitle isEqualToString:@"VIP"]) {
                  vc = [[arrowItem.destVcClass alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
                    vc.title = arrowItem.title;
                    ((UCFWebViewJavascriptBridgeLevel *)vc).url = LEVELURL;
                    ((UCFWebViewJavascriptBridgeLevel *)vc).navTitle = @"会员等级";
                     //vc.rootVc = self;
                }
            }
                break;
            case 1: {
                vc.rootVc = self;
                if ([item.subtitle isEqualToString:@"未认证"]) {
                    if (openStatus < 3) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
                
            case 2: {
                BindPhoneNumViewController *v = (BindPhoneNumViewController *)vc;
                v.authedPhone = item.subtitle;
                v.uperViewController = self;
                if ([item.subtitle isEqualToString:@"未绑定"]) {
                    
                    vc = [[UCFModifyPhoneViewController alloc] initWithNibName:@"UCFModifyPhoneViewController" bundle:nil];
                }
                v.rootVc = self;
            }
                break;
                
            case 3: {
                vc.rootVc = self;
                if ([item.subtitle isEqualToString:@"未绑定"]) {
                    if(openStatus < 3){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.tag = 10005;
                        [alert show];
                    }
                    return;
                }else {
                    if (openStatus == 5) {
                        FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:REMINDBANKH5 title:@"特殊用户绑卡提醒"];
                        webController.baseTitleType = @"specialUser";
                       [self.navigationController pushViewController:webController  animated:YES];
                        return;
                    }
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
                    vc = [storyboard instantiateViewControllerWithIdentifier:@"bankcardinfo"];
//                    vc = [[UCFBankCardInfoViewController alloc] init];
                    vc.title = @"绑定银行卡";
                }
            }
                break;
            case 4: {
                vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
                vc.title = arrowItem.title;
                ((RiskAssessmentViewController *)vc).url = GRADELURL;
                [self.navigationController pushViewController:vc  animated:YES];
                return;

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
            }else if([NSStringFromClass(arrowItem.destVcClass)  isEqualToString: @"TradePasswordVC"]){ //设置交易密码或修改交易密码
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
                    tradePasswordVC.isCompanyAgent = [self.isCompanyAgent boolValue];
                    [self.navigationController pushViewController:tradePasswordVC  animated:YES];
                }
            }
        }
    }
}
#pragma mark 徽商资金存管专题页面
-(void)gotoBankDepositoryAccountVC{
     NSInteger openStatus = [UserInfoSingle sharedManager].openStatus;
    if (openStatus < 3) {
        UCFBankDepositoryAccountViewController * bankDepositoryAccountVC =[[UCFBankDepositoryAccountViewController alloc ]initWithNibName:@"UCFBankDepositoryAccountViewController" bundle:nil];
        bankDepositoryAccountVC.openStatus = openStatus;
        [self.navigationController pushViewController:bankDepositoryAccountVC animated:YES];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getPersonalCenterNetData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateFaceSwitchSwip" object:nil];
}
@end
