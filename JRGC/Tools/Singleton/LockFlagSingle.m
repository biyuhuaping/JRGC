//
//  LockFlagSingle.m
//  JRGC
//
//  Created by 金融工场 on 15/9/16.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "LockFlagSingle.h"

@implementation LockFlagSingle
+ (LockFlagSingle *)sharedManager
{
    static LockFlagSingle *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
