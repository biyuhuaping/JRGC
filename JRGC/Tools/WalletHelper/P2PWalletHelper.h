//
//  P2PWalletHelper.h
//  JRGC
//
//  Created by 张瑞超 on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P2PWalletHelper : NSObject<NetworkModuleDelegate>
+ (P2PWalletHelper *)sharedManager;
- (UIViewController *)getUCFWalletTargetController;
- (BOOL)checkUserHSStateCanOpenWallet;
- (void)getUserWalletData;
@end
