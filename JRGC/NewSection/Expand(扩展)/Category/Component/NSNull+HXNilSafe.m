//
//  NSNull+HXNilSafe.m
//  HXNullDictionary
//
//  Created by ShiCang on 16/9/28.
//  Copyright © 2016年 Caver. All rights reserved.
//

#import "NSNull+HXNilSafe.h"
#import "NSObject+HXSwizzling.h"


@implementation NSNull (HXNilSafe)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hx_swizzleMethod:@selector(methodSignatureForSelector:) withMethod:@selector(hx_methodSignatureForSelector:)];
        [self hx_swizzleMethod:@selector(forwardInvocation:) withMethod:@selector(hx_forwardInvocation:)];
    });
}

- (NSMethodSignature *)hx_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self hx_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)hx_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        // nothing to do
        return;
    }
    
    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    
    [anInvocation setReturnValue:buffer];
}


@end
