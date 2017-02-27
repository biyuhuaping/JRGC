//
//  UCFCollctionKeyBidViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//
//  投标页面

#import "UCFCollctionKeyBidViewController.h"
#import "InvestmentItemInfo.h"
#import "InvestmentCell.h"
#import "MoneyBoardCell.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "UCFInvestmentView.h"
#import "FullWebViewController.h"
#import "UCFCompleteBidViewCtrl.h"//投标成功页
#import "UCFTopUpViewController.h"
#import "CalculatorView.h"
#import "AppDelegate.h"
#import "SubInvestmentCell.h"
#import "ToolSingleTon.h"
#import "UCFSelectPayBackController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UCFPurchaseWebView.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFBatchBidWebViewController.h"
@interface UCFCollctionKeyBidViewController ()<UITableViewDataSource,UITableViewDelegate,MoneyBoardCellDelegate>
{
    BOOL    isFirstInvest;              //是否第一次投资
    BOOL    isHasOverdueGongDou;
    BOOL    isShowYouHui;
    BOOL    isGongDouSwitch;
    
    double  needToRechare;
    BOOL    haveYouHuiNotUse;
    CGFloat orginalHeight;
    BOOL    gongChangTextField;
    //    BOOL    isSucessInvest;             //是否投资成功
    BOOL    isHaveCashNum;              //是否有返现券
    BOOL    isHaveCouponNum;            //是否有反息券
    BOOL    isCompanyAgent;             //是否是机构用户
    NSString *_contractTitle;
    BOOL  _isP2P;//是否P2p标，yes 为是 NO 为尊享
    
}
@property (strong, nonatomic)NSMutableArray             *intelligenceArray;
@property (strong, nonatomic)  UITableView        *bidTableView;
@property (strong, nonatomic)UITextField                *gCCodeTextField;
@property (strong, nonatomic)UITextField                *commendNameTextField;
@property (strong, nonatomic)UITextField                *teleTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewSpace;
@property (copy, nonatomic) NSString                    *apptzticket;
@property (strong, nonatomic) NSMutableDictionary       *cashDict;                  //从优惠券页面选择过来的选中数据
@property (strong, nonatomic) NSMutableDictionary       *coupDict;                  //从优惠券页面选择过来的选中数据
@property (copy, nonatomic) NSString                    *tmpTextFieldTextValue;     //选中
@end

