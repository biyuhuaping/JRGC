//
//  UCFP2PAuthPaymentWebViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2018/2/2.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFWebViewJavascriptBridgeController.h"
@protocol UCFP2PAuthPaymentWebViewControllerDelegate <NSObject>
//***授权是否成功
- (void)isP2PAuthPaymentSuccess:(NSString *)isSuccess;//@"success"成功 @"fair" 失败
@end

@interface UCFP2PAuthPaymentWebViewController : UCFWebViewJavascriptBridgeController
@property(nonatomic, assign)id<UCFP2PAuthPaymentWebViewControllerDelegate> delegate;
@end

