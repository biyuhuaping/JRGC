//
//  FundsDetailGroup.h
//  JRGC
//
//  Created by NJW on 15/4/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundsDetailGroup : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray *content;

+ (instancetype)fundDetailGroupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
