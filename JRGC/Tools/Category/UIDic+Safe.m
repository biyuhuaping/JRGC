//
//  UIDic+Safe.m
//  JYDReserve
//
//  Created by 卢俊城 on 14-8-6.
//  Copyright (c) 2014年 卢俊城. All rights reserved.
//

#import "UIDic+Safe.h"

@implementation NSDictionary (Safe)

- (id)objectSafeForKey:(NSString *)key
{
    if (!key) {
        DDLogDebug(@"key为空");
        return @"";
    }
    else if([self[key] isKindOfClass:[NSNull class]]){
        DDLogDebug(@"字典为空(Null)");
        return @"";
    }
    else if (!self[key]) {
        DDLogDebug(@"字典为空(nil)");
        return @"";
    }
    return self[key];
}
- (id)objectSafeDictionaryForKey:(NSString *)key
{
    if (!key) {
        DDLogDebug(@"key为空");
        return @{};
    }
    else if([self[key] isKindOfClass:[NSNull class]]){
        DDLogDebug(@"字典为空(Null)");
        return @{};
    }
    else if (!self[key]) {
        DDLogDebug(@"字典为空(nil)");
        return @{};
    }
    return self[key];
}
- (id)objectSafeArrayForKey:(NSString *)key
{
    if (!key) {
        DDLogDebug(@"key为空");
        return @[];
    }
    else if([self[key] isKindOfClass:[NSNull class]]){
        DDLogDebug(@"字典为空(Null)");
        return @[];
    }
    else if (!self[key]) {
        DDLogDebug(@"字典为空(nil)");
        return @[];
    }
    return self[key];
}
- (BOOL)isExistenceforKey:(NSString *)key
{
    if([[self allKeys] containsObject:key])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
