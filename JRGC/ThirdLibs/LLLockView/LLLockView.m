//
//  LLLockView.m
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockView.h"
#import "Common.h"

#define kLLBaseCircleNumber 10000       // tag基数（请勿修改）
#define kCircleMargin 35.0              // 圆点离屏幕左边距
#define kCircleDiameter 60.0            // 圆点直径
#define kLLCircleAlpha 1.0              // 圆点透明度
#define kLLLineWidth 15.0               // 线条宽
#define kLLLineColor UIColorWithRGB(0xC2D0F7) // 线条色蓝
#define kLLLineColorWrong UIColorWithRGB(0xFFD1CD) // 线条色红

@interface LLLockView ()
{
    NSMutableArray* buttonArray;
    NSMutableArray* selectedButtonArray;
    NSMutableArray* wrongButtonArray;
    CGPoint nowPoint;
    
    NSTimer* timer;
    
    BOOL isWrongColor;
    BOOL isDrawing; // 正在画中
}

@end

@implementation LLLockView

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
    buttonArray = [NSMutableArray array];
    selectedButtonArray = [NSMutableArray array];
    
    // 初始化圆点
    for (int i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int x,y;
        if (kIS_Iphone4) {
            x = kCircleMargin + (i%3) * (kCircleDiameter+(320-kCircleMargin*2- kCircleDiameter *3)/2);
            y = kCircleMargin + (i/3) * (kCircleDiameter+(320-kCircleMargin*2- kCircleDiameter *3)/2);
            x = [Common calculateNewSizeBaseMachine:x];
            y = [Common calculateNewSizeBaseMachine:y];
        } else {
            x = 45 + (i%3) * (kCircleDiameter+(320- 45*2- kCircleDiameter *3)/2);
            y = 45 + (i/3) * (kCircleDiameter+(320- 45*2- kCircleDiameter *3)/2);
        }

//        LLLog(@"每个圆点位置 %d,%d", x, y);
        [button setFrame:CGRectMake(x, y, [Common calculateNewSizeBaseMachine:kCircleDiameter], [Common calculateNewSizeBaseMachine:kCircleDiameter])];
        
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"password_round_normal.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"password_round_right.png"] forState:UIControlStateSelected];
        button.userInteractionEnabled= NO;//禁止用户交互
        button.alpha = kLLCircleAlpha;
        button.tag = i + kLLBaseCircleNumber + 1; // tag从基数+1开始,
        [self addSubview:button];
        [buttonArray addObject:button];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    LLLog(@"touch began");
    isDrawing = NO;
    // 如果是错误色才重置(timer重置过了)
    if (isWrongColor) {
        [self clearColorAndSelectedButton];
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDrawing = YES;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    LLLog(@"输入密码结束");
    [self endPosition];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    LLLog(@"输入密码取消");
    [self endPosition];
}


#pragma mark - 绘制连线
- (void)drawRect:(CGRect)rect
{
    LLLog(@"drawRect - %@", [NSString stringWithFormat:@"%d", isWrongColor]);
    
    if (selectedButtonArray.count > 1) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        isWrongColor ? [kLLLineColorWrong set] : [kLLLineColor set]; // 正误线条色
        CGContextSetLineWidth(context, kLLLineWidth);
        
        // 画之前线s
        CGPoint addLines[9] = {0};
        int count = 0;
        for (UIButton* button in selectedButtonArray) {
            CGPoint point = CGPointMake(button.center.x, button.center.y);
            addLines[count++] = point;
            
            // 画中心圆
            CGRect circleRect = CGRectMake(button.center.x- kLLLineWidth/2,
                                           button.center.y - kLLLineWidth/2,
                                           kLLLineWidth,
                                           kLLLineWidth);
            CGContextSetFillColorWithColor(context, kLLLineColor.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        }
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, addLines, count);
        CGContextStrokePath(context);
         //*/
        
        // 画当前线
        UIButton* lastButton = selectedButtonArray.lastObject;
        CGContextMoveToPoint(context, lastButton.center.x, lastButton.center.y);
        CGContextAddLineToPoint(context, nowPoint.x, nowPoint.y);
        CGContextStrokePath(context);
    }
    
}

