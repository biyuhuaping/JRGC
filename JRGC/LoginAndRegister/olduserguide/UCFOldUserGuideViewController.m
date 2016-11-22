
//
//  UCFOldUserGuideViewController.m
//  JRGC
//
//  Created by 狂战之巅 on 16/8/4.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFOldUserGuideViewController.h"
#import "BlockUIAlertView.h"

#import "OpeningMerchantsVC.h"  //注册成功，开通微商
#import "UpgradeAccountVC.h"    //升级存管账户
#import "TradePasswordVC.h"     //设置交易密码
#import "AccountWebView.h"      //开户成功web页
#import "UINavigationController+FDFullscreenPopGesture.h"

#define TITLEHEIGHT 44
#define TITLEWIDTH  SCREEN_WIDTH/3
#define IMAGEVIEWWIDTH 15
#define WORDHEIGHT 14
#define WORDCOLORBLUE UIColorWithRGB(0x6280a8)
#define WORDCOLORGRAY UIColorWithRGB(0x999999)
#define TITLECOLORGRAY UIColorWithRGB(0xf9f9f9)

@interface UCFOldUserGuideViewController ()

//@property (nonatomic, assign) OledUserGuideType guideType;

@property (nonatomic, strong) OpeningMerchantsVC *openVC;   //注册页面
@property (nonatomic, strong) UpgradeAccountVC *upgradeVC;  //徽商存管页面
@property (nonatomic, strong) TradePasswordVC *passWordVC;  //设置交易密码页面
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UIView *firstView;    //标题注册view
@property (nonatomic, strong) UIView *secondView;   //标题徽商view
@property (nonatomic, strong) UIView *thirdView;    //标题密码view

@end

@implementation UCFOldUserGuideViewController

+ (UCFOldUserGuideViewController *)createGuideHeadSetp:(int) step
{
    UCFOldUserGuideViewController *vc = [[UCFOldUserGuideViewController alloc] initWithNibName:@"UCFOldUserGuideViewController" bundle:nil];
    //vc.isRegister = isRegister;
    //vc.isBankCard   = bankCard;
    //vc.isOpenAccount = openAccount;
    //vc.isTradePwdSet = tradePwdSet;
    vc.isStep     = step;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.fd_interactivePopDisabled = YES;
    self.navigationItem.hidesBackButton = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getToBack) name:BACK_TO_HS object:nil];
    [self addRightButtonWithName:@"关闭"];
    
    [self createHeadTitleView]; //创建标题视图
    [self createViewController];//创建流程视图
    [self initView]; //初始化视图
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 45);
    CGRect frame = CGRectMake(CGRectGetMinX(self.view.bounds) , CGRectGetMinY(self.view.bounds) + 45, ScreenWidth, ScreenHeight - 44);
    self.openVC.view.frame = frame;
    self.upgradeVC.view.frame = frame;
    self.passWordVC.view.frame = frame;
    [self.view layoutIfNeeded];
}

