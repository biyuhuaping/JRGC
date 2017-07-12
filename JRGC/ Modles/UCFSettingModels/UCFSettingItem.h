//
//  UCFSettingItem.h
//  JRGC
//
//  Created by NJW on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFSettingItem : NSObject

typedef void (^UCFSettingItemOption)();
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;


/**
 *  存储数据用的key
 */
@property (nonatomic, copy) NSString *key;
/**
 *  是否可选则（No不可选择-至灰色）
 */

@property (nonatomic, assign) BOOL isSelect;

/**
 *  点击那个cell需要做什么事情
 */
@property (nonatomic, copy) UCFSettingItemOption option;

@property (nonatomic,assign) BOOL isShowOrHide; // YES 显示 NO 不显示

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle;
@end
