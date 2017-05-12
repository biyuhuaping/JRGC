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

@interface UCFUserPresenter ()
@property (strong, nonatomic) UCFHomeAPIManager *apiManager;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *userInfoListCells;
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
    if ([self.userInfoOneModel.openStatus intValue] < 2) {
        userInfoList0.isShow = NO;
        userInfoList0.subtitle = @"未开户";
    }
    else {
        userInfoList0.isShow = YES;
        userInfoList0.subtitle = self.userInfoOneModel.p2pCashBalance.length > 0 ? [NSString stringWithFormat:@"%@元", self.userInfoOneModel.p2pCashBalance] : @"0.00元";

    }
    
    UCFUserInfoListItem *userInfoList1 = [UCFUserInfoListItem itemWithTitle:@"尊享账户" destVcClass:nil];

    if ([self.userInfoOneModel.zxOpenStatus intValue] < 2) {
        userInfoList1.isShow = NO;
        userInfoList1.subtitle = @"未开户";
    }
    else {
        userInfoList1.isShow = YES;
        userInfoList1.subtitle = self.userInfoOneModel.zxCashBalance.length > 0 ? [NSString stringWithFormat:@"%@元", self.userInfoOneModel.zxCashBalance] : @"0.00元";
    }
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
            [weakSelf.userInfoListCells removeAllObjects];
            [weakSelf initUI];
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

- (void)fetchProDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander
{
    [self.apiManager fetchProDetailInfoWithParameter:parameter completionHandler:^(NSError *error, id result) {
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)refreshData {
    [self fetchUserInfoTwoDataWithCompletionHandler:nil];
}


#pragma mark - 无奈的代码
- (BOOL)checkIDAAndBankBlindState:(SelectAccoutType)type {
    NSUInteger openStatus = (type == SelectAccoutTypeP2P ? [self.userInfoOneModel.openStatus integerValue] : [self.userInfoOneModel.zxOpenStatus integerValue]);
    __weak typeof(self) weakSelf = self;
    if (openStatus == 1 || openStatus == 2) {
        NSString *message = (type == SelectAccoutTypeP2P ? P2PTIP1 : ZXTIP1);
        NSInteger step = (type == SelectAccoutTypeP2P ? [self.userInfoOneModel.openStatus integerValue] : [self.userInfoOneModel.zxOpenStatus integerValue]);
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
            if (index == 1) {
                HSHelper *helper = [HSHelper new];
                UIViewController *VC = (UIViewController *)weakSelf.userInfoViewDelegate;
                [helper pushOpenHSType:type Step:step nav:VC.parentViewController.navigationController];
            }
        } otherButtonTitles:@"确定"];
        [alert show];
        return NO;
    }
    return YES;
}

@end