- (void)addRightButtonWithName:(NSString *)rightButtonName
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 44, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightbutton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:WORDCOLORGRAY forState:UIControlStateNormal];
    //rightbutton.titleLabel.textColor = TITLECOLORGRAY;
    //[rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    
    if (kIS_IOS7) {
        [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    } else {
        [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)getToBack {
    [self.upgradeVC.view endEditing:YES];
    [self.passWordVC.view endEditing:YES];
    
    NSString *messege = @"确定返回？";
    switch ([UserInfoSingle sharedManager].openStatus) {
        case 1://未开户-->>>新用户开户
        case 2:{//已开户 --->>>老用户(白名单)开户
            messege = @"未开通徽商存管不能投标、提现、充值。";
        }
            break;
        case 3:{//已绑卡-->>>去设置交易密码页面
            messege = @"未设置交易密码不能投标、提现。";
        }
            break;
    }

    BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:messege cancelButtonTitle:@"取消" clickButton:^(NSInteger index) {
        if (index == 1) {
            if (self.isPresentViewController) {
                //视图是弹出来的，那么要
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } otherButtonTitles:@"确定"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert show];
    });
}

//初始化标题view
- (void)initView {
    switch (self.isStep) {
        case 1:{
            //显示注册成功页面
            [self showRegisterView];
        }
            break;
        case 2:{
            //显示徽商绑定页面
            [self changeTitleViewController:showDepository];
        }
            break;
        case 3:{
            //显示设置交易密码
            [self changeTitleViewController:showPassWord];
        }
            break;
    }    
}

//创建控制器
- (void)createViewController
{
    self.openVC = [[OpeningMerchantsVC alloc] initWithNibName:@"OpeningMerchantsVC" bundle:nil];
    self.openVC.db = self;
    [self addChildViewController:self.openVC];
    [self.scrollView addSubview:self.openVC.view];
    self.currentVC = self.openVC;

    self.upgradeVC = [[UpgradeAccountVC alloc] initWithNibName:@"UpgradeAccountVC" bundle:nil];
    self.upgradeVC.db = self;
    [self addChildViewController:self.upgradeVC];
    
    self.passWordVC = [[TradePasswordVC alloc] initWithNibName:@"TradePasswordVC" bundle:nil];
    self.passWordVC.db = self;
    [self addChildViewController:self.passWordVC];
}

//初始化titleView
- (void)createHeadTitleView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-15, TITLEHEIGHT)]; //箭头位置所以单独处理15像素
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //第一个视图
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, TITLEWIDTH, TITLEHEIGHT)];
    [bottomView addSubview:self.firstView];
    
    UIImageView *arrowImView1 = [[UIImageView alloc] init];
    [self.firstView addSubview:arrowImView1];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"完成注册";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14.0];
    [self.firstView addSubview:label1];
    
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:label1.font, NSFontAttributeName,nil];
    CGSize titleSize = [label1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic1 context:nil].size;
    CGFloat arrowX = (CGRectGetWidth(self.firstView.frame) - titleSize.width - IMAGEVIEWWIDTH)/2;
    
    arrowImView1.frame = CGRectMake(arrowX, (CGRectGetHeight(self.firstView.frame) - IMAGEVIEWWIDTH)/2, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    label1.frame = CGRectMake(CGRectGetMaxX(arrowImView1.frame)+5, (CGRectGetHeight(self.firstView.frame) - WORDHEIGHT)/2, titleSize.width, WORDHEIGHT);
    
    //第二个视图
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstView.frame), 0, TITLEWIDTH, TITLEHEIGHT)];
    [bottomView addSubview:self.secondView];
    
    UIImageView *arrowImView2 = [[UIImageView alloc] init];
    arrowImView2.tag = 200;
    [self.secondView addSubview:arrowImView2];
    
    UIImageView *hookImView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 44)];
    hookImView2.tag = 201;
    [self.secondView addSubview:hookImView2];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"徽商存管";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14.0];
    [self.secondView addSubview:label2];
    
    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:label2.font, NSFontAttributeName,nil];
    CGSize titleSize2 = [label2.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic2 context:nil].size;
    CGFloat arrowX2 = (CGRectGetWidth(self.secondView.frame) - titleSize2.width - IMAGEVIEWWIDTH - 15)/2;
    arrowImView2.frame = CGRectMake(arrowX2 + 15, (CGRectGetHeight(self.secondView.frame) - IMAGEVIEWWIDTH)/2, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    label2.frame = CGRectMake(CGRectGetMaxX(arrowImView2.frame)+5, (CGRectGetHeight(self.secondView.frame) - WORDHEIGHT)/2, titleSize2.width, WORDHEIGHT);
    
    //第三个视图
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.secondView.frame), 0, TITLEWIDTH+15, TITLEHEIGHT)];
    [bottomView addSubview:self.thirdView];
    
    UIImageView *arrowImView3 = [[UIImageView alloc] init];
    arrowImView3.tag = 300;
    [self.thirdView addSubview:arrowImView3];
    
    UIImageView *hookImView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 44)];
    hookImView3.tag = 301;
    [self.thirdView addSubview:hookImView3];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"交易密码";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:14.0];
    [self.thirdView addSubview:label3];
    
    NSDictionary * dic3 = [NSDictionary dictionaryWithObjectsAndKeys:label3.font, NSFontAttributeName,nil];
    CGSize titleSize3 = [label3.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic3 context:nil].size;
    
    CGFloat arrowX3 = (CGRectGetWidth(self.thirdView.frame) - titleSize3.width - IMAGEVIEWWIDTH - 15)/2;
    
    arrowImView3.frame = CGRectMake(arrowX3, (CGRectGetHeight(self.thirdView.frame) - IMAGEVIEWWIDTH)/2, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    label3.frame = CGRectMake(CGRectGetMaxX(arrowImView3.frame)+5, (CGRectGetHeight(self.thirdView.frame) - WORDHEIGHT)/2, titleSize3.width, WORDHEIGHT);

    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [bottomView addSubview:topLineView];
    
    UIView *bottmLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomView.frame) - 0.5, ScreenWidth, 0.5)];
    bottmLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [bottomView addSubview:bottmLineView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 1
/**
 *  选中的样子：   有步骤图片，字体和图片都是蓝色，背景为白色
 未选中样子：  有步骤图片，字体和图片都是灰色，背景为白色
 完成的样子：  有完成图片，字体和图片都是灰色，背景为灰色
 */

- (void)registerView//注册选中的样子
{
    for (UIView *views  in self.firstView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_one"];
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = UIColorWithRGB(0x6280a8);
        }
    }
}