@implementation UCFCollctionKeyBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.intelligenceArray = [NSMutableArray arrayWithCapacity:1];
    [self addLeftButton];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadMainView) name:@"UPDATEINVESTDATA" object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self makeMainView];
    self.apptzticket = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"apptzticket"]];
    self.view.backgroundColor = [UIColor colorWithRed:228/255.0 green:229/255.0 blue:234/255.0 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    self.tabViewSpace.constant += 0.5;
    
    //    [self.bidTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(reloadMainView)];
    
    self.navigationController.fd_prefersNavigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    if (isSucessInvest) {
    //        [self.navigationController popToRootViewControllerAnimated:NO];
    //    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - 监听键盘
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}

#pragma mark - inputBarDelegate
-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)time
{
    if (height == 0)
    {
        _bidTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - 58);
    }
    else
    {
        CGRect viewFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - 58);
        viewFrame.size.height -= height;
        viewFrame.size.height += 58;
        if (viewFrame.size.height != _bidTableView.frame.size.height) {
            _bidTableView.frame = viewFrame;
        }
    }
}
#warning 过期工豆
- (BOOL)checkOverdueGongDou
{ ///
    NSString *beancount = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"beancount"]]];
    if (beancount.length == 0 ||[beancount isEqualToString:@"0"]) {
        return NO;
    } else {
        return YES;
    }
    return NO;
}
- (void)makeMainView
{
    // 初始化优惠券数据
    //    youhuiDict = [NSMutableDictionary dictionaryWithCapacity:1];
    //    [youhuiDict setValue: @"请手动勾选优惠券" forKey:@"youHuiShow"];
    //    [youhuiDict setValue:@"0" forKey:@"couponSum"];
    //    [youhuiDict setValue:@"0" forKey:@"couponPrdaimSum"];
    //    [youhuiDict setValue:@"0" forKey:@"couponCount"];
    //    [youhuiDict setValue:@"" forKey:@"showMessage"];
    //    self.beanIds = @"";
    //判断是否第一次投资
    isFirstInvest = [self checkIsFirstInvest];
    isHasOverdueGongDou = [self checkOverdueGongDou];
    
//    NSString *cashNum = [_dataDict objectForKey:@"cashNum"];
//    NSString *couponNum = [_dataDict objectForKey:@"couponNum"];
    //是否有返现券
    isHaveCashNum = NO;    //是否有返息券
    isHaveCouponNum =  NO;
    isCompanyAgent = NO;// [[_dataDict objectForKey:@"isCompanyAgent"] boolValue];
    
    
    InvestmentItemInfo * info1 = [[InvestmentItemInfo alloc] initWithDictionary:[_dataDict objectForKey:@"data"]];
    self.bidArray = [NSMutableArray array];
    [self.bidArray addObject:info1];
    
    if (self.bidType == 0) {
        _isP2P = YES;
        baseTitleLabel.text = @"投标";
    }
    
    double gondDouBalance = [[_dataDict objectForKey:@"beanAmount"] doubleValue];
    if ((int)gondDouBalance > 0) {
        isGongDouSwitch = YES;
    }
    if (isCompanyAgent) {
        isHaveCashNum = NO;
        isHaveCouponNum = NO;
        isGongDouSwitch = NO;
        isHasOverdueGongDou = NO;
    }
    
    _bidTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-67) style:UITableViewStylePlain];
    
    _bidTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bidTableView.delegate = self;
    _bidTableView.dataSource = self;
    _bidTableView.backgroundColor = [UIColor clearColor];
    _bidTableView.userInteractionEnabled = YES;
    if ([_bidTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_bidTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_bidTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_bidTableView setLayoutMargins: UIEdgeInsetsZero];
    }
    _bidTableView.tableFooterView =[self createFootView];
    [self.view addSubview:_bidTableView];
    [_bidTableView reloadData];
    [self cretateInvestmentView];
    UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
    [_bidTableView addGestureRecognizer:frade];
    orginalHeight = _bidTableView.contentSize.height;
    _bidTableView.backgroundColor = UIColorWithRGB(0xebebee);
    
}
- (void)fadeKeyboard
{
    [self.view endEditing:YES];
}
- (void)cretateInvestmentView
{
    UIView *preView = (UIView *)[self.view viewWithTag:9000];
    if (preView) {
        [preView removeFromSuperview];
    }
    
    UIView *investBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight -NavigationBarHeight - 67, ScreenWidth, 67)];
    investBaseView.backgroundColor = [UIColor clearColor];
    investBaseView.tag = 9000;
    [self.view addSubview:investBaseView];
    
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 57)];
    bkView.backgroundColor = [UIColor whiteColor];
    [investBaseView addSubview:bkView];
    
    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.frame = CGRectMake(XPOS, 20,ScreenWidth - XPOS*2, 37);
    investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
    investmentButton.layer.cornerRadius = 2.0;
    investmentButton.layer.masksToBounds = YES;
    
    NSString *buttonTitle =  @"批量投资";
    [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
    [investmentButton addTarget:self action:@selector(checkIsCanInvest) forControlEvents:UIControlEventTouchUpInside];
    [investBaseView addSubview:investmentButton];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 10)];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    [investBaseView addSubview:shadowView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 1000) {
            MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell.inputMoneyTextFieldLable becomeFirstResponder];
        } else if (alertView.tag == 2000) {
            
        } else if (alertView.tag == 10023) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if (alertView.tag == 6000) {
            [_gCCodeTextField becomeFirstResponder];
        }
    } else if (buttonIndex == 1) {
        if (alertView.tag == 3000) {
            [self getNormalBidNetData];
        }
        if (alertView.tag == 2000) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
            UCFTopUpViewController *topUpView  = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
            topUpView.defaultMoney = [NSString stringWithFormat:@"%.2f",needToRechare];
            topUpView.title = @"充值";
            //topUpView.isGoBackShowNavBar = YES;
            topUpView.uperViewController = self;
            [self.navigationController pushViewController:topUpView animated:YES];
        }
        if (alertView.tag == 4000) {
            MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            int compare = [Common stringA:[NSString stringWithFormat:@"%.2f",[cell.inputMoneyTextFieldLable.text doubleValue]] ComparedStringB:@"1000.00"];
            if (compare == 1 || compare == 0 ) {
                [self showLastAlert:cell.inputMoneyTextFieldLable.text];
            } else {
                [self getNormalBidNetData];
            }
        }
        if (alertView.tag == 5001) {//开通批量投资限额页面
            UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
            batchInvestment.isStep = 1 ;
            [self.navigationController pushViewController:batchInvestment animated:YES];
        }
    }
}
- (void)checkIsCanInvest
{
    MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *investMoney = cell.inputMoneyTextFieldLable.text;
    if ([Common isPureNumandCharacters:investMoney]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return;
    }
    investMoney = [NSString stringWithFormat:@"%.2f",[investMoney doubleValue]];
    if ([Common stringA:@"0.01" ComparedStringB:investMoney] == 1) {
        [MBProgressHUD displayHudError:@"请输入投资金额"];
        return;
    }
    
    BOOL isOpenBatchStr = [[_dataDict objectSafeForKey:@"isOpenBatch"] boolValue];
    if(!isOpenBatchStr){ //是否开启一键投标
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未开启批量投资，暂不能投资" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
        alertView.tag = 5001;
        [alertView show];
        return;
    }
    
    
    
    
    //2.判断是否小于最少投资额
    
    NSDictionary *colPrdClaimDetailDict = [_dataDict objectSafeDictionaryForKey:@"colPrdClaimDetail"];
    NSString *canBuyAmtStr =[NSString stringWithFormat:@"%@",[colPrdClaimDetailDict objectSafeForKey:@"canBuyAmt"]];
    
    
    NSString *keTouJinE = [NSString stringWithFormat:@"%.2f",[canBuyAmtStr doubleValue]];
    
    NSString *colMinInvestStr =[NSString stringWithFormat:@"%@",[colPrdClaimDetailDict objectSafeForKey:@"colMinInvest"]];
    NSString *minInVestNum = [NSString stringWithFormat:@"%.2f",[colMinInvestStr doubleValue]];
    
    
    if([Common stringA:minInVestNum ComparedStringB:investMoney] == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投资金额不可低于起投金额" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }

    NSString *maxIn =[NSString stringWithFormat:@"%@",[colPrdClaimDetailDict objectSafeForKey:@"batchAmount"]];
 
    if (maxIn.length != 0) {
        if ([Common stringA:investMoney ComparedStringB:maxIn] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该项目限投¥%@",maxIn] delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
            alert.tag = 1000;
            [alert show];
            return;
        }
    }
    if([Common stringA:investMoney ComparedStringB:keTouJinE] == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不可以这么任性哟，投资金额已超过剩余可投金额了" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    
    if ([keTouJinE doubleValue] - [investMoney doubleValue] < [minInVestNum doubleValue] && [Common stringA:keTouJinE ComparedStringB:investMoney] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标剩余的金额已不足起投额，不差这一点了亲，全投了吧！" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    //可用金额
    double availableBala= [[_dataDict objectForKey:@"availableBalance"]  doubleValue];
    //可用工豆
    double gondDouBalance = [[_dataDict objectForKey:@"beanAmount"] doubleValue]/100.0f;
    
    NSString *availableBalance = nil;
    if (cell.gongDouSwitch.on) {
        availableBalance = [NSString stringWithFormat:@"%.2f",availableBala + gondDouBalance];
    } else {
        availableBalance = [NSString stringWithFormat:@"%.2f",availableBala];
    }
    
    if([Common stringA:investMoney ComparedStringB:availableBalance] == 1)
    {
        NSString *keyongMoney = availableBalance;
        needToRechare = [investMoney doubleValue] - [keyongMoney doubleValue];
        NSString *showStr = [NSString stringWithFormat:@"总计投资金额¥%@\n可用金额%@\n另需充值金额¥%.2f",cell.inputMoneyTextFieldLable.text,cell.KeYongMoneyLabel.text,needToRechare];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可用金额不足" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
        alert.tag = 2000;
        [alert show];
        return;
    }

    
    int compare = [Common stringA:investMoney ComparedStringB:@"1000.00"];
    if (compare == 1 || compare == 0 ) {
        [self showLastAlert:investMoney];
    } else {
        [self getNormalBidNetData];
    }
}

//投资超过1000最后的提醒框
- (void)showLastAlert:(NSString *)investMoney
{
    NSString *showStr = @"";
    showStr = [NSString stringWithFormat:@"投资金额¥%@,确认投资吗?",[UCFToolsMehod AddComma:investMoney]];
    
    NSString *buttonTitle = @"批量投资";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:buttonTitle, nil];
    alert.tag = 3000;
    [alert show];
}
- (void)checkGongchangCode:(NSString *)string
{
    NSString *parStr = [NSString stringWithFormat:@"pomoCode=%@",string];
    [[NetworkModule sharedNetworkModule] postReq:parStr tag:kSXTagCheckPomoCode owner:self];
}
- (void)getNormalBidNetData
{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (isFirstInvest) {
        if ([[Common deleteStrHeadAndTailSpace:_gCCodeTextField.text] length] > 0) {
            [self checkGongchangCode:[Common deleteStrHeadAndTailSpace:_gCCodeTextField.text]];
        } else {
            [self sendBuyDataToService];
        }
    } else {
        [self sendBuyDataToService];
    }
}
-(NSString *)useCoupGetBeans{
    
    return @"";
}
#warning 添加网络请求
- (void)sendBuyDataToService
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *prdClaimsId = [NSString stringWithFormat:@"%@",[[_dataDict objectForKey:@"colPrdClaimDetail"] objectForKey:@"id"]] ;
    MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *investAmt = [UCFToolsMehod isNullOrNilWithString:cell.inputMoneyTextFieldLable.text];

    
    [paramDict setValue:userID forKey:@"userId"];
    [paramDict setValue:prdClaimsId forKey:@"tenderId"];
    [paramDict setValue:investAmt forKey:@"investAmount"];
    
    
    if (isGongDouSwitch) {
        double gondDouBalance = [[[_dataDict objectForKey:@"beanUser"] objectForKey:@"availableBalance"] doubleValue];
        [paramDict setValue:[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:gondDouBalance]] forKey:@"investBeans"];
    }
    
    if (isFirstInvest) {
        NSString *recommendCode = [UCFToolsMehod isNullOrNilWithString:_gCCodeTextField.text];
        [paramDict setValue:recommendCode forKey:@"recomendFactoryCode"];
        
    } else {
        NSString *recommendCode = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:[[self.dataDict objectForKey:@"adviserUser"] objectForKey:@"promotioncode"]]];
        [paramDict setValue:recommendCode forKey:@"recomendFactoryCode"];
    }
    
    if (self.coupDict && self.cashDict) {
        //返现券反息券共用
        NSString *beanIds0 = [self.coupDict valueForKey:@"idStr"];//返息
        NSString *beanIds1 = [self.cashDict valueForKey:@"idStr"]; //返现
        [paramDict setValue:beanIds1 forKey:@"cashBackIds"];
        [paramDict setValue:beanIds0 forKey:@"couponId"];
    } else if (self.coupDict) {
        //使用返息券
        NSString *beanIds = [self.coupDict valueForKey:@"idStr"];
        [paramDict setValue:beanIds forKey:@"couponId"];
    } else if (self.cashDict) {
        //使用返现券
        NSString *beanIds = [self.cashDict valueForKey:@"idStr"];
        [paramDict setValue:beanIds forKey:@"cashBackIds"];
    }
    NSString *apptzticket =  [self.dataDict objectSafeForKey:@"apptzticket"];
    [paramDict setValue:apptzticket forKey:@"investClaimsTicket"];
    [[NetworkModule sharedNetworkModule] newPostReq:paramDict tag:kSXTagColBatchInvestUrl owner:self signature:YES];
}

