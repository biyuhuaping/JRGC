//
//  SDLoopProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-19.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDLoopProgressView.h"

@implementation SDLoopProgressView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    if (self.completedColor) {
        [self.completedColor set];
    }else{
        [UIColorWithRGB(0xfd4d4c) set];
    }
    CGContextSetLineWidth(ctx, 6);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2;
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - 5.0;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
    
    // 进度数字
//    NSString *progressStr = [NSString stringWithFormat:@"%.0f", self.progress * 100];
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20 * SDProgressViewFontScale];
//    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    [self setCenterProgressText:progressStr withAttributes:attributes];
}

@end
