//
//  KTAlertController.h
//  KTAlertController
//
//  Created by Kevin on 16/8/14.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KTAlertControllerAnimationType)
{
    KTAlertControllerAnimationTypeCenterShow = 0,   // 从中间放大弹出
    KTAlertControllerAnimationTypeUpDown            // 从上往下掉
};

typedef enum : NSUInteger {
    CalulateTypeNone = 0,
    CalulateTypeEqualRepaymentBySeason,
    CalulateTypeEqualRepaymentByMonth,
    CalulateTypeOnceRepaymentAndInterest,
    CalulateTypeRepaymentOnlyCapital,
    CalulateTypeOnceRepaymentByDay,
} CalulateType;

@interface KTAlertController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, assign) KTAlertControllerAnimationType animationType;

+ (instancetype)alertControllerWithTitle:(NSString *)title description:(NSString *)description cancel:(NSString *)cancel button:(NSString *)button action:(void (^)())buttonAction;

@end
