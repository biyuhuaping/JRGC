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
@property (strong, nonatomic) UCFHomeListGroupPresenter *groupPresenter4;
@property (strong, nonatomic) UCFHomeListGroupPresenter *groupPresenter5;
@end

@implementation UCFHomeListPresenter

- (UCFHomeListGroupPresenter *)groupPresenter0
{
    if (!_groupPresenter0) {
        UCFHomeListGroup *group0 = [[UCFHomeListGroup alloc] init];
        group0.showMore = NO;
        _groupPresenter0 = [UCFHomeListGroupPresenter presenterWithGroup:group0];
    }
    return _groupPresenter0;
}

- (UCFHomeListGroupPresenter *)groupPresenter1
{
    if (!_groupPresenter1) {
        UCFHomeListGroup *group1 = [[UCFHomeListGroup alloc] init];
        group1.showMore = YES;
        group1.type = @"12";
        _groupPresenter1 = [UCFHomeListGroupPresenter presenterWithGroup:group1];
    }
    return _groupPresenter1;
}

- (UCFHomeListGroupPresenter *)groupPresenter2
{
    if (!_groupPresenter2) {
        UCFHomeListGroup *group2 = [[UCFHomeListGroup alloc] init];
//        group2.headTitle = @"工场微金";
        group2.type = @"11";
        group2.showMore = YES;
//        group2.headerImage = @"mine_icon_p2p";
        _groupPresenter2 = [UCFHomeListGroupPresenter presenterWithGroup:group2];
    }
    return _groupPresenter2;
}

- (UCFHomeListGroupPresenter *)groupPresenter3
{
    if (!_groupPresenter3) {
        UCFHomeListGroup *group3 = [[UCFHomeListGroup alloc] init];
//        group3.headTitle = @"工场黄金";
        group3.showMore = YES;
        group3.type = @"15";
//        group3.headerImage = @"mine_icon_gold";
        _groupPresenter3 = [UCFHomeListGroupPresenter presenterWithGroup:group3];
    }
    return _groupPresenter3;
}

- (UCFHomeListGroupPresenter *)groupPresenter4
{
    if (!_groupPresenter4) {
        UCFHomeListGroup *group4 = [[UCFHomeListGroup alloc] init];
        group4.title = @"资金周转";
        group4.showMore = NO;
        group4.headerImage = @"mine_icon_transfer";
        _groupPresenter4 = [UCFHomeListGroupPresenter presenterWithGroup:group4];
    }
    return _groupPresenter4;
}

- (UCFHomeListGroupPresenter *)groupPresenter5
{
    if (!_groupPresenter5) {
        UCFHomeListGroup *group5 = [[UCFHomeListGroup alloc] init];
//        group5.headTitle = @"预约宝";
//        group5.desc = @"平均1小时起息";
        group5.showMore = NO;
//        group5.type = @"15";
//        group5.headerImage = @"mine_factory_reserved";
        _groupPresenter5 = [UCFHomeListGroupPresenter presenterWithGroup:group5];
    }
    return _groupPresenter5;
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
//    UCFHomeListCellModel *model = [[UCFHomeListCellModel alloc] init];
//    model.moedelType = UCFHomeListCellModelTypeOneImageBatchLending;
//    model.backImage = @"home_bg_1";
//    model.prdName = @"批量出借专区";
//    model.type = @"省心出借";
//    UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:model];
//    NSMutableArray *temp3 = [NSMutableArray arrayWithObject:cellPresenter];
//    self.groupPresenter3.group.prdlist = temp3;
    
    NSMutableArray *temp4 = [[NSMutableArray alloc] init];
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
        [temp4 addObject:cellPresenter];
    }
    self.groupPresenter4.group.prdlist = temp4;
    
    [self.homeListCells addObject:self.groupPresenter0];
    [self.homeListCells addObject:self.groupPresenter2];
    [self.homeListCells addObject:self.groupPresenter5];
    [self.homeListCells addObject:self.groupPresenter1];
    
    
    [self.homeListCells addObject:self.groupPresenter3];
    [self.homeListCells addObject:self.groupPresenter4];
}

