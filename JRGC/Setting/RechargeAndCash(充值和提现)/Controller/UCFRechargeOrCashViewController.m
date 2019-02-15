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
#import "UCFGoldCashMoneyViewController.h"
#import "UCFGoldRechargeViewController.h"
#import "UCFToolsMehod.h"
#import "ToolSingleTon.h"
#import "UCFNewRechargeViewController.h"
@interface UCFRechargeOrCashViewController ()<UCFRechargeAndCashViewDelegate>

@property (nonatomic ,strong)UCFRechargeAndCashView *p2PAccoutCardView;
@property (nonatomic ,strong)UCFRechargeAndCashView *honerAccoutCardView;
@property (nonatomic ,strong)UCFRechargeAndCashView *goldAccoutCardView;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *totallBalanceLabel;
@property (nonatomic ,strong)UIButton *closeBtn;;
@end

@implementation UCFRechargeOrCashViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    lineViewAA.hidden = YES;
     [self.navigationController.navigationBar setHidden:YES];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], ScreenHeight - [Common calculateNewSizeBaseMachine:110] * 3 - 15 - [Common calculateNewSizeBaseMachine:20], 150,  [Common calculateNewSizeBaseMachine:20])];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"请选择充值账户";
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.hidden = YES;
    [self.view addSubview:_titleLabel];
    
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:15] - 30, ScreenHeight - [Common calculateNewSizeBaseMachine:110] * 3 - 55, 30,55)];
    [_closeBtn setImage:[UIImage imageNamed:@"ad_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.hidden = YES;
    [self.view addSubview:_closeBtn];
    
    
    _p2PAccoutCardView = [self createAccoutCardView];
    _p2PAccoutCardView.tag = 1001;
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
    
    _isRechargeOrCash ? [self cashInfoData] : [self rechargeInfoData];
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
    p2pCardModel.isRechargeOrCash = _isRechargeOrCash;
    p2pCardModel.cardLogoImageName = @"card_logo_wj";
    p2pCardModel.cardBgImageName = @"card_bg_blue";
    p2pCardModel.accoutBalanceStr = @"";
    NSString *p2pCardName  = [_dataDict objectSafeForKey:@"p2pCardName"];
    p2pCardModel.cardDetialStr = p2pCardName;
    p2pCardModel.cardStateStr = [_dataDict objectSafeForKey:@"p2pCardState"];;
    p2pCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"p2pCardNum"];

    
    UCFAccoutCardModel *honerCardModel  = [[UCFAccoutCardModel alloc]init];
    honerCardModel.cardTitleStr = @"充值至尊享账户";
    honerCardModel.isRechargeOrCash = _isRechargeOrCash;
    honerCardModel.cardLogoImageName = @"card_logo_zx";
    honerCardModel.cardBgImageName = @"card_bg_red";
    honerCardModel.accoutBalanceStr = @"";
    NSString *honerCardName  = [_dataDict objectSafeForKey:@"zxCardName"];
    honerCardModel.cardDetialStr = honerCardName;
    honerCardModel.cardStateStr = [_dataDict objectSafeForKey:@"zxCardState"];
    honerCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"zxCardNum"];

    UCFAccoutCardModel *goldCardModel  = [[UCFAccoutCardModel alloc]init];
    goldCardModel.cardTitleStr = @"充值至黄金账户";
    goldCardModel.isRechargeOrCash = _isRechargeOrCash;
    goldCardModel.cardLogoImageName = @"card_logo_gold";
    goldCardModel.cardBgImageName = @"card_bg_yellow";
    goldCardModel.accoutBalanceStr = @"";
    goldCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"goldCardNum"];
    goldCardModel.cardDetialStr = [_dataDict objectSafeForKey:@"goldCardName"];
    goldCardModel.cardStateStr = [_dataDict objectSafeForKey:@"goldCardState"];;
    
    _p2PAccoutCardView.accoutCardModel = p2pCardModel;
    _honerAccoutCardView.accoutCardModel = honerCardModel;
    _goldAccoutCardView.accoutCardModel = goldCardModel;
    
    NSMutableArray *rechargeAccoutArray = [NSMutableArray new];
    
    if([UserInfoSingle sharedManager].superviseSwitch)//监管开关打开
    {
        
            if (SingleUserInfo.loginData.userInfo.zxIsNew && SingleUserInfo.loginData.userInfo.goldIsNew)
            { // 该情况已处理
           
            }else if(!SingleUserInfo.loginData.userInfo.zxIsNew && SingleUserInfo.loginData.userInfo.goldIsNew)
            {
                [rechargeAccoutArray addObject:_honerAccoutCardView];
                [rechargeAccoutArray addObject:_p2PAccoutCardView];
            }else if(SingleUserInfo.loginData.userInfo.zxIsNew && !SingleUserInfo.loginData.userInfo.goldIsNew)
            {
                [rechargeAccoutArray addObject:_goldAccoutCardView];
                [rechargeAccoutArray addObject:_p2PAccoutCardView];
            }else {
                [rechargeAccoutArray addObject:_goldAccoutCardView];
                [rechargeAccoutArray addObject:_honerAccoutCardView];
                [rechargeAccoutArray addObject:_p2PAccoutCardView];
            }
        
    }
    else{
        [rechargeAccoutArray addObject:_goldAccoutCardView];
        [rechargeAccoutArray addObject:_honerAccoutCardView];
        [rechargeAccoutArray addObject:_p2PAccoutCardView];
    }
    NSUInteger  rechargeAccoutCount =  rechargeAccoutArray.count;
    _titleLabel.frame =  CGRectMake([Common calculateNewSizeBaseMachine:15], ScreenHeight - [Common calculateNewSizeBaseMachine:110] * rechargeAccoutCount - 15 - [Common calculateNewSizeBaseMachine:20], 150,  [Common calculateNewSizeBaseMachine:20]);
     _closeBtn.frame = CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:15] - 30, ScreenHeight - [Common calculateNewSizeBaseMachine:110] * rechargeAccoutCount - 55, 30,55);
    
    
    
