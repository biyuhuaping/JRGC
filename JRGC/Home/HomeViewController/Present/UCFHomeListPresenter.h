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

@interface UCFHomeListPresenter : NSObject

@property (weak, nonatomic) id<HomeListViewPresenterCallBack> view;

- (NSArray *)allDatas;

+ (instancetype)presenter;

- (BOOL)authorization;

- (void)fetchHomeListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;

- (void)resetData;
@end
