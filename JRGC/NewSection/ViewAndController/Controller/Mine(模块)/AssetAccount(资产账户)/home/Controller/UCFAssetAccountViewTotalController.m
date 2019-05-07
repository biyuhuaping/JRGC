 //
//  UCFAssetAccountViewTotalController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAssetAccountViewTotalController.h"
#import "NZLabel.h"
#import "BaseScrollview.h"

#import "UCFAccountCenterAssetsOverViewModel.h"
#import "UCFAccountCenterAssetsOverViewApi.h"
#import "PieModel.h"

#import "UCFAssetAccountViewTotalHeaderView.h"
#import "UCFAssetAccountViewTotalHeaderAccountView.h"
#import "UCFAssetAccountViewTotalListView.h"
#import "UCFAssetAccountViewTotalTitleListView.h"
#import "UCFAccountAssetsProofViewController.h"
#import "GoldTransactionRecordViewController.h"
#import "UCFAccountDetailViewController.h"
#import "UCFAccountDetailWZAndZXViewController.h"
@interface UCFAssetAccountViewTotalController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UCFAssetAccountViewTotalHeaderAccountView *headerAccountView;

@property (nonatomic, strong) UCFAssetAccountViewTotalHeaderView *headView;

@property (nonatomic, strong) UCFAssetAccountViewTotalListView *listView;

@property (nonatomic, strong) UCFAssetAccountViewTotalTitleListView *titleListView;

@property (nonatomic, strong) UCFAccountCenterAssetsOverViewModel *model;

@property (nonatomic, strong) BaseScrollview *listScrollView;

@property (nonatomic, strong) MyRelativeLayout *listScrollLayout;
@end

