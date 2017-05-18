//
//  UcfWalletSDK.h
//  UcfWalletSDK
//
//  Created by Songchao Zhang on 17/4/21.
//  Copyright © 2017年 UcfWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UcfWalletSDK : NSObject

+ (UIViewController *)wallet:(NSDictionary *)params retHandler:(id)handler retSelector:(SEL)selector navTitle:(NSString *)title;

//切换用户登录等情况时，可调用刷新
+ (void)refreshWalletVC:(NSDictionary *)params navTitle:(NSString *)title walletVC:(UIViewController *)vc;

+ (void)updateWalletBadgeWithMerchantId:(NSString *)merchantId
                                 UserId:(NSString *)userId
                               isDelete:(BOOL)isDelete
                                 result:(void (^)(NSDictionary *resultDict))result;

+ (void)setEnvironment:(NSInteger)environment;

+ (BOOL)handleApplication:(UIApplication *)application openUrl:(NSURL *)url;

+ (BOOL)handleApplication:(UIApplication *)application openUrl:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options;
@end
