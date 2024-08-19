//
//  CircleMapView.m
//  CircleConstructionMAP
//
//  Created by 余晋龙 on 16/8/20.
//  Copyright © 2016年 余晋龙. All rights reserved.
//

#import "CircleMapView.h"
#import "UIColor+Hex.h"
#import <math.h>
#define PI 3.14159265358979323846
//#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define degreesToRadian(x) ( 180.0 / PI * (x))

#define radiu 32.5 //中心白色圆的半径

@interface CircleMapView ()
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *signs;
@end

@implementation CircleMapView

- (NSArray *)colors
{
    if (!_colors) {
        _colors = [[NSArray alloc] initWithObjects:@"ff9897", @"93aaf2", nil];

    }
    return _colors;
}
- (NSArray *)signs
{
    if (!_signs) {
        _signs = [[NSArray alloc] initWithObjects:@"本人", @"C1全体", nil];
    }
    return _signs;
}

//初始化
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _circleRadius = self.frame.size.height * 0.5;
    }
    return self;
}

-(CGFloat)getShareNumber:(UCFDataStaticsModel *)model{  //比例
    CGFloat f = 0.0;
    for (int  i = 0; i < model.chartDetail.count; i++) {
        UCFDataDetailModel *detail = [model.chartDetail objectAtIndex:i];
        f += [detail.amount doubleValue];
    }
    NSLog(@"总量：%.2f  比例:%.2f",f,360.0 / f);
    return M_PI*2 / f;
}

-(void)drawRect:(CGRect)rect{
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if ([self.model.totalAmount doubleValue] == 0) {
        [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.height * 0.5, self.frame.size.height / 2) andWithAngle_start:0 andWithAngle_end:360 andWithColor:[UIColor colorWithHexString:@"e3e5ea"] andInt:0];
        if (self.model.chartDetail.count > 0) {
            for (int i = 0; i < self.model.chartDetail.count; i++) {
                //小圆的中心点
                CGFloat xx = _circleRadius * 2 + 30;
                CGFloat yy = 50 + i*(50+2.5);
                [self addInstructionsAndnumber:[UIColor colorWithHexString: self.colors[i]] andCGContextRef:ctx andX:xx andY:yy andInt:i];
            }
        }
    }
    else {
        CGFloat bl = [self getShareNumber:self.model]; //得到比例
        CGFloat angle_start =0; //开始时的弧度  －－－－－ 旋转200度
        CGFloat ff = 0;  //记录偏转的角度 －－－－－ 旋转200度
        for (int i = 0; i < self.model.chartDetail.count; i++) {
            UCFDataDetailModel *detail = [self.model.chartDetail objectAtIndex:i];
            //float angle_end = radians([_dataArray[i] floatValue] *bl + ff);  //结束
            CGFloat angle_end =([detail.amount  doubleValue] *bl + ff);  //结束
            ff += [detail.amount doubleValue] *bl;  //开始之前的角度
            DDLogDebug(@"angle-end:%f", angle_end);
            
            //drawArc(ctx, self.center, angle_start, angle_end, _colorArray[i]);
            
            // 1.上下文
            // 2.中心点
            // 3.开始
            // 4.结束
            // 5.颜色
            
            [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.height * 0.5, self.frame.size.height / 2) andWithAngle_start:angle_start andWithAngle_end:angle_end andWithColor:[UIColor colorWithHexString: self.colors[i]] andInt:i];
            
            //        NSLog(@"开始:%.2f  数据:%.2f  加值:%.2f  结束: %.2f   AAA:%.2f",angle_start,[_dataArray[i] floatValue],[_dataArray[i] floatValue] *bl,angle_end,[_dataArray[i] floatValue] *bl + angle_start);
            
            
            angle_start = angle_end;
            
            //小圆的中心点
            CGFloat xx = _circleRadius * 2 + 30;
            CGFloat yy = 50 + i*(50+2.5);
            
            //添加说明
            [self addInstructionsAndnumber:[UIColor colorWithHexString: self.colors[i]] andCGContextRef:ctx andX:xx andY:yy andInt:i];
            }

    }
    
    [self addCenterCircle];//添加中心圆
}

//添加中心圆
-(void)addCenterCircle{
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.height / 2, self.frame.size.height / 2) radius:radiu startAngle:0 endAngle:PI * 2 clockwise:YES];
    
    [[UIColor whiteColor] set];
    [arcPath fill];
    [arcPath stroke];
    
}


-(CGFloat)radians:(CGFloat)degrees {  //由角度获取弧度
    return degrees * M_PI / 180;
}
-(void)drawArcWithCGContextRef:(CGContextRef)ctx
                  andWithPoint:(CGPoint) point
            andWithAngle_start:(float)angle_start
              andWithAngle_end:(float)angle_end
                  andWithColor:(UIColor *)color
                        andInt:(int)n {
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( color.CGColor));
    CGContextAddArc(ctx, point.x, point.y, self.bounds.size.height * 0.5,  angle_start, angle_end, 0);
    CGContextFillPath(ctx);
}

