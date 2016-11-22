//
//  NZLabel.h
//  NZLabel
//
//  Created by Bruno Furtado on 03/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@class ZBLinkLabelModel;
typedef void (^ZBLinkLabelBlock)(ZBLinkLabelModel *linkModel);

@interface NZLabel : UILabel

- (void)setBoldFontToRange:(NSRange)range;
- (void)setBoldFontToString:(NSString *)string;

- (void)setFontColor:(UIColor *)color range:(NSRange)range;
- (void)setFontColor:(UIColor *)color string:(NSString *)string;

- (void)setFont:(UIFont *)font range:(NSRange)range;
- (void)setFont:(UIFont *)font string:(NSString *)string;
- (void)addLinkString:(NSString *)linkString block:(ZBLinkLabelBlock)linkBlock;

@end


@interface ZBLinkLabelModel : NSObject
@property (copy, nonatomic) ZBLinkLabelBlock linkBlock;
@property (copy, nonatomic) NSString *linkString;
@property (assign, nonatomic) NSRange range;
@property (strong, nonatomic) id parameter;//点击链点的相关参数：id，色值，字体大小等

- (instancetype)initLinkLabelModelWithString:(NSString *)linkString range:(NSRange)range linkParameter:(id)parameter block:(ZBLinkLabelBlock)linkBlock;

@end
