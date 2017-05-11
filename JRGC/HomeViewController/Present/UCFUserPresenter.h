//
//  UCFUserPresenter.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeAPIManager.h"

@class UCFUserPresenter;
#pragma mark - 轮播图的代理回掉
@protocol UCFUserPresenterCyceleImageCallBack <NSObject>
- (void)cycleImageViewPresenter:(UCFUserPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error;
@end

#pragma mark - 个人信心的代理回调
@protocol UCFUserPresenterUserInfoCallBack <NSObject>
- (void)userInfoPresenter:(UCFUserPresenter *)presenter didRefreshUserInfoWithResult:(id)result error:(NSError *)error;
@end

@interface UCFUserPresenter : NSObject
@property (weak, nonatomic) id<UCFUserPresenterUserInfoCallBack> userInfoViewDelegate;
@property (weak, nonatomic) id<UCFUserPresenterCyceleImageCallBack> cycleImageViewDelegate;

+ (instancetype)presenter;
- (NSArray *)allDatas;

- (void)fetchUserInfoOneDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;
- (void)fetchUserInfoTwoDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;
@end
