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
#import "UCFHomeIconModel.h"
#import "UCFHomeIconPresenter.h"
#import "HSHelper.h"
#import "UCFAttachModel.h"
@interface UCFHomeListPresenter ()<NetworkModuleDelegate>
@property (strong, nonatomic) UCFHomeAPIManager *apiManager;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *homeListCells;
@property (strong, nonatomic) NSMutableArray *homeIconList;
@property (assign, nonatomic) BOOL authorization;
@property (strong, nonatomic) NSDictionary  *showSectionsDict;
@property (assign, nonatomic) NSInteger     currentRequestIndex;
//@property (strong, nonatomic) UCFHomeListGroupPresenter *groupTransferPresenter;
@end

@implementation UCFHomeListPresenter

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
        self.homeIconList = [[NSMutableArray alloc] init];
//        [self initData];
    }
    return self;
}

#pragma mark - Interface

- (NSArray *)allDatas {
    return self.homeListCells;
}

- (NSArray *)allHomeIcons {
    return self.homeIconList;
}

#pragma mark - 请求首页列表数据

- (void)fetchHomeIconListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{
    __weak typeof(self) weakSelf = self;
    [self.apiManager fetchHomeIconListWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            [weakSelf.homeIconList removeAllObjects];
            weakSelf.canReservedClicked = YES;
            NSDictionary *resultDict = result;
            NSArray *iconList = [resultDict objectForKey:@"productMap"];
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (UCFHomeIconModel *homeIconModel in iconList) {
                UCFHomeIconPresenter *iconPresenter = [UCFHomeIconPresenter presenterWithItem:homeIconModel];
                [temp addObject:iconPresenter];
            }
            weakSelf.homeIconList = temp;
        }
        else if ([result isKindOfClass:[NSString class]]) {
            
        }
        if ([weakSelf.iconDelegate respondsToSelector:@selector(homeIconListViewPresenter:didRefreshDataWithResult:error:)]) {
            [self.iconDelegate homeIconListViewPresenter:weakSelf didRefreshDataWithResult:result error:error];
        }
        
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)fetchHomeListDataWithCompletionHandler:(NetworkCompletionHandler)completionHander {
    __weak typeof(self) weakSelf = self;
    self.canReservedClicked = YES;
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
            weakSelf.homeListCells = temp;
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
    if ([group.type intValue] == 0) {
        group.showMore = NO;
    }
    else {
        group.showMore = YES;
    }
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (UCFHomeListCellModel *model in group.prdlist) {
        
        if ([group.type isEqualToString:@"0"]) {
            model.moedelType = UCFHomeListCellModelTypeNewUser;
            [temp addObject:model];
            break;
        } else if ([group.type isEqualToString:@"19"]) {
            model.moedelType = UCFHomeListCellModelTypeDebtsTransfer;
            [temp addObject:model];
        } else {
            if ([model.type isEqualToString:@"0"]) { //预约
                model.moedelType = UCFHomeListCellModelTypeReserved;
            } else if ([model.type isEqualToString:@"1"]) { //P2P散标
                model.moedelType = UCFHomeListCellModelTypeDefault;
            } else if ([model.type isEqualToString:@"3"]) { //智存宝
                model.moedelType = UCFHomeListCellModelTypeAI;
            } else if ([model.type isEqualToString:@"14"]) { //批量
                model.moedelType = UCFHomeListCellModelTypeBatch;
            }
            [temp addObject:model];
        }
    }
    group.prdlist = temp;
    return [UCFHomeListGroupPresenter presenterWithGroup:group];
}

#pragma mark - 重制数据
- (void)resetData {
    [self.homeListCells removeAllObjects];
}

