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
@interface NewPurchaseBidController ()
@property(nonatomic, strong) MyLinearLayout *contentLayout;
@property(nonatomic, strong) UCFSectionHeadView *bidInfoHeadSectionView;
@property(nonatomic, strong) UCFRemindFlowView *remind;
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
    
    UCFSectionHeadView *bidHeadView = [UCFSectionHeadView new];
    bidHeadView.myTop = 0;
    bidHeadView.myHorzMargin = 0;
    bidHeadView.myHeight = 27;
    [self.contentLayout addSubview:bidHeadView];
    [bidHeadView setShowLabelText:@"产融通"];
    self.bidInfoHeadSectionView = bidHeadView;
    
    UCFBidInfoView *bidInfo = [UCFBidInfoView new];
    bidInfo.myTop = 0;
    bidInfo.myHorzMargin = 0;
    bidInfo.myHeight = 61;
    bidInfo.backgroundColor = [UIColor whiteColor];
    [self.contentLayout addSubview:bidInfo];
    [bidInfo bidLayoutSubViewsFrame];
    
    UCFRemindFlowView *remind = [UCFRemindFlowView new];
    remind.myTop = 0;
    remind.myHorzMargin = 0;
    remind.heightSize.equalTo(@36);
    remind.backgroundColor = UIColorWithRGB(0xebebee);
    remind.subviewVSpace = 5;
    remind.subviewHSpace = 5;
    [self.contentLayout addSubview:remind];
    self.remind = remind;
//    remind.backgroundColor = [UIColor redColor];
    [_remind  reloadViewContentWithTextArr:@[@"text",@"tex111t",@"tex22212t"]];

    UCFInvestFundsBoard *fundsBoard = [UCFInvestFundsBoard linearLayoutWithOrientation:MyOrientation_Vert];
    fundsBoard.myHorzMargin = 0;
    [self.contentLayout addSubview:fundsBoard];
    [fundsBoard addSubSectionViews];
    
    UCFCouponBoard *couponBoard = [UCFCouponBoard linearLayoutWithOrientation:MyOrientation_Vert];
    couponBoard.myHorzMargin = 0;
    couponBoard.myTop = 10;
    [self.contentLayout addSubview:couponBoard];
    [couponBoard addSubSectionViews];

    [self fetchNetData];
}
- (void)fetchNetData
{
//    []
    
}
- (void)viewDidLoad {
//    [super viewDidLoad];
    [self addLeftButton];
    
}
- (void)beginPost:(kSXTag)tag {
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}


@end
