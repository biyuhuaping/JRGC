//
//  OriginalObject.m
//  weakCategory
//
//  Created by zrc on 2018/3/22.
//  Copyright © 2018年 zrc. All rights reserved.
//

#import "OriginalObject.h"

@implementation OriginalObject
- (instancetype)initWithBlock:(DeallocBlock)block
{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}
- (void)dealloc
{
    self.block ? self.block() : nil;
}
@end
