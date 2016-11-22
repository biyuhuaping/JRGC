//
//  UCFSettingSwitchItem.h
//  JRGC
//
//  Created by NJW on 15/4/20.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingItem.h"

@interface UCFSettingSwitchItem : UCFSettingItem
// 1 代表指纹解锁开关
@property(nonatomic)NSInteger   switchType;
// 扩展父类方法
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title withSwitchType:(NSInteger)switchType;
@end
