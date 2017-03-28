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

// 可用余额
@property (copy, nonatomic) NSString *balanceMoney;
// 最近回款日
@property (copy, nonatomic) NSString *lastBackMoneyDate;
// 尊享是否开户
@property (assign, nonatomic) BOOL isHonorUser;
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
    listModel0_0.subtitle = self.balanceMoney.length > 0 ? [NSString stringWithFormat:@"%@元", self.balanceMoney] : @"0.00元";
    listModel0_0.describeWord = self.lastBackMoneyDate.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.lastBackMoneyDate] : @"";
    UCFPCListCellPresenter *presenter0_0 = [UCFPCListCellPresenter presenterWithItem:listModel0_0];
    UCFPCListModel *listModel0_1 = [UCFPCListModel itemWithTitle:@"尊享账户" destVcClass:nil];
    listModel0_1.subtitle = @"委托投资、多重保障";
    listModel0_1.describeWord = self.isHonorUser ? @"已开户" : @"未开户";
    UCFPCListCellPresenter *presenter0_1 = [UCFPCListCellPresenter presenterWithItem:listModel0_1];
    group0.items = [NSMutableArray array];
    [group0.items addObject:presenter0_0];
    [group0.items addObject:presenter0_1];
    
    UCFPCGroupPresenter *group1 = [[UCFPCGroupPresenter alloc] init];
    UCFPCListModel *listModel1_0 = [UCFPCListModel itemWithIcon:@"" title:@"常用工具" destVcClass:nil];
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
//    self.userId= @"930334";
//    [[NSUserDefaults standardUserDefaults] setValue:self.userId forKey:UUID];
//    [[NSUserDefaults standardUserDefaults]  synchronize];
    if (self.userId.length>0) {
        [self.apiManager fetchUserInfoWithUserId:self.userId completionHandler:^(NSError *error, id result) {
//            self.isHonorUser = YES;
            
            if ([result isKindOfClass:[UCFPersonCenterModel class]]) {
                UCFPersonCenterModel *personCenter = result;
                self.isHonorUser = [personCenter.enjoyOpenStatus isEqualToString:@"1"] ? NO : YES;
                self.balanceMoney = personCenter.p2pAmount;
                self.lastBackMoneyDate = personCenter.p2pRepayPerDate;
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
    
    
//    [self.apiManager refreshUserBlogsWithUserId:self.userId completionHandler:^(NSError *error, id result) {
//        
//        if (!error) {
//            
//            [self.blogs removeAllObjects];
//            [self formatResult:result];
//        }
//        
//        if ([self.view respondsToSelector:@selector(blogViewPresenter:didRefreshDataWithResult:error:)]) {
//            [self.view blogViewPresenter:self didRefreshDataWithResult:result error:error];
//        }
//        
//        !completionHander ?: completionHander(error, result);
//    }];
}

- (void)refreshData {
    [self fetchDataWithCompletionHandler:nil];
}



@end
