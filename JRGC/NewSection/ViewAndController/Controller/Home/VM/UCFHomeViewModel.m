//
//  UCFHomeViewModel.m
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHomeViewModel.h"
#import "UCFHomeBannerApi.h"
#import "UCFNewBannerModel.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
#import "UCFCellDataModel.h"

@interface UCFHomeViewModel ()
@property(nonatomic, strong)UCFNewBannerModel *bannerModel;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation UCFHomeViewModel
- (void)fetchNetData
{
    if (SingleUserInfo.loginData.userInfo.userId.length > 0 && (SingleUserInfo.loginData.userInfo.isRisk == NO || SingleUserInfo.loginData.userInfo.isAutoBid == NO)) {
        @PGWeakObj(self);
        [SingleUserInfo requestUserAllStatueWithView:_rootViewController.view];
        SingleUserInfo.requestUserbackBlock = ^(BOOL finish) {
            [selfWeak beginBatchRequest];
        };
    } else {
        [self beginBatchRequest];
    }
//    if (self.isFetchDataLoading) {
//        return;
//    }
//    self.isFetchDataLoading = YES;
//    [self.dataArray removeAllObjects];
//    [self getBannerData];
//
//    if (SingleUserInfo.loginData.userInfo.userId.length > 0 && (SingleUserInfo.loginData.userInfo.isRisk == NO || SingleUserInfo.loginData.userInfo.isAutoBid == NO)) {
//        [self getUserAllStatue];
//    } else {
//        [self addUserGuideData];
//        [self getBidListData];
//    }

}
- (void)beginBatchRequest
{
    //获取banner数据
    @PGWeakObj(self);
    UCFHomeBannerApi *bannerRequest = [[UCFHomeBannerApi alloc] init];
    UCFHomeListRequest *bidListrequest = [[UCFHomeListRequest alloc] init];
    UCFMallProductApi *mallRequest = [[UCFMallProductApi alloc] initWithPageType:@"index"];
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[bannerRequest , bidListrequest,mallRequest]];
    if (_rootViewController.view.window != nil) {
        batchRequest.animatingView = _rootViewController.view;
    }
    
    [batchRequest setCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        [selfWeak.dataArray removeAllObjects];
        NSArray *requests = batchRequest.requestArray;
        BaseRequest *receiptrRequest0 = requests[0];
        if ([receiptrRequest0 isKindOfClass:[UCFHomeBannerApi class]]) {
            [selfWeak dealBannerData:(UCFHomeBannerApi *)receiptrRequest0];
        }
        [selfWeak addUserGuideData];

        BaseRequest *receiptrRequest1 = requests[1];
        if ([receiptrRequest1 isKindOfClass:[UCFHomeListRequest class]]) {
            [selfWeak dealRequestData:receiptrRequest1];
        }
        BaseRequest *receiptrRequest2 = requests[2];
        if ([receiptrRequest2 isKindOfClass:[UCFMallProductApi class]]) {
            [selfWeak dealMallRequestData:receiptrRequest2];
        }
        //给反射标识赋值
        selfWeak.modelListArray = selfWeak.dataArray;
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        //给反射标识赋值
        selfWeak.modelListArray = selfWeak.dataArray;
    }];
    [batchRequest start];
}
- (void)getUserAllStatue
{
    @PGWeakObj(self);
    SingleUserInfo.requestUserbackBlock = ^(BOOL finish) {
        [selfWeak addUserGuideData];
        [selfWeak getBidListData];
    };
    
    [SingleUserInfo requestUserAllStatueWithView:_rootViewController.view];
}
- (void)getListData
{

}
- (void)getBannerData
{
    @PGWeakObj(self);
    
    //获取banner数据
    UCFHomeBannerApi *api = [[UCFHomeBannerApi alloc] init];
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [selfWeak dealBannerData:request];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
    [api start];
}
- (void)dealBannerData:(YTKBaseRequest *)request
{
    UCFNewBannerModel *bannerModel = request.responseJSONModel;
    self.bannerModel = bannerModel;
    if (bannerModel.ret) {
        NSMutableArray *imgsArr = [NSMutableArray arrayWithCapacity:10];
        for (Banner *bannermodel in bannerModel.data.banner) {
            [imgsArr addObject:bannermodel.thumb];
        }
        self.imagesArr = imgsArr;
    } else {
        
    }
    NSString *siteNotice = bannerModel.data.siteNoticeMap.siteNotice;
    if (siteNotice.length > 0) {
        self.siteNoticeStr = siteNotice;
    }
    //推荐array
    if (bannerModel.data.recommendBanner.count > 0) {
        NSMutableArray *recommendArr = [NSMutableArray arrayWithCapacity:10];
        for (RecommendBanner *model in bannerModel.data.recommendBanner) {
            [recommendArr addObject:model];
        }
        self.recommendBannerArray = recommendArr;
    }
    //coinBanner
    if (bannerModel.data.coinBanner.count > 0) {
        NSMutableArray *coinBannerArr = [NSMutableArray arrayWithCapacity:10];
        for (CoinBanner *model in bannerModel.data.coinBanner) {
            [coinBannerArr addObject:model];
        }
        self.coinBannerArray = coinBannerArr;
    }
//    if (self.dataArray.count > 0) {
//
//        CellConfig *data1 =  [[self.dataArray objectSafeAtIndex:0] objectSafeAtIndex:0];
//        if ([data1.className isEqualToString:@"UCFOldUserNoticeCell"]) {
//            data1.dataModel = self.bannerModel.data.siteNoticeMap;
//        }
//        //给反射标识赋值
//        //            selfWeak.modelListArray = self.dataArray;
//    }
}
- (void)addUserGuideData
{
    NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
    if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] >= 4 && SingleUserInfo.loginData.userInfo.isRisk && !SingleUserInfo.loginData.userInfo.isNewUser) {
        SEL sel = NSSelectorFromString(@"reflectDataModel:");
        CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFOldUserNoticeCell" title:@"" showInfoMethod:sel heightOfCell:140];
        data1.dataModel = self.bannerModel.data.siteNoticeMap;
        [section1 addObject:data1];
    } else {
        //新手引导  老用户已经做了风险测评 但是未设置交易密码 或者白名单用户
        CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFNewUserGuideTableViewCell" title:@"新手入门" showInfoMethod:nil heightOfCell:SingleUserInfo.loginData.userInfo.isRisk && [SingleUserInfo.loginData.userInfo.openStatus intValue] > 3 ? 185 - 55: 185];
        [section1 addObject:data1];
    }
    
    [self.dataArray addObject:section1];
    //给反射标识赋值
