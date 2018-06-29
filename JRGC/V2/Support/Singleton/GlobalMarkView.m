//
//  GlobalMarkView.m
//  ZXB
//
//  Created by 金融工场 on 2018/2/2.
//  Copyright © 2018年 UCFGROUP. All rights reserved.
//

#import "GlobalMarkView.h"
@implementation GlobalMarkView
+ (GlobalMarkView *)sharedManager
{
    static GlobalMarkView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


@end
