//
//  UCFUserPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserPresenter.h"
#import "UCFUserInfoListItem.h"
#import "HSHelper.h"
#import "UserInfoSingle.h"
@interface UCFUserPresenter ()
@property (strong, nonatomic) UCFHomeAPIManager *apiManager;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *userInfoListCells;
@end

@implementation UCFUserPresenter

- (NSString *)userId
{
    NSString *userId1 = SingleUserInfo.loginData.userInfo.userId;
    _userId = userId1.length > 0 ? userId1 : @"";
    return _userId;
}

#pragma mark - 系统方法
- (instancetype)init {
    if (self = [super init]) {
        self.userInfoListCells = [NSMutableArray array];
        self.apiManager = [UCFHomeAPIManager new];
        self.canClicked = YES;
        [self initUI];
    }
    return self;
}

#pragma mark - 类方法生成本类
+ (instancetype)presenter
{
    return [[self alloc] init];
}

- (NSArray *)allDatas {
    return self.userInfoListCells;
}

#pragma mark - 初始化数据
- (void)initUI
{
    UCFUserInfoListItem *userInfoList1 = [UCFUserInfoListItem itemWithTitle:@"微金账户" destVcClass:nil];
    if ([self.userInfoOneModel.openStatus intValue] <= 2) {
        userInfoList1.isShow = NO;
        userInfoList1.subtitle = @"未开户";
    }
    else {
        userInfoList1.isShow = YES;
        userInfoList1.subtitle = self.userInfoOneModel.p2pCashBalance.length > 0 ? [NSString stringWithFormat:@"%@元", self.userInfoOneModel.p2pCashBalance] : @"0.00元";

    }
    
    UCFUserInfoListItem *userInfoList0 = [UCFUserInfoListItem itemWithTitle:@"尊享账户" destVcClass:nil];

    if ([self.userInfoOneModel.zxOpenStatus intValue] <= 2) {
        userInfoList0.isShow = NO;
        userInfoList0.subtitle = @"未开户";
    }
    else {
        userInfoList0.isShow = YES;
        userInfoList0.subtitle = self.userInfoOneModel.zxCashBalance.length > 0 ? [NSString stringWithFormat:@"%@元", self.userInfoOneModel.zxCashBalance] : @"0.00元";
    }
    //黄金账户
    UCFUserInfoListItem *userInfoList2 = [UCFUserInfoListItem itemWithTitle:@"黄金账户" destVcClass:nil];
    userInfoList2.isShow = YES;
    userInfoList2.subtitle = self.userInfoOneModel.holdGoldAmount.length > 0 ? [NSString stringWithFormat:@"%@克", self.userInfoOneModel.holdGoldAmount] : @"0.000克";
    
    [self.userInfoListCells addObject:userInfoList0];
    [self.userInfoListCells addObject:userInfoList1];
    [self.userInfoListCells addObject:userInfoList2];

}

- (void)fetchUserInfoOneDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{
    if (!self.userId || [self.userId isEqualToString:@""]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.canClicked = NO;
//    [self.apiManager fetchUserInfoOneWithUserId:self.userId completionHandler:^(NSError *error, id result) {
//        weakSelf.canClicked = YES;
//        if ([result isKindOfClass:[UCFUserInfoModel class]]) {
//            weakSelf.userInfoOneModel = result;
//            [weakSelf.userInfoListCells removeAllObjects];
//            [weakSelf initUI];
//        }
//        else if ([result isKindOfClass:[NSString class]]) {
//            
//        }
//        if ([weakSelf.userInfoViewDelegate respondsToSelector:@selector(userInfoPresenter:didRefreshUserInfoOneWithResult:error:)]) {
//            [weakSelf.userInfoViewDelegate userInfoPresenter:weakSelf didRefreshUserInfoOneWithResult:result error:error];
//        }
//        
//        !completionHander ?: completionHander(error, result);
//    }];
}

- (void)fetchUserInfoTwoDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{
    if (!self.userId || [self.userId isEqualToString:@""]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
//    [self.apiManager fetchUserInfoTwoWithUserId:self.userId completionHandler:^(NSError *error, id result) {
//        if ([result isKindOfClass:[UCFUserInfoModel class]]) {
//            
//        }
//        else if ([result isKindOfClass:[NSString class]]) {
//            
//        }
//        if ([weakSelf.userInfoViewDelegate respondsToSelector:@selector(userInfoPresenter:didRefreshUserInfoTwoWithResult:error:)]) {
//            [weakSelf.userInfoViewDelegate userInfoPresenter:weakSelf didRefreshUserInfoTwoWithResult:result error:error];
//        }
//        
//        !completionHander ?: completionHander(error, result);
//    }];
}

- (void)fetchSignDataWithUserId:(NSString *)userId withToken:(NSString *)token completionHandler:(NetworkCompletionHandler)completionHander
{
    [self.apiManager fetchSignInfo:userId token:token completionHandler:^(NSError *error, id result) {
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)fetchProDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.userInfoViewDelegate;
    [MBProgressHUD showHUDAddedTo:baseVC.parentViewController.view animated:YES];
    __weak typeof(self) weakSelf = self;
    NSString *type = [parameter objectForKey:@"type"];
    [self.apiManager fetchProDetailInfoWithParameter:parameter completionHandler:^(NSError *error, id result) {
        if (type.intValue == 4) {
            if ([weakSelf.userInfoViewDelegate respondsToSelector:@selector(userInfoPresenter:didReturnPrdClaimsDealBidWithResult:error:)]) {
                [weakSelf.userInfoViewDelegate userInfoPresenter:self didReturnPrdClaimsDealBidWithResult:result error:error];
            }
        }
//        if ([weakSelf.userInfoViewDelegate respondsToSelector:@selector(userInfoPresenter:didReturnPrdClaimsDealBidWithResult:error:)]) {
//            [weakSelf.userInfoViewDelegate userInfoPresenter:self didReturnPrdClaimsDealBidWithResult:result error:error];
//        }
        !completionHander ?: completionHander(error, result);
    }];
}
- (void)fetchCollectionDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.userInfoViewDelegate;
    [MBProgressHUD showHUDAddedTo:baseVC.parentViewController.view animated:YES];
//    __weak typeof(self) weakSelf = self;
    [self.apiManager fetchCollectionDetailInfoWithParameter:parameter completionHandler:^(NSError *error, id result) {
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)refreshData {
    [self fetchUserInfoTwoDataWithCompletionHandler:nil];
}

- (void)setDefault
{
    self.userInfoOneModel = nil;
    
    [self initUI];
}

@end
