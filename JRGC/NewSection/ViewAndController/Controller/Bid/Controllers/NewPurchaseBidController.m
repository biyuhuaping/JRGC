//
//  NewPurchaseBidController.m
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "NewPurchaseBidController.h"
#import "UCFSectionHeadView.h"
#import "UCFBidInfoView.h"
#import "UCFRemindFlowView.h"
#import "UCFInvestFundsBoard.h"
#import "UCFCouponBoard.h"
#import "UCFBidViewModel.h"
#import "UCFBidFootBoardView.h"
#import "FullWebViewController.h"
#import "UCFRecommendView.h"
#import "UCFFundsInvestButton.h"
#import "UCFPurchaseWebView.h"
#import "UCFNewRechargeViewController.h"
#import "UCFInvestmentCouponController.h"
#import "UCFBidViewModel.h"
#import "UCFInvestmentCouponModel.h"
#import "IQKeyboardManager.h"

@interface NewPurchaseBidController ()<UCFCouponBoardDelegate,UCFInvestFundsBoardDelegate>
@property(nonatomic, strong) MyLinearLayout *contentLayout;
@property(nonatomic, strong) UCFSectionHeadView *bidInfoHeadSectionView;
@property(nonatomic, strong) UCFSectionHeadView *bidHeadView;
@property(nonatomic, strong) UCFBidInfoView     *bidInfoDetailView;
@property(nonatomic, strong) UCFRemindFlowView *remind;
@property(nonatomic, strong) UCFInvestFundsBoard *fundsBoardView;
@property(nonatomic, strong) UCFCouponBoard *couponBoard;
@property(nonatomic, strong) UCFRecommendView *recommendView;
@property(nonatomic, strong) UCFBidFootBoardView    *footView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UCFFundsInvestButton *investButton;
@property(nonatomic, strong) UCFBidViewModel       *viewModel;

@property(nonatomic, copy) NSString *rechargeMoneyStr;
@property(nonatomic, strong)NSArray *cashArray;
@property(nonatomic, strong)NSArray *couponArray;
@end

@implementation NewPurchaseBidController

- (void)loadView
{    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
    self.view = rootLayout;
    rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    rootLayout.insetsPaddingFromSafeArea = UIRectEdgeBottom;  //您可以在这里将值改变为UIRectEdge的其他类型然后试试运行的效果。并且在运行时切换横竖屏看看效果
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.myHorzMargin = 0;
    scrollView.topPos.equalTo(@0);
    scrollView.bottomPos.equalTo(@57);
    scrollView.myHorzMargin = 0;
    [rootLayout addSubview:scrollView];
    self.scrollView = scrollView;
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(15, 0, 0, 0);
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    contentLayout.heightSize.lBound(scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
    [scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    
    _bidHeadView = [UCFSectionHeadView new];
    _bidHeadView.myTop = 0;
    _bidHeadView.myHorzMargin = 0;
    _bidHeadView.myHeight = 43;
    [self.contentLayout addSubview:_bidHeadView];
    [_bidHeadView layoutSubviewFrame];
    
    UCFBidInfoView *bidInfo = [UCFBidInfoView new];
    bidInfo.myTop = 0;
    bidInfo.myHorzMargin = 0;
    bidInfo.myHeight = 80;
    bidInfo.backgroundColor = [UIColor whiteColor];
    [self.contentLayout addSubview:bidInfo];
    [bidInfo bidLayoutSubViewsFrame];
    self.bidInfoDetailView = bidInfo;
    
    UCFRemindFlowView *remind = [UCFRemindFlowView new];
    remind.myTop = 0;
    remind.myHorzMargin = 0;
    remind.heightSize.equalTo(@40);
    remind.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
    remind.subviewVSpace = 5;
    remind.subviewHSpace = 5;
    [self.contentLayout addSubview:remind];
    self.remind = remind;

    UCFInvestFundsBoard *fundsBoard = [UCFInvestFundsBoard linearLayoutWithOrientation:MyOrientation_Vert];
    fundsBoard.myHorzMargin = 0;
    fundsBoard.delegate = self;
    [self.contentLayout addSubview:fundsBoard];
    [fundsBoard addSubSectionViews];
    self.fundsBoardView = fundsBoard;
    
    if (SingleUserInfo.isShowCouple) {
        UCFCouponBoard *couponBoard = [UCFCouponBoard linearLayoutWithOrientation:MyOrientation_Vert];
        couponBoard.myHorzMargin = 0;
        couponBoard.myTop = 10;
        couponBoard.delegate = self;
        [self.contentLayout addSubview:couponBoard];
        [couponBoard addSubSectionViews];
        self.couponBoard = couponBoard;
    }

    
    UCFRecommendView *recommendView = [UCFRecommendView linearLayoutWithOrientation:MyOrientation_Vert];
    recommendView.myHorzMargin = 0;
    [self.contentLayout addSubview:recommendView];
    [recommendView addSubSectionViews];
    self.recommendView = recommendView;
    
    UCFBidFootBoardView *footView = [UCFBidFootBoardView linearLayoutWithOrientation:MyOrientation_Vert];
    footView.myVertMargin = 10;
    footView.myHorzMargin = 0;
    footView.backgroundColor = UIColorWithRGB(0xebebee);
    footView.userInteractionEnabled = YES;
    [self.contentLayout addSubview:footView];
    self.footView = footView;
    [footView createAllShowView];
    
    UCFFundsInvestButton *investButton = [UCFFundsInvestButton new];
    investButton.myHorzMargin = 0;
    investButton.bottomPos.equalTo(@0);
    investButton.myHeight = 50;
    investButton.backgroundColor = [UIColor whiteColor];
    [rootLayout addSubview:investButton];
    [investButton createSubviews];
    self.investButton = investButton;
}
- (void)fetchNetData
{
    
}
- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self addLeftButton];
    [super viewDidLoad];
    
    [self addLeftButton];
    UILabel *baseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200)/2.0f, 0, 200, 30)];
    baseTitleLabel.textAlignment = NSTextAlignmentCenter;
    [baseTitleLabel setTextColor:UIColorWithRGB(0x333333)];
    [baseTitleLabel setBackgroundColor:[UIColor clearColor]];
    baseTitleLabel.font = [UIFont systemFontOfSize:18];
    baseTitleLabel.text = @"出借";
    self.navigationItem.titleView = baseTitleLabel;
    [self initializationData];
}
- (void)initializationData
{
    UCFBidViewModel *vm = [UCFBidViewModel new];
    
    [self.bidHeadView showView:vm];

    [self.bidInfoDetailView showView:vm];

    [self.remind showView:vm];

    [self.fundsBoardView showView:vm];

    if ([UserInfoSingle sharedManager].isShowCouple) {
        [self.couponBoard showView:vm];
    }

    [self.recommendView showView:vm];

    [self.footView showView:vm];

    [self.investButton showView:vm];

    [vm setDataModel:_bidDetaiModel];

    [vm setRootController:self];

    [self bindData:vm];
//
    self.viewModel = vm;
    

}