#pragma mark - 处理
// 当前手指位置
- (void)updateFingerPosition:(CGPoint)point{
    
    nowPoint = point;
    if (nowPoint.x < [Common calculateNewSizeBaseMachine:32]){
        nowPoint.x = [Common calculateNewSizeBaseMachine:32];
    } else if (nowPoint.y < [Common calculateNewSizeBaseMachine:32]){
        nowPoint.y = [Common calculateNewSizeBaseMachine:32];
    } else if (nowPoint.x > [Common calculateNewSizeBaseMachine:(320 - 32)]){
        nowPoint.x = [Common calculateNewSizeBaseMachine:(320 - 32)];
    } else if (nowPoint.y > [Common calculateNewSizeBaseMachine:(320 - 32)]){
        nowPoint.y = [Common calculateNewSizeBaseMachine:(320 - 32)];
    }
     
//    LLLog(@"point x=%f, y=%f", point.x, point.y);
    
    for (UIButton *thisbutton in buttonArray) {
        CGFloat xdiff =point.x-thisbutton.center.x;
        CGFloat ydiff=point.y - thisbutton.center.y;
        
        if (fabsf(xdiff) <36 &&fabsf (ydiff) <36){
            // 未选中的才能加入
            if (!thisbutton.selected) {
                thisbutton.selected = YES;
                [selectedButtonArray  addObject:thisbutton];
            }
        }
    }
    // 生成密码串
    UIButton *strbutton;
    NSString *string=@"";
    for (int i=0; i < selectedButtonArray.count; i++) {
        strbutton = selectedButtonArray[i];
        string= [string stringByAppendingFormat:@"%d",(int)strbutton.tag-kLLBaseCircleNumber];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setindecatorbtnnofication" object:nil userInfo:@{@"indecatorkey":string}];
    
    [self setNeedsDisplay];
    
//    [self addstring]; // 可以用来划完后自动解锁，不用松开手指
}

- (void)endPosition
{
    isDrawing = NO;
    
    UIButton *strbutton;
    NSString *string=@"";
    
    // 生成密码串
    for (int i=0; i < selectedButtonArray.count; i++) {
        strbutton = selectedButtonArray[i];
        string= [string stringByAppendingFormat:@"%d",(int)strbutton.tag-kLLBaseCircleNumber];
    }
    
    [self clearColorAndSelectedButton]; // 清除到初始样式
    
    if ([self.delegate respondsToSelector:@selector(lockString:)]) {
        if (string && string.length>0) {
            [self.delegate lockString:string];
        }
    }
    
    LLLog(@"addstring end Position");
//    [self addstring]; // 委托上一界面去处理
    
    LLLog(@"end Position");
    
}

// 清除至初始状态
- (void)clearColor
{
    if (isWrongColor) {
        LLLog(@"clearColorAndSelectedButton");
        // 重置颜色
        isWrongColor = NO;
        for (UIButton* button in buttonArray) {
            [button setBackgroundImage:[UIImage imageNamed:@"password_round_right.png"] forState:UIControlStateSelected];
        }
        
    }
}

- (void)clearSelectedButton
{
    // 换到下次按时再弄
    for (UIButton *thisButton in buttonArray) {
        [thisButton setSelected:NO];
    }
    [selectedButtonArray removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)clearColorAndSelectedButton
{
    if (!isDrawing) {
        [self clearColor];
        [self clearSelectedButton];
    }
    
}

#pragma mark - 生成密码
-(void)addstring{
    
}

#pragma mark - 显示错误
- (void)showErrorCircles:(NSString*)string
{
    LLLog(@"ShowError");

    isWrongColor = YES;
    
    NSMutableArray* numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSNumber* number = [NSNumber numberWithInt:[string substringWithRange:range].intValue-1]; // 数字是1开始的
        [numbers addObject:number];
        [buttonArray[number.intValue] setSelected:YES];
        
        [selectedButtonArray addObject:buttonArray[number.intValue]];
    }
    
    for (UIButton* button in buttonArray) {
        if (button.selected) {
            [button setBackgroundImage:[UIImage imageNamed:@"password_round_wrong.png"] forState:UIControlStateSelected];
        }
        
    }
    
    [self setNeedsDisplay];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(clearColorAndSelectedButton)
                                           userInfo:nil
                                            repeats:NO];
    
}


@end
