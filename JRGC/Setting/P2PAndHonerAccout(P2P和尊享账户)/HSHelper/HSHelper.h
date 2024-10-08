//
//  HSHelper.h
//  JRGC
//
//  Created by 金融工场 on 2017/3/28.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFOldUserGuideViewController.h"
#import "UCFBankDepositoryAccountViewController.h"
#import "UCFGoldAuthorizationViewController.h"
@interface HSHelper : NSObject <NetworkModuleDelegate>
-(NSString *)checkCompanyIsOpen:(SelectAccoutType)accoutType;
-(BOOL)checkP2POrWJIsAuthorization:(SelectAccoutType)accoutType;
- (BOOL)checkHSState:(SelectAccoutType)type withValue:(NSInteger)vlaue;
- (void)pushP2POrWJAuthorizationType:(SelectAccoutType)type nav:(UINavigationController *)nav;
- (void)pushGoldAuthorizationType:(SelectAccoutType)type nav:(UINavigationController *)nav;//黄金授权
- (void)pushGoldAuthorizationType:(SelectAccoutType)type nav:(UINavigationController *)nav sourceVC:(NSString *)soucreFrom;
- (void)pushOpenHSType:(SelectAccoutType)type Step:(NSInteger)step nav:(UINavigationController *)nav;
//isPrensentView 视图是否是模态出来的 默认是NO 
- (void)pushOpenHSType:(SelectAccoutType)type Step:(NSInteger)step nav:(UINavigationController *)nav isPresentView:(BOOL)isPresent;

/**
 微金开户
 */
+ (void)goToWeijinOpenAccount:(UINavigationController *)nav;
@end
