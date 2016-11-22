//
//  FundAccountGroup.h
//  SectionDemo
//
//  Created by NJW on 15/4/23.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundAccountGroup : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *content;
/**
 *  数组中装的都是Funds模型
 */
@property (nonatomic, strong) NSArray *fundlist;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
