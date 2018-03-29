//
//  NSString+FormatForThousand.h
//  JRGC
//
//  Created by NJW on 15/5/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormatForThousand)

//千位分隔符
+ (NSString *)getKilobitDecollator:(double)floatVel withUnit:(NSString *)unit;

@end
