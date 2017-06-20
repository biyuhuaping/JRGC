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
#import "UCFHomeListCellPresenter.h"

@interface UCFHomeListPresenter ()
@property (strong, nonatomic) UCFHomeAPIManager *apiManager;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *homeListCells;
@property (assign, nonatomic) BOOL authorization;

@property (strong, nonatomic) UCFHomeListGroupPresenter *groupPresenter0;
@property (strong, nonatomic) UCFHomeListGroupPresenter *groupPresenter1;
@property (strong, nonatomic) UCFHomeListGroupPresenter *groupPresenter2;
@property (strong, nonatomic) UCFHomeListGroupPresenter *groupPresenter3;
@end

@implementation UCFHomeListPresenter

- (UCFHomeListGroupPresenter *)groupPresenter0
{
    if (!_groupPresenter0) {
        UCFHomeListGroup *group0 = [[UCFHomeListGroup alloc] init];
        group0.headTitle = @"新手专区";
        group0.showMore = NO;
        group0.headerImage = @"mine_icon_new";
        _groupPresenter0 = [UCFHomeListGroupPresenter presenterWithGroup:group0];
    }
    return _groupPresenter0;
}

- (UCFHomeListGroupPresenter *)groupPresenter1
{
    if (!_groupPresenter1) {
        UCFHomeListGroup *group1 = [[UCFHomeListGroup alloc] init];
        group1.headTitle = @"工场尊享";
        group1.showMore = YES;
        group1.type = @"12";
        group1.headerImage = @"mine_icon_enjoy";
        _groupPresenter1 = [UCFHomeListGroupPresenter presenterWithGroup:group1];
    }
    return _groupPresenter1;
}

- (UCFHomeListGroupPresenter *)groupPresenter2
{
    if (!_groupPresenter2) {
        UCFHomeListGroup *group2 = [[UCFHomeListGroup alloc] init];
        group2.headTitle = @"工场微金";
        group2.type = @"11";
        group2.showMore = YES;
        group2.headerImage = @"mine_icon_p2p";
        _groupPresenter2 = [UCFHomeListGroupPresenter presenterWithGroup:group2];
    }
    return _groupPresenter2;
}

- (UCFHomeListGroupPresenter *)groupPresenter3
{
    if (!_groupPresenter3) {
        UCFHomeListGroup *group3 = [[UCFHomeListGroup alloc] init];
        group3.headTitle = @"资金周转";
        group3.showMore = NO;
        group3.headerImage = @"mine_icon_transfer";
        _groupPresenter3 = [UCFHomeListGroupPresenter presenterWithGroup:group3];
    }
    return _groupPresenter3;
}

- (NSString *)userId
{
    NSString *userId1 = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    _userId = userId1.length > 0 ? userId1 : @"";
    return _userId;
}

#pragma mark - 类方法生成本类
+ (instancetype)presenter
{
    return [[self alloc] init];
}

#pragma mark - 系统方法
- (instancetype)init {
    if (self = [super init]) {
        self.apiManager = [UCFHomeAPIManager new];
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
    UCFHomeListCellModel *model = [[UCFHomeListCellModel alloc] init];
    model.moedelType = UCFHomeListCellModelTypeOneImageBatchLending;
    model.backImage = @"home_bg_1";
    model.prdName = @"批量出借专区";
    model.type = @"省心出借";
    UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:model];
    NSMutableArray *temp2 = [NSMutableArray arrayWithObject:cellPresenter];
    self.groupPresenter2.group.prdlist = temp2;
    
    NSMutableArray *temp3 = [[NSMutableArray alloc] init];
    NSArray *imageArr = @[@"home_bg_2", @"home_bg_4"];
    NSArray *titleArr = @[@"转让专区", @""];
    NSArray *typeArr = @[@"自由转让，灵活变现", @""];
    for (int i=0; i<2; i++) {
        UCFHomeListCellModel *model = [[UCFHomeListCellModel alloc] init];
        if (i==0) {
            model.moedelType = UCFHomeListCellModelTypeOneImageTransfer;
        }
        else if (i==1) {
            model.moedelType = UCFHomeListCellModelTypeOneImageBatchCycle;
        }
        model.prdName = [titleArr objectAtIndex:i];
        model.type = [typeArr objectAtIndex:i];
        model.backImage = [imageArr objectAtIndex:i];
        UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:model];
        [temp3 addObject:cellPresenter];
    }
    self.groupPresenter3.group.prdlist = temp3;
    
    [self.homeListCells addObject:self.groupPresenter0];
    [self.homeListCells addObject:self.groupPresenter1];
    [self.homeListCells addObject:self.groupPresenter2];
    [self.homeListCells addObject:self.groupPresenter3];
}

