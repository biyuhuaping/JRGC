//
//  UCFHomeViewModel.m
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHomeViewModel.h"

@implementation UCFHomeViewModel
- (void)fetchNetData
{
    if (SingleUserInfo.loginData.userInfo.userId.length > 0) {
        UCFUserAllStatueRequest *request1 = [[UCFUserAllStatueRequest alloc] initWithUserId:SingleUserInfo.loginData.userInfo.userId];
        request1.animatingView = _loaingSuperView;
        [request1 setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSDictionary *dic = request.responseObject;
            NSDictionary *userDict = dic[@"data"][@"userSatus"];
            SingleUserInfo.loginData.userInfo.zxOpenStatus = [NSString stringWithFormat:@"%@",userDict[@"zxOpenStatus"]];
            SingleUserInfo.loginData.userInfo.openStatus = [userDict[@"openStatus"] intValue];
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

    UCFHomeListRequest *request = [[UCFHomeListRequest alloc] init];
    request.animatingView = _loaingSuperView;
    @PGWeakObj(self);
    [request setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [selfWeak dealRequestData:request];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
    [request start];
}
- (void)dealRequestData:(YTKBaseRequest *)request
{
    
    UCFNewHomeListModel *model = request.responseJSONModel;
    if (model.ret) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:5];
        NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];

        if (SingleUserInfo.loginData.userInfo.openStatus >= 4 && SingleUserInfo.loginData.userInfo.isRisk) {
            CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFOldUserNoticeCell" title:@"" showInfoMethod:nil heightOfCell:140];
            [section1 addObject:data1];
        } else {
            //新手引导
             CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFNewUserGuideTableViewCell" title:@"新手入门" showInfoMethod:nil heightOfCell:185];
            [section1 addObject:data1];
        }
        [dataArray addObject:section1];

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
                            CellConfig *data2_1 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"新手专享" showInfoMethod:nil heightOfCell:((ScreenWidth - 30) * 6 /23)];
                            [section2 addObject:data2_1];
                        }
                        [dataArray addObject:section2];
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
                            [section3 addObject:data2_1];
                        }
                        [dataArray addObject:section3];
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
                            [section4 addObject:data2_1];
                        }
                        [dataArray addObject:section4];
                    }
                }
            }
       
        
        
        CellConfig *data3_0 = [CellConfig cellConfigWithClassName:@"UCFShopPromotionCell" title:@"商城特惠" showInfoMethod:nil heightOfCell:(ScreenWidth - 30) * 6 /23 + 160];
        NSMutableArray *section3 = [NSMutableArray arrayWithCapacity:1];
        [section3 addObject:data3_0];
        [dataArray addObject:section3];
        
        CellConfig *data4_0 = [CellConfig cellConfigWithClassName:@"UCFBoutiqueCell" title:@"商城精选" showInfoMethod:nil heightOfCell:150];
        NSMutableArray *section4 = [NSMutableArray arrayWithCapacity:1];
        [section4 addObject:data4_0];
        [dataArray addObject:section4];
        
        CellConfig *data5_0 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"推荐内容" showInfoMethod:@selector(reflectDataModel:) heightOfCell:((ScreenWidth - 30) * 6 /23)];
        NSMutableArray *section5 = [NSMutableArray arrayWithCapacity:1];
        [section5 addObject:data5_0];
        [dataArray addObject:section5];
        //给反射标识赋值
        self.modelListArray = dataArray;
    } else {
        
    }
    

}
@end
