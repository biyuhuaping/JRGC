//
//  NSDictionary+HXNilSafe.m
//  HXNullDictionary
//
//  Created by ShiCang on 16/9/28.
//  Copyright © 2016年 Caver. All rights reserved.
//

#import "NSDictionary+HXNilSafe.h"
#import "NSObject+HXSwizzling.h"


@implementation NSDictionary (HXNilSafe)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hx_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(hx_initWithObjects:forKeys:count:)];
        [self hx_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(hx_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)hx_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    
    return [self hx_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)hx_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    
    return [self hx_initWithObjects:safeObjects forKeys:safeKeys count:j];
}


@end