- (void)fetchHomeListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander {
    __weak typeof(self) weakSelf = self;
    self.canReservedClicked = NO;
    [self.apiManager fetchHomeListWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            [weakSelf resetData];
            weakSelf.canReservedClicked = YES;
            NSDictionary *resultDict = result;
            UCFHomeListGroup *investGroup = [resultDict objectForKey:@"appointInvest"];
            if (investGroup) {
                NSArray *investModels = investGroup.prdlist;
                UCFHomeListCellModel *investModel = [investModels firstObject];
                investModel.moedelType = UCFHomeListCellModelTypeReserved;
                UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:investModel];
                weakSelf.groupPresenter5.group.type = investGroup.type;
                weakSelf.groupPresenter5.group.title = investGroup.title;
                weakSelf.groupPresenter5.group.desc = investGroup.desc;
                weakSelf.groupPresenter5.group.iconUrl = investGroup.iconUrl;
                weakSelf.groupPresenter5.group.prdlist = [NSArray arrayWithObjects:cellPresenter, nil];
            }
            
            NSArray *groupList = [resultDict objectForKey:@"homelistContent"];
            for (UCFHomeListGroup *group in groupList) {
                NSArray *array = group.prdlist;
                if (array.count > 0) {
                    if ([group.type isEqualToString:@"11"]) {
//                        weakSelf.groupPresenter2.group.type = group.type;
                        weakSelf.groupPresenter2.group.type = group.type;
                        weakSelf.groupPresenter2.group.title = group.title;
                        weakSelf.groupPresenter2.group.iconUrl = group.iconUrl;
                        weakSelf.groupPresenter2.group.prdlist = [weakSelf productPrdListWithDataSource:array];
                    }
                    else if ([group.type isEqualToString:@"12"]) {
//                        weakSelf.groupPresenter1.group.type = group.type;
                        weakSelf.groupPresenter1.group.type = group.type;
                        weakSelf.groupPresenter1.group.title = group.title;
                        weakSelf.groupPresenter1.group.iconUrl = group.iconUrl;
                        weakSelf.groupPresenter1.group.prdlist = [weakSelf productPrdListWithDataSource:array];
                    }
                    else if ([group.type isEqualToString:@"13"]) {
                        weakSelf.groupPresenter0.group.type = group.type;
                        weakSelf.groupPresenter0.group.title = group.title;
                        weakSelf.groupPresenter0.group.iconUrl = group.iconUrl;
                        weakSelf.groupPresenter0.group.prdlist = [weakSelf productPrdListWithDataSource:array];
                    }
                    else if ([group.type isEqualToString:@"15"]) {
//                        NSMutableArray *temp = [weakSelf productPrdListWithDataSource:array];
//                        [temp addObject:[weakSelf.groupPresenter3.group.prdlist lastObject]];
                        weakSelf.groupPresenter3.group.type = group.type;
                        weakSelf.groupPresenter3.group.title = group.title;
                        weakSelf.groupPresenter3.group.iconUrl = group.iconUrl;
                        NSMutableArray *temp = [weakSelf productPrdListWithDataSource:array];
                        UCFHomeListCellModel *model = [[UCFHomeListCellModel alloc] init];
                        model.moedelType = UCFHomeListCellModelTypeGoldFixed;
                        UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:model];
                        [temp insertObject:cellPresenter atIndex:0];
                        weakSelf.groupPresenter3.group.prdlist = temp;
                        
                    }
                }
            }
            
            UCFHomeListCellModel *listInfo = [resultDict objectForKey:@"listInfo"];
            UCFHomeListCellPresenter *temp3 = [self.groupPresenter3.group.prdlist lastObject];
            temp3.item.totalCount = listInfo.totalCount;
            
            UCFHomeListCellPresenter *temp40 = [self.groupPresenter4.group.prdlist firstObject];
            temp40.item.transferNum = listInfo.transferNum;
            
            UCFHomeListCellPresenter *temp41 = [self.groupPresenter4.group.prdlist objectAtIndex:1];
            temp41.item.zxTransferNum = listInfo.zxTransferNum;
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
    self.groupPresenter4 = nil;
    self.groupPresenter5 = nil;
    [self initData];
}
@end
