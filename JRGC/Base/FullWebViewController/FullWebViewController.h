//
//  FullWebViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFCycleModel.h"
@interface FullWebViewController : UCFBaseViewController<UIWebViewDelegate>


@property (nonatomic,retain) NSString *sourceVc;
@property (nonatomic,retain) NSString *flageHaveShareBut;//***标记-是否在webview右上角有分享按钮：nil-没有、@“分享”-有
@property (nonatomic,retain) UCFCycleModel *dicForShare;//***返回的banner图数据modle
@property (nonatomic, copy) NSString *localFilePath;
- (id)initWithWebUrl:(NSString*)url title:(NSString*)titleStr;

- (id)initWithHtmlStr:(NSString*)htmlStr title:(NSString *)titleStr;


@end