@implementation UCFAssetAccountViewTotalController

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
    [self.scrollLayout addSubview:self.headerAccountView];
    [self.scrollLayout addSubview:self.listScrollView];
    [self.listScrollView addSubview:self.listScrollLayout];
    
    [self request];
}
- (BaseScrollview *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [BaseScrollview new];
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
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
        _scrollLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _scrollLayout.heightSize.lBound(self.scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _scrollLayout;
}

- (BaseScrollview *)listScrollView
{
    if (nil == _listScrollView ){
        _listScrollView = [BaseScrollview new];
        _listScrollView.scrollEnabled = YES;
        //隐藏水平滚动条
        _listScrollView.showsHorizontalScrollIndicator=NO;
        //设置分页
        _listScrollView.pagingEnabled=YES;
        _listScrollView.bounces=NO;
        _listScrollView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _listScrollView.topPos.equalTo(self.headerAccountView.bottomPos);
        _listScrollView.leftPos.equalTo(@0);
        _listScrollView.myWidth = PGScreenWidth;
        if (self.model.data.assetList.count > 1) {//279 243
             _listScrollView.myHeight = 243;
        }
        else
        {
            _listScrollView.myHeight = 279;
        }
    }
    return _listScrollView;
}

- (MyRelativeLayout *)listScrollLayout
{
//    MyRelativeLayout *aLayout = [MyRelativeLayout new];
//    aLayout.backgroundColor = [UIColor yellowColor];
//    aLayout.widthSize.equalTo(self.listScrollView.widthSize);
//    aLayout.heightSize.equalTo(self.listScrollView.heightSize);
//    aLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
//    aLayout.wrapContentHeight = YES;
//    [self.listScrollView addSubview:aLayout];
    if (nil == _listScrollLayout) {
        _listScrollLayout = [MyRelativeLayout new];
        _listScrollLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _listScrollLayout.heightSize.equalTo(self.listScrollView.heightSize);
        _listScrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _listScrollLayout.wrapContentWidth = YES; //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _listScrollLayout;
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
- (UCFAssetAccountViewTotalHeaderAccountView *)headerAccountView
{
    if (nil ==_headerAccountView) {
        _headerAccountView = [[UCFAssetAccountViewTotalHeaderAccountView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 63)];
        _headerAccountView.topPos.equalTo(self.headView.bottomPos);
        _headerAccountView.myLeft = 0;
    }
    return _headerAccountView;
}

- (UCFAssetAccountViewTotalListView *)listView
{
    if (nil == _listView) {

        _listView = [[UCFAssetAccountViewTotalListView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 279)];//不带标题,只显示列表
        _listView.myTop =0;
        [_listView.enterButton setTitle:@"资金流水" forState:UIControlStateNormal];
        _listView.myLeft = 0;
    }
    return _listView;
}
- (UCFAssetAccountViewTotalTitleListView *)titleListView
{
    if (nil == _titleListView) {
        
        _titleListView = [[UCFAssetAccountViewTotalTitleListView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 243)];//带账户标题
        _titleListView.myTop = 0;
        _titleListView.myLeft = 0;
    }
    return _titleListView;
}

- (void)request
{
    UCFAccountCenterAssetsOverViewApi * request = [[UCFAccountCenterAssetsOverViewApi alloc] init];
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
            ShowCodeMessage(self.model.code, self.model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
       
    }];
}

- (void)reloadView:(UCFAccountCenterAssetsOverViewModel *)model
{
    if (model.data.assetList.count <= 1) {
        
        UCFAccountCenterAssetsOverViewAssetlist *list = model.data.assetList.firstObject;
        
        PieModel *availBalanceModel = [[PieModel alloc]init];
        availBalanceModel.count = [list.availBalance floatValue];
        availBalanceModel.color = PNBlue;

        PieModel *waitPrincipalModel = [[PieModel alloc]init];
        waitPrincipalModel.count = [list.waitPrincipal floatValue];
        waitPrincipalModel.color = PNOrange;

        PieModel *waitInterestModel = [[PieModel alloc]init];
        waitInterestModel.count = [list.waitInterest floatValue];
        waitInterestModel.color = PNYellow;

        PieModel *frozenBalanceModel = [[PieModel alloc]init];
        frozenBalanceModel.count = [list.frozenBalance floatValue];
        frozenBalanceModel.color = PNPinkRed;
        
        [self.headView reloadPieView:@[availBalanceModel,waitPrincipalModel,waitInterestModel,frozenBalanceModel] andTotalAssets:model.data.totalAsset];
        self.headerAccountView.myVisibility = MyVisibility_Gone;
        [self.listScrollLayout addSubview:self.listView];
        [self.listView reloadAccountContent:model];
        [self.listView.enterButton addTarget:self action:@selector(jumpAccountCapital:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        self.listScrollLayout.myWidth = self.model.data.assetList.count *PGScreenWidth;
        NSMutableArray *pieArray = [NSMutableArray array];
        @PGWeakObj(self);
        [model.data.assetList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"顺序遍历array：%zi-->%@", idx, obj);
            //“P2P” :微金账户 “ZX”：尊享账户 "GOLD":黄金账户
            UCFAccountCenterAssetsOverViewAssetlist *asset = [model.data.assetList objectAtIndex:idx];
            PieModel *availBalanceModel = [[PieModel alloc]init];
            availBalanceModel.count = [asset.availBalance floatValue];
            
            if ([asset.type isEqualToString:@"P2P"]) {
                availBalanceModel.color = PNBlue;
            }
            else if ([asset.type isEqualToString:@"ZX"]) {
                availBalanceModel.color = PNOrange;
            }
            else if ([asset.type isEqualToString:@"GOLD"]) {
                availBalanceModel.color = PNYellow;
            }
            
            [pieArray addObject: availBalanceModel];
            
            UCFAssetAccountViewTotalTitleListView *titleListView = [[UCFAssetAccountViewTotalTitleListView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 265)];//带账户标题
            titleListView.myTop = 0;
            titleListView.myLeft = idx *PGScreenWidth;
            [titleListView reloadAccountContent:asset];
            [titleListView.enterButton addTarget:self action:@selector(jumpAccountCapital:) forControlEvents:UIControlEventTouchUpInside];
            [selfWeak.listScrollLayout addSubview:titleListView];
        }];
        
        [self.headView reloadPieView:pieArray andTotalAssets:model.data.totalAsset];
        self.headerAccountView.myVisibility = MyVisibility_Visible;
        [self.headerAccountView reloadAccountLayout:model];
        
        
    }
}

- (void)jumpAccountCapital:(UIButton *)btn
{
    if (btn.tag == 1000) {
        //微金流水
        UCFAccountDetailWZAndZXViewController *accountDetailVC = [[UCFAccountDetailWZAndZXViewController alloc] init];
        accountDetailVC.accoutType = SelectAccoutTypeP2P;
        [self.rt_navigationController pushViewController:accountDetailVC animated:YES];
    }
    else if (btn.tag == 1001) {
        //尊享流水
        UCFAccountDetailViewController *accountDetailVC = [[UCFAccountDetailViewController alloc] initWithNibName:@"UCFAccountDetailViewController" bundle:nil];
        accountDetailVC.selectedSegmentIndex = 1;
        accountDetailVC.accoutType = SelectAccoutTypeP2P;
        [self.rt_navigationController pushViewController:accountDetailVC animated:YES];
    }
    else if (btn.tag == 1002) {
        //黄金交易记录
        GoldTransactionRecordViewController *vc1 = [[GoldTransactionRecordViewController alloc] initWithNibName:@"GoldTransactionRecordViewController" bundle:nil];
        [self.rt_navigationController pushViewController:vc1 animated:YES];
    }
    else if (btn.tag == 1003) {
        //资产证明
        if (nil != self.model && self.model.ret){
            UCFAccountAssetsProofViewController * assetProofVC = [[UCFAccountAssetsProofViewController alloc]initWithNibName:@"UCFAccountAssetsProofViewController" bundle:nil];
            assetProofVC.totalAssetStr = self.model.data.totalAsset;
            [self.rt_navigationController pushViewController:assetProofVC animated:YES];
        }
    }
    else if (btn.tag == 1004) {
        //资产说明
        if (nil != self.model && self.model.ret) {
            if (self.model.data.assetList.count == 1) {
                //        有微金账户，无尊享黄金账户
                //        总资产=可用余额+待收本金+预期利息+冻结金额
                UCFPopViewWindow *pop = [UCFPopViewWindow new];
                pop.contentStr = @"总资产=可用余额+待收本金+预期利息+冻结金额";
                pop.type = POPMessageIKnowWindowButton;
                pop.titletStr = @"总资产";
                pop.controller = self;
                [pop startPopView];
            }
            if (self.model.data.assetList.count == 2) {
                //        有微金、尊享账户，无黄金账户
                //        总资产=微金账户总资产+尊享账户总资产

                UCFPopViewWindow *pop = [UCFPopViewWindow new];
                pop.contentStr = @"总资产=微金账户总资产+尊享账户总资产";
                pop.type = POPMessageIKnowWindowButton;
                pop.titletStr = @"总资产";
                pop.controller = self;
                [pop startPopView];
            }
            if (self.model.data.assetList.count == 3) {
                //        有微金、尊享、黄金账户
                //        总资产=微金账户总资产+尊享账户总资产+黄金账户总资产

                UCFPopViewWindow *pop = [UCFPopViewWindow new];
                pop.contentStr = @"总资产=微金账户总资产+尊享账户总资产+黄金账户总资产";
                pop.type = POPMessageIKnowWindowButton;
                pop.titletStr = @"总资产";
                pop.controller = self;
                [pop startPopView];
            }
        }
    }
}


//if (SingleUserInfo.loginData.userInfo.isCompanyAgent) {
//    [AuxiliaryFunc showToastMessage:@"企业用户暂不支持开通资产证明，请在个人账户查看" withView:self.view];
//    return;
//}
//UCFAccountAssetsProofViewController * assetProofVC = [[UCFAccountAssetsProofViewController alloc]initWithNibName:@"UCFAccountAssetsProofViewController" bundle:nil];
//assetProofVC.totalAssetStr = self.assetModel.total;
//[self.navigationController pushViewController:assetProofVC animated:YES];
@end
