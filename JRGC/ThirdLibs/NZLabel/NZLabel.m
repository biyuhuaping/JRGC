//
//  NZLabel.m
//  NZLabel
//
//  Created by Bruno Furtado on 03/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#import "NZLabel.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

@interface NZLabel ()

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSMutableAttributedString *attributedString;
@property (strong, nonatomic) NSMutableArray *linkArray;

@end

@implementation NZLabel

static inline CGFloat ZBFlushFactorForTextAlignment(NSTextAlignment textAlignment) {
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            return 0.5f;
        case NSTextAlignmentRight:
            return 1.0f;
        case NSTextAlignmentLeft:
        default:
            return 0.0f;
    }
}

#pragma mark - Public methods
- (void)setBoldFontToRange:(NSRange)range
{
    NSString *fontNameBold = [NSString stringWithFormat:@"%@-Bold", [[self.font familyName] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    if (![UIFont fontWithName:fontNameBold size:self.font.pointSize]) {
#ifdef NZDEBUG
        NSLog(@"%s: Font not found: %@", __PRETTY_FUNCTION__, fontNameBold);
#endif
        return;
    }
    
    UIFont *font = [UIFont fontWithName:fontNameBold size:self.font.pointSize];
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributed addAttribute:NSFontAttributeName value:font range:range];
    
    self.attributedText = attributed;
}

- (void)setBoldFontToString:(NSString *)string
{
    NSRange range = [self.text rangeOfString:string];
    [self setBoldFontToRange:range];
}

- (void)setFontColor:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributed addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.attributedText = attributed;
}

- (void)setFontColor:(UIColor *)color string:(NSString *)string
{
    NSRange range = [self.text rangeOfString:string];
    [self setFontColor:color range:range];
}
- (void)setMoreColor:(UIColor *)color string:(NSString *)string
{
    if (self.text == nil) {
        DDLogDebug(@"当前内容为空");
        return;
    }
    NSMutableString *strTemp = [[NSMutableString alloc] initWithString:self.text];
    NSMutableArray *array = [NSMutableArray array];
    NSRange range;
    while (1) {
        range = [strTemp rangeOfString:string];
        if(range.location == NSNotFound)
        {
            break;
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:range.location],@"location",[NSNumber numberWithInteger:range.length],@"length", nil];
        //        NSInteger anInteger = [aNumber integerValue];
        [array addObject:dic];
        
        [strTemp replaceOccurrencesOfString:string withString:[self getReplaceOccurrencesOfStringNum:range.length] options:NSCaseInsensitiveSearch range:range]; ;
    }
    //    [self setFont:font range:range];
    [self setMoreColor:color rangeArray:array];
}
- (NSString *)getReplaceOccurrencesOfStringNum:(NSInteger )num
{
    NSMutableString *strLenst = [NSMutableString new];
    for (int i = 1; i <= num; i++) {
        [strLenst appendString:@"`"];
    }
    return [strLenst copy];
}
- (void)setMoreColor:(UIColor *)color rangeArray:(NSMutableArray *)range
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    for (int i = 0; i < [range count]; i++) {
        NSDictionary *dic = [range objectAtIndex:i];
        NSRange rangeTemp ;
        rangeTemp.location = [[dic objectForKey:@"location"] integerValue];
        rangeTemp.length = [[dic objectForKey:@"length"] integerValue];
        [attributed addAttribute:NSForegroundColorAttributeName value:color range:rangeTemp];
    }
    self.attributedText = attributed;
}
- (void)setFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributed addAttribute:NSFontAttributeName value:font range:range];
    
    self.attributedText = attributed;
}

- (void)setFont:(UIFont *)font string:(NSString *)string
{
    NSRange range = [self.text rangeOfString:string];
    [self setFont:font range:range];
}

- (void)setMoreFont:(UIFont *)font string:(NSString *)string
{
    NSMutableString *strTemp = [[NSMutableString alloc] initWithString:self.text];;
    NSMutableArray *array = [NSMutableArray array];
    NSRange range;
    while (1) {
        range = [strTemp rangeOfString:string];
        if(range.location == NSNotFound)
        {
            break;
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:range.location],@"location",[NSNumber numberWithInteger:range.length],@"length", nil];
        [array addObject:dic];
        NSRange abc ;
        abc.length = 1;
        abc.location = range.location;
        [strTemp replaceOccurrencesOfString:string withString:@"`" options:NSCaseInsensitiveSearch range:range]; ;
    }
    [self setMoreFont:font rangeArray:array];
}
- (void)setMoreFont:(UIFont *)font rangeArray:(NSMutableArray *)range
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    for (int i = 0; i < [range count]; i++) {
        NSDictionary *dic = [range objectAtIndex:i];
        NSRange rangeTemp ;
        rangeTemp.location = [[dic objectForKey:@"location"] integerValue];
        rangeTemp.length = [[dic objectForKey:@"length"] integerValue];
        [attributed addAttribute:NSFontAttributeName value:font range:rangeTemp];
    }
    self.attributedText = attributed;
}

