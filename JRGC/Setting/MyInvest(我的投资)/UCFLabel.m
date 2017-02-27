//
//  UCFLabel.m
//  Test01
//
//  Created by njw on 2017/2/27.
//  Copyright © 2017年 njw. All rights reserved.
//

#import "UCFLabel.h"

@implementation UCFLabel

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor whiteColor];
    [super drawTextInRect:rect];
    self.textColor = [UIColor redColor];
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
}

@end
