//
//  UCFPCListViewPresenter.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPCListViewPresenter.h"
#import "UCFPCGroupPresenter.h"
#import "UCFPersonCenterModel.h"

@interface UCFPCListViewPresenter ()
@property (strong, nonatomic) NSMutableArray *pcListCells;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) UCFPersonAPIManager *apiManager;

// p2p账户可用余额
@property (copy, nonatomic) NSString *p2pBalanceMoney;
// 尊享账户可用余额
@property (copy, nonatomic) NSString *hornerBalanceMoney;
// p2p账户最近回款日
@property (copy, nonatomic) NSString *p2pLastBackMoneyDate;
// 尊享账户最近回款日
@property (copy, nonatomic) NSString *hornerLastBackMoneyDate;
// 尊享是否开户
@property (assign, nonatomic) BOOL isHonorUser;
// P2P账户是否开户
@property (assign, nonatomic) BOOL isP2PUser;
@end

@implementation UCFPCListViewPresenter
+(instancetype)presenter
{
    return [[UCFPCListViewPresenter alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.pcListCells = [NSMutableArray array];
        self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
        self.apiManager = [UCFPersonAPIManager new];
        [self initData];
    }
    return self;
}

#pragma mark - Interface

- (NSArray *)allDatas {
    return self.pcListCells;
}

- (BOOL)isHonorUser
{
    return _isHonorUser;
}

- (void)initData
{
    UCFPCGroupPresenter *group0 = [[UCFPCGroupPresenter alloc] init];
    UCFPCListModel *listModel0_0 = [UCFPCListModel itemWithTitle:@"P2P账户" destVcClass:nil];
    listModel0_0.isShow = self.isP2PUser;
    if (self.isP2PUser) {
        listModel0_0.subtitle = self.p2pBalanceMoney.length > 0 ? [NSString stringWithFormat:@"%@元", self.p2pBalanceMoney] : @"0.00元";
        listModel0_0.describeWord = self.p2pLastBackMoneyDate.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.p2pLastBackMoneyDate] : @"";
    }
    else {
        listModel0_0.subtitle = @"小额分散、安全合规";
        listModel0_0.describeWord = @"未开户";
    }
    UCFPCListCellPresenter *presenter0_0 = [UCFPCListCellPresenter presenterWithItem:listModel0_0];
    
    
    UCFPCListModel *listModel0_1 = [UCFPCListModel itemWithTitle:@"尊享账户" destVcClass:nil];
    listModel0_1.isShow = self.isHonorUser;
    if (self.isHonorUser) {
        listModel0_1.subtitle = @"委托投资、多重保障";
        listModel0_1.describeWord = self.hornerLastBackMoneyDate.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.hornerLastBackMoneyDate] : @"";
    }
    else {
        listModel0_1.subtitle = @"委托投资、多重保障";
        listModel0_1.describeWord = @"未开户";
    }
    
    UCFPCListCellPresenter *presenter0_1 = [UCFPCListCellPresenter presenterWithItem:listModel0_1];
    group0.items = [NSMutableArray array];
    [group0.items addObject:presenter0_0];
    [group0.items addObject:presenter0_1];
    
    UCFPCGroupPresenter *group1 = [[UCFPCGroupPresenter alloc] init];
    UCFPCListModel *listModel1_0 = [UCFPCListModel itemWithIcon:@"" title:@"常用功能" destVcClass:nil];
    UCFPCListCellPresenter *presenter1_0 = [UCFPCListCellPresenter presenterWithItem:listModel1_0];
    UCFPCListModel *listModel1_1 = [UCFPCListModel itemWithIcon:@"uesr_icon_class" title:@"会员等级" destVcClass:nil];
    UCFPCListCellPresenter *presenter1_1 = [UCFPCListCellPresenter presenterWithItem:listModel1_1];
    UCFPCListModel *listModel1_2 = [UCFPCListModel itemWithIcon:@"uesr_icon_number" title:@"工场码" destVcClass:nil];
    UCFPCListCellPresenter *presenter1_2 = [UCFPCListCellPresenter presenterWithItem:listModel1_2];
    UCFPCListModel *listModel1_3 = [UCFPCListModel itemWithIcon:@"uesr_icon_redbag" title:@"红包" destVcClass:nil];
    UCFPCListCellPresenter *presenter1_3 = [UCFPCListCellPresenter presenterWithItem:listModel1_3];
    UCFPCListModel *listModel1_4 = [UCFPCListModel itemWithIcon:@"uesr_icon_more" title:@"更多" destVcClass:nil];
    UCFPCListCellPresenter *presenter1_4 = [UCFPCListCellPresenter presenterWithItem:listModel1_4];
    group1.items = [NSMutableArray array];
    [group1.items addObject:presenter1_0];
    [group1.items addObject:presenter1_1];
    [group1.items addObject:presenter1_2];
    [group1.items addObject:presenter1_3];
    [group1.items addObject:presenter1_4];
    [self.pcListCells addObject:group0];
    [self.pcListCells addObject:group1];
    
}

- (void)fetchDataWithCompletionHandler:(NetworkCompletionHandler)completionHander {
    
    [self.apiManager fetchUserInfoWithUserId:self.userId completionHandler:^(NSError *error, id result) {
//            self.isHonorUser = YES;
        
        if ([result isKindOfClass:[UCFPersonCenterModel class]]) {
            UCFPersonCenterModel *personCenter = result;
            
            self.isP2PUser = [personCenter.p2pOpenStatus isEqualToString:@"1"] ? NO : YES;
            self.p2pBalanceMoney = personCenter.p2pAmount;
            self.p2pLastBackMoneyDate = personCenter.p2pRepayPerDate;
            
            self.isHonorUser = [personCenter.enjoyOpenStatus isEqualToString:@"1"] ? NO : YES;
            self.hornerBalanceMoney = personCenter.enjoyAmount;
            self.hornerLastBackMoneyDate = personCenter.enjoyRepayPerDate;
            
            [self.pcListCells removeAllObjects];
            [self initData];
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
        
        
        if ([self.view respondsToSelector:@selector(pcListViewPresenter:didRefreshDataWithResult:error:)]) {
            [self.view pcListViewPresenter:self didRefreshDataWithResult:result error:error];
        }
        if ([self.userInvoView respondsToSelector:@selector(pcListViewPresenter:didRefreshUserInfoWithResult:error:)]) {
            [self.userInvoView pcListViewPresenter:self didRefreshUserInfoWithResult:result error:error];
        }
        
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)fetchSignInfoWithUserId:(NSString *)userId withToken:(NSString *)token CompletionHandler:(NetworkCompletionHandler)completionHander
{
    [self.apiManager fetchSignInfo:userId token:token completionHandler:^(NSError *error, id result) {
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)refreshData {
    [self fetchDataWithCompletionHandler:nil];
}

#pragma mark - 恢复初始数据
- (void)setDefaultState
{
    self.isHonorUser = NO;
    self.isP2PUser = NO;
    [self.pcListCells removeAllObjects];
    [self initData];
    if ([self.view respondsToSelector:@selector(setDefaultState)]) {
        [self.view setDefaultState];
    }
    if ([self.userInvoView respondsToSelector:@selector(setDefaultState)]) {
        [self.userInvoView setDefaultState];
    }
}

@end
