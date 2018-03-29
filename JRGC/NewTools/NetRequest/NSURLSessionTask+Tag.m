//
//  NSURLSessionTask+Tag.m
//  JRGC
//
//  Created by zrc on 2018/3/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "NSURLSessionTask+Tag.h"
#import <objc/runtime.h>

static char *strKey = "ksxTag";
@implementation NSURLSessionTask (Tag)
- (void)setKsxTag:(int)tag
{
    objc_setAssociatedObject(self, strKey, [NSNumber numberWithInt:tag], OBJC_ASSOCIATION_ASSIGN);
}
- (int)ksxTag {
    NSNumber *numberValue = objc_getAssociatedObject(self, strKey);
    return [numberValue intValue];
}
@end
