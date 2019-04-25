//
//  LLLockIndicator.m
//  LockSample
//
//  Created by Lugede on 14/11/13.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockIndicator.h"
#import "Common.h"

#define kLLBaseCircleNumber 10000       // tag基数（请勿修改）
#define kCircleDiameter 10.0            // 圆点直径
#define kCircleMargin   10.0              // 圆点间距


@interface LLLockIndicator ()
{
    BOOL    isWrongColor;
}
@property (nonatomic, strong) NSMutableArray* buttonArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation LLLockIndicator

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (void)initCircles
{
    self.buttonArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    // 初始化圆点
    for (int i=0; i<9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int x,y;
        if (kIS_Iphone4) {
            x = (i%3) * (kCircleDiameter+kCircleMargin);
            y = (i/3) * (kCircleDiameter+kCircleMargin);
        } else {
            x = (i%3) * (kCircleDiameter+7);
            y = (i/3) * (kCircleDiameter+7);
        }
        
        LLLog(@"每个圆点位置 %d,%d", x, y);
        [button setFrame:CGRectMake(x, y, kCircleDiameter, kCircleDiameter)];
        
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"password_point_normal.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"password_point_right.png"] forState:UIControlStateSelected];
        button.userInteractionEnabled= NO;//禁止用户交互
        button.tag = i + kLLBaseCircleNumber + 1; // tag从基数+1开始,
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setPasswordString:(NSString*)string
{
    for (UIButton* button in self.buttonArray) {
        [button setSelected:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"password_point_right.png"] forState:UIControlStateSelected];
    }
    [self.selectArray removeAllObjects];
    isWrongColor = NO;

    NSMutableArray* numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i=0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSNumber* number = [NSNumber numberWithInt:[string substringWithRange:range].intValue-1]; // 数字是1开始的
        [numbers addObject:number];
        [self.buttonArray[number.intValue] setSelected:YES];
        [self.selectArray addObject:self.buttonArray[number.intValue]];
    }
    [self setNeedsDisplay];
//    for (UIButton* button in buttonArray) {
//        if (button.selected) {
//            [button setBackgroundImage:[UIImage imageNamed:@"password_round_wrong.png"] forState:UIControlStateSelected];
//        }
//
//    }
}
- (void)showErrorCircles:(NSString*)string
{
    LLLog(@"ShowError");
    
    isWrongColor = YES;
    [self.selectArray removeAllObjects];

    NSMutableArray* numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSNumber* number = [NSNumber numberWithInt:[string substringWithRange:range].intValue-1]; // 数字是1开始的
        [numbers addObject:number];
        [self.buttonArray[number.intValue] setSelected:YES];
        
        [self.selectArray addObject:self.buttonArray[number.intValue]];
    }
    
    for (UIButton* button in self.selectArray) {
        if (button.selected) {
            [button setBackgroundImage:[UIImage imageNamed:@"password_point_wrong"] forState:UIControlStateSelected];
        }
        
    }
    
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    if (self.selectArray.count > 1) {
        
        UIColor *rightColor = UIColorWithRGB(0xC2D0F7);
        UIColor *wrongColor = UIColorWithRGB(0xFFD1CD);
        CGFloat LineWidth = 4.0f;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        isWrongColor ? [wrongColor set] : [rightColor set]; // 正误线条色
        CGContextSetLineWidth(context, LineWidth);
        
        // 画之前线s
        CGPoint addLines[9];
        int count = 0;
        for (UIButton* button in self.selectArray) {
            CGPoint point = CGPointMake(button.center.x, button.center.y);
            addLines[count++] = point;
            
            // 画中心圆
            CGRect circleRect = CGRectMake(button.center.x- LineWidth/2,
                                           button.center.y - LineWidth/2,
                                           LineWidth,
                                           LineWidth);
            CGContextSetFillColorWithColor(context, rightColor.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        }
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, addLines, count);
        CGContextStrokePath(context);
        //*/
        
        // 画当前线
//        UIButton* lastButton = self.selectArray.lastObject;
//        CGContextMoveToPoint(context, lastButton.center.x, lastButton.center.y);
//        CGContextAddLineToPoint(context, nowPoint.x, nowPoint.y);
//        CGContextStrokePath(context);
    }
}
@end
