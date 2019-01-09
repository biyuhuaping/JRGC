//
//  NSObject+HXSwizzling.h
//  HXNullDictionary
//
//  Created by ShiCang on 16/9/28.
//  Copyright © 2016年 Caver. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (HXSwizzling)


+ (BOOL)hx_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;

+ (BOOL)hx_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel;


@end
