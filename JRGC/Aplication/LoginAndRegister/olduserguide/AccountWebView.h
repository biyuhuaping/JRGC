//
//  AccountWebView.h
//  JRGC
//
//  Created by biyuhuaping on 16/8/16.
//  Copyright © 2016年 qinwei. All rights reserved.
//  开户成功web页

#import <UIKit/UIKit.h>
#import "UCFWebViewJavascriptBridgeController.h"

@interface AccountWebView : UCFWebViewJavascriptBridgeController

@property (nonatomic, strong) NSDictionary *postData;
@property BOOL isPresentViewController; //是否弹出视图

@end
