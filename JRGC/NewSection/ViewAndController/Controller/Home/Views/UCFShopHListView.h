//
//  UCFShopHListView.h
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

@class UCFShopHListView;
@protocol UCFShopHListViewDataSource <NSObject>

- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView;

@end
@protocol UCFShopHListViewDelegate <NSObject>

- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize;

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index;

- (void)shopHListView:(UCFShopHListView *)shopListView didSelectRowAtIndex:(NSInteger)index;
@end

#import "BaseView.h"


NS_ASSUME_NONNULL_BEGIN

@interface UCFShopHListView : BaseView
@property(nonatomic, weak)id<UCFShopHListViewDataSource>dataSource;
@property(nonatomic, weak)id<UCFShopHListViewDelegate>delegate;

@property(nonatomic, assign)CGFloat horizontalSpace;

/**
 刷新视图
 */
- (void)reloadView;
@end

NS_ASSUME_NONNULL_END
