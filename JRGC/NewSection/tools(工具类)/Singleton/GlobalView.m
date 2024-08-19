//
//  GlobalView.m
//  JRGC
//
//  Created by zrc on 2019/1/17.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "GlobalView.h"

@implementation GlobalView
+ (GlobalView *)sharedManager
{
    static GlobalView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
