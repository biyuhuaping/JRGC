//
//  UCFAssetAccountViewEarningsController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAssetAccountViewEarningsController.h"
#import "UCFAccountCenterAlreadyProfitModel.h"
#import "UCFAccountCenterAlreadyProfitApi.h"
#import "UCFAssetAccountViewTotalHeaderView.h"
#import "UCFAccountAssetsProofViewController.h"
#import "NZLabel.h"
#import "BaseScrollview.h"
#import "PieModel.h"
#import "UCFAssetAccountViewEarningsListView.h"

@interface UCFAssetAccountViewEarningsController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UCFAssetAccountViewTotalHeaderView *headView;

@property (nonatomic, strong) UCFAccountCenterAlreadyProfitModel *model;

@property (nonatomic, strong) UCFAssetAccountViewEarningsListView *listView;
@end

@implementation UCFAssetAccountViewEarningsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview: self.scrollView];
    [self.scrollView addSubview:self.scrollLayout];
    [self.scrollLayout addSubview:self.headView];
    [self.scrollLayout addSubview:self.listView];
    [self request];
}
- (BaseScrollview *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [BaseScrollview new];
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _scrollView.leftPos.equalTo(@0);
        _scrollView.rightPos.equalTo(@0);
        _scrollView.topPos.equalTo(@0);
        _scrollView.bottomPos.equalTo(@0);
    }
    return _scrollView;
}

- (MyLinearLayout *)scrollLayout
{
    if (nil == _scrollLayout) {
        _scrollLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _scrollLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _scrollLayout.heightSize.lBound(self.scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _scrollLayout;
}

- (UCFAssetAccountViewTotalHeaderView *)headView
{
    if (nil ==_headView) {
        _headView = [[UCFAssetAccountViewTotalHeaderView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 290)];
        [_headView.amountShownBtn addTarget:self action:@selector(jumpAccountCapital:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.totalAssetsBtn addTarget:self action:@selector(jumpAccountCapital:) forControlEvents:UIControlEventTouchUpInside];
        _headView.myTop = 0;
        _headView.myLeft = 0;
    }
    return _headView;
}

- (UCFAssetAccountViewEarningsListView *)listView
{
    if (nil == _listView) {
        
        _listView = [[UCFAssetAccountViewEarningsListView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 279)];//不带标题,只显示列表
        _listView.myTop =0;
        _listView.myLeft = 0;
        if (!self.zxAccountIsShow) {
            _listView.zxProfitLayout.myVisibility = MyVisibility_Gone;
        }
        if (!self.nmAccountIsShow) {
            _listView.goldProfitLayout.myVisibility = MyVisibility_Gone;
        }
    }
    return _listView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)request
{
    UCFAccountCenterAlreadyProfitApi * request = [[UCFAccountCenterAlreadyProfitApi alloc] init];
    request.animatingView = self.view;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogInfo(@"%@", request.responseJSONModel);
        self.model = [request.responseJSONModel copy];
        //        DDLogDebug(@"---------%@",model);
        if (self.model.ret == YES) {
            
            [self reloadView:self.model];
        }
        else{
//            ShowMessage(self.model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
- (void)reloadView:(UCFAccountCenterAlreadyProfitModel *)model
{
    NSMutableArray *array = [NSMutableArray array];
    PieModel *wjProfitModel = [[PieModel alloc]init];
    wjProfitModel.count = [model.data.wjProfit floatValue];
    wjProfitModel.color = PNBlue;
    [array addObject:wjProfitModel];
    
    PieModel *zxProfitModel = [[PieModel alloc]init];
    zxProfitModel.count = [model.data.zxProfit floatValue];
    zxProfitModel.color = PNOrange;
    if (self.zxAccountIsShow) {
        [array addObject:zxProfitModel];
    }
    
    PieModel *goldProfitModel = [[PieModel alloc]init];
    goldProfitModel.count = [model.data.goldProfit floatValue];
    goldProfitModel.color = PNYellow;
    if (self.nmAccountIsShow) {
        [array addObject:goldProfitModel];
    }
    
    PieModel *couponProfitModel = [[PieModel alloc]init];
    couponProfitModel.count = [model.data.couponProfit floatValue];
    couponProfitModel.color = PNLightBlue;
    [array addObject:couponProfitModel];
    
    
    PieModel *beanProfitModel = [[PieModel alloc]init];
    beanProfitModel.count = [model.data.beanProfit floatValue];
    beanProfitModel.color = PNPinkRed;
    [array addObject:beanProfitModel];
    
    PieModel *balanceProfitModel = [[PieModel alloc]init];
    balanceProfitModel.count = [model.data.balanceProfit floatValue];
    balanceProfitModel.color = PNLightGreen;
    [array addObject:balanceProfitModel];
    
    [self.headView reloadPieView:[array copy] andTotalAssets:model.data.totalProfit];
    
    [self.listView reloadAccountContent:self.model];
    
}
- (void)jumpAccountCapital:(UIButton *)btn
{
   if (btn.tag == 1003) {
        //资产证明
        if (nil != self.model && self.model.ret){
            UCFAccountAssetsProofViewController * assetProofVC = [[UCFAccountAssetsProofViewController alloc]initWithNibName:@"UCFAccountAssetsProofViewController" bundle:nil];
            assetProofVC.totalAssetStr = self.model.data.totalProfit;
            [self.rt_navigationController pushViewController:assetProofVC animated:YES];
        }
    }
    else if (btn.tag == 1004) {
        //资产说明
        if (nil != self.model && self.model.ret)
        {
            
           //已收收益 包括金融工场平台的所有已回款项目的利息，以及已起息项目中的返现券利息、已使用工豆利息和余额生息利息。
            UCFPopViewWindow *pop = [UCFPopViewWindow new];
            pop.contentStr = @"包括金融工场平台的所有已回款项目的利息，以及已起息项目中的返现券利息、已使用工豆利息和余额生息利息。";
            pop.type = POPMessageIKnowWindowButton;
            pop.titletStr = @"已收收益";
            pop.controller = self;
            [pop startPopView];
            
        }
    }
}
@end
