//
//  NSMutableDictionary+HXNilSafe.m
//  HXNullDictionary
//
//  Created by ShiCang on 16/9/28.
//  Copyright © 2016年 Caver. All rights reserved.
//

#import "NSMutableDictionary+HXNilSafe.h"
#import "NSObject+HXSwizzling.h"


@implementation NSMutableDictionary (HXNilSafe)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class hx_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(hx_setObject:forKey:)];
        [class hx_swizzleMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(hx_setObject:forKeyedSubscript:)];
    });
}

- (void)hx_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    
    if (!anObject) {
        anObject = [NSNull null];
    }
    
    [self hx_setObject:anObject forKey:aKey];
}

- (void)hx_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    
    if (!obj) {
        obj = [NSNull null];
    }
    
    [self hx_setObject:obj forKeyedSubscript:key];
}


@end
