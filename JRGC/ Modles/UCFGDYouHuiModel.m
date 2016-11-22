//
//  UCFGDYouHuiModel.m
//  JRGC
//
//  Created by HeJing on 15/1/5.
//  Copyright (c) 2015年 www.ucfgroup.com. All rights reserved.
//

#import "UCFGDYouHuiModel.h"

@implementation UCFGDYouHuiModel

- (instancetype)initWithGongDouDict:(NSDictionary *)dict;
{
    if (self = [super init]) {
        self.fafangStyle = dict[@"issueType"];
        self.fafangTime = dict[@"issueTime"];
        self.gongDouCount = dict[@"beanCount"];
        self.alreadyUse = dict[@"beanUsed"];
        self.noUse = dict[@"beanUnused"];
        self.alreadyExpired = dict[@"beanOverdue"];
        self.youxiao = dict[@"overdueTime"];
    }
    return self;
}

+ (instancetype)gongDouWithDict:(NSDictionary *)dict;
{
    return [[self alloc]initWithGongDouDict:dict];
}



@end
