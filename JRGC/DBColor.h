//
//  DBColor.h
//  DUOBAO
//
//  Created by 战神归来 on 15/10/28.
//  Copyright © 2015年 战神归来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBColor : NSObject
/**
 *  16进制颜色转换
 */
+ (UIColor *) colorWithHexString: (NSString *)color andAlpha:(CGFloat )setAlpha;

/**
 *  根据颜色生成UIimage对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
@end