-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    //    if (self.bidTableView.header.isRefreshing) {
    //        [self.bidTableView.header endRefreshing];
    //    }
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    if (tag.intValue == kSXTagPrdClaimsSaveDeals) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([rstcode intValue] == 1) {
            //跳转投标成功页
            DBLOG(@"投标成功页的数据字典:%@",dic);
            UCFCompleteBidViewCtrl *compl = [[UCFCompleteBidViewCtrl alloc]initWithNibName:@"UCFCompleteBidViewCtrl" bundle:nil];
            compl.dataDict = [NSMutableDictionary dictionaryWithDictionary:dic];
            compl.superView = self;
            [self.navigationController pushViewController:compl animated:YES];
            //            isSucessInvest = YES;
            
        } else {
            if ([rstcode intValue] == 15) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
                alert.tag = 10023;
                [alert show];
            } else {
                [self reloadMainView];
                [AuxiliaryFunc showAlertViewWithMessage:dic[@"statusdes"]];
            }
        }
    } else if (tag.intValue == kSXTagPrdClaimsDealBid){
        if ([[dic valueForKey:@"status"] integerValue] == 1) {
            self.dataDict = dic;
            self.apptzticket = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"apptzticket"]];
            
            InvestmentItemInfo * info1 = [[InvestmentItemInfo alloc] initWithDictionary:[_dataDict objectForKey:@"data"]];
            self.bidArray = [NSMutableArray array];
            [self.bidArray addObject:info1];
            [_bidTableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
            alert.tag = 10023;
            [alert show];
        }
        
    } else if (tag.intValue == kSXTagCheckPomoCode) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"status"] isEqualToString:@"1"]) {
            [self sendBuyDataToService];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"  message:@"工场码不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
            alert.tag = 6000;
            [alert show];
        }
    }else if (tag.intValue == kSXTagColBatchInvestUrl){
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        if([rstcode intValue] == 1)
        {
            NSDictionary *dataDict  = [dic objectSafeDictionaryForKey:@"data"];
            
            NSString *applyAmount = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"applyAmount"]];
            
            NSString *investAmount = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"investAmount"]];
            NSArray *orderIds = [dataDict objectSafeArrayForKey:@"orderIds"];
            
            NSMutableString *orderIdsArryStr = [[NSMutableString alloc] initWithCapacity:0];
            [orderIdsArryStr setString:@"["];
            for ( int i = 0 ;i < orderIds.count;i++) {
                NSString *orderIdStr =  [NSString stringWithFormat:@"%@",orderIds[i]];
                if (i == 0) {
                    [orderIdsArryStr appendFormat:@"%@",orderIdStr];
                }else{
                    [orderIdsArryStr appendFormat:@",%@",orderIdStr];
                }
            }
            [orderIdsArryStr appendString:@"]"];
            
            NSDictionary *reqDict =  @{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"applyAmount":applyAmount,@"investAmount":investAmount,@"orderIds":orderIdsArryStr};
            
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",SERVER_IP,BATCHINVESTSTATUS];
            UCFBatchBidWebViewController *webView = [[UCFBatchBidWebViewController alloc]initWithNibName:@"UCFBatchBidWebViewController" bundle:nil];
