//
//  UCFLockHandleViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/9.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#define LLLockRetryTimes 5 // 最多重试几次
#define LLLockAnimationOn  // 开启窗口动画，注释此行即可关闭

#import <UIKit/UIKit.h>
#import "LLLockView.h"
#import "LLLockPassword.h"
#import "LLLockConfig.h"
#import "RegisterSuccessAlert.h"

// 进入此界面时的不同目的
typedef enum {
    LLLockViewTypeCheck,  // 检查手势密码
    LLLockViewTypeCreate, // 创建手势密码
    LLLockViewTypeModify, // 修改
    LLLockViewTypeClean,  // 清除
}LLLockViewType;

@class UCFLockHandleViewController;
@protocol UCFLockHandleDelegate <NSObject>

@optional
- (void)lockHandleViewController:(UCFLockHandleViewController *)lockHandleVC didClickLeapWithSign:(BOOL)sign;

@end

@interface UCFLockHandleViewController : UIViewController <LLLockDelegate,UIAlertViewDelegate,RegSuccessDelegate>

@property (nonatomic) LLLockViewType nLockViewType; // 此窗口的类型
@property (nonatomic,assign) BOOL isFromRegister;
@property (nonatomic, weak) id<UCFLockHandleDelegate> delegate;
@property (nonatomic, copy) NSString *souceVc;

- (id)initWithType:(LLLockViewType)type; // 直接指定方式打开
- (void)hide;
- (void)openTouchidAlert;
@end
