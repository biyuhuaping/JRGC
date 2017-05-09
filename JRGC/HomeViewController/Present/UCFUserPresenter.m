//
//  UCFUserPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserPresenter.h"
#import "UCFUserInfoListItem.h"

@interface UCFUserPresenter ()
@property (strong, nonatomic) NSMutableArray *userInfoListCells;
// p2p账户可用余额
@property (copy, nonatomic) NSString *p2pBalanceMoney;
// 尊享账户可用余额
@property (copy, nonatomic) NSString *hornerBalanceMoney;
// 尊享是否开户
@property (assign, nonatomic) BOOL isHonorUser;
// P2P账户是否开户
@property (assign, nonatomic) BOOL isP2PUser;
@end

@implementation UCFUserPresenter

#pragma mark - 系统方法
- (instancetype)init {
    if (self = [super init]) {
        self.userInfoListCells = [NSMutableArray array];
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

- (BOOL)isHonorUser
{
    return _isHonorUser;
}

#pragma mark - 初始化数据
- (void)initUI
{
    UCFUserInfoListItem *userInfoList0 = [UCFUserInfoListItem itemWithTitle:@"P2P账户" destVcClass:nil];
    userInfoList0.isShow = self.isP2PUser;
    if (self.isP2PUser) {
        userInfoList0.subtitle = self.p2pBalanceMoney.length > 0 ? [NSString stringWithFormat:@"%@元", self.p2pBalanceMoney] : @"0.00元";
    }
    else {
        userInfoList0.subtitle = @"未开户";
    }
    
    UCFUserInfoListItem *userInfoList1 = [UCFUserInfoListItem itemWithTitle:@"尊享账户" destVcClass:nil];
    userInfoList1.isShow = self.isHonorUser;
    if (self.isHonorUser) {
        userInfoList1.subtitle = self.hornerBalanceMoney.length > 0 ? [NSString stringWithFormat:@"%@元", self.hornerBalanceMoney] : @"";
    }
    else {
        userInfoList1.subtitle = @"未开户";
    }
}
@end
