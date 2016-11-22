//
//  UCFSettingGroup.h
//  JRGC
//
//  Created by NJW on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFSettingGroup : NSObject
// 头部标题
@property (nonatomic, copy) NSString *headTitle;
// 尾部标题
@property (nonatomic, copy) NSString *footerTitle;
// 组中的选项
@property (nonatomic, strong) NSMutableArray *items;

@end
