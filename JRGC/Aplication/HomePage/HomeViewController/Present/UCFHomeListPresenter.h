//
//  UCFHomeListPresenter.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeAPIManager.h"

@class UCFHomeListPresenter;
@protocol HomeListViewPresenterCallBack <NSObject>

- (void)homeListViewPresenter:(UCFHomeListPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error;

@end

@protocol HomeIconListViewPresenterCallBack <NSObject>

- (void)homeIconListViewPresenter:(UCFHomeListPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error;
- (void)homeIconListPresenter:(UCFHomeListPresenter *)presenter didReturnPrdClaimsDealBidWithResult:(id)result error:(NSError *)error;

@end

@interface UCFHomeListPresenter : NSObject

@property (weak, nonatomic) id<HomeListViewPresenterCallBack> view;
@property (weak, nonatomic) id<HomeIconListViewPresenterCallBack> iconDelegate;
@property (assign, nonatomic) BOOL canReservedClicked;
- (NSArray *)allDatas;
- (NSArray *)allHomeIcons;

+ (instancetype)presenter;

- (BOOL)authorization;

- (BOOL)checkIDAAndBankBlindState:(SelectAccoutType)type;

- (void)fetchHomeListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;

- (void)fetchHomeIconListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;

- (void)fetchProDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander;

- (void)fetchCollectionDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander;

- (void)resetData;
@end