- (void)couponBoard:(UCFCouponBoard *)board SelectPayBackButtonClick:(UIButton *)button
{
    NSString *prdclaimid = [self.viewModel getDataModelBidID];
    NSString *investAmt = [self.viewModel getTextFeildInputMoeny];
    if (prdclaimid == nil || [prdclaimid isEqualToString:@""] || investAmt == nil || [investAmt isEqualToString:@""]) {
        return;
    }
    UCFInvestmentCouponController *uc = [[UCFInvestmentCouponController alloc] init];
    uc.prdclaimid = prdclaimid;
    uc.investAmt = investAmt;
    uc.barSelectIndex = button.tag - 100;
//    uc.barSelectIndex = 1;
    uc.cashSelectArr = [NSMutableArray arrayWithArray:self.cashArray];
    uc.couponSelectArr = [NSMutableArray arrayWithArray:self.couponArray];
    [self.navigationController pushViewController:uc animated:YES];
    
    [self bindCoupleView:uc];
}
- (void)investFundsBoard:(UCFInvestFundsBoard *)board withRechargeButtonClick:(UIButton *)button
{
    UCFNewRechargeViewController *vc = [[UCFNewRechargeViewController alloc] initWithNibName:@"UCFNewRechargeViewController" bundle:nil];
    vc.accoutType = SelectAccoutTypeP2P;
    vc.uperViewController = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)bindCoupleView:(UCFInvestmentCouponController *)vc
{
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:vc keyPaths:@[@"cashSelectArr"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"cashSelectArr"]) {
            NSArray *arr = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (arr.count > 0) {
                self.cashArray = [arr mutableCopy];
                double totalInvestMultip = 0;
                double totalcouponAmount = 0;
                NSString *totalIDStr = @"";
                for (int i = 0; i < arr.count; i++) {
                    InvestmentCouponCouponlist *model = arr[i];
                    totalInvestMultip += model.investMultip;
                    totalcouponAmount += [model.couponAmount doubleValue];
                    if (i == arr.count - 1) {
                        totalIDStr = [totalIDStr stringByAppendingString:[NSString stringWithFormat:@"%ld",model.couponId]];
                    } else {
                        totalIDStr = [totalIDStr stringByAppendingString:[NSString stringWithFormat:@"%ld,",model.couponId]];
                    }
                }
                weakSelf.viewModel.cashSelectCount = arr.count;
                weakSelf.viewModel.cashTotalcouponAmount = [NSString stringWithFormat:@"%.2f",totalInvestMultip];
                weakSelf.viewModel.cashTotalIDStr = totalIDStr;
                weakSelf.viewModel.repayCash = [NSString stringWithFormat:@"%.2f",totalcouponAmount];

            } else {
                weakSelf.viewModel.cashSelectCount = 0;
                weakSelf.viewModel.repayCash = @"0";
                weakSelf.viewModel.cashTotalcouponAmount = @"0";
                weakSelf.viewModel.cashTotalIDStr = @"";
                weakSelf.cashArray = [NSArray array];
            }
        }
    }];
    [self.KVOController observe:vc keyPaths:@[@"couponSelectArr"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"couponSelectArr"]) {
            NSArray *arr = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (arr.count > 0) {
                self.couponArray = [arr mutableCopy];
                double totalInvestMultip = 0;
                double couponAmount = 0;
                NSString *totalIDStr = @"";
                
                weakSelf.viewModel.couponSelectCount = 1;
                InvestmentCouponCouponlist *model = arr[0];
                couponAmount = [model.couponAmount doubleValue];
                totalInvestMultip = model.investMultip;
                totalIDStr =  [NSString stringWithFormat:@"%ld",(long)model.couponId];
                weakSelf.viewModel.couponTotalcouponAmount = [NSString stringWithFormat:@"%.2f",totalInvestMultip];
                weakSelf.viewModel.repayCoupon = [NSString stringWithFormat:@"%@",[self.viewModel getInvestGetBeansByCoupon:[NSString stringWithFormat:@"%.2f",couponAmount]]];
                weakSelf.viewModel.couponIDStr = totalIDStr;
            } else {
                weakSelf.viewModel.couponSelectCount = 0;
                weakSelf.viewModel.repayCoupon = @"0";
                weakSelf.viewModel.couponTotalcouponAmount = @"0";
                weakSelf.viewModel.couponIDStr = @"";
                weakSelf.couponArray = [NSArray array];
            }
        }
    }];
}