- (void)registerFinshView//注册完成的样子
{
    self.firstView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    for (UIView *views  in self.firstView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)views).image = [UIImage imageNamed:@"authentication_icon_finish"];
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}

#pragma mark - 2
- (void)saveView {//徽商选中的样子
    self.secondView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.secondView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 200) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_2_normal"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_gray"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORBLUE;
        }
    }
}

- (void)saveBeforeView {//徽商未选中的样子
    self.secondView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.secondView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 200) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_2_gray"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_transparent"];
            }
        }
        if ([views isKindOfClass:[UILabel class]])  {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}

- (void)saveViewFinsh {//徽商完成的样子
    self.secondView.backgroundColor = TITLECOLORGRAY;
    for (UIView *views  in self.secondView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 200) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"authentication_icon_finish"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_gray"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}

#pragma mark - 3
- (void)passWordView {//密码选中的样子
    self.thirdView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.thirdView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 300) {
               ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_3"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_gray"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORBLUE;
        }
    }
}

- (void)passWordBeforeView {//密码未选中的样子
    self.thirdView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.thirdView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 300) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_3_gray"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_transparent"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}

- (void)passWordViewFinsh {//密码完成的样子
    self.thirdView.backgroundColor = TITLECOLORGRAY;
    for (UIView *views  in self.thirdView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)views).image = [UIImage imageNamed:@"authentication_icon_finish"];
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}

#pragma mark - 切换标题和控制器
- (void)changeTitleViewController:(showViewType)type {
    if(type == showDepository) {
        [self transitionToViewController:self.upgradeVC withType:showDepository];
    }
    else if(type == showPassWord) {
        self.passWordVC.idCardNo = self.upgradeVC.idCardNo;//@"110101198503011099";//
        [self transitionToViewController:self.passWordVC withType:showPassWord];
    }
    else if(type == showWebView) {
//        AccountWebView *webView = [[AccountWebView alloc] initWithNibName:@"AccountWebView" bundle:nil];
//        webView.title = @"即将跳转";
//        webView.url = SETHSPWD;
//        webView.webDataDic = @{@"idCardNo":self.passWordVC.idCardNo, @"validateCode":self.passWordVC.validateCode, @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID]};
//        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (void)transitionToViewController:(UIViewController *)toViewController withType:(showViewType)type
{
    [self transitionFromViewController:self.currentVC toViewController:toViewController duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.25];
        [animation setFillMode:kCAFillModeForwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [toViewController.view.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        self.currentVC = toViewController;
        if(type == showDepository) {
            [self showDepositoryView];
        }
        else if(type == showPassWord) {
            //self.passWordVC.idCardNo = self.upgradeVC.idCardNo;
            [self showPassWordView];
        }
    }];
}

- (void)showRegisterView {
    baseTitleLabel.text = @"注册成功";
    [self registerView];
    [self saveBeforeView];
    [self passWordBeforeView];
}

- (void)showDepositoryView {
    baseTitleLabel.text = @"开通徽商存管";
    [self registerFinshView];
    [self saveView];
    [self passWordBeforeView];
}

- (void)showPassWordView {
    baseTitleLabel.text = @"设置交易密码";
    [self registerFinshView];
    [self saveViewFinsh];
    [self passWordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    //刷新首页、债券转让、个人中心数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignmentUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACK_TO_HS object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MODIBANKZONE_SUCCESSED object:nil];//返回绑定银行卡页面刷刷新数据
 }

@end
