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

@end

@protocol UserInfoViewPresenterCallBack <NSObject>

- (void)pcListViewPresenter:(UCFPCListViewPresenter *)presenter didRefreshUserInfoWithResult:(id)result error:(NSError *)error;

@end

@interface UCFPCListViewPresenter : NSObject

@property (weak, nonatomic) id<PCListViewPresenterCallBack> view;
@property (weak, nonatomic) id<UserInfoViewPresenterCallBack> userInvoView;

+(instancetype)presenter;
- (NSArray *)allDatas;

- (void)refreshData;
- (void)fetchDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;
@end
