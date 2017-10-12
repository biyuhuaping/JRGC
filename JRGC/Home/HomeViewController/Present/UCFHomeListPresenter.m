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

@interface UCFHomeListPresenter ()
@property (strong, nonatomic) UCFHomeAPIManager *apiManager;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *homeListCells;
@property (strong, nonatomic) NSMutableArray *homeIconList;
@property (assign, nonatomic) BOOL authorization;

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
    if ([group.type intValue] == 13 || [group.type intValue] == 16 || [group.type intValue] == 17) {
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
        else if ([group.type isEqualToString:@"13"]) {
            model.moedelType = UCFHomeListCellModelTypeNewUser;
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
}

#pragma mark - 无奈的代码
- (BOOL)checkIDAAndBankBlindState:(SelectAccoutType)type {
    
    //    [UserInfoSingle sharedManager].openStatus = [listInfo.openStatus integerValue];
    //    [UserInfoSingle sharedManager].enjoyOpenStatus
    NSUInteger openStatus = (type == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus  : [UserInfoSingle sharedManager].enjoyOpenStatus );
    __weak typeof(self) weakSelf = self;
    if (openStatus == 1 || openStatus == 2) {
        NSString *message = (type == SelectAccoutTypeP2P ? P2PTIP1 : ZXTIP1);
        NSInteger step = (type == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus  : [UserInfoSingle sharedManager].enjoyOpenStatus);
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
            if (index == 1) {
                HSHelper *helper = [HSHelper new];
                UIViewController *VC = (UIViewController *)weakSelf.view;
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
    [MBProgressHUD showHUDAddedTo:baseVC.parentViewController.view animated:YES];
    __weak typeof(self) weakSelf = self;
    NSString *type = [parameter objectForKey:@"type"];
    [self.apiManager fetchProDetailInfoWithParameter:parameter completionHandler:^(NSError *error, id result) {
        if (type.intValue == 4) {
//            if ([weakSelf.iconDelegate respondsToSelector:@selector(userInfoPresenter:didReturnPrdClaimsDealBidWithResult:error:)]) {
//                [weakSelf.userInfoViewDelegate userInfoPresenter:self didReturnPrdClaimsDealBidWithResult:result error:error];
//            }
        }
        !completionHander ?: completionHander(error, result);
    }];
}

- (void)fetchCollectionDetailDataWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHander
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.iconDelegate;
    [MBProgressHUD showHUDAddedTo:baseVC.parentViewController.view animated:YES];
    //    __weak typeof(self) weakSelf = self;
    [self.apiManager fetchCollectionDetailInfoWithParameter:parameter completionHandler:^(NSError *error, id result) {
        !completionHander ?: completionHander(error, result);
    }];
}
@end
