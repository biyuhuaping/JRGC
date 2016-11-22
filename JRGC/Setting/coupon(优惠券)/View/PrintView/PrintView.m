//
//  MaskView.m
//  印章demo
//
//  Created by NJW on 15/4/22.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import "PrintView.h"
#import "UIImage+zhang.h"

@interface PrintView ()

@end

@implementation PrintView

- (instancetype)initWithFrame:(CGRect)frame andTime:(NSString *)time
{
    self = [super initWithFrame:frame];
    if (self) {
        self.useTime = time;
    }
    return self;
}

- (void)setUseTime:(NSString *)useTime
{
    _useTime = useTime;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *oldPrintImage = [UIImage imageNamed:@"coupon_icon_stamp"];
    UIImage *image = nil;
    if (self.conponType == 2) {
        oldPrintImage = [UIImage imageNamed:@"coupon_icon_expired"];
        image = [UIImage addText:oldPrintImage text:@""];
    }else{
        image = [UIImage addText:oldPrintImage text:self.useTime];
    }
    
    CGSize size = [oldPrintImage size];
    
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 95, 0);
    CGContextRotateCTM(ctx, (18.0f * M_PI) / 180.0f);
    
    // 将ctx拷贝一份放到栈中
    CGContextSaveGState(ctx);
    
    [image drawInRect:CGRectMake(0, 10, size.width, size.height)];
    
    // 将栈顶的上下文出栈,替换当前的上下文
    CGContextRestoreGState(ctx);
}

@end
