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
#import "UCFToolsMehod.h"
#import "ToolSingleTon.h"
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
        p2pCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"p2pCardNum"];
        p2pCardModel.cardStateStr = @"";
    }
    
    UCFAccoutCardModel *honerCardModel  = [[UCFAccoutCardModel alloc]init];
    honerCardModel.cardTitleStr = @"充值至尊享账户";
    honerCardModel.isRechargeOrCash = _isRechargeOrCash;
    honerCardModel.cardLogoImageName = @"card_logo_zx";
    honerCardModel.cardBgImageName = @"card_bg_red";
    honerCardModel.accoutBalanceStr = @"";
    if([UserInfoSingle sharedManager].zxAuthorization){
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
            honerCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"zxCardNum"];;
            honerCardModel.cardStateStr = @"";
        }
 
    }else{
        honerCardModel.cardDetialStr = @"未授权";
        honerCardModel.cardNumberStr = @"";
        honerCardModel.cardStateStr = @"去授权";
    }
    
    UCFAccoutCardModel *goldCardModel  = [[UCFAccoutCardModel alloc]init];
    goldCardModel.cardTitleStr = @"充值至黄金账户";
    goldCardModel.isRechargeOrCash = _isRechargeOrCash;
    goldCardModel.cardLogoImageName = @"card_logo_gold";
    goldCardModel.cardBgImageName = @"card_bg_yellow";
    goldCardModel.accoutBalanceStr = @"";
    if ([UserInfoSingle sharedManager].openStatus < 3 &&  [UserInfoSingle sharedManager].enjoyOpenStatus < 3) {
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
            goldCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"goldCardNum"];
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
//提现数据以及动画
-(void)cashInfoData
{
    
    UCFAccoutCardModel *p2pCardModel  = [[UCFAccoutCardModel alloc]init];
    p2pCardModel.cardTitleStr = @"微金账户余额";
    p2pCardModel.isRechargeOrCash = _isRechargeOrCash;
    p2pCardModel.cardLogoImageName = [_dataDict objectSafeForKey:@"p2pCardLogoUrl"];
    p2pCardModel.cardBgImageName =[_dataDict objectSafeForKey:@"p2pCardBgColor"];
    p2pCardModel.accoutBalanceStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[_dataDict objectSafeForKey:@"p2pBalance"]]];
    if ([UserInfoSingle sharedManager].openStatus == 3)  {
        p2pCardModel.cardDetialStr = @"未设置交易密码";
        p2pCardModel.cardNumberStr = @"";
        p2pCardModel.cardStateStr = @"去设置";
    }else{
        p2pCardModel.cardDetialStr = [_dataDict objectSafeForKey:@"p2pCardName"];
        p2pCardModel.cardNumberStr = [_dataDict objectSafeForKey:@"p2pCardNum"];
        p2pCardModel.cardStateStr = @"";
    }
    
    UCFAccoutCardModel *honerCardModel  = [[UCFAccoutCardModel alloc]init];
    honerCardModel.cardTitleStr = @"尊享账户余额";
    honerCardModel.isRechargeOrCash = _isRechargeOrCash;
    honerCardModel.cardLogoImageName = [_dataDict objectSafeForKey:@"honerCardLogoUrl"];// @"card_logo_zx";
    honerCardModel.cardBgImageName =[_dataDict objectSafeForKey:@"p2pCardBgColor"]; // @"card_bg_red";
    honerCardModel.accoutBalanceStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[_dataDict objectSafeForKey:@"zxBalance"]]];
    if ([UserInfoSingle sharedManager].enjoyOpenStatus == 3)  {
        honerCardModel.cardDetialStr = @"未设置交易密码";
        honerCardModel.cardNumberStr = @"";
        honerCardModel.cardStateStr = @"去设置";
    }else{
        honerCardModel.cardDetialStr = [_dataDict objectSafeForKey:@"p2pCardName"];
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
    if([UserInfoSingle sharedManager].openStatus < 3)//微金未开通账户
    {
        if ([UserInfoSingle sharedManager].enjoyOpenStatus < 3) { //尊享未开通账户
            if ([UserInfoSingle sharedManager].goldAuthorization) {//黄金已开通账户***
                [cashAccoutArray addObject:_goldAccoutCardView];
            }else{//黄金未开通账户
                //                _goldAccoutCardView.accoutCardModel = honerCardModel;//
            }
        }else{//黄金
            if ([UserInfoSingle sharedManager].goldAuthorization) {//黄金已开通账户
                [cashAccoutArray addObject:_goldAccoutCardView];
                [cashAccoutArray addObject:_honerAccoutCardView];
                
            }else{//黄金未开通账户 即只有尊享账户
                [cashAccoutArray addObject:_honerAccoutCardView];
            }
        }
    }
    else {
        if ([UserInfoSingle sharedManager].enjoyOpenStatus < 3) { //尊享未开通账户
            if ([UserInfoSingle sharedManager].goldAuthorization) {//黄金已开通账户***
                [cashAccoutArray addObject:_goldAccoutCardView];
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }else{
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }
        }else{//黄金开通账户
            if ([UserInfoSingle sharedManager].goldAuthorization) {//黄金已开通账户***
                [cashAccoutArray addObject:_goldAccoutCardView];
                [cashAccoutArray addObject:_honerAccoutCardView];
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }else{//黄金未开通账户
                [cashAccoutArray addObject:_honerAccoutCardView];
                [cashAccoutArray addObject:_p2PAccoutCardView];
            }
        }
    }

    NSUInteger cashAccoutCount  = [cashAccoutArray count];
    _titleLabel.text = @"请选择提现账户";
    _totallBalanceLabel = [[UILabel alloc]initWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], ScreenHeight - [Common calculateNewSizeBaseMachine:110] * cashAccoutCount - 15 - [Common calculateNewSizeBaseMachine:16], 200,  [Common calculateNewSizeBaseMachine:16])];
    _totallBalanceLabel.backgroundColor = [UIColor clearColor];
    _totallBalanceLabel.textAlignment = NSTextAlignmentLeft;
    _totallBalanceLabel.text = [NSString stringWithFormat:@"可用总余额¥%@",[UCFToolsMehod AddComma:[_dataDict objectSafeForKey:@"goldBalance"]]];
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
               NSString *userSatues = [NSString stringWithFormat:@"%ld",(long)[UserInfoSingle sharedManager].openStatus];
               NSDictionary *parametersDict =  @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userSatues":userSatues};
               [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:self.accoutType];
           }
       }
       else if ([cardTitleStr hasPrefix:@"尊享"])//尊享提现
       {
           self.accoutType = SelectAccoutTypeHoner;
           if( [self checkUserCanInvestIsDetail:NO type:self.accoutType]){ //判断是否设置交易密码
//               [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               NSString *userSatues = [NSString stringWithFormat:@"%ld",(long)[UserInfoSingle sharedManager].openStatus];
               NSDictionary *parametersDict =  @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userSatues":userSatues};
               [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:self.accoutType];
           }
       }else{//黄金提现
           
           UCFGoldCashViewController *vc1 = [[UCFGoldCashViewController alloc] initWithNibName:@"UCFGoldCashViewController" bundle:nil];
           vc1.baseTitleText = @"黄金变现";
           vc1.rootVc = self;
           [self.navigationController pushViewController:vc1 animated:YES];
       }
   }else{
       switch (tag) {
           case 1001://微金充值
           {
               if([cardModel.cardStateStr isEqualToString:@"去开户"] || [cardModel.cardStateStr isEqualToString:@"去绑卡"])
               {
                   HSHelper *helper = [HSHelper new];
                   [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController isPresentView:YES];
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
               if([cardModel.cardStateStr isEqualToString:@"去授权"])
               {
                   [[HSHelper new] pushP2POrWJAuthorizationType:SelectAccoutTypeHoner nav:self.navigationController];
               }
               else if([cardModel.cardStateStr isEqualToString:@"去开户"] || [cardModel.cardStateStr isEqualToString:@"去绑卡"])
               {
                   HSHelper *helper = [HSHelper new];
                   [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController isPresentView:YES];
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
                   [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController isPresentView:YES];
               }
               else if([cardModel.cardStateStr isEqualToString:@"去授权"])//去黄金授权页面
               {
                   HSHelper *helper = [HSHelper new];
                   [helper pushGoldAuthorizationType:SelectAccoutTypeGold nav:self.navigationController sourceVC:@"UCFRechargeOrCashVC"];
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
    DBLOG(@"UCFP2POrHonerAccoutViewController : %@",dic);
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
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController isPresentView:YES];
        }
    }else if (alertView.tag == 8010) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController isPresentView:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
