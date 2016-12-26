//
//  FundAccountItem.h
//  SectionDemo
//
//  Created by NJW on 15/4/23.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundAccountItem : NSObject
@property (nonatomic, copy) NSString *ItemName;
@property (nonatomic, strong) NSNumber *ItemData;

+ (instancetype)fundWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end