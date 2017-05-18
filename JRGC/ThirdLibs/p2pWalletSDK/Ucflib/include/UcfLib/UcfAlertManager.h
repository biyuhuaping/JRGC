//
//  UcfAlertManager.h
//  UcfWallet
//
//  Created by Songchao Zhang on 16/8/15.
//  Copyright © 2016年 UcfPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"
#import <UIKit/UIKit.h>

@interface UcfAlertManager : NSObject

UCF_AS_SINGLETON(UcfAlertManager)

- (void)showHud:(NSString *)msg;
- (void)showLoadingInView:(UIView *)view;
- (void)showLoadingWithMsg:(NSString *)msg;
- (void)hideHud;
- (void)showAlert:(NSString *)msg;
- (void)showDoneWithMsg:(NSString *)msg;

@end
