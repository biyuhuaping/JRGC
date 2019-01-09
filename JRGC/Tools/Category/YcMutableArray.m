//
//  NSMutableArray+YcMutableArray.m
//  minShengOa
//
//  Created by zfx on 13-11-2.
//  Copyright (c) 2013年 li maoshan. All rights reserved.
//

#import "YcMutableArray.h"

@implementation NSMutableArray (YcMutableArray)

- (id)objectSafeAtIndex:(NSUInteger)index
{
    if ([self isEqual:[NSNull null]]) {
        DDLogDebug(@"数组为空！");
        return nil;
    }
    
    else if (index >= [self count]) {
        DDLogDebug(@"数组越界：%lu-%lu",(unsigned long)index,(unsigned long)self.count);
        return nil;
    }
    
    return self[index];
}

@end
