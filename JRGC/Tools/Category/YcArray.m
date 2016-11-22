//
//  NSMutableArray+YcMutableArray.m
//  minShengOa
//
//  Created by zfx on 13-11-2.
//  Copyright (c) 2013年 li maoshan. All rights reserved.
//

#import "YcArray.h"

@implementation NSArray (YcArray)

- (id)objectSafeAtIndex:(NSUInteger)index
{
    if ([self isEqual:[NSNull null]]) {
        DBLog(@"数组为空！");
        return nil;
    }
    
    else if (index >= [self count]) {
        DBLog(@"数组越界！");
        return nil;
    }
    
    return self[index];
}

@end