//    [self moveView:_goldAccoutCardView moveTime:0.25 moveY:[Common calculateNewSizeBaseMachine:110]];
//    [self moveView:_honerAccoutCardView  moveTime:0.4 moveY:[Common calculateNewSizeBaseMachine:110] *2];
//    [self moveView:_p2PAccoutCardView moveTime:0.6 moveY:[Common calculateNewSizeBaseMachine:110] * 3];
    
    
    //根据充值账户数组，开始动画
    for (UCFRechargeAndCashView * accoutView in  rechargeAccoutArray) {
        NSUInteger  index = [rechargeAccoutArray indexOfObject:accoutView] + 1;
        if (index  == rechargeAccoutCount) {
            accoutView.tag = 1001;
        }
        float animatTime = 0.25;
        if (index == 2) {
            animatTime = 0.45;
        }else if (index == 3){
            animatTime = 0.6;
        }
        [self moveView:accoutView moveTime:animatTime   moveY:[Common calculateNewSizeBaseMachine:110 * index]];
    }
}
//提现数据以及动画
-(void)cashInfoData
{
    
    UCFAccoutCardModel *p2pCardModel  = [[UCFAccoutCardModel alloc]init];
    p2pCardModel.cardTitleStr = @"微金账户余额";
    p2pCardModel.isRechargeOrCash = _isRechargeOrCash;
    p2pCardModel.cardLogoImageName = [_dataDict objectSafeForKey:@"p2pCardLogoUrl"];
    p2pCardModel.cardBgImageName =[_dataDict objectSafeForKey:@"p2pCardBgColor"];
    p2pCardModel.accoutBalanceStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[_dataDict objectSafeForKey:@"p2pBalance"]]];
    if (SingleUserInfo.loginData.userInfo.openStatus == 3)  {
        p2pCardModel.cardDetialStr = @"未设置交易密码";
        p2pCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"p2pCardNum"];;
        p2pCardModel.cardStateStr = @"去设置";
    }else{
        p2pCardModel.cardDetialStr = [_dataDict objectSafeForKey:@"p2pCardName"];
        p2pCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"p2pCardNum"];
        p2pCardModel.cardStateStr = @"";
    }
    
    UCFAccoutCardModel *honerCardModel  = [[UCFAccoutCardModel alloc]init];
    honerCardModel.cardTitleStr = @"尊享账户余额";
    honerCardModel.isRechargeOrCash = _isRechargeOrCash;
    honerCardModel.cardLogoImageName = [_dataDict objectSafeForKey:@"zxCardLogoUrl"];// @"card_logo_zx";
    honerCardModel.cardBgImageName =[_dataDict objectSafeForKey:@"zxCardBgColor"]; // @"card_bg_red";
    honerCardModel.accoutBalanceStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[_dataDict objectSafeForKey:@"zxBalance"]]];
    if ([SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] == 3)  {
        honerCardModel.cardDetialStr = @"未设置交易密码";
        honerCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"zxCardNum"];;
        honerCardModel.cardStateStr = @"去设置";
    }else{
        honerCardModel.cardDetialStr = [_dataDict objectSafeForKey:@"zxCardName"];
        honerCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"zxCardNum"];;
        honerCardModel.cardStateStr = @"";
    }
    
    UCFAccoutCardModel *goldCardModel  = [[UCFAccoutCardModel alloc]init];
    goldCardModel.cardTitleStr = @"黄金账户余额";
    goldCardModel.isRechargeOrCash = _isRechargeOrCash;
    goldCardModel.cardLogoImageName = [_dataDict objectSafeForKey:@"goldCardLogoUrl"]; //@"card_logo_gold";
    goldCardModel.cardBgImageName = [_dataDict objectSafeForKey:@"goldCardBgColor"]; // @"card_bg_yellow";
    goldCardModel.accoutBalanceStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[_dataDict objectSafeForKey:@"goldBalance"]]];
    goldCardModel.cardDetialStr = [_dataDict objectSafeForKey:@"goldCardName"];
    goldCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"goldCardNum"];
    goldCardModel.cardStateStr = @"";

    _p2PAccoutCardView.accoutCardModel = p2pCardModel;
    _honerAccoutCardView.accoutCardModel = honerCardModel;
    _goldAccoutCardView.accoutCardModel = goldCardModel;
    
    /*
     备注:
     有几个已开通账户，展示几个。 注意添加顺序 会影响动画顺序
     黄金账户未授权之前，不展示绑定的银行卡；若三个账户均未开户，点击提现时，吐司提示“没有可提现的账户”；
     已开通账户展示可用余额。
     • 若用户未设置交易密码，样式如下图，在选择提现账户后先跳转至设置交易密码的页面，设置完成后，回到“我的”页面。
     */
    
    NSMutableArray *cashAccoutArray = [NSMutableArray new];
    if(SingleUserInfo.loginData.userInfo.openStatus < 3)//微金未开通账户
    {
        if ([SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] < 3) { //尊享未开通账户
            if (SingleUserInfo.loginData.userInfo.goldAuthorization) {//黄金已开通账户***
                [cashAccoutArray addObject:_goldAccoutCardView];
            }else{//黄金未开通账户
                //                _goldAccoutCardView.accoutCardModel = honerCardModel;//
            }
        }else{//黄金
            if (SingleUserInfo.loginData.userInfo.goldAuthorization) {//黄金已开通账户
                [cashAccoutArray addObject:_goldAccoutCardView];
                [cashAccoutArray addObject:_honerAccoutCardView];
                
            }else{//黄金未开通账户 即只有尊享账户
                [cashAccoutArray addObject:_honerAccoutCardView];
            }
        }
    }
    else {
        if ([SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] < 3) { //尊享未开通账户
            if (SingleUserInfo.loginData.userInfo.goldAuthorization) {//黄金已开通账户***
                [cashAccoutArray addObject:_goldAccoutCardView];
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }else{
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }
        }else{//黄金开通账户
            if (SingleUserInfo.loginData.userInfo.goldAuthorization) {//黄金已开通账户***
                [cashAccoutArray addObject:_goldAccoutCardView];
                [cashAccoutArray addObject:_honerAccoutCardView];
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }else{//黄金未开通账户
                [cashAccoutArray addObject:_honerAccoutCardView];
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }
        }
    }
    if([UserInfoSingle sharedManager].superviseSwitch)//监管开关打开
    {

            if (SingleUserInfo.loginData.userInfo.zxIsNew && SingleUserInfo.loginData.userInfo.goldIsNew)
            { // 该情况已经处理了
                
            }else if( !SingleUserInfo.loginData.userInfo.zxIsNew && SingleUserInfo.loginData.userInfo.goldIsNew)
            {
                [cashAccoutArray removeAllObjects];
                
                [cashAccoutArray addObject:_honerAccoutCardView];
                if (SingleUserInfo.loginData.userInfo.openStatus > 3)//微金开户添加到数组里
                {
                       [cashAccoutArray addObject:_p2PAccoutCardView];
                }
            }else if(SingleUserInfo.loginData.userInfo.zxIsNew && !SingleUserInfo.loginData.userInfo.goldIsNew)
            {
                [cashAccoutArray removeAllObjects];
                [cashAccoutArray addObject:_goldAccoutCardView];
                if (SingleUserInfo.loginData.userInfo.openStatus > 3)//微金开户添加到数组里
                {
                    [cashAccoutArray addObject:_p2PAccoutCardView];
                }
            }else {
                
            }
    }
    else{

    }
    
    NSUInteger cashAccoutCount  = [cashAccoutArray count];
    _titleLabel.text = @"请选择提现账户";
    _totallBalanceLabel = [[UILabel alloc]initWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], ScreenHeight - [Common calculateNewSizeBaseMachine:110] * cashAccoutCount - 15 - [Common calculateNewSizeBaseMachine:16], 200,  [Common calculateNewSizeBaseMachine:16])];
    _totallBalanceLabel.backgroundColor = [UIColor clearColor];
    _totallBalanceLabel.textAlignment = NSTextAlignmentLeft;
    _totallBalanceLabel.text = [NSString stringWithFormat:@"可用总余额¥%@",[UCFToolsMehod AddComma:[_dataDict objectSafeForKey:@"totalBalance"]]];
    _totallBalanceLabel.font = [UIFont systemFontOfSize:13];
    _totallBalanceLabel.textColor = [UIColor whiteColor];
    _totallBalanceLabel.hidden = YES;
    [self.view addSubview:_totallBalanceLabel];
    
   
    _titleLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:15], CGRectGetMidY(_totallBalanceLabel.frame) - 10 - [Common calculateNewSizeBaseMachine:20], 150,  [Common calculateNewSizeBaseMachine:20]);
    _closeBtn.frame = CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:15] - 30, ScreenHeight - [Common calculateNewSizeBaseMachine:110] * cashAccoutCount - 55, 30,55);
    
    //根据已开通的账户，开始动画
   for (UCFRechargeAndCashView * accoutView in  cashAccoutArray) {
        NSUInteger  index = [cashAccoutArray indexOfObject:accoutView] + 1;
       if (index  == cashAccoutCount) {
           accoutView.tag = 1001;
       }
       float animatTime = 0.25;
       if (index == 2) {
           animatTime = 0.45;
       }else if (index == 3){
           animatTime = 0.6;
       }
        [self moveView:accoutView moveTime:animatTime   moveY:[Common calculateNewSizeBaseMachine:110 * index]];
    }
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

        if (view.tag == 1001){
            _closeBtn.hidden = NO;
            _titleLabel.hidden = NO;
            _totallBalanceLabel.hidden = NO;
        }
        _p2PAccoutCardView.userInteractionEnabled = YES;
        _honerAccoutCardView.userInteractionEnabled = YES;
        _goldAccoutCardView.userInteractionEnabled = YES;
    }];
}

