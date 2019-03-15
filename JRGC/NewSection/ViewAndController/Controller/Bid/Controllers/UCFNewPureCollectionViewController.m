//
//  UCFNewPureCollectionViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewPureCollectionViewController.h"
#import "UCFSectionHeadView.h"
#import "UCFBidInfoView.h"
#import "UCFRemindFlowView.h"
#import "UCFTransMoneyBoardView.h"
#import "UCFBidFootBoardView.h"
#import "UCFFundsInvestButton.h"
#import "UCFCollectionViewModel.h"
@interface UCFNewPureCollectionViewController ()<UCFTransMoneyBoardViewDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) MyLinearLayout *contentLayout;
@property(nonatomic, strong) UCFSectionHeadView *bidHeadView;
@property(nonatomic, strong) UCFBidInfoView     *bidInfoDetailView;
@property(nonatomic, strong) UCFRemindFlowView  *remind;
@property(nonatomic, strong) UCFTransMoneyBoardView *fundsBoardView;
@property(nonatomic, strong) UCFBidFootBoardView    *footView;
@property(nonatomic, strong) UCFFundsInvestButton   *investButton;


@property(nonatomic, strong) UCFCollectionViewModel *VM;

@end

@implementation UCFNewPureCollectionViewController
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
    
    UCFTransMoneyBoardView *fundsBoard = [UCFTransMoneyBoardView linearLayoutWithOrientation:MyOrientation_Vert];
    fundsBoard.myHorzMargin = 0;
    fundsBoard.delegate = self;
    [self.contentLayout addSubview:fundsBoard];
    [fundsBoard addSubSectionViews];
    self.fundsBoardView = fundsBoard;
    
    
    UCFBidFootBoardView *footView = [UCFBidFootBoardView linearLayoutWithOrientation:MyOrientation_Vert];
    footView.myVertMargin = 10;
    footView.myHorzMargin = 0;
    footView.backgroundColor = UIColorWithRGB(0xebebee);
    footView.userInteractionEnabled = YES;
    [self.contentLayout addSubview:footView];
    self.footView = footView;
    [footView createTransShowView];
    
    
    UCFFundsInvestButton *investButton = [UCFFundsInvestButton new];
    investButton.myHorzMargin = 0;
    investButton.bottomPos.equalTo(@0);
    investButton.myHeight = 50;
    investButton.backgroundColor = [UIColor whiteColor];
    [rootLayout addSubview:investButton];
    [investButton createSubviews];
    self.investButton = investButton;
}
- (void)leftBar1Clicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlueLeftButton];
    [self setTitleViewText:@"出借"];
    [self initializationData];

}
- (void)initializationData
{
    UCFCollectionViewModel *vm = [UCFCollectionViewModel new];
    self.VM = vm;
    
    [self.bidHeadView blindBaseViewModel:vm];
    
    [self.bidInfoDetailView blindBaseViewModel:vm];
    
    [self.remind blindCollectionVM:vm];

    [self.fundsBoardView showTransView:vm];

    [self.footView showTransView:vm];
//
//    [self.investButton showTransView:vm];
    
    [vm setModel:_batchPageModel];

}


@end