//            UCFPurchaseWebView *webView = [[UCFPurchaseWebView alloc]initWithNibName:@"UCFPurchaseWebView" bundle:nil];
            webView.url =  urlStr;
            webView.webDataDic = reqDict;
            webView.navTitle = @"即将跳转";
//            webView.rootVc = @"collctionKeyBidVC";
            [self.navigationController pushViewController:webView animated:YES];
            NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            [navVCArray removeObjectAtIndex:navVCArray.count-2];
            [self.navigationController setViewControllers:navVCArray animated:NO];
        }
        else{
//            [self reloadMainView];
            [AuxiliaryFunc showAlertViewWithMessage:[dic objectSafeForKey:@"message"]];
        }
        
    }else if(tag.intValue == kSXTagGetContractMsg) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSDictionary *dictionary =  [dic objectSafeDictionaryForKey:@"contractMess"];
        NSString *status = [dic objectSafeForKey:@"status"];
        if ([status intValue] == 1) {
            NSString *contractMessStr = [dictionary objectSafeForKey:@"contractMess"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:contractMessStr title:_contractTitle];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            //            [self showHTAlertdidFinishGetUMSocialDataResponse];
        }
    }
    //    if (self.bidTableView.header.isRefreshing) {
    //        [self.bidTableView.header endRefreshing];
    //    }
}

