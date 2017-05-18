//
//  UcfTouchIDUtils.h
//  UcfWallet
//
//  Created by Songchao Zhang on 15/10/14.
//  Copyright © 2015年 UcfPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface UcfTouchIDUtils : NSObject


/**
 *  @prama msg 指纹弹框上展示的文字
 *  @prama succeed 验证指纹成功的block回调，failed 验证指纹失败或者设备不支持的block回调
 */
+ (void)authenticateUserWithMessage:(NSString *)msg Success:(dispatch_block_t)succeed failed:(void (^)(LAError errorCode))failed;

/**
 *  判断Touch ID 是否可用
 */
+ (BOOL)canAuthenticateUserSuccess:(dispatch_block_t)succeed failed:(void (^)(LAError errorCode))failed;
@end
