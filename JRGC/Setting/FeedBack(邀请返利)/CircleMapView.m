//
//  CircleMapView.m
//  CircleConstructionMAP
//
//  Created by 余晋龙 on 16/8/20.
//  Copyright © 2016年 余晋龙. All rights reserved.
//

#import "CircleMapView.h"
#import "UIColor+Hex.h"
#define PI 3.14159265358979323846
//#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define degreesToRadian(x) ( 180.0 / PI * (x))

#define radiu 32.5 //中心白色圆的半径
@implementation CircleMapView
//初始化
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataArray = [[NSMutableArray alloc] init];
        _circleRadius = self.frame.size.height * 0.5;
    }
    return self;
}

-(CGFloat)getShareNumber:(NSMutableArray *)arr{  //比例
    CGFloat f = 0.0;
    for (int  i = 0; i < arr.count; i++) {
        f += [arr[i][@"number"] floatValue];
    }
    NSLog(@"总量：%.2f  比例:%.2f",f,360.0 / f);
    return M_PI*2 / f;
}

-(void)drawRect:(CGRect)rect{
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.height * 0.5, self.frame.size.height / 2) andWithAngle_start:0 andWithAngle_end:360 andWithColor:[UIColor colorWithHexString:@"e3e5ea"] andInt:0];
   
    
    CGFloat bl = [self getShareNumber:_dataArray]; //得到比例
    
       //float angle_start = radians(0.0); //开始
    CGFloat angle_start =0; //开始时的弧度  －－－－－ 旋转200度
    CGFloat ff = 0;  //记录偏转的角度 －－－－－ 旋转200度
    for (int i = 0; i < _dataArray.count; i++) {
        //float angle_end = radians([_dataArray[i] floatValue] *bl + ff);  //结束
        CGFloat angle_end =([_dataArray[i][@"number"]  floatValue] *bl + ff);  //结束
        ff += [_dataArray[i][@"number"] floatValue] *bl;  //开始之前的角度
        
        //drawArc(ctx, self.center, angle_start, angle_end, _colorArray[i]);
        
        // 1.上下文
        // 2.中心点
        // 3.开始
        // 4.结束
        // 5.颜色
        
        [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.height * 0.5, self.frame.size.height / 2) andWithAngle_start:angle_start andWithAngle_end:angle_end andWithColor:[UIColor colorWithHexString: _dataArray[i][@"color"]] andInt:i];
        
        
//        NSLog(@"开始:%.2f  数据:%.2f  加值:%.2f  结束: %.2f   AAA:%.2f",angle_start,[_dataArray[i] floatValue],[_dataArray[i] floatValue] *bl,angle_end,[_dataArray[i] floatValue] *bl + angle_start);
        
        
        angle_start = angle_end;
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
    
    //小圆的中心点
    CGFloat xx = _circleRadius * 2 + 30;
    CGFloat yy = 50 + n*(30+2.5);
    
    //添加说明
    [self addInstructionsAndnumber:color andCGContextRef:ctx andX:xx andY:yy andInt:n];
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
    CGSize itemSizeNumber = [[NSString stringWithFormat:@"%@",_dataArray[n][@"number"]] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    
//    数字的起点
    CGFloat numberStartX = x + 7;
    CGFloat numberStartY = y - itemSizeNumber.height * 0.5;
    
    //指引线上面的数字
    [[NSString stringWithFormat:@"%@",_dataArray[n][@"number"]] drawAtPoint:CGPointMake(numberStartX, numberStartY) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSForegroundColorAttributeName:color}];
    
    //文字的起点
    CGFloat textStartX = numberStartX;
    CGFloat textStartY = numberStartY + itemSizeNumber.height;
    
    //指引线下面的text
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
     paragraph.alignment = NSTextAlignmentLeft;
   
    [_dataArray[n][@"name"] drawInRect:CGRectMake(textStartX, textStartY, 150, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self setNeedsDisplay];
}
@end
