//
//  UCFPCListViewPresenter.h
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UCFPCListCellPresenter.h"
#import "UCFPersonAPIManager.h"

@class UCFPCListViewPresenter;
@protocol PCListViewPresenterCallBack <NSObject>

- (void)pcListViewPresenter:(UCFPCListViewPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error;
- (void)setDefaultState;

@end

@protocol UserInfoViewPresenterCallBack <NSObject>

- (void)pcListViewPresenter:(UCFPCListViewPresenter *)presenter didRefreshUserInfoWithResult:(id)result error:(NSError *)error;
- (void)setDefaultState;

@end

@interface UCFPCListViewPresenter : NSObject

@property (weak, nonatomic) id<PCListViewPresenterCallBack> view;
@property (weak, nonatomic) id<UserInfoViewPresenterCallBack> userInvoView;

+(instancetype)presenter;
- (NSArray *)allDatas;

- (void)refreshData;
- (void)fetchDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;

- (void)fetchSignInfoWithUserId:(NSString *)userId withToken:(NSString *)token CompletionHandler:(NetworkCompletionHandler)completionHander;

#pragma mark - 恢复初始数据
- (void)setDefaultState;
@end