- (void)bindData:(UCFBidViewModel *)vm
{
    vm.superView = self.view;
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:vm keyPaths:@[@"contractTypeModel",@"hsbidInfoDict",@"rechargeStr",@"investMoneyIsChange"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"contractTypeModel"]) {
            id funds = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if ([funds isKindOfClass:[UCFContractTypleModel class]]) {
                UCFContractTypleModel *model = (UCFContractTypleModel *)funds;
                if ([model.type isEqualToString:@"1"]) {
                    FullWebViewController *controller = [[FullWebViewController alloc] initWithWebUrl:model.url title:model.title];
                    controller.baseTitleType = @"detail_heTong";
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                } else if ([model.type isEqualToString:@"3"]) {
                    FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:model.htmlContent title:model.title];
                    controller.baseTitleType = @"detail_heTong";
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }
            NSLog(@"%@",funds);
        } else if ([keyPath isEqualToString:@"hsbidInfoDict"]) {
            NSDictionary *dic = [change objectSafeDictionaryForKey:NSKeyValueChangeNewKey];
            if ([[dic allKeys] count] > 0) {
                NSDictionary  *dataDict = dic[@"data"][@"tradeReq"];
                NSString *urlStr = dic[@"data"][@"url"];
                UCFPurchaseWebView *webView = [[UCFPurchaseWebView alloc]initWithNibName:@"UCFPurchaseWebView" bundle:nil];
                webView.url = urlStr;
                webView.rootVc = weakSelf.rootVc;
                webView.webDataDic =dataDict;
                webView.navTitle = @"即将跳转";
                webView.accoutType = SelectAccoutTypeP2P;
                [weakSelf.navigationController pushViewController:webView animated:YES];
                NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:weakSelf.navigationController.viewControllers];
                [navVCArray removeObjectAtIndex:navVCArray.count-2];
                [weakSelf.navigationController setViewControllers:navVCArray animated:NO];
            }
        } else if ([keyPath isEqualToString:@"rechargeStr"]) {
            NSString *str = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (str.length > 0) {
                weakSelf.rechargeMoneyStr = str;
            }
        } else if ([keyPath isEqualToString:@"investMoneyIsChange"]) {
           BOOL isChange = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (isChange) {
                
                weakSelf.viewModel.cashSelectCount = 0;
                weakSelf.viewModel.repayCash = @"0";
                weakSelf.viewModel.cashTotalcouponAmount = @"0";
                weakSelf.viewModel.cashTotalIDStr = @"";
                weakSelf.cashArray = [NSArray array];
                
                weakSelf.viewModel.couponSelectCount = 0;
                weakSelf.viewModel.repayCoupon = @"0";
                weakSelf.viewModel.couponTotalcouponAmount = @"0";
                weakSelf.viewModel.couponIDStr = @"";
                weakSelf.couponArray = [NSArray array];
            }
        }
    }];
}

- (void)reflectAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (buttonIndex == 0) {
        if (tag == 1000 || tag == 6000) {
            [self.view endEditing:YES];
        } else if (tag == 10023) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else if (buttonIndex == 1) {
        if (tag == 2000) {
            UCFNewRechargeViewController *vc = [[UCFNewRechargeViewController alloc] initWithNibName:@"UCFNewRechargeViewController" bundle:nil];
            vc.uperViewController = self;
            vc.defaultMoney = self.rechargeMoneyStr;
            vc.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)dealloc
{
    NSLog(@"释放了");
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = NO;
}

@end
