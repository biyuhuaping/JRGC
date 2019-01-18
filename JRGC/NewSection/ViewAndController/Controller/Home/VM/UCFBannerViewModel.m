//
//  UCFBannerViewModel.m
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBannerViewModel.h"
#import "UCFHomeBannerApi.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
@implementation UCFBannerViewModel
- (void)fetchNetData
{
    UCFHomeBannerApi *api = [[UCFHomeBannerApi alloc] init];
    api.delegate = self;
    [api start];
}
- (void)requestFinished:(YTKBaseRequest *)request {
    
    UCFNewBannerModel *model = request.responseJSONModel;
    self.model = model;
    if (model.ret) {
        NSMutableArray *imgsArr = [NSMutableArray arrayWithCapacity:10];
        for (Banner *bannermodel in model.data.banner) {
            [imgsArr addObject:bannermodel.thumb];
        }
        self.imagesArr = imgsArr;
    } else {
    
    }
    NSString *siteNotice = model.data.siteNoticeMap.siteNotice;
    if (siteNotice.length > 0) {
        self.siteNoticeStr = siteNotice;
    }
    if (model.data.giftBanner.count > 0) {
         Giftbanner *giftModel = [model.data.giftBanner objectAtIndex:0];
         self.giftimageUrl = giftModel.thumb;
    }
    
}

- (void)requestFailed:(YTKBaseRequest *)request {
    
    NSLog(@"failed");
}

- (void)cycleViewSelectIndex:(NSInteger)index
{
    Banner *bannermodel = _model.data.banner[index];
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
@end

