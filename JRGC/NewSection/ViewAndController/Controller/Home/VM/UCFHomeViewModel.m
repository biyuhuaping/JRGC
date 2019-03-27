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
    [self.dataArray removeAllObjects];
    
    [self getUserAllStatue];
    [self getBannerData];
    [self addUserGuideData];
    [self getBidListData];

    
}
- (void)getUserAllStatue
{
    if (SingleUserInfo.loginData.userInfo.userId.length > 0) {
        UCFUserAllStatueRequest *request1 = [[UCFUserAllStatueRequest alloc] initWithUserId:SingleUserInfo.loginData.userInfo.userId];
        request1.animatingView = _loaingSuperView;
        [request1 setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSDictionary *dic = request.responseObject;
            NSDictionary *userDict = dic[@"data"][@"userSatus"];
            SingleUserInfo.loginData.userInfo.zxOpenStatus = [NSString stringWithFormat:@"%@",userDict[@"zxOpenStatus"]];
            SingleUserInfo.loginData.userInfo.openStatus = [NSString stringWithFormat:@"%@",userDict[@"openStatus"]];
            SingleUserInfo.loginData.userInfo.nmAuthorization = [userDict[@"nmGoldAuthStatus"] boolValue];
            SingleUserInfo.loginData.userInfo.isNewUser = [userDict[@"isNew"] boolValue];
            SingleUserInfo.loginData.userInfo.isRisk = [userDict[@"isRisk"] boolValue];
            SingleUserInfo.loginData.userInfo.isAutoBid = [userDict[@"isAutoBid"] boolValue];
            SingleUserInfo.loginData.userInfo.zxAuthorization = [NSString stringWithFormat:@"%@",userDict[@"zxAuthorization"]];
            SingleUserInfo.loginData.userInfo.isCompanyAgent = [userDict[@"company"] boolValue];
            [SingleUserInfo setUserData:SingleUserInfo.loginData];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
        }];
        [request1 start];
    }
}
- (void)getBannerData
{
    @PGWeakObj(self);
    
    //获取banner数据
    UCFHomeBannerApi *api = [[UCFHomeBannerApi alloc] init];
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        UCFNewBannerModel *bannerModel = request.responseJSONModel;
        selfWeak.bannerModel = bannerModel;
        if (bannerModel.ret) {
            NSMutableArray *imgsArr = [NSMutableArray arrayWithCapacity:10];
            for (Banner *bannermodel in bannerModel.data.banner) {
                [imgsArr addObject:bannermodel.thumb];
            }
            selfWeak.imagesArr = imgsArr;
            
        } else {
            
        }
        NSString *siteNotice = bannerModel.data.siteNoticeMap.siteNotice;
        if (siteNotice.length > 0) {
            selfWeak.siteNoticeStr = siteNotice;
        }
        //推荐array
        if (bannerModel.data.recommendBanner.count > 0) {
            NSMutableArray *recommendArr = [NSMutableArray arrayWithCapacity:10];
            for (RecommendBanner *model in bannerModel.data.recommendBanner) {
                [recommendArr addObject:model.thumb];
//                [recommendArr addObject:@"https://www.baidu.com/img/bd_logo1.png?where=super"];
            }
            selfWeak.recommendBannerArray = recommendArr;
        }
        //coinBanner
        if (bannerModel.data.coinBanner.count > 0) {
            NSMutableArray *coinBannerArr = [NSMutableArray arrayWithCapacity:10];
            for (CoinBanner *model in bannerModel.data.coinBanner) {
                [coinBannerArr addObject:model.thumb];
            }
            selfWeak.coinBannerArray = coinBannerArr;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
    [api start];
}
- (void)addUserGuideData
{
    NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
    if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] >= 4 && SingleUserInfo.loginData.userInfo.isRisk) {
        SEL sel = NSSelectorFromString(@"reflectDataModel:");
        CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFOldUserNoticeCell" title:@"" showInfoMethod:sel heightOfCell:140];
        data1.dataModel = self.siteNoticeStr;
        [section1 addObject:data1];
    } else {
        //新手引导
        CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFNewUserGuideTableViewCell" title:@"新手入门" showInfoMethod:nil heightOfCell:185];
        [section1 addObject:data1];
    }
    
    [self.dataArray addObject:section1];
    //给反射标识赋值
    self.modelListArray = self.dataArray;
    
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
    UCFMallProductApi *mallRequest = [[UCFMallProductApi alloc] initWithPageType:@"home"];
    mallRequest.animatingView = _loaingSuperView;
    [mallRequest setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [selfWeak dealMallRequestData:request];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
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
                //                    1新手 2 智能出借 3 优质债权
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
                        CellConfig *data2_1 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"新手专享" showInfoMethod:sel heightOfCell:((ScreenWidth - 30) * 6 /23)];
                        UCFCellDataModel *dataMode = [UCFCellDataModel new];
                        dataMode.modelType = @"coinArray";
                        dataMode.data1 = self.coinBannerArray;
                        data2_1.dataModel = dataMode;
                        [section2 addObject:data2_1];
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
                        CellConfig *data2_1 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"新手专享" showInfoMethod:nil heightOfCell:((ScreenWidth - 30) * 6 /23)];
                        UCFCellDataModel *dataMode = [UCFCellDataModel new];
                        dataMode.modelType = @"coinArray";
                        dataMode.data1 = self.coinBannerArray;
                        data2_1.dataModel = dataMode;
                        [section3 addObject:data2_1];
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
                        CellConfig *data2_1 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"新手专享" showInfoMethod:nil heightOfCell:((ScreenWidth - 30) * 6 /23)];
                        UCFCellDataModel *dataMode = [UCFCellDataModel new];
                        dataMode.modelType = @"coinArray";
                        dataMode.data1 = self.coinBannerArray;
                        data2_1.dataModel = dataMode;
                        [section4 addObject:data2_1];
                    }
                    [self.dataArray addObject:section4];
                }
            }
        }
        //给反射标识赋值
        self.modelListArray = self.dataArray;
    } else {
        ShowMessage(model.message);
    }
    [self getMallData];

    
}
- (void)dealMallRequestData:(YTKBaseRequest *)request
{
    UCFHomeMallDataModel *model = request.responseJSONModel;
    SEL sel = NSSelectorFromString(@"reflectDataModel:");
    if (model.ret) {
        CellConfig *data3_0 = [CellConfig cellConfigWithClassName:@"UCFShopPromotionCell" title:@"商城特惠" showInfoMethod:sel heightOfCell:(ScreenWidth - 30) * 6 /23 + 160];
        UCFCellDataModel *dataMode = [UCFCellDataModel new];
        dataMode.modelType = @"mall";
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (UCFhomeMallbannerlist *bannerModel in model.data.mallBannerList) {
            [arr addObject:bannerModel.thumb];
        }
        dataMode.data1 =  arr;
        dataMode.data2 = model.data.mallRecommends;
        NSMutableArray *section3 = [NSMutableArray arrayWithCapacity:1];
        data3_0.dataModel = dataMode;
        [section3 addObject:data3_0];
        [self.dataArray addObject:section3];
        
        NSMutableArray *section4 = [NSMutableArray arrayWithCapacity:1];
        CellConfig *data4_0 = [CellConfig cellConfigWithClassName:@"UCFBoutiqueCell" title:@"商城精选" showInfoMethod:sel heightOfCell:150];
         UCFCellDataModel *dataMode1 = [UCFCellDataModel new];
        dataMode1.modelType = @"mallDiscounts";
        dataMode1.data1 = model.data.mallDiscounts;
        data4_0.dataModel = dataMode1;
        [section4 addObject:data4_0];
        
        [self.dataArray addObject:section4];
    } else {
        ShowMessage(model.message);
    }
    CellConfig *data5_0 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"推荐内容" showInfoMethod:sel heightOfCell:((ScreenWidth - 30) * 6 /23)];
    UCFCellDataModel *mallDataMode = [UCFCellDataModel new];
    mallDataMode.modelType = @"recommend";
    mallDataMode.data1 = self.recommendBannerArray;
    data5_0.dataModel = mallDataMode;
    NSMutableArray *section5 = [NSMutableArray arrayWithCapacity:1];
    [section5 addObject:data5_0];
    [self.dataArray addObject:section5];
    self.modelListArray = self.dataArray;
}

- (void)cycleViewSelectIndex:(NSInteger)index
{
    Banner *bannermodel = self.bannerModel.data.banner[index];
    UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
    webView.rootVc = _rootViewController;
    webView.baseTitleType = @"lunbotuhtml";
    webView.url = bannermodel.url;
    webView.navTitle = bannermodel.title;
    webView.dicForShare.url = bannermodel.url;
    webView.dicForShare.thumb = bannermodel.thumb;
    webView.title = bannermodel.title;
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
