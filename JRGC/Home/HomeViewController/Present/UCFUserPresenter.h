//
//  UCFUserPresenter.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeAPIManager.h"
#import "UCFUserInfoModel.h"

@class UCFUserPresenter;
#pragma mark - 轮播图的代理回掉
@protocol UCFUserPresenterCyceleImageCallBack <NSObject>
- (void)cycleImageViewPresenter:(UCFUserPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error;
@end

#pragma mark - 个人信心的代理回调
@protocol UCFUserPresenterUserInfoCallBack <NSObject>
- (void)userInfoPresenter:(UCFUserPresenter *)presenter didRefreshUserInfoOneWithResult:(id)result error:(NSError *)error;
- (void)userInfoPresenter:(UCFUserPresenter *)presenter didRefreshUserInfoTwoWithResult:(id)result error:(NSError *)error;
- (void)userInfoPresenter:(UCFUserPresenter *)presenter didReturnPrdClaimsDealBidWithResult:(id)result error:(NSError *)error;
@end

@interface UCFUserPresenter : NSObject<UIAlertViewDelegate>
@property (strong, nonatomic) UCFUserInfoModel *userInfoOneModel;
@property (weak, nonatomic) id<UCFUserPresenterUserInfoCallBack> userInfoViewDelegate;
@property (weak, nonatomic) id<UCFUserPresenterCyceleImageCallBack> cycleImageViewDelegate;

+ (instancetype)presenter;
- (NSArray *)allDatas;

- (void)fetchUserInfoOneDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;
- (void)fetchUserInfoTwoDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;
- (void)fetchSignDataWithUserId:(NSString *)userId withToken:(NSString *)token completionHandler:(NetworkCompletionHandler)completionHander;

- (void)fetchProDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander;
#pragma mark - 刷新token
- (void)refreshData;
- (BOOL)checkIDAAndBankBlindState:(SelectAccoutType)type;
@end