-(void)clickRechargeAndCashView:(UCFRechargeAndCashView *)cardView WithTag:(NSInteger)tag WithModel:(UCFAccoutCardModel *)cardModel  
{
   if(cardModel.isRechargeOrCash)//提现
   {
       NSString *cardTitleStr = cardModel.cardTitleStr;
       if ([cardTitleStr hasPrefix:@"微金"])//微金提现
       {
           self.accoutType = SelectAccoutTypeP2P;
           if( [self checkUserCanInvestIsDetail:NO type:self.accoutType]){ //判断是否设置交易密码
//               [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               NSString *userSatues = [NSString stringWithFormat:@"%ld",(long)SingleUserInfo.loginData.userInfo.openStatus];
               NSDictionary *parametersDict =  @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userSatues":userSatues};
               [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:self.accoutType];
           }
       }
       else if ([cardTitleStr hasPrefix:@"尊享"])//尊享提现
       {
           self.accoutType = SelectAccoutTypeHoner;
           if( [self checkUserCanInvestIsDetail:NO type:self.accoutType]){ //判断是否设置交易密码
//               [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               NSString *userSatues = [NSString stringWithFormat:@"%ld",(long)SingleUserInfo.loginData.userInfo.openStatus];
               NSDictionary *parametersDict =  @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userSatues":userSatues};
               [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:self.accoutType];
           }
       }
       else{//黄金提现
           UCFGoldCashMoneyViewController *goldCashMoney = [[UCFGoldCashMoneyViewController alloc] initWithNibName:@"UCFGoldCashMoneyViewController" bundle:nil];
           goldCashMoney.baseTitleText = @"提现";
           goldCashMoney.balanceMoney = [[cardModel.accoutBalanceStr substringFromIndex:1] stringByReplacingOccurrencesOfString:@"," withString:@""];
           goldCashMoney.rootVc = self;
           [self.navigationController pushViewController:goldCashMoney animated:YES];

       }
   }else{
       switch (tag) {
           case 1001://微金充值
           {
               if([cardModel.cardDetialStr  hasSuffix:@"开户"] || [cardModel.cardStateStr hasSuffix:@"开户"]  || [cardModel.cardDetialStr hasSuffix:@"绑卡"] || [cardModel.cardStateStr hasSuffix:@"绑卡"])
               {
                   HSHelper *helper = [HSHelper new];
                   [helper pushOpenHSType:SelectAccoutTypeP2P Step:SingleUserInfo.loginData.userInfo.openStatus nav:self.navigationController isPresentView:YES];
               }
               else
               {
                   
                   UCFNewRechargeViewController *vc = [[UCFNewRechargeViewController alloc] initWithNibName:@"UCFNewRechargeViewController" bundle:nil];
                   vc.uperViewController = self;
                   //            vc.defaultMoney = [NSString stringWithFormat:@"%.2f",needToRechare];
                   vc.accoutType = SelectAccoutTypeP2P;
                   [self.navigationController pushViewController:vc animated:YES];
         
                   
//                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
//                   UCFTopUpViewController * rechargeVC = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
//                   rechargeVC.title = @"充值";
//                   rechargeVC.uperViewController = self;
//                   rechargeVC.accoutType = SelectAccoutTypeP2P;
//                   [self.navigationController pushViewController:rechargeVC animated:YES];
               }
           }
               break;
           case 102://尊享充值
           {
               if([cardModel.cardDetialStr  hasSuffix:@"授权"] || [cardModel.cardStateStr hasSuffix:@"授权"])
               {
                   [[HSHelper new] pushP2POrWJAuthorizationType:SelectAccoutTypeHoner nav:self.navigationController];
               }
               else if([cardModel.cardDetialStr  hasSuffix:@"开户"] || [cardModel.cardStateStr hasSuffix:@"开户"]  || [cardModel.cardDetialStr hasSuffix:@"绑卡"] || [cardModel.cardStateStr hasSuffix:@"绑卡"])
               {
                   HSHelper *helper = [HSHelper new];
                   [helper pushOpenHSType:SelectAccoutTypeHoner Step:[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] nav:self.navigationController isPresentView:YES];
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
               if([cardModel.cardDetialStr  hasSuffix:@"开户"] || [cardModel.cardStateStr hasSuffix:@"开户"]  )//去尊享开户
               {
                   HSHelper *helper = [HSHelper new];
                   [helper pushOpenHSType:SelectAccoutTypeHoner Step:[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] nav:self.navigationController isPresentView:YES];
               }
               else if([cardModel.cardDetialStr  hasSuffix:@"授权"] || [cardModel.cardStateStr hasSuffix:@"授权"])//去黄金授权页面
               {
                   if (SingleUserInfo.loginData.userInfo.openStatus < 3 && [SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] < 3 )
                   {
                      [[HSHelper new] pushP2POrWJAuthorizationType:SelectAccoutTypeHoner nav:self.navigationController];
                   }
                   else{
                       HSHelper *helper = [HSHelper new];
                       [helper pushGoldAuthorizationType:SelectAccoutTypeGold nav:self.navigationController sourceVC:@"UCFRechargeOrCashVC"];
                   }
               }
               else {//去黄金充值页面
                   //去充值页面
                   UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
                   goldRecharge.baseTitleText = @"充值";
                   goldRecharge.rootVc = self;
                   [self.navigationController pushViewController:goldRecharge animated:YES];
               }
           }
           default:
               break;
       }
 
   }
}
#pragma mark - 网络请求结果
-(void)beginPost:(kSXTag)tag{
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


-(void)endPost:(id)result tag:(NSNumber *)tag{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    DDLogDebug(@"UCFP2POrHonerAccoutViewController : %@",dic);
    BOOL ret = [[dic objectSafeForKey:@"ret"] boolValue];
    NSString *rsttext =  [dic objectSafeForKey:@"message"];
    switch (tag.integerValue) {
        case kSXTagCashAdvance://提现请求
        {
            if (ret) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TopUpAndCash" bundle:nil];
                UCFCashViewController *crachViewController  = [storyboard instantiateViewControllerWithIdentifier:@"cash"];
                [ToolSingleTon sharedManager].apptzticket = dic[@"apptzticket"];
                crachViewController.title = @"提现";
                crachViewController.cashInfoDic = dic;
                crachViewController.accoutType = self.accoutType;
                crachViewController.rootVc = self;
                [self.navigationController pushViewController:crachViewController animated:YES];
                return;
            } else {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
            
        }
            break;
    }
}
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail type:(SelectAccoutType)accout;
{
    
    NSString *tipStr1 = accout == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = accout == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;
    
    NSInteger openStatus = accout == SelectAccoutTypeP2P ? SingleUserInfo.loginData.userInfo.openStatus :[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue];
    
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
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:SingleUserInfo.loginData.userInfo.openStatus nav:self.navigationController isPresentView:YES];
        }
    }else if (alertView.tag == 8010) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] nav:self.navigationController isPresentView:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
