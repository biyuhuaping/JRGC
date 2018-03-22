//
//  ASIHTTPRequest+Owner.m
//  JRGC
//
//  Created by zrc on 2018/3/22.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "ASIHTTPRequest+Owner.h"
#import <objc/runtime.h>
#import "OriginalObject.h"
@implementation ASIHTTPRequest (Owner)

- (id<NetworkModuleDelegate>)owner
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setOwner:(id<NetworkModuleDelegate>)owner
{
    OriginalObject *ob = [[OriginalObject alloc] initWithBlock:^{
        objc_setAssociatedObject(self, @selector(owner), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 这里关联的key必须唯一，如果使用_cmd，对一个对象多次关联的时候，前面的对象关联会失效。
    objc_setAssociatedObject(owner, (__bridge const void *)(ob.block), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(owner), owner, OBJC_ASSOCIATION_ASSIGN);
}
@end