#pragma mark - tableViewMethod
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        view.backgroundColor = UIColorWithRGBA(93, 106, 145, 1);
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isFirstInvest) {
        return 3;
    } else {
        return 2;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 109.0f;
        } else if (indexPath.row == 1) {
            if (isCompanyAgent) { //机构用户需要把工豆隐藏
                return 202 - 44.0f;
            } else {
                return 202.0f;
            }
        } else if (indexPath.row == 2) {
            return 30;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 47;
        } else if (indexPath.row == 1) {
            if (!isHaveCashNum) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.row == 2) {
            if (!isHaveCouponNum) {
                return 0;
            } else {
                return 44;
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 47;
        } else {
            return 67;
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (isHasOverdueGongDou) {
            return 3;
        }
        return 2;
    } else if (section == 1) {
        //返现券和返息券任意一张张数不为0 返回三个cell 通过高度去控制显示不显示
        if(isHaveCouponNum || isHaveCashNum) {
            return 3;
        } else {
            return 0;
        }
    } else if (section == 2) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellStr1 = @"cell1";
        SubInvestmentCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr1];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SubInvestmentCell" owner:self options:nil][0];
        }
        [cell setCollectionKeyBidInvestItemInfo:[_dataDict objectSafeDictionaryForKey:@"colPrdClaimDetail"]];
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        static NSString *cellStr2 = @"cell2";
        MoneyBoardCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr2];
        if (cell == nil) {
            cell = [[MoneyBoardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            double gondDouBalance = [[_dataDict objectForKey:@"beanAmount"] doubleValue];
            if (gondDouBalance > 0.0f) {
                cell.gongDouSwitch.on = YES;
            } else {
                cell.gongDouSwitch.userInteractionEnabled = NO;
            }
            cell.isCollctionkeyBid = YES;
            cell.inputMoneyTextFieldLable.text = [self GetDefaultText];
            
        }
        cell.isCompanyAgent = isCompanyAgent;
        if (isGongDouSwitch) {
            cell.gongDouAccout.textColor = UIColorWithRGB(0x333333);
            cell.gongDouCountLabel.textColor = UIColorWithRGB(0x333333);
            
        } else {
            cell.gongDouAccout.textColor = UIColorWithRGB(0x999999);
            cell.gongDouCountLabel.textColor = UIColorWithRGB(0x999999);
        }
       
        cell.dataDict = _dataDict;
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        static NSString *cellStr = @"tipCell";
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.backgroundColor = UIColorWithRGBA(92, 106, 145, 1);
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        NSString *beancount = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"beancount"]];
        NSString *showStr = [NSString stringWithFormat:@"价值¥%.2f工豆即将过期，请尽快使用",[beancount doubleValue]/100.0f];
        cell.textLabel.text = showStr;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *cellStr3 = @"cell3";
        UITableViewCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr3];
            cell.backgroundColor = UIColorWithRGB(0xf9f9f9);
            [self drawDetailView:cell];
        }
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        static NSString *cellStr4 = @"cell4";
        UITableViewCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr4];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr4];
            CGFloat offX = 0.0f;
            if (isHaveCouponNum) {
                offX = 15.0f;
            }
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(offX, 44, ScreenWidth, 0.5)];
            lineView1.backgroundColor = UIColorWithRGB(0xe3e5ea);
            [cell addSubview:lineView1];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, ScreenWidth, 44);
            button.backgroundColor = [UIColor clearColor];
            button.tag = 400;
            [button addTarget:self action:@selector(pushSelectYouHuiQuan:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            cell.textLabel.textColor = UIColorWithRGB(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
            arrowImageView.frame = CGRectMake(ScreenWidth - 8 - 20,(44 - 13)/2, 8, 13);
            [cell addSubview:arrowImageView];
            
            UILabel *availableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(arrowImageView.frame) - 5, 44)];
            availableLabel.textColor = UIColorWithRGB(0x555555);
            availableLabel.font = [UIFont systemFontOfSize:16.0f];
            availableLabel.text = @"0张可用";
            availableLabel.tag = 1001;
            availableLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:availableLabel];
        }
        UILabel *availableLabel = (UILabel *)[cell viewWithTag:1001];
        //没有返现券的时候内容清空
        if (isHaveCashNum) {
            cell.textLabel.text = @"返现券";
            availableLabel.hidden = NO;
        } else {
            cell.textLabel.text = @"";
            availableLabel.hidden = YES;
        }
        if (self.cashDict) {
            //返现多少
            NSString *couponSum = [self.cashDict valueForKey:@"youhuiMoney"];
            //需要投资多少反上述现金
            NSString *couponPrdaimSum = [self.cashDict valueForKey:@"manzuMoney"];
            NSString *total1 = [NSString stringWithFormat:@"返现¥%@,满¥%@可用",[UCFToolsMehod AddComma:couponSum],[UCFToolsMehod AddComma:couponPrdaimSum]];
            NSRange range1 = [total1 rangeOfString:[NSString stringWithFormat:@"返现¥%@",[UCFToolsMehod AddComma:couponSum]]];
            range1.location += 2;
            range1.length -= 2;
            NSRange range2 = [total1 rangeOfString:[NSString stringWithFormat:@"满¥%@",[UCFToolsMehod AddComma:couponPrdaimSum]]];
            range2.location += 1;
            range2.length -= 1;
            NSValue *value1 = [NSValue valueWithBytes:&range1 objCType:@encode(NSRange)];
            NSValue *value2 = [NSValue valueWithBytes:&range2 objCType:@encode(NSRange)];
            NSDictionary *attributeDict0 = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont boldSystemFontOfSize:12.0],NSFontAttributeName,
                                            UIColorWithRGB(0x333333),NSForegroundColorAttributeName,nil];
            
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:UIColorWithRGB(0xf03b43),NSForegroundColorAttributeName,nil];
            
            availableLabel.attributedText = [Common twoSectionOfLabelShowDifferentAttribute:[NSArray arrayWithObjects:attributeDict,attributeDict0, nil] WithTextLocations:[NSArray arrayWithObjects:value1,value2, nil] WithTotalString:total1];
            availableLabel.font = [UIFont systemFontOfSize:12.0f];
        } else {
            NSString *cashNum = [_dataDict objectForKey:@"cashNum"];
            NSString *total1 = [NSString stringWithFormat:@"%@张可用",cashNum];
            availableLabel.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xf03b43) WithSectionText:cashNum WithTotalString:total1];
            availableLabel.font = [UIFont systemFontOfSize:16.0f];
        }
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        static NSString *cellStr4 = @"cell5";
        UITableViewCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr4];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr4];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, ScreenWidth, 44);
            button.backgroundColor = [UIColor clearColor];
            button.tag = 401;
            [button addTarget:self action:@selector(pushSelectYouHuiQuan:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            cell.textLabel.textColor = UIColorWithRGB(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            //cell.backgroundColor = UIColorWithRGB(0xffe8b7);
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
            arrowImageView.frame = CGRectMake(ScreenWidth - 8 - 20,(44 - 13)/2, 8, 13);
            [cell addSubview:arrowImageView];
            
            UILabel *availableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(arrowImageView.frame) - 5, 44)];
            availableLabel.textColor = UIColorWithRGB(0x555555);
            availableLabel.font = [UIFont systemFontOfSize:16.0f];
            availableLabel.text = @"0张可用";
            availableLabel.tag = 1001;
            availableLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:availableLabel];
        }
        UILabel *availableLabel = (UILabel *)[cell viewWithTag:1001];
        //返息券可用数量
        if (isHaveCouponNum) {
            cell.textLabel.text = @"返息券";
            availableLabel.hidden = NO;
        } else {
            cell.textLabel.text = @"";
            availableLabel.hidden = YES;
        }
        if (self.coupDict) {
            NSString *couponSum = [self useCoupGetBeans];
            //需要投资多少反上述现金
            NSString *couponPrdaimSum = [self.coupDict valueForKey:@"manzuMoney"];
            NSString *total1 = [NSString stringWithFormat:@"返息¥%@工豆,满¥%@可用",[UCFToolsMehod AddComma:couponSum],[UCFToolsMehod AddComma:couponPrdaimSum]];
            NSString *backRate = [NSString stringWithFormat:@"返息¥%@",[UCFToolsMehod AddComma:couponSum]];
            NSRange range1 = [total1 rangeOfString:backRate];
            range1.location += 2;
            range1.length -= 2;
            NSString *tmpStr2 = [NSString stringWithFormat:@"满¥%@",[UCFToolsMehod AddComma:couponPrdaimSum]];
            NSRange range2 = [total1 rangeOfString:tmpStr2];
            range2.location += 1;
            range2.length -= 1;
            NSValue *value1 = [NSValue valueWithBytes:&range1 objCType:@encode(NSRange)];
            NSValue *value2 = [NSValue valueWithBytes:&range2 objCType:@encode(NSRange)];
            NSDictionary *attributeDict0 = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont boldSystemFontOfSize:12.0],NSFontAttributeName,
                                            UIColorWithRGB(0x333333),NSForegroundColorAttributeName,nil];
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:UIColorWithRGB(0xf03b43),NSForegroundColorAttributeName,nil];
            availableLabel.attributedText = [Common twoSectionOfLabelShowDifferentAttribute:[NSArray arrayWithObjects:attributeDict,attributeDict0, nil] WithTextLocations:[NSArray arrayWithObjects:value1,value2, nil] WithTotalString:total1];
            availableLabel.font = [UIFont systemFontOfSize:12.0f];
        } else {
            NSString *CouponNum = [_dataDict objectForKey:@"couponNum"];
            NSString *total1 = [NSString stringWithFormat:@"%@张可用",CouponNum];
            availableLabel.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xf03b43) WithSectionText:CouponNum WithTotalString:total1];
            availableLabel.font = [UIFont systemFontOfSize:16.0f];
        }
        return cell;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        static NSString *cellStr5 = @"cell6";
        UITableViewCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr5];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr5];
            UIView *topView =[[UIView alloc] init];
            topView.backgroundColor = UIColorWithRGB(0xebebee);
            topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
            [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
            [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
            [cell addSubview:topView];
            
            UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 37)];
            headview.backgroundColor = UIColorWithRGB(0xf9f9f9);
            [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:headview isTop:NO];
            [cell addSubview:headview];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.5, 300, 16)];
            textLabel.font = [UIFont systemFontOfSize:14.0f];
            textLabel.text = @"推荐人（没有推荐人可不填）";
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.textColor = UIColorWithRGB(0x333333);
            [headview addSubview:textLabel];
        }
        return cell;
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        static NSString *cellStr6 = @"cell7";
        UITableViewCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr6];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr6];
            [self addView:cell];
        }
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - MoneyBoardCellDelegate 计算器点击事件
- (void)showCalutorView
{
    [self.view endEditing:YES];
    MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *investMoney = cell.inputMoneyTextFieldLable.text;
    if (cell.inputMoneyTextFieldLable.text.length == 0 || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0"] || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0.0"] || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0.00"]) {
        [MBProgressHUD displayHudError:@"请输入投资金额"];
        return;
    }
    CalculatorView * view = [[CalculatorView alloc] init];
    view.tag = 173924;
    [view reloadViewWithData:_dataDict AndNowMoney:investMoney AndChildPrdClaimId:_childPrdClaimId];
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:view];
}
- (void)changeGongDouSwitchStatue:(UISwitch *)sender
{
    isGongDouSwitch = sender.on;
    [_bidTableView reloadData];
}
//通知主界面刷新
- (void)reloadSuperView:(UITextField *)textField
{
    [_bidTableView reloadData];
    self.tmpTextFieldTextValue = textField.text;
}