- (void)fetchHomeListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander {
    __weak typeof(self) weakSelf = self;
    [self.apiManager fetchHomeListWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            [self resetData];
            NSDictionary *resultDict = result;
            NSArray *groupList = [resultDict objectForKey:@"homelistContent"];
            for (UCFHomeListGroup *group in groupList) {
                NSArray *array = group.prdlist;
                if (array.count > 0) {
                    if ([group.type isEqualToString:@"11"]) {
//                        weakSelf.groupPresenter2.group.type = group.type;
                        NSMutableArray *temp = [weakSelf productPrdListWithDataSource:array];
                        [temp addObject:[weakSelf.groupPresenter2.group.prdlist lastObject]];
                        weakSelf.groupPresenter2.group.prdlist = temp;
                    }
                    else if ([group.type isEqualToString:@"12"]) {
//                        weakSelf.groupPresenter1.group.type = group.type;
                        weakSelf.groupPresenter1.group.prdlist = [weakSelf productPrdListWithDataSource:array];
                    }
                    else if ([group.type isEqualToString:@"13"]) {
//                        weakSelf.groupPresenter0.group.type = group.type;
                        weakSelf.groupPresenter0.group.prdlist = [weakSelf productPrdListWithDataSource:array];
                    }
                }
            }
            
            
            UCFHomeListCellModel *listInfo = [resultDict objectForKey:@"listInfo"];
            UCFHomeListCellPresenter *temp2 = [self.groupPresenter2.group.prdlist lastObject];
            temp2.item.totalCount = listInfo.totalCount;
            
            UCFHomeListCellPresenter *temp30 = [self.groupPresenter3.group.prdlist firstObject];
            temp30.item.p2pTransferNum = listInfo.transferNum;
            
            UCFHomeListCellPresenter *temp31 = [self.groupPresenter3.group.prdlist objectAtIndex:1];
            temp31.item.zxTransferNum = listInfo.zxTransferNum;
            [UserInfoSingle sharedManager].p2pAuthorization = listInfo.p2pAuthorization;
            [UserInfoSingle sharedManager].zxAuthorization = listInfo.zxAuthorization;
            [UserInfoSingle sharedManager].openStatus = [listInfo.openStatus integerValue];
            [UserInfoSingle sharedManager].enjoyOpenStatus = [listInfo.zxOpenStatus integerValue];
            
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
        if ([weakSelf.view respondsToSelector:@selector(homeListViewPresenter:didRefreshDataWithResult:error:)]) {
            [self.view homeListViewPresenter:weakSelf didRefreshDataWithResult:result error:error];
        }
        
        !completionHander ?: completionHander(error, result);
    }];
}

- (NSMutableArray *)productPrdListWithDataSource:(NSArray *)dataSource
{
    NSMutableArray *temp = [NSMutableArray new];
    for (UCFHomeListCellModel *model in dataSource) {
        model.moedelType = UCFHomeListCellModelTypeDefault;
        UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:model];
        [temp addObject:cellPresenter];
        
    }
    return temp;
}

#pragma mark - 重制数据
- (void)resetData {
    [self.homeListCells removeAllObjects];
    self.groupPresenter0 = nil;
    self.groupPresenter1 = nil;
    self.groupPresenter2 = nil;
    self.groupPresenter3 = nil;
    [self initData];
}
@end