//    self.modelListArray = self.dataArray;
    
}
- (void)getBidListData
{
    @PGWeakObj(self);
    UCFHomeListRequest *request = [[UCFHomeListRequest alloc] init];
    request.animatingView = _loaingSuperView;
    [request setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [selfWeak dealRequestData:request];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [selfWeak getMallData];
    }];
    [request start];
}
- (void)getMallData
{
    @PGWeakObj(self);
    UCFMallProductApi *mallRequest = [[UCFMallProductApi alloc] initWithPageType:@"index"];
    mallRequest.animatingView = _loaingSuperView;
    [mallRequest setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [selfWeak dealMallRequestData:request];
//        selfWeak.isFetchDataLoading = NO;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        selfWeak.isFetchDataLoading = NO;
    }];
    [mallRequest start];
} 
- (void)dealRequestData:(YTKBaseRequest *)request
{
    
    UCFNewHomeListModel *model = request.responseJSONModel;
    if (model.ret) {
        //添加标列表信息
        if (model.data.group.count > 0) {
            NSArray *groupArr = model.data.group;
            for (int i = 0; i < groupArr.count; i++) {
                UCFNewHomeGroupModel *groupModel = groupArr[i];
                //1新手 2 智能出借 3 优质债权
                if ([groupModel.type isEqualToString:@"1"]) {
                    NSArray *prdList = groupModel.prdList;
                    SEL sel = NSSelectorFromString(@"reflectDataModel:");
                    NSMutableArray *section2 = [NSMutableArray arrayWithCapacity:1];
                    for (int j = 0; j < prdList.count; j++) {
                        UCFNewHomeListPrdlist *prdModel = prdList[j];
                        prdModel.groupType = @"1"; //新手标
                        CellConfig *data2_0 = [CellConfig cellConfigWithClassName:@"UCFNewUserBidCell" title:@"新手专享" showInfoMethod:sel heightOfCell:150 + 15];
                        data2_0.dataModel = prdModel;
                        [section2 addObject:data2_0];
                    }
                    //因为最后要添加一个广告促销位，但是这个广告位可放在新手 智能出借 优质债权的每一组的最后，因此要看谁是最后一组，把广告位追加到最后一组
                    if (i == groupArr.count - 1) {
                        //添加促销广告banner
                        [self addbidListBottomAd:section2 andSel:sel];
                    }
                    [self.dataArray addObject:section2];
                }
                else if ([groupModel.type isEqualToString:@"2"]) { //
                    NSArray *prdList = groupModel.prdList;
                    SEL sel = NSSelectorFromString(@"reflectDataModel:");
                    NSMutableArray *section3 = [NSMutableArray arrayWithCapacity:1];
                    for (int j = 0; j < prdList.count; j++) {
                        UCFNewHomeListPrdlist *prdModel = prdList[j];
                        prdModel.groupType = @"2";
                        CellConfig *data3_0 = [CellConfig cellConfigWithClassName:@"UCFNewUserBidCell" title:@"智能出借" showInfoMethod:sel heightOfCell:150 + 15];
                        data3_0.dataModel = prdModel;
                        [section3 addObject:data3_0];
                    }
                    if (i == groupArr.count - 1) {
                        //添加促销广告banner
                        [self addbidListBottomAd:section3 andSel:sel];
                    }
                    [self.dataArray addObject:section3];
                }
                else if ([groupModel.type isEqualToString:@"3"]) {
                    NSArray *prdList = groupModel.prdList;
                    SEL sel = NSSelectorFromString(@"reflectDataModel:");
                    NSMutableArray *section4 = [NSMutableArray arrayWithCapacity:1];
                    for (int j = 0; j < prdList.count; j++) {
                        UCFNewHomeListPrdlist *prdModel = prdList[j];
                        prdModel.groupType = @"3";
                        CellConfig *data4_0 = [CellConfig cellConfigWithClassName:@"UCFNewUserBidCell" title:@"优质债权" showInfoMethod:sel heightOfCell:150 + 15];
                        data4_0.dataModel = prdModel;
                        [section4 addObject:data4_0];
                    }
                    
                    if (i == groupArr.count - 1) {
                        //添加促销广告banner
                        [self addbidListBottomAd:section4 andSel:sel];
   
                    }
                    [self.dataArray addObject:section4];
                }
            }
        }
        for (int i = 0; i < self.dataArray.count; i++) {
            NSArray *arr = [self.dataArray objectSafeAtIndex:i];
            for (int j = 0; j < arr.count; j++) {
                CellConfig *data = [arr objectAtIndex:j];
                if ([data.className isEqualToString:@"UCFNewUserBidCell"]) {
                    if (i == self.dataArray.count - 1) {
                        data.heightOfCell = 150 + 15;
                    }
                    if (j == arr.count - 1) {
                        data.heightOfCell = 150;
                    }
                }
            }
        }
        

    } else {
        ShowCodeMessage(model.code, model.message);
    }
//    [self getMallData];

    
}
- (void)addbidListBottomAd:(NSMutableArray *)section andSel:(SEL)sel
{
    if (SingleUserInfo.loginData.userInfo.jyIsShow) {
        CellConfig *data2_0 = [CellConfig cellConfigWithClassName:@"UCFJYRouteTableViewCell" title:@"新手专享" showInfoMethod:sel heightOfCell:((ScreenWidth - 30) * 9 /23) + 15];
        [section addObject:data2_0];
    }
    CellConfig *data2_1 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"新手专享" showInfoMethod:sel heightOfCell:((ScreenWidth - 30) * 6 /23)];
    UCFCellDataModel *dataMode = [UCFCellDataModel new];
    dataMode.modelType = @"coinArray";
    dataMode.data1 = self.coinBannerArray;
    data2_1.dataModel = dataMode;
    [section addObject:data2_1];
}
- (void)dealMallRequestData:(YTKBaseRequest *)request
{
    UCFHomeMallDataModel *model = request.responseJSONModel;
    
    SEL sel = NSSelectorFromString(@"reflectDataModel:");
    if (model.ret) {
        
        self.remcommendUrl = model.data.mallDiscountsUrl;
        self.boutiqueUrl = model.data.mallSelectedUrl;
        
        CGFloat bannerHegit = model.data.mallBannerList.count != 0 ? (ScreenWidth - 30) * 6 /23 : 0;
        CGFloat shopHeight = model.data.mallDiscounts.count != 0 ? (ScreenWidth - 30)/3 + 48 : 0 ;
        
        CellConfig *data3_0 = [CellConfig cellConfigWithClassName:@"UCFShopPromotionCell" title:@"商城特惠" showInfoMethod:sel heightOfCell:(bannerHegit  + shopHeight)];
        UCFCellDataModel *dataMode = [UCFCellDataModel new];
        dataMode.modelType = @"mall";
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (UCFhomeMallbannerlist *bannerModel in model.data.mallBannerList) {
            [arr addObject:bannerModel];
        }
        dataMode.data1 =  arr;
        dataMode.data2 = model.data.mallDiscounts;
        NSMutableArray *section3 = [NSMutableArray arrayWithCapacity:1];
        data3_0.dataModel = dataMode;
        if (shopHeight > 0.01) {
            [section3 addObject:data3_0];
            [self.dataArray addObject:section3];
        }
        
        CGFloat boutiqueHeight = model.data.mallSelected.count != 0 ? 105 + 48 : 0;
        NSMutableArray *section4 = [NSMutableArray arrayWithCapacity:1];
        CellConfig *data4_0 = [CellConfig cellConfigWithClassName:@"UCFBoutiqueCell" title:@"商城精选" showInfoMethod:sel heightOfCell:boutiqueHeight];
        UCFCellDataModel *dataMode1 = [UCFCellDataModel new];
        dataMode1.modelType = @"mallDiscounts";
        dataMode1.data1 = model.data.mallSelected;
        data4_0.dataModel = dataMode1;
        [section4 addObject:data4_0];
        if (boutiqueHeight > 0.01) {
            [self.dataArray addObject:section4];
        }
    } else {
        ShowCodeMessage(model.code, model.message);
    }
    if (self.recommendBannerArray.count > 0) {
        CellConfig *data5_0 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"内容推荐" showInfoMethod:sel heightOfCell:((ScreenWidth - 30) * 6 /23)];
        UCFCellDataModel *mallDataMode = [UCFCellDataModel new];
        mallDataMode.modelType = @"recommend";
        mallDataMode.data1 = self.recommendBannerArray;
        data5_0.dataModel = mallDataMode;
        NSMutableArray *section5 = [NSMutableArray arrayWithCapacity:1];
        [section5 addObject:data5_0];
        [self.dataArray addObject:section5];
    }
//    self.modelListArray = self.dataArray;
}

- (void)cycleViewSelectIndex:(NSInteger)index
{
    Banner *bannermodel = self.bannerModel.data.banner[index];
    UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
    webView.rootVc = _rootViewController;
    webView.baseTitleType = @"lunbotuhtml";
    webView.url = bannermodel.url;
    webView.navTitle = bannermodel.title;
    webView.title = bannermodel.title;

    UCFCycleModel *shareModel = [UCFCycleModel new];
    shareModel.url = bannermodel.url;
    shareModel.thumb = bannermodel.thumb;
    shareModel.title = bannermodel.title;
    shareModel.desc = bannermodel.url;
    webView.dicForShare = shareModel;
    webView.hidesBottomBarWhenPushed = YES;
    [_rootViewController.rt_navigationController pushViewController:webView animated:YES];
}
- (NSMutableArray *)recommendBannerArray
{
    if (!_recommendBannerArray) {
        _recommendBannerArray = [NSMutableArray array];
    }
    return _recommendBannerArray;
}
- (NSMutableArray *)coinBannerArray
{
    if (!_coinBannerArray) {
        _coinBannerArray = [NSMutableArray array];
    }
    return _coinBannerArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