- (void)allInvestOrGotoPay:(NSInteger)mark
{
    if (mark == 500) {
        MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.inputMoneyTextFieldLable.text = [self GetDefaultText];
        [self reloadSuperView:cell.inputMoneyTextFieldLable];
    } else if (mark == 501) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
        UCFTopUpViewController *topUpView  = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
        //topUpView.isGoBackShowNavBar = YES;
        topUpView.title = @"充值";
        topUpView.uperViewController = self;
        [self.navigationController pushViewController:topUpView animated:YES];
    }
}

#pragma mark - -------------------textField-------------------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    orginalHeight = _bidTableView.contentSize.height;
    if (textField == _gCCodeTextField) {
        gongChangTextField = YES;
    } else {
        gongChangTextField = NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _gCCodeTextField) {
        gongChangTextField = NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _gCCodeTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
- (void)addView:(UITableViewCell *)cell
{
    UIView * inputBaseView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 15, ScreenWidth - 30.0f, 37.0f)];
    inputBaseView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    inputBaseView.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    inputBaseView.layer.borderWidth = 0.5f;
    inputBaseView.layer.cornerRadius = 4.0f;
    [cell addSubview:inputBaseView];
    
    _gCCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 8.5f, CGRectGetWidth(inputBaseView.frame) - 20, 20.0f)];
    _gCCodeTextField.backgroundColor = [UIColor clearColor];
    _gCCodeTextField.delegate = self;
    _gCCodeTextField.returnKeyType = UIReturnKeyDone;
    _gCCodeTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _gCCodeTextField.placeholder = @"点击填写工场码";
    [inputBaseView addSubview:_gCCodeTextField];
    
    //    UIView * inputBaseView1 = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(inputBaseView.frame) + 10, ScreenWidth - 30.0f, 37.0f)];
    //    inputBaseView1.backgroundColor = UIColorWithRGB(0xf2f2f2);
    //    inputBaseView1.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    //    inputBaseView1.layer.borderWidth = 0.5f;
    //    inputBaseView1.layer.cornerRadius = 4.0f;
    //    [cell addSubview:inputBaseView1];
    //
    //    _commendNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 10.5f, CGRectGetWidth(inputBaseView.frame) - 20, 16.0f)];
    //    _commendNameTextField.backgroundColor = [UIColor clearColor];
    //    _commendNameTextField.placeholder = @"推荐人姓名";
    //    [inputBaseView1 addSubview:_commendNameTextField];
    //
    //    UIView * inputBaseView2 = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(inputBaseView1.frame) + 10, ScreenWidth - 30.0f, 37.0f)];
    //    inputBaseView2.backgroundColor = UIColorWithRGB(0xf2f2f2);
    //    inputBaseView2.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    //    inputBaseView2.layer.borderWidth = 0.5f;
    //    inputBaseView2.layer.cornerRadius = 4.0f;
    //    [cell addSubview:inputBaseView2];
    //
    //    _teleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 10.5f, CGRectGetWidth(inputBaseView.frame) - 20, 16.0f)];
    //    _teleTextField.backgroundColor = [UIColor clearColor];
    //    _teleTextField.placeholder = @"推荐人手机号";
    //    [inputBaseView2 addSubview:_teleTextField];
    
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 160.5, ScreenWidth, 0.5)];
    //    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    //    [cell addSubview:lineView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 66.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [cell addSubview:lineView];
    
}

- (void)drawDetailView:(UITableViewCell *)cell
{
    UIView *topView =[[UIView alloc] init];
    topView.backgroundColor = UIColorWithRGB(0xebebee);
    topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
    [cell addSubview:topView];
    
    UIImageView * coupImage = [[UIImageView alloc] init];
    coupImage.image = [UIImage imageNamed:@"invest_icon_coupon.png"];
    coupImage.tag = 2999;
    coupImage.frame = CGRectMake(13, 10 + (37 - 25)/2.0f, 25, 25);
    [cell addSubview:coupImage];
    
    UILabel *commendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coupImage.frame) + 7, 10 + (37 - 14)/2, 80, 14)];
    commendLabel.text = @"使用优惠券";
    commendLabel.font = [UIFont systemFontOfSize:14.0f];
    commendLabel.textColor = UIColorWithRGB(0x555555);
    [cell addSubview:commendLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [cell addSubview:lineView];
}