- (void)addLinkString:(NSString *)linkString block:(ZBLinkLabelBlock)linkBlock{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)];
    [self addGestureRecognizer:tap];
    
    NSRange range = [self.text rangeOfString:linkString];
    ZBLinkLabelModel *linkModel = [[ZBLinkLabelModel alloc]initLinkLabelModelWithString:linkString range:range linkParameter:nil block:linkBlock];
    if (linkModel) {
        [self.linkArray addObject:linkModel];
    }
}

#pragma mark - Private methods
- (NSMutableArray *)linkArray {
    if (!_linkArray) {
        _linkArray = [[NSMutableArray alloc]init];
    }
    return _linkArray;
}

- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture{
//    NSParameterAssert(self != nil);
//    
//    CGSize labelSize = self.bounds.size;
//    // 创建实例 NSLayoutManager（布局管理器），NSTextContainer（文本容器），NSTextStorage（文本存储）
//    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
//    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
//    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
//    
//    // 配置布局管理器和文本存储
//    [layoutManager addTextContainer:textContainer];
//    [textStorage addLayoutManager:layoutManager];
//    
//    // 配置label的文本容器
//    textContainer.lineFragmentPadding = 0.0;
//    textContainer.lineBreakMode = self.lineBreakMode;
//    textContainer.maximumNumberOfLines = self.numberOfLines;
//    textContainer.size = labelSize;
//    
//    // 找到点击字符的位置，对比指定范围
//    CGPoint locationOfTouchInLabel = [tapGesture locationInView:self];
//    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
//    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
//                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
//    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
//                                                         locationOfTouchInLabel.y - textContainerOffset.y);
//    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer inTextContainer:textContainer fractionOfDistanceBetweenInsertionPoints:nil];
//    NSRange targetRange = [self.text rangeOfString:self.linkString];
//    if (NSLocationInRange(indexOfCharacter, targetRange)) {
//        self.linkBlock(self.linkString);
//    }
    CGPoint location = [tapGesture locationInView:self];
    NSUInteger curIndex = (NSUInteger)[self characterIndexAtPoint:location];
    for (ZBLinkLabelModel *linkModel in _linkArray) {
        NSRange range = [self.text rangeOfString:linkModel.linkString];
        if (NSLocationInRange(curIndex, range)) {
            linkModel.linkBlock(linkModel);
        }
    }
}

- (CFIndex)characterIndexAtPoint:(CGPoint)p {
    CGRect textRect = self.bounds;
    //textRect的height值存在误差，值需设大一点，不然不会包含最后一行lines
    CGRect pathRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width, textRect.size.height+ 100000);
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    // p.x-5 是因为测试发现x轴坐标有偏移误差
    p = CGPointMake(p.x-5, pathRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, pathRect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CGPathRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CGPathRelease(path);
        return NSNotFound;
    }
    
    CFIndex idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = (CGFloat)floor(lineOrigin.y - descent);
        CGFloat yMax = (CGFloat)ceil(lineOrigin.y + ascent);
        
        // Apply penOffset using flushFactor for horizontal alignment to set lineOrigin since this is the horizontal offset from drawFramesetter
        CGFloat flushFactor = ZBFlushFactorForTextAlignment(self.textAlignment);
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, textRect.size.width);
        lineOrigin.x = penOffset;
        
        // Check if we've already passed the line
        if (p.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (p.y >= yMin) {
            // Check if the point is within this line horizontally
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CGPathRelease(path);
    DDLogDebug(@"点击第%ld个字符",idx);
    return idx;
}

@end








@implementation ZBLinkLabelModel
- (instancetype)initLinkLabelModelWithString:(NSString *)linkString range:(NSRange)range linkParameter:(id)parameter block:(ZBLinkLabelBlock)linkBlock {
    if ((self = [super init])) {
        _linkBlock = linkBlock;
        _linkString = [linkString copy];
        _range = range;
        _parameter = parameter;
    }
    return self;
}

@end
