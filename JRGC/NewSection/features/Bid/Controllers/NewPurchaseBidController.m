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
@interface NewPurchaseBidController ()<UCFCouponBoardDelegate>
@property(nonatomic, strong) MyLinearLayout *contentLayout;
@property(nonatomic, strong) UCFSectionHeadView *bidInfoHeadSectionView;
@property(nonatomic, strong) UCFSectionHeadView *bidHeadView;
@property(nonatomic, strong) UCFBidInfoView     *bidInfoDetailView;
@property(nonatomic, strong) UCFRemindFlowView *remind;
@property(nonatomic, strong) UCFInvestFundsBoard *fundsBoardView;
@property(nonatomic, strong) UCFCouponBoard *couponBoard;
@property(nonatomic, strong) UCFBidFootBoardView    *footView;
@end

@implementation NewPurchaseBidController
- (void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = UIColorWithRGB(0xebebee);
    self.view = scrollView;
    
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
    
    UCFBidFootBoardView *footView = [UCFBidFootBoardView linearLayoutWithOrientation:MyOrientation_Vert];
    footView.myVertMargin = 10;
    footView.myHorzMargin = 0;
    footView.backgroundColor = UIColorWithRGB(0xebebee);
//    footView.backgroundColor = [UIColor yellowColor];
    footView.userInteractionEnabled = YES;
    [self.contentLayout addSubview:footView];
    self.footView = footView;
    [footView createAllShowView];
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
    
    [self.footView showView:vm];
    
    [vm setDataModel:_bidDetaiModel];
    vm.superView = self.view;
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:vm keyPaths:@[@"contractTypeModel"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
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
        }
    }];
}
- (void)couponBoard:(UCFCouponBoard *)board SelectPayBackButtonClick:(UIButton *)button
{
    
}




@end
