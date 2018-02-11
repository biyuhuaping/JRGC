//
//  UCFSettingFuncItem.h
//  JRGC
//
//  Created by njw on 2018/2/2.
//  Copyright © 2018年 qinwei. All rights reserved.
//

#import "UCFSettingItem.h"

typedef enum : NSUInteger {
    UCFSettingBatchLendingTypeNone = 10,
    UCFSettingBatchLendingTypeUnopened,
    UCFSettingBatchLendingTypeOverduring,
    UCFSettingBatchLendingTypeOpenned,
} UCFSettingBatchLendingType;

typedef enum : NSUInteger {
    UCFSettingPaymentAuthTypeNone = 10,
    UCFSettingPaymentAuthTypeUnAuth,
    UCFSettingPaymentAuthTypeAuthed,
    UCFSettingPaymentAuthTypeOverAuth,
} UCFSettingPaymentAuthType;

@interface UCFSettingFuncItem : UCFSettingItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;
@property (nonatomic, assign) UCFSettingBatchLendingType batchLendingType;
@property (nonatomic, assign) UCFSettingPaymentAuthType paymentAuthType;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;
@end
