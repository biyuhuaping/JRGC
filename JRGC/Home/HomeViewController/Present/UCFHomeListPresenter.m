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

@property (strong, nonatomic) UCFHomeListGroupPresenter *groupTransferPresenter;
@end

@implementation UCFHomeListPresenter

- (UCFHomeListGroupPresenter *)groupTransferPresenter
{
    if (!_groupTransferPresenter) {
        UCFHomeListGroup *group4 = [[UCFHomeListGroup alloc] init];
        group4.title = @"资金周转";
        group4.showMore = NO;
        group4.headerImage = @"mine_icon_transfer";
        _groupTransferPresenter = [UCFHomeListGroupPresenter presenterWithGroup:group4];
    }
    return _groupTransferPresenter;
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
    self.groupTransferPresenter.group.prdlist = temp4;
    [self.homeListCells addObject:self.groupTransferPresenter];

}

- (void)fetchHomeListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander {
    __weak typeof(self) weakSelf = self;
    self.canReservedClicked = NO;
    [self.apiManager fetchHomeListWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            [weakSelf resetData];
            weakSelf.canReservedClicked = YES;
            NSDictionary *resultDict = result;
            NSArray *groupList = [resultDict objectForKey:@"homelistContent"];
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (UCFHomeListGroup *group in groupList) {
                UCFHomeListGroupPresenter *groupPresenter = [weakSelf homeListGroupPresenterWithGroup:group];
                [temp addObject:groupPresenter];
            }
            [temp addObjectsFromArray:weakSelf.homeListCells];
            weakSelf.homeListCells = temp;
            
            UCFHomeListCellModel *listInfo = [resultDict objectForKey:@"listInfo"];
            
            UCFHomeListCellPresenter *temp40 = [self.groupTransferPresenter.group.prdlist firstObject];
            temp40.item.transferNum = listInfo.transferNum;
            
            UCFHomeListCellPresenter *temp41 = [self.groupTransferPresenter.group.prdlist objectAtIndex:1];
            temp41.item.zxTransferNum = listInfo.zxTransferNum;
            [UserInfoSingle sharedManager].p2pAuthorization = listInfo.p2pAuthorization;
            [UserInfoSingle sharedManager].zxAuthorization = listInfo.zxAuthorization;
            [UserInfoSingle sharedManager].openStatus = [listInfo.openStatus integerValue];
            [UserInfoSingle sharedManager].enjoyOpenStatus = [listInfo.zxOpenStatus integerValue];
//            UCFHomeListGroup *investGroup = [resultDict objectForKey:@"appointInvest"];
//            if (investGroup) {
//                NSArray *investModels = investGroup.prdlist;
//                UCFHomeListCellModel *investModel = [investModels firstObject];
//                investModel.moedelType = UCFHomeListCellModelTypeReserved;
//                UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:investModel];
//                weakSelf.groupPresenter5.group.type = investGroup.type;
//                weakSelf.groupPresenter5.group.title = investGroup.title;
//                weakSelf.groupPresenter5.group.desc = investGroup.desc;
//                weakSelf.groupPresenter5.group.iconUrl = investGroup.iconUrl;
//                weakSelf.groupPresenter5.group.prdlist = [NSArray arrayWithObjects:cellPresenter, nil];
//            }
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
        if ([weakSelf.view respondsToSelector:@selector(homeListViewPresenter:didRefreshDataWithResult:error:)]) {
            [self.view homeListViewPresenter:weakSelf didRefreshDataWithResult:result error:error];
        }
        
        !completionHander ?: completionHander(error, result);
    }];
}

- (UCFHomeListGroupPresenter *)homeListGroupPresenterWithGroup:(UCFHomeListGroup *)group
{
//    UCFHomeListGroup *tempGroup = [[UCFHomeListGroup alloc] init];
//    tempGroup.title = group.title;
//    tempGroup.iconUrl = group.iconUrl;
//    tempGroup.type = group.type;
    if ([group.type intValue] == 13 || [group.type intValue] == 16) {
        group.showMore = NO;
    }
    else {
        group.showMore = YES;
    }
    NSMutableArray *temp = [NSMutableArray new];
    for (UCFHomeListCellModel *model in group.prdlist) {
        if ([model.type isEqualToString:@"6"]) {
            model.moedelType = UCFHomeListCellModelTypeGoldFixed;
        }
        else if ([model.type isEqualToString:@"0"]) {
            model.moedelType = UCFHomeListCellModelTypeReserved;
        }
        else {
            model.moedelType = UCFHomeListCellModelTypeDefault;
        }
        UCFHomeListCellPresenter *cellPresenter = [UCFHomeListCellPresenter presenterWithItem:model];
        [temp addObject:cellPresenter];
    }
    group.prdlist = temp;
    return [UCFHomeListGroupPresenter presenterWithGroup:group];
}

#pragma mark - 重制数据
- (void)resetData {
    [self.homeListCells removeAllObjects];
    self.groupTransferPresenter = nil;
    [self initData];
}
@end
