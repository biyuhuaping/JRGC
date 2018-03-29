//
//  P2PWalletHelper.h
//  JRGC
//
//  Created by 张瑞超 on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GetWalletDataSource) {
    GetWalletDataDefault = 0, //从TabBar 进入
    GetWalletDataTwoBank,     //两张选择新银卡进入刷新
    GetWalletDataOpenHS       //开通徽商进入
};
@interface P2PWalletHelper : NSObject<NetworkModuleDelegate>
@property(assign, nonatomic) GetWalletDataSource source;

+ (P2PWalletHelper *)sharedManager;
- (UIViewController *)getUCFWalletTargetController;
- (BOOL)checkUserHSStateCanOpenWallet;
- (void)getUserWalletData:(GetWalletDataSource)source;
- (void)refreshWalletData:(NSDictionary *)dict;
- (void)changeTabMoveToWalletTabBar;
@end
