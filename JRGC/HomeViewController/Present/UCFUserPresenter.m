//
//  UCFUserPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserPresenter.h"
#import "UCFUserInfoListItem.h"
#import "UCFUserInfoModel.h"

@interface UCFUserPresenter ()
@property (strong, nonatomic) UCFHomeAPIManager *apiManager;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *userInfoListCells;
@property (strong, nonatomic) UCFUserInfoModel *userInfoOneModel;

// p2p账户可用余额
@property (copy, nonatomic) NSString *p2pBalanceMoney;
// 尊享账户可用余额
@property (copy, nonatomic) NSString *hornerBalanceMoney;
// 尊享是否开户
@property (copy, nonatomic) NSString *honorUserState;
// P2P账户是否开户
@property (copy, nonatomic) NSString *P2PUserState;
@end

@implementation UCFUserPresenter

- (NSString *)userId
{
    NSString *userId1 = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    _userId = userId1.length > 0 ? userId1 : @"";
    return _userId;
}

#pragma mark - 系统方法
- (instancetype)init {
    if (self = [super init]) {
        self.userInfoListCells = [NSMutableArray array];
        self.apiManager = [UCFHomeAPIManager new];
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
    UCFUserInfoListItem *userInfoList0 = [UCFUserInfoListItem itemWithTitle:@"P2P账户" destVcClass:nil];
//    userInfoList0.isShow = self.isP2PUser;
//    if (self.isP2PUser) {
//        userInfoList0.subtitle = self.p2pBalanceMoney.length > 0 ? [NSString stringWithFormat:@"%@元", self.p2pBalanceMoney] : @"0.00元";
//    }
//    else {
//        userInfoList0.subtitle = @"未开户";
//    }
    
    UCFUserInfoListItem *userInfoList1 = [UCFUserInfoListItem itemWithTitle:@"尊享账户" destVcClass:nil];
//    userInfoList1.isShow = self.isHonorUser;
//    if (self.isHonorUser) {
//        userInfoList1.subtitle = self.hornerBalanceMoney.length > 0 ? [NSString stringWithFormat:@"%@元", self.hornerBalanceMoney] : @"";
//    }
//    else {
//        userInfoList1.subtitle = @"未开户";
//    }
    [self.userInfoListCells addObject:userInfoList0];
    [self.userInfoListCells addObject:userInfoList1];
}

- (void)fetchUserInfoOneDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{
    if (!self.userId || [self.userId isEqualToString:@""]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.apiManager fetchUserInfoOneWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        if ([result isKindOfClass:[UCFUserInfoModel class]]) {
            weakSelf.userInfoOneModel = result;
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
        if ([weakSelf.userInfoViewDelegate respondsToSelector:@selector(userInfoPresenter:didRefreshUserInfoOneWithResult:error:)]) {
            [weakSelf.userInfoViewDelegate userInfoPresenter:weakSelf didRefreshUserInfoOneWithResult:result error:error];
        }
        
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)fetchUserInfoTwoDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{
    if (!self.userId || [self.userId isEqualToString:@""]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.apiManager fetchUserInfoTwoWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        if ([result isKindOfClass:[UCFUserInfoModel class]]) {
            
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
        if ([weakSelf.userInfoViewDelegate respondsToSelector:@selector(userInfoPresenter:didRefreshUserInfoTwoWithResult:error:)]) {
            [weakSelf.userInfoViewDelegate userInfoPresenter:weakSelf didRefreshUserInfoTwoWithResult:result error:error];
        }
        
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)fetchSignDataWithUserId:(NSString *)userId withToken:(NSString *)token completionHandler:(NetworkCompletionHandler)completionHander
{
    [self.apiManager fetchSignInfo:userId token:token completionHandler:^(NSError *error, id result) {
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)refreshData {
    [self fetchUserInfoTwoDataWithCompletionHandler:nil];
}

@end