/**
 * @color 颜色
 * @ctx CGContextRef
 * @x 小圆的中心点的x
 * @y 小圆的中心点的y
 * @n 表示第几个弧行
 * @angele 弧度的中心角度
 */

//添加说明
-(void)addInstructionsAndnumber:(UIColor *)color
        andCGContextRef:(CGContextRef)ctx
                   andX:(CGFloat)x
                   andY:(CGFloat)y
                 andInt:(int)n
{
    
    //NSLog(@"%f ----/  %f",x,y);
    
    //小圆中心点
    CGFloat smallCircleCenterPointX = x;
    CGFloat smallCircleCenterPointY = y;
    
    //画边上的小圆
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(smallCircleCenterPointX, smallCircleCenterPointY) radius:4 startAngle:0 endAngle:PI * 2 clockwise:YES];
    [color set];
    [arcPath fill];
    [arcPath stroke];

    // 数字的长度
    CGSize itemSizeNumber;
    UCFDataDetailModel * detail = [self.model.chartDetail objectAtIndex:0];
    NSString *tempStr;
    double rate =0;
    if ([self.model.totalAmount doubleValue] == 0) {
        tempStr = [NSString stringWithFormat:@"%@", self.signs[n]];
    }
    else if ([detail.amount doubleValue]==0) {
        
        if (n==0) {
            rate = [detail.amount doubleValue] / [self.model.totalAmount doubleValue] * 100;
        }
        else {
            rate = 100 - [detail.amount doubleValue] / [self.model.totalAmount doubleValue] * 100;
        }
        tempStr = [NSString stringWithFormat:@"%@%d%%", self.signs[n], (int)rate];
    }
    else {
        if (n==0) {
            rate = [detail.amount doubleValue] / [self.model.totalAmount doubleValue] * 100;
            if (rate < 0.01) {
                rate = 0.01;
                tempStr = [NSString stringWithFormat:@"%@%.2f%%", self.signs[n], rate];
            }
            else if (rate > 99.99) {
                rate = 99.99;
                tempStr = [NSString stringWithFormat:@"%@%.2f%%", self.signs[n], rate];
            }
            else {
                rate = [self roundCashValue:rate];
                tempStr = [NSString stringWithFormat:@"%@%@%%", self.signs[n], [self removeZero:rate]];
            }
        }
        else {
            rate = 100 - [detail.amount doubleValue] / [self.model.totalAmount doubleValue] * 100;
            if (rate < 0.01) {
                rate = 0.01;
                tempStr = [NSString stringWithFormat:@"%@%.2f%%", self.signs[n], rate];
            }
            else if (rate > 99.99) {
                rate = 99.99;
                tempStr = [NSString stringWithFormat:@"%@%.2f%%", self.signs[n], rate];
            }
            else {
                rate = 100 - [self roundCashValue:([detail.amount doubleValue] / [self.model.totalAmount doubleValue] * 100)];
                tempStr = [NSString stringWithFormat:@"%@%@%%", self.signs[n], [self removeZero:rate]];
            }
        }
//        [self roundCashValue:rate];
        
    }
    itemSizeNumber = [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]}];
  
//    数字的起点
    CGFloat numberStartX = x + 7;
    CGFloat numberStartY = y - itemSizeNumber.height * 0.5;
    
    //指引线上面的数字
    [tempStr drawAtPoint:CGPointMake(numberStartX, numberStartY) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0],NSForegroundColorAttributeName:color}];
   
    //文字的起点
    CGFloat textStartX = numberStartX;
    CGFloat textStartY = numberStartY + itemSizeNumber.height+10;
    
    //指引线下面的text
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
     paragraph.alignment = NSTextAlignmentLeft;
   
    detail = [self.model.chartDetail objectAtIndex:n];
    [[NSString stringWithFormat:@"¥%.2f", [detail.amount doubleValue]] drawInRect:CGRectMake(textStartX, textStartY, 150, 50) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x555555"],NSParagraphStyleAttributeName:paragraph}];

}
- (void)setModel:(UCFDataStaticsModel *)model {
    _model = model;
    [self setNeedsDisplay];
}

- (double)roundCashValue:(double)value
{
    NSArray *array = [[NSString stringWithFormat:@"%f", value] componentsSeparatedByString:@"."];
    
    NSInteger pointBefore = [[array firstObject] integerValue];
    double pointAfter = value-pointBefore;
    
    if (pointAfter < 0.004) {
        return pointBefore;
    }
    else return pointBefore + pointAfter + 0.01;
}


- (NSString *)removeZero:(double)value
{
    NSArray *array = [[NSString stringWithFormat:@"%f", value] componentsSeparatedByString:@"."];
    NSString *pointAfter = [[array lastObject] substringToIndex:1];
    if ([pointAfter hasPrefix:@"0"]) {
        pointAfter = [pointAfter substringToIndex:0];
        return [NSString stringWithFormat:@"%@.%@",[array firstObject], pointAfter];
    }
    else if ([pointAfter isEqualToString:@"00"]) {
        return [array firstObject];
    }
    else
        return [NSString stringWithFormat:@"%.2f",value];
}
@end
