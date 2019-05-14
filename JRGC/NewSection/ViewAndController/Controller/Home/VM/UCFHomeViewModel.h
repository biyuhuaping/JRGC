//
//  UCFHomeViewModel.h
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeListRequest.h"
#import "UCFUserAllStatueRequest.h"
#import "CellConfig.h"
#import "UCFMallProductApi.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFHomeViewModel : NSObject

@property(nonatomic, weak)UIView    *loaingSuperView;

@property(nonatomic, strong)NSArray *modelListArray;

/**
 顶部banner数据源
 */
@property(nonatomic, strong)NSArray *imagesArr;

/**
 公告文案
 */
@property(nonatomic, copy)  NSString    *siteNoticeStr;

/**
 推荐banner内容数组
 */
@property(nonatomic, strong)NSMutableArray     *recommendBannerArray;

/**
 <#Description#>
 */
@property(nonatomic, strong)NSMutableArray     *coinBannerArray;

/**
 商城banner
 */
@property(nonatomic, strong)NSArray      *mallBannerList;


/**
 商城推荐查看更多URL
 */
@property(nonatomic, copy)NSString      *remcommendUrl;

/**
 商城精选查看更多URL
 */
@property(nonatomic, copy)NSString      *boutiqueUrl;


@property(nonatomic, weak) UIViewController *rootViewController;

/**
 是否在数据加载中，加载中，不接受第二次，数据刷新
 */
//@property(nonatomic, assign) BOOL  isFetchDataLoading;

- (void)fetchNetData;

- (void)cycleViewSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