//根据金额选择优惠券
- (void)pushSelectYouHuiQuan:(UIButton *)button
{
    UCFSelectPayBackController *viewController = [[UCFSelectPayBackController alloc] init];
    MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    double investAmtMoney = [cell.inputMoneyTextFieldLable.text doubleValue];
    //工豆数
    double gondDouBalance = [[[_dataDict objectForKey:@"beanUser"] objectForKey:@"availableBalance"] doubleValue];
    //钱数
    double moneyBalance = [[[_dataDict objectForKey:@"actUser"] objectForKey:@"availableBalance"] doubleValue];
    if (isGongDouSwitch) {
        viewController.keYongMoney = moneyBalance + gondDouBalance/100.0f;
    } else {
        viewController.keYongMoney = moneyBalance;
    }
    viewController.onlyMoney = moneyBalance;
    viewController.touZiMoney =investAmtMoney;
    viewController.occupyRate = [[self.dataDict valueForKey:@"occupyRate"] doubleValue];
    //返息券有选中，再次进入选择页面
    if (self.coupDict) {
        viewController.backInterestRate = [self.coupDict objectForKey:@"backInterestRate"];
        double money1 = investAmtMoney;
        NSString *annleRate = [self.coupDict objectForKey:@"backInterestRate"];
        NSString *repayPeriodDay = nil;
        //灵活期限标如果有灵活期限holdtime取 holdtime 否则取repayPeriodDay
        NSString *holdTime = [[_dataDict objectForKey:@"data"] objectForKey:@"holdTime"];
        if (holdTime.length > 0) {
            repayPeriodDay = holdTime;
        } else {
            repayPeriodDay = [[_dataDict objectForKey:@"data"] objectForKey:@"repayPeriodDay"];
        }
        double liLv = [annleRate doubleValue]/100.0f;
        double qiXian = [repayPeriodDay doubleValue];
        //计算返息的工豆
        money1 = ((money1 * liLv)/360.0f) * qiXian;
        viewController.interestSum = round(money1 *100.0f)/100.0f * [[self.dataDict valueForKey:@"occupyRate"] doubleValue];
        viewController.interestPrdaimSum = [[self.coupDict objectForKey:@"manzuMoney"] doubleValue];
        viewController.tmpSelectCounpArray = [self.coupDict objectForKey:@"selectArray"];
    }
    //返现券有选中，再次进入选择页面
    if(self.cashDict) {
        viewController.couponPrdaimSum = [[self.cashDict objectForKey:@"manzuMoney"] doubleValue];
        viewController.couponSum = [[self.cashDict objectForKey:@"youhuiMoney"] doubleValue];
        viewController.tmpSelectCashArray = [self.cashDict objectForKey:@"selectArray"];
    }
    viewController.listType = button.tag - 400;
    viewController.gongDouCount = cell.gongDouSwitch.on == YES ? gondDouBalance : 0;
    InvestmentItemInfo *info =  self.bidArray[0];
    viewController.keTouMoney = [info.borrowAmount doubleValue] - [info.completeLoan doubleValue];
    viewController.baseTitleType = @"detail_heTong";
    viewController.prdclaimid = [[_dataDict objectForKey:@"data"] objectForKey:@"id"];
    viewController.bidDataDict = _dataDict;
    viewController.superViewController = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 获取优惠券金额
- (void)getYouHuiQuanNum
{
    
}

// 是否第一次投资(普通标)
- (BOOL)checkIsFirstInvest
{
    NSString *recommendCode = [_dataDict objectForKey:@"recomendFactoryCode"];
    if ([recommendCode isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}
//获取默认填写金额
-(NSString *)GetDefaultText
{
//    InvestmentItemInfo * info1 = [[InvestmentItemInfo alloc] initWithDictionary:[_dataDict objectForKey:@"data"]];
    
    NSDictionary *colPrdClaimDetailDict = [_dataDict objectSafeDictionaryForKey:@"colPrdClaimDetail"];
    
    NSString *canBuyAmtStr = [NSString stringWithFormat:@"%@",[colPrdClaimDetailDict objectSafeForKey:@"canBuyAmt"]];
    
    
    long long int keTouJinE = round(([canBuyAmtStr doubleValue])* 100);
    
    
    long long int keYongZiJin = round([[self.dataDict objectForKey:@"availableBalance"]doubleValue] * 100);
    
    NSInteger gongDouCount = [[_dataDict objectForKey:@"beanAmount"] integerValue];
    if (!isGongDouSwitch) {
        gongDouCount = 0;
    }
    keYongZiJin += gongDouCount;
    
    NSString *colMinInvestStr = [NSString stringWithFormat:@"%@",[colPrdClaimDetailDict objectSafeForKey:@"colMinInvest"]];
    long long int minInVestNum = round([colMinInvestStr intValue]* 100);
    
    //判断是不是最后一笔
    if (keTouJinE - minInVestNum < minInVestNum) {
        return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keTouJinE)/100.0f]];
    } else {
        if (keYongZiJin < minInVestNum) {
            return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(minInVestNum)/100.0f]];
        }
        if (keYongZiJin >= minInVestNum && keYongZiJin < keTouJinE) {
            if (keYongZiJin + minInVestNum < keTouJinE) {
                return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keYongZiJin)/100.0f]];
            } else {
                return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keTouJinE - minInVestNum)/100.0f]];
            }
        }
        if (keYongZiJin >= minInVestNum && keYongZiJin >= keTouJinE) {
            return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keTouJinE)/100.0f]];
        }
    }
    return @"100.0";
}
- (NSString *)checkBeyondLimit:(NSString *)investMoney
{

//    NSString *maxIn = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"batchAmount"]];
//    if (maxIn.length != 0) {
//        if ([Common stringA:investMoney ComparedStringB:maxIn] == 1) {
//            return maxIn;
//        } else {
//            return investMoney;
//        }
//    }
    return investMoney;
}
- (UIView *)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 98)];
    footView.backgroundColor = UIColorWithRGB(0xebebee);
    footView.userInteractionEnabled = YES;
    NSArray *contractMsgArr = @[@"批量投资协议"];
    NSString *totalStr = [NSString stringWithFormat:@"同意并确认"];
    for (int i = 0; i < contractMsgArr.count; i++) {
        NSString *tmpStr = [contractMsgArr objectAtIndex:i];
        totalStr = [totalStr stringByAppendingString:[NSString stringWithFormat:@"《%@》",tmpStr]];
    }
    NZLabel *label1 = [[NZLabel alloc] init];
    label1.font = [UIFont systemFontOfSize:12.0f];
    CGSize size = [Common getStrHeightWithStr:totalStr AndStrFont:12 AndWidth:ScreenWidth-25];
    label1.numberOfLines = 0;
    label1.frame = CGRectMake(23, 15, ScreenWidth-25, size.height);
    label1.text = totalStr;
    label1.userInteractionEnabled = YES;
    label1.textColor = UIColorWithRGB(0x999999);
    
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < contractMsgArr.count; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"《%@》",[contractMsgArr objectAtIndex:i] ];
        [label1 addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
            [weakSelf showHeTong:linkModel];
        }];
        [label1 setFontColor:UIColorWithRGB(0x4aa1f9) string:tmpStr];
    }
    [footView addSubview:label1];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(CGRectGetMinX(label1.frame) - 7, CGRectGetMinY(label1.frame) + 4, 5, 5);
    imageView1.image = [UIImage imageNamed:@"point.png"];
    [footView addSubview:imageView1];
    
    CGFloat height1 = CGRectGetMaxY(label1.frame);
    NSArray *downContractList = [_dataDict objectForKey:@"downContractList"];
    if (downContractList.count > 0) {
        
        NSString *totalStr1 = [NSString stringWithFormat:@"同意并认可"];
        for (int i = 0; i < downContractList.count; i++) {
            NSString *tmpStr = [[downContractList objectAtIndex:i] valueForKey:@"contractName"];
            totalStr1 = [totalStr1 stringByAppendingString:[NSString stringWithFormat:@"《%@》",tmpStr]];
        }
        
        NZLabel *label2 = [[NZLabel alloc] init];
        label2.font = [UIFont systemFontOfSize:12.0f];
        CGSize size1 = [Common getStrHeightWithStr:totalStr1 AndStrFont:12 AndWidth:ScreenWidth-25];
        label2.numberOfLines = 0;
        label2.frame = CGRectMake(23, height1 + 10, ScreenWidth-25, size1.height);
        label2.text = totalStr1;
        label2.userInteractionEnabled = YES;
        label2.textColor = UIColorWithRGB(0x999999);
        
        height1 = CGRectGetMaxY(label2.frame);
        
        UIImageView * imageView3 = [[UIImageView alloc] init];
        imageView3.frame = CGRectMake(CGRectGetMinX(label2.frame) - 7, CGRectGetMinY(label2.frame) + 4, 5, 5);
        imageView3.image = [UIImage imageNamed:@"point.png"];
        [footView addSubview:imageView3];
        
        //    __weak typeof(self) weakSelf = self;
        for (int i = 0; i < downContractList.count; i++) {
            NSString *tmpStr = [NSString stringWithFormat:@"《%@》",[[downContractList objectAtIndex:i] valueForKey:@"contractName"]];
            [label2 addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
                [weakSelf showPDF:linkModel];
            }];
            [label2 setFontColor:UIColorWithRGB(0x4aa1f9) string:tmpStr];
        }
        [footView addSubview:label2];
        
        UILabel *jieshouLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(23, height1+10, ScreenWidth-25, 12)];
        jieshouLabel0.backgroundColor = [UIColor clearColor];
        jieshouLabel0.text = [_dataDict objectForKey:@"openTypeMess"];
        jieshouLabel0.font = [UIFont systemFontOfSize:12];
        jieshouLabel0.textColor = UIColorWithRGB(0x999999);
        [footView addSubview:jieshouLabel0];
        
        UIImageView * imageView4 = [[UIImageView alloc] init];
        imageView4.frame = CGRectMake(CGRectGetMinX(jieshouLabel0.frame) - 7, CGRectGetMinY(jieshouLabel0.frame) + 4, 5, 5);
        imageView4.image = [UIImage imageNamed:@"point.png"];
        [footView addSubview:imageView4];
        
        height1 = CGRectGetMaxY(jieshouLabel0.frame);
        
    }
    
    
    
    
    UILabel *jieshouLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, height1+10, ScreenWidth-25, 12)];
    jieshouLabel.backgroundColor = [UIColor clearColor];
    jieshouLabel.text = @"本人接受筹标期内资金不计利息,投资意向不可撤销";
    jieshouLabel.font = [UIFont systemFontOfSize:12];
    jieshouLabel.textColor = UIColorWithRGB(0x999999);
    [footView addSubview:jieshouLabel];
    
    footView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(jieshouLabel.frame) + 15);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:footView isTop:YES];
    
    UIImageView * imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(CGRectGetMinX(jieshouLabel.frame) - 7, CGRectGetMinY(jieshouLabel.frame) + 4, 5, 5);
    imageView2.image = [UIImage imageNamed:@"point.png"];
    [footView addSubview:imageView2];
    
    return footView;
}


