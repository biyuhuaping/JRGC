//
//  UCFHomeListPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListPresenter.h"
#import "UCFHomeAPIManager.h"
#import "UCFHomeListGroupPresenter.h"
#import "UCFHomeListGroup.h"

@interface UCFHomeListPresenter ()
@property (strong, nonatomic) UCFHomeAPIManager *apiManager;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *homeListCells;
@end

@implementation UCFHomeListPresenter
#pragma mark - 类方法生成本类
+ (instancetype)presenter
{
    return [[self alloc] init];
}

#pragma mark - 系统方法
- (instancetype)init {
    if (self = [super init]) {
        self.apiManager = [UCFHomeAPIManager new];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
        self.userId = userId != nil ? userId : @"";
        self.homeListCells = [[NSMutableArray alloc] init];
        [self initData];
    }
    return self;
}

#pragma mark - Interface

- (NSArray *)allDatas {
    return self.homeListCells;
}

#pragma mark - 初始化数据
- (void)initData
{
    UCFHomeListGroup *group0 = [[UCFHomeListGroup alloc] init];
    group0.headTitle = @"新手专区";
    group0.showMore = NO;
    UCFHomeListGroupPresenter *groupPresenter0 = [UCFHomeListGroupPresenter presenterWithGroup:group0];
    
    UCFHomeListGroup *group1 = [[UCFHomeListGroup alloc] init];
    group1.headTitle = @"工场尊享";
    group1.showMore = YES;
    UCFHomeListGroupPresenter *groupPresenter1 = [UCFHomeListGroupPresenter presenterWithGroup:group1];
    
    UCFHomeListGroup *group2 = [[UCFHomeListGroup alloc] init];
    group2.headTitle = @"工场微金";
    group2.showMore = YES;
    UCFHomeListGroupPresenter *groupPresenter2 = [UCFHomeListGroupPresenter presenterWithGroup:group2];
    
    UCFHomeListGroup *group3 = [[UCFHomeListGroup alloc] init];
    group3.headTitle = @"资金周转";
    group3.showMore = NO;
    UCFHomeListGroupPresenter *groupPresenter3 = [UCFHomeListGroupPresenter presenterWithGroup:group3];
    
    [self.homeListCells addObject:groupPresenter0];
    [self.homeListCells addObject:groupPresenter1];
    [self.homeListCells addObject:groupPresenter2];
    [self.homeListCells addObject:groupPresenter3];
}

- (void)fetchHomeListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander {
    
    [self.apiManager fetchHomeListWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        
    }];
    
//    [self.apiManager fetchUserInfoWithUserId:self.userId completionHandler:^(NSError *error, id result) {
//        //            self.isHonorUser = YES;
//        
//        if ([result isKindOfClass:[UCFPersonCenterModel class]]) {
//            UCFPersonCenterModel *personCenter = result;
//            
//            self.isP2PUser = [personCenter.p2pOpenStatus isEqualToString:@"1"] ? NO : YES;
//            self.p2pBalanceMoney = personCenter.p2pAmount;
//            self.p2pLastBackMoneyDate = personCenter.p2pRepayPerDate;
//            
//            self.isHonorUser = [personCenter.enjoyOpenStatus isEqualToString:@"1"] ? NO : YES;
//            self.hornerBalanceMoney = personCenter.enjoyAmount;
//            self.hornerLastBackMoneyDate = personCenter.enjoyRepayPerDate;
//            
//            [self.pcListCells removeAllObjects];
//            [self initData];
//        }
//        else if ([result isKindOfClass:[NSString class]]) {
//            
//        }
//        
//        
//        if ([self.view respondsToSelector:@selector(pcListViewPresenter:didRefreshDataWithResult:error:)]) {
//            [self.view pcListViewPresenter:self didRefreshDataWithResult:result error:error];
//        }
//        if ([self.userInvoView respondsToSelector:@selector(pcListViewPresenter:didRefreshUserInfoWithResult:error:)]) {
//            [self.userInvoView pcListViewPresenter:self didRefreshUserInfoWithResult:result error:error];
//        }
//        
//        !completionHander ?: completionHander(error, result);
//    }];
}
@end
