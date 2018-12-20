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

@property(nonatomic, copy) NSString *rechargeMoneyStr;

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
    contentLayout.padding = UIEdgeInsetsMake(10, 0, 0, 0);
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    contentLayout.heightSize.lBound(scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
    [scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    
    _bidHeadView = [UCFSectionHeadView new];
    _bidHeadView.myTop = 0;
    _bidHeadView.myHorzMargin = 0;
    _bidHeadView.myHeight = 27;
    [self.contentLayout addSubview:_bidHeadView];
    self.bidInfoHeadSectionView = _bidHeadView;
    [_bidHeadView layoutSubviewFrame];
    
    UCFBidInfoView *bidInfo = [UCFBidInfoView new];
    bidInfo.myTop = 0;
    bidInfo.myHorzMargin = 0;
    bidInfo.myHeight = 61;
    bidInfo.backgroundColor = [UIColor whiteColor];
    [self.contentLayout addSubview:bidInfo];
    [bidInfo bidLayoutSubViewsFrame];
    self.bidInfoDetailView = bidInfo;
    
    UCFRemindFlowView *remind = [UCFRemindFlowView new];
    remind.myTop = 0;
    remind.myHorzMargin = 0;
    remind.heightSize.equalTo(@36);
    remind.backgroundColor = UIColorWithRGB(0xebebee);
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
    
    UCFCouponBoard *couponBoard = [UCFCouponBoard linearLayoutWithOrientation:MyOrientation_Vert];
    couponBoard.myHorzMargin = 0;
    couponBoard.myTop = 10;
    couponBoard.delegate = self;
    [self.contentLayout addSubview:couponBoard];
    [couponBoard addSubSectionViews];
    self.couponBoard = couponBoard;
    
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
    investButton.myHeight = 57;
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
    [self addLeftButton];
    [self initializationData];
}
- (void)initializationData
{
    UCFBidViewModel *vm = [UCFBidViewModel new];
    
    [self.bidHeadView showView:vm];

    [self.bidInfoDetailView showView:vm];
    
    [self.remind showView:vm];
    
    [self.fundsBoardView showView:vm];
    
    [self.couponBoard showView:vm];
    
    [self.recommendView showView:vm];
    
    [self.footView showView:vm];
    
    [self.investButton showView:vm];
    
    [vm setDataModel:_bidDetaiModel];
    
    [vm setRootController:self];
    
    [self bindData:vm];

}
- (void)couponBoard:(UCFCouponBoard *)board SelectPayBackButtonClick:(UIButton *)button
{
    
}
- (void)investFundsBoard:(UCFInvestFundsBoard *)board withRechargeButtonClick:(UIButton *)button
{
    UCFNewRechargeViewController *vc = [[UCFNewRechargeViewController alloc] initWithNibName:@"UCFNewRechargeViewController" bundle:nil];
    vc.accoutType = SelectAccoutTypeP2P;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)bindData:(UCFBidViewModel *)vm
{
    vm.superView = self.view;
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:vm keyPaths:@[@"contractTypeModel",@"hsbidInfoDict",@"rechargeStr"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
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
            vc.defaultMoney = self.rechargeMoneyStr;
            vc.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


@end
