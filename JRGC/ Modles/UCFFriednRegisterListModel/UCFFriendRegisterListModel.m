//
//  UCFFriendRegisterListModel.m
//  JRGC
//
//  Created by 金融工场 on 14/11/28.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFFriendRegisterListModel.h"

@implementation UCFFriendRegisterListModel

- (instancetype)initWithRegisterDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.realName = dict[@"realName"];
        self.numPhone = dict[@"mobile"];
        self.createTime = dict[@"createTime"];
        self.loginName = dict[@"loginName"];
    }
    return self;

}

+ (instancetype)friendRegistWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithRegisterDict:dict];
}


@end
