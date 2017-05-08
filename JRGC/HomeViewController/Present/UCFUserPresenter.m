//
//  UCFUserPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserPresenter.h"

@implementation UCFUserPresenter

#pragma mark - 系统方法
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - 类方法生成本类
+ (instancetype)presenter
{
    return [[self alloc] init];
}
@end
