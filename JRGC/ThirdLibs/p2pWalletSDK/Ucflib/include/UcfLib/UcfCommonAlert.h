//
//  UcfCommonAlert.h
//  UcfWallet
//
//  Created by zsc on 15/7/27.
//  Copyright (c) 2015年 UcfPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum ItemType
{
    ITEM_OK,
    ITEM_CANCEL,
    ITEM_OTHER,
    ITEM_DESTRUCTIVE
    
}ItemType;

typedef enum StyleType
{
    STYLE_ALERT,
    STYLE_ACTION_SHEET
}StyleType;


@class UcfAlertItem;
typedef void(^UcfAlertHandler)(UcfAlertItem *item);


/**
 *  通用Alert，系统类型的Alert，为了兼容iOS8 以后的AlertViewController
 */
@interface UcfCommonAlert : NSObject
@property(nonatomic,readonly) NSArray *actions;

/**
 *  获取对应index的button title
 */
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (NSInteger)addButtonWithTitle:(NSString *)title;

/**
 *  初始化方法，StyleType对应是Alert 还是 Action
 */
- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message style:(StyleType)style;

/**
 *  添加按钮
 */
- (void)addButton:(ItemType)type withTitle:(NSString *)title handler:(UcfAlertHandler)handler;

/**
 *  就一个确定按钮的简单提示框
 */
+ (void)showMessage:(NSString *)title message:(NSString *)message;
- (void)show;
@end


@interface UcfAlertItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic) ItemType type;
@property (nonatomic) NSUInteger tag;
@property (nonatomic, copy) UcfAlertHandler action;
@end