#pragma mark - 无奈的代码
- (BOOL)checkIDAAndBankBlindState:(SelectAccoutType)type {
    NSUInteger openStatus = (type == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus  : [UserInfoSingle sharedManager].enjoyOpenStatus );
    __weak typeof(self) weakSelf = self;
    if (openStatus == 1 || openStatus == 2) {
        NSString *message = (type == SelectAccoutTypeP2P ? P2PTIP1 : ZXTIP1);
        NSInteger step = (type == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus  : [UserInfoSingle sharedManager].enjoyOpenStatus);
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
            if (index == 1) {
                HSHelper *helper = [HSHelper new];
                UIViewController *VC = (UIViewController *)weakSelf.iconDelegate;
                [helper pushOpenHSType:type Step:step nav:VC.parentViewController.navigationController];
            }
        } otherButtonTitles:@"确认"];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)fetchProDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.iconDelegate;
    [MBProgressHUD showOriginHUDAddedTo:baseVC.parentViewController.view animated:YES];
    __weak typeof(self) weakSelf = self;
    NSString *type = [parameter objectForKey:@"type"];
    [self.apiManager fetchProDetailInfoWithParameter:parameter completionHandler:^(NSError *error, id result) {
        if (type.intValue == 4  || type.intValue == 10) {
            if ([weakSelf.iconDelegate respondsToSelector:@selector(homeIconListPresenter:didReturnPrdClaimsDealBidWithResult:error:)]) {
                [weakSelf.iconDelegate homeIconListPresenter:weakSelf didReturnPrdClaimsDealBidWithResult:result error:error];
            }
        }
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)fetchCollectionDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.iconDelegate;
    [MBProgressHUD showOriginHUDAddedTo:baseVC.parentViewController.view animated:YES];
    //    __weak typeof(self) weakSelf = self;
    [self.apiManager fetchCollectionDetailInfoWithParameter:parameter completionHandler:^(NSError *error, id result) {
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)getDefaultShowListSection:(NSDictionary *)parameter
{
    [[NetworkModule sharedNetworkModule] newPostReq:parameter tag:kSXTagGetHomeShowSections owner:self signature:NO Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == kSXTagGetHomeShowSections) {
        self.showSectionsDict = dic;
        if ([self.showSectionsDict[@"data"][@"resultData"] count] > 0) {
            
            NSArray *dataArr = self.showSectionsDict[@"data"][@"resultData"];
            if (dataArr.count != self.homeListCells.count) {
                [self.homeListCells removeAllObjects];
            }
            _currentRequestIndex = 0;
            [self getSectionDeatilData];
        }
    } else if (tag.intValue == kSXTagGetHomeNewUserSection) {
        NSDictionary  *dataDict = dic[@"data"];
        UCFHomeListGroup * tempG = [[UCFHomeListGroup alloc] init];
        NSArray *dataArr = self.showSectionsDict[@"data"][@"resultData"];
        for (NSDictionary *sectionDict in dataArr) {
            if ([sectionDict[@"type"] intValue] == 0) { //新手专区
                tempG.iconUrl = sectionDict[@"iconUrl"];
                tempG.showMore = NO;
                tempG.title = sectionDict[@"title"];
                tempG.type = [NSString stringWithFormat:@"%@",sectionDict[@"type"]];
                NSMutableArray *tmp = [[NSMutableArray alloc] init];
                for (NSDictionary *dd in dataDict[@"attach"]) {
                    UCFAttachModel *attach = [UCFAttachModel attachListWithDict:dd];
                    [tmp addObject:attach];
                }
                tempG.attach = tmp;
                NSMutableArray *prdArr = [NSMutableArray arrayWithCapacity:1];
                UCFHomeListCellModel *model = [[UCFHomeListCellModel alloc] initWithDictionary:dataDict[@"prdClaim"]];
                [prdArr addObject:model];
                tempG.prdlist = prdArr;
                
                UCFHomeListGroupPresenter *groupPresenter = [self homeListGroupPresenterWithGroup:tempG];
                BOOL hasCache = NO;
                for (UCFHomeListGroupPresenter *tmpgroupPresenter in self.homeListCells) {
                    if (tmpgroupPresenter.type == groupPresenter.type) {
                        hasCache = YES;
                        NSInteger index = [self.homeListCells indexOfObject:tmpgroupPresenter];
                        [self.homeListCells replaceObjectAtIndex:index withObject:groupPresenter];
                        break;
                    }
                }
                if (!hasCache) {
                    [self.homeListCells addObject:groupPresenter];
                }
                if ([self.view respondsToSelector:@selector(homeListViewPresenter:didRefreshDataWithResult:error:)]) {
                    [self.view homeListViewPresenter:self didRefreshDataWithResult:result error:nil];
                }
                _currentRequestIndex++;
                [self getSectionDeatilData];
                
                break;
            }
        }
    }
    else if (tag.intValue == kSXTagGetHomeOtherSection) {
        NSArray *dataArr = self.showSectionsDict[@"data"][@"resultData"];
        NSDictionary *sectionDict = dataArr[_currentRequestIndex];
        UCFHomeListGroup * tempG = [[UCFHomeListGroup alloc] init];
    
        tempG.iconUrl = sectionDict[@"iconUrl"];
        tempG.showMore = YES;
        tempG.title = sectionDict[@"title"];
        tempG.type = [NSString stringWithFormat:@"%@",sectionDict[@"type"]];
        
        NSDictionary *dataDict = dic[@"data"];
        NSMutableArray *prdArr = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dd in dataDict[@"resultData"]) {
            UCFHomeListCellModel *model = [[UCFHomeListCellModel alloc] initWithDictionary:dd];
            [prdArr addObject:model];
        }
        tempG.prdlist = prdArr;
        BOOL hasCache = NO;

        UCFHomeListGroupPresenter *groupPresenter = [self homeListGroupPresenterWithGroup:tempG];
        for (UCFHomeListGroupPresenter *tmpgroupPresenter in self.homeListCells) {
            if (tmpgroupPresenter.type == groupPresenter.type) {
                hasCache = YES;
                NSInteger index = [self.homeListCells indexOfObject:tmpgroupPresenter];
                [self.homeListCells replaceObjectAtIndex:index withObject:groupPresenter];
                break;
            }
        }
        if (!hasCache) {
            [self.homeListCells addObject:groupPresenter];
        }
        
        if ([self.view respondsToSelector:@selector(homeListViewPresenter:didRefreshDataWithResult:error:)]) {
            [self.view homeListViewPresenter:self didRefreshDataWithResult:result error:nil];
        }
        _currentRequestIndex++;
        [self performSelector:@selector(getSectionDeatilData) withObject:nil afterDelay:0];
    }

}
- (void)getSectionDeatilData
{
    NSArray *dataArr = self.showSectionsDict[@"data"][@"resultData"];
    if (_currentRequestIndex <= dataArr.count - 1) {
        NSDictionary *sectionDict = dataArr[_currentRequestIndex];
        if ([sectionDict[@"type"] intValue] == 0) { //新手专区
            NSDictionary *parmDict = nil;
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
            if (userId) {
                parmDict = @{@"userId":userId};
            }
            [[NetworkModule sharedNetworkModule] newPostReq:parmDict tag:kSXTagGetHomeNewUserSection owner:self signature:NO Type:SelectAccoutDefault];
        } else {
            NSDictionary *parmDict = nil;
            parmDict = @{@"type":[NSString stringWithFormat:@"%@",sectionDict[@"type"]]};
            [[NetworkModule sharedNetworkModule] newPostReq:parmDict tag:kSXTagGetHomeOtherSection owner:self signature:NO Type:SelectAccoutDefault];
        }
    }
    

}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}

@end
