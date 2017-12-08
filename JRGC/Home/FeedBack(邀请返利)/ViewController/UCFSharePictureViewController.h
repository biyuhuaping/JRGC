//
//  UCFSharePictureViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/11/29.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"

typedef NS_ENUM(NSUInteger, KTAlertControllerAnimationType)
{
    KTAlertControllerAnimationTypeCenterShow = 0,   // 从中间放大弹出
    KTAlertControllerAnimationTypeUpDown            // 从上往下掉
};

@interface UCFSharePictureViewController : UCFBaseViewController
@property (nonatomic, assign) KTAlertControllerAnimationType animationType;
@property (weak, nonatomic) IBOutlet UIView *backView;

+ (instancetype)showSharePictureViewController;
@end
