//
//  UCFRechargeOrCashViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFRechargeOrCashViewController.h"
#import "UCFRechargeAndCashView.h"
#import "UCFAccoutCardModel.h"
#import "UCFCashViewController.h"
#import "UCFTopUpViewController.h"
#import "HSHelper.h"
#import "UCFGoldCashViewController.h"
#import "UCFGoldRechargeViewController.h"
@interface UCFRechargeOrCashViewController ()<UCFRechargeAndCashViewDelegate>
{
    UCFRechargeAndCashView *_p2PAccoutCardView;
    UCFRechargeAndCashView *_honerAccoutCardView;
    UCFRechargeAndCashView *_goldAccoutCardView;
    UILabel *titleLabel;
    UIButton *closeBtn;
}

@end

@implementation UCFRechargeOrCashViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController.navigationBar setHidden:YES];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], ScreenHeight - [Common calculateNewSizeBaseMachine:110] * 3 - 15 - [Common calculateNewSizeBaseMachine:20], 150,  [Common calculateNewSizeBaseMachine:20])];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"请选择充值账户";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.hidden = YES;
    [self.view addSubview:titleLabel];
    
    closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:15] - 30, ScreenHeight - [Common calculateNewSizeBaseMachine:110] * 3 - 55, 30,55)];
    [closeBtn setImage:[UIImage imageNamed:@"ad_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.hidden = YES;
    [self.view addSubview:closeBtn];
    
    
    _p2PAccoutCardView = [self createAccoutCardView];
    _p2PAccoutCardView.tag = 101;
    [self.view addSubview:_p2PAccoutCardView];
    
    
    _honerAccoutCardView = [self createAccoutCardView];
    _honerAccoutCardView.tag = 102;
    [self.view addSubview:_honerAccoutCardView];
    
    _goldAccoutCardView = [self createAccoutCardView];
    _goldAccoutCardView.tag = 103;
    [self.view addSubview:_goldAccoutCardView];
    
    [self.view bringSubviewToFront:_goldAccoutCardView];
    [self.view sendSubviewToBack:_p2PAccoutCardView];
    [_p2PAccoutCardView bringSubviewToFront:_honerAccoutCardView];
    [_p2PAccoutCardView sendSubviewToBack:_goldAccoutCardView];
    
    [self rechargeInfoData];
}
-(UCFRechargeAndCashView *)createAccoutCardView
{
   UCFRechargeAndCashView *accoutCardView = [[[NSBundle mainBundle ]loadNibNamed:@"UCFRechargeAndCashView" owner:nil options:nil] firstObject];
    accoutCardView.frame = CGRectMake([Common calculateNewSizeBaseMachine:20], ScreenHeight, ScreenWidth -  [Common calculateNewSizeBaseMachine:20] * 2, [Common calculateNewSizeBaseMachine:110]);
    accoutCardView.delegate = self;
    return accoutCardView;
}
-(void)rechargeInfoData
{
    
    UCFAccoutCardModel *p2pCardModel  = [[UCFAccoutCardModel alloc]init];
    p2pCardModel.cardTitleStr = @"充值至微金账户";
    p2pCardModel.cardLogoImageName = @"card_logo_wj";
    p2pCardModel.cardBgImageName = @"card_bg_blue";
    if ([UserInfoSingle sharedManager].openStatus == 1) {
        p2pCardModel.cardDetialStr = @"未开户";
        p2pCardModel.cardNumberStr = @"";
        p2pCardModel.cardStateStr = @"去开户";
    }else if ([UserInfoSingle sharedManager].openStatus == 2)  {
        p2pCardModel.cardDetialStr = @"未绑卡";
        p2pCardModel.cardNumberStr = @"";
        p2pCardModel.cardStateStr = @"去绑卡";
    }else{
        p2pCardModel.cardDetialStr = @"微金徽商存管账户";
        p2pCardModel.cardNumberStr = @"0000 0000 0000 0000";
        p2pCardModel.cardStateStr = @"";
    }
    
    UCFAccoutCardModel *honerCardModel  = [[UCFAccoutCardModel alloc]init];
    honerCardModel.cardTitleStr = @"充值至尊享账户";
    honerCardModel.cardLogoImageName = @"card_logo_zx";
    honerCardModel.cardBgImageName = @"card_bg_red";
    if ([UserInfoSingle sharedManager].enjoyOpenStatus == 1) {
        honerCardModel.cardDetialStr = @"未开户";
        honerCardModel.cardNumberStr = @"";
        honerCardModel.cardStateStr = @"去开户";
    }else if ([UserInfoSingle sharedManager].enjoyOpenStatus == 2)  {
        honerCardModel.cardDetialStr = @"未绑卡";
        honerCardModel.cardNumberStr = @"";
        honerCardModel.cardStateStr = @"去绑卡";
    }else{
        honerCardModel.cardDetialStr = @"尊享徽商存管账户";
        honerCardModel.cardNumberStr = @"0000 0000 0000 0000";
        honerCardModel.cardStateStr = @"";
    }

    UCFAccoutCardModel *goldCardModel  = [[UCFAccoutCardModel alloc]init];
    goldCardModel.cardTitleStr = @"充值至黄金账户";
    goldCardModel.cardLogoImageName = @"card_logo_gold";
    goldCardModel.cardBgImageName = @"card_bg_yellow";
    if ([UserInfoSingle sharedManager].openStatus < 3 || [UserInfoSingle sharedManager].enjoyOpenStatus < 3) {
        goldCardModel.cardDetialStr = @"未开户";
        goldCardModel.cardNumberStr = @"";
        goldCardModel.cardStateStr = @"去开户";
    }else {
        if (![UserInfoSingle sharedManager].goldAuthorization ){
            goldCardModel.cardDetialStr = @"未授权";
            goldCardModel.cardNumberStr = @"";
            goldCardModel.cardStateStr = @"去授权";
        }else{
            goldCardModel.cardDetialStr = @"工场黄金账户";
            goldCardModel.cardNumberStr = @"0000 0000 0000 0000";
            goldCardModel.cardStateStr = @"";
        }
    }
    _p2PAccoutCardView.accoutCardModel = p2pCardModel;
    _honerAccoutCardView.accoutCardModel = honerCardModel;
    _goldAccoutCardView.accoutCardModel = goldCardModel;
    
    [self moveView:_goldAccoutCardView moveTime:0.25 moveY:[Common calculateNewSizeBaseMachine:110]];
    [self moveView:_honerAccoutCardView  moveTime:0.4 moveY:[Common calculateNewSizeBaseMachine:110] *2];
    [self moveView:_p2PAccoutCardView moveTime:0.6 moveY:[Common calculateNewSizeBaseMachine:110] * 3];
}
-(void)closeView
{
//    self.navigationController.viewControllers = [NSMutableArray new];
    [self dismissViewControllerAnimated:NO completion:^{
        
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark =====横向、纵向移动===========
-(void )moveView:(UIView *)view   moveTime:(float)time moveY:(float)y
{
    [UIView animateWithDuration:time  delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint center= view.center;
        center.y -= y;
        view.center = center;
    } completion:^(BOOL finished) {
        if (view.tag == 101) {
            titleLabel.hidden = NO;
            closeBtn.hidden = NO;
        }
    }];
}

-(void)clickRechargeAndCashView:(UCFRechargeAndCashView *)cardView WithTag:(NSInteger)tag WithModel:(UCFAccoutCardModel *)cardModel
{
    switch (tag) {
        case 101://微金充值
        {
            if([cardModel.cardStateStr isEqualToString:@"去开户"] || [cardModel.cardStateStr isEqualToString:@"去绑卡"])
            {
                HSHelper *helper = [HSHelper new];
                [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
            }
            else
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
                UCFTopUpViewController * rechargeVC = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
                rechargeVC.title = @"充值";
                rechargeVC.uperViewController = self;
                rechargeVC.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:rechargeVC animated:YES];
            }
        }
            break;
        case 102://尊享充值
        {
            if([cardModel.cardStateStr isEqualToString:@"去开户"] || [cardModel.cardStateStr isEqualToString:@"去绑卡"])
            {
                HSHelper *helper = [HSHelper new];
                [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
            }
            else
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
                UCFTopUpViewController * rechargeVC = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
                rechargeVC.title = @"充值";
                rechargeVC.uperViewController = self;
                rechargeVC.accoutType = SelectAccoutTypeHoner;
                [self.navigationController pushViewController:rechargeVC animated:YES];
            }
        }
            break;
        case 103://黄金充值
        {
            if([cardModel.cardStateStr isEqualToString:@"去开户"])//去尊享开户
            {
                HSHelper *helper = [HSHelper new];
                [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
            }
            else if([cardModel.cardStateStr isEqualToString:@"去授权"])//去黄金授权页面
            {
                HSHelper *helper = [HSHelper new];
                [helper pushGoldAuthorizationType:SelectAccoutTypeGold nav:self.navigationController];
            }
            else {//去黄金充值页面
                //去充值页面
                UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
                goldRecharge.baseTitleText = @"充值";
                goldRecharge.rootVc = self;
                [self.navigationController pushViewController:goldRecharge animated:YES];
                return;
                
                
                UCFGoldCashViewController *vc1 = [[UCFGoldCashViewController alloc] initWithNibName:@"UCFGoldCashViewController" bundle:nil];
                vc1.baseTitleText = @"黄金变现";
                vc1.rootVc = self;
                [self.navigationController pushViewController:vc1 animated:YES];
            }
        }
        default:
            break;
    }
}

- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail type:(SelectAccoutType)accout;
{
    
    NSString *tipStr1 = accout == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = accout == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;
    
    NSInteger openStatus = accout == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus :[UserInfoSingle sharedManager].enjoyOpenStatus;
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag =  self.accoutType == SelectAccoutTypeP2P ? 8000 :8010;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            
        }
    }else if (alertView.tag == 8010) {
        if (buttonIndex == 1) {
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
