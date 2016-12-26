/*
 * Copyright (c) 2011 Eli Wang
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */


#import "UIView+AddLine.h"


@implementation UIView(AddLine)

- (void)addHorizontalLineWithWidth:(CGFloat)width color:(UIColor *)color atOrigin:(CGPoint)origin
{
    CGRect f = self.frame;
    f.size.height += width;
    self.frame = f;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y,
                                                                  self.frame.size.width - origin.x, width)];
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubview:bottomLine];
}

- (UIView *)addVerticalLineWithWidth:(CGFloat)width color:(UIColor *)color atOrigin:(CGPoint)origin
{
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, self.frame.size.height - origin.y)];
    vLine.backgroundColor = color;
    vLine.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:vLine];
    
    return vLine;
}

@end
