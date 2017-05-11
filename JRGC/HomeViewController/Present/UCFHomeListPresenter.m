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
    model.moedelType = UCFHomeListCellModelTypeOneImage;
    UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:model];
    NSMutableArray *temp2 = [NSMutableArray arrayWithObject:cellPresenter];
    self.groupPresenter2.group.prdlist = temp2;
    
    NSMutableArray *temp3 = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        UCFHomeListCellModel *model = [[UCFHomeListCellModel alloc] init];
        model.moedelType = UCFHomeListCellModelTypeOneImage;
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
            NSDictionary *resultDict = result;
            NSArray *groupList = [resultDict objectForKey:@"homelistContent"];
            for (UCFHomeListGroup *group in groupList) {
                NSArray *array = group.prdlist;
                if (array.count > 0) {
                    if ([group.type isEqualToString:@"11"]) {
                        NSMutableArray *temp = [weakSelf productPrdListWithDataSource:array];
                        [temp addObject:[weakSelf.groupPresenter2.group.prdlist lastObject]];
                        weakSelf.groupPresenter2.group.prdlist = temp;
                    }
                    else if ([group.type isEqualToString:@"12"]) {
                        weakSelf.groupPresenter1.group.prdlist = [weakSelf productPrdListWithDataSource:array];
                    }
                    else if ([group.type isEqualToString:@"13"]) {
                        weakSelf.groupPresenter0.group.prdlist = [weakSelf productPrdListWithDataSource:array];
                    }
                }
            }
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
@end
