//
//  Image.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/30.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Image : NSObject


+ (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType;

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;

+ (UIImage*)createImageWithColor:(UIColor*)color withCGRect:(CGRect)rec;
@end

NS_ASSUME_NONNULL_END