#warning ddddddddddddddddddd
- (NSString *)valueIndex:(ZBLinkLabelModel *)linkModel WithDataArr:(NSArray *)contractMsgArr typeKey:(NSString *)key
{
    NSString *contractStr = linkModel.linkString;
    
    NSString *type = @"";
    for (int i = 0; i < contractMsgArr.count; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"《%@》",[[contractMsgArr objectAtIndex:i] valueForKey:@"contractName"]];
        if ([tmpStr isEqualToString:contractStr]) {
            type = [[contractMsgArr objectAtIndex:i] valueForKey:key];
            _contractTitle = [[contractMsgArr objectAtIndex:i] valueForKey:@"contractName"];
            break;
        }
    }
    return type;
}
//展示合同
- (void)showHeTong:(ZBLinkLabelModel *)linkModel
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSDictionary *userOtherMsg = [_dataDict objectForKey:@"userOtherMsg"];
//    NSArray *contractMsgArr = [userOtherMsg valueForKey:@"contractMsg"];
//    NSString *contractTypeStr = [self valueIndex:linkModel WithDataArr:contractMsgArr typeKey:@"contractType"];
//    
//    NSString *projectId = [[self.dataDict objectForKey:@"data"] objectForKey:@"id"];
//    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdClaimId=%@&contractType=%@&prdType=0",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],projectId,contractTypeStr];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetContractMsg owner:self];
    FullWebViewController *controller = [[FullWebViewController alloc] initWithWebUrl:@"https://www.9888.cn/batch_invest_terms.html" title:@"批量投资协议"];
    controller.baseTitleType = @"detail_heTong";
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)showPDF:(ZBLinkLabelModel *)linkModel
{
    NSArray *contractMsgArr = [_dataDict objectForKey:@"downContractList"];
    NSString *key = @"contractDownUrl";
    NSString *url = [self valueIndex:linkModel WithDataArr:contractMsgArr typeKey:key];
    NSString *urlStringUTF8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    FullWebViewController *controller = [[FullWebViewController alloc] initWithWebUrl:urlStringUTF8 title:_contractTitle];
    controller.baseTitleType = @"detail_heTong";
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)reloadMainView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParameters = nil;
    NSString *projectId = [[_dataDict objectForKey:@"data"] objectForKey:@"id"];
    strParameters = [NSString stringWithFormat:@"userId=%@&id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],projectId];//101943
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
