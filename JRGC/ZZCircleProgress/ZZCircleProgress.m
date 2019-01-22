//
//  ZZCircleProgress.m
//  ZZCircleProgressDemo
//
//  Created by iMac on 2016/12/23.
//  Copyright © 2016年 zhouxing. All rights reserved.
//

#import "ZZCircleProgress.h"
#import "NSTimer+timerBlock.h"

//角度转换为弧度
#define CircleDegreeToRadian(d) ((d)*M_PI)/180.0
//255进制颜色转换
#define CircleRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//宽高定义
#define CircleSelfWidth self.frame.size.width
#define CircleSelfHeight self.frame.size.height


@implementation ZZCircleProgress
{
    CGFloat fakeProgress;
    NSTimer *timer;//定时器用作动画
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame
                pathBackColor:(UIColor *)pathBackColor
                pathFillColor:(UIColor *)pathFillColor
                   startAngle:(CGFloat)startAngle
                  strokeWidth:(CGFloat)strokeWidth {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        if (pathBackColor) {
            _pathBackColor = pathBackColor;
        }
        if (pathFillColor) {
            _pathFillColor = pathFillColor;
        }
        _startAngle = CircleDegreeToRadian(startAngle);
        _strokeWidth = strokeWidth;
    }
    return self;
}

//初始化数据
- (void)initialization {
    self.backgroundColor = [UIColor clearColor];
    _pathBackColor = CircleRGB(204, 204, 204);
    _pathFillColor = CircleRGB(255, 65, 51);
    _strokeWidth = 10;//线宽默认为10
    _startAngle = -CircleDegreeToRadian(90);//圆起点位置
    _reduceValue = CircleDegreeToRadian(0);//整个圆缺少的角度
    _animationModel = CircleIncreaseByProgress;//根据进度来
    _showPoint = YES;//小圆点
    _showProgressText = YES;//文字
    _forceRefresh = NO;//一直刷新动画
    
    fakeProgress = 0.0;//用来逐渐增加直到等于progress的值
    //获取图片资源
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"ZZCircleProgress" ofType:@"bundle"]];
    _pointImage = [UIImage imageNamed:@"circle_point1" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
}

#pragma Set
- (void)setStartAngle:(CGFloat)startAngle {
    if (_startAngle != CircleDegreeToRadian(startAngle)) {
        _startAngle = CircleDegreeToRadian(startAngle);
        [self setNeedsDisplay];
    }
}

- (void)setReduceValue:(CGFloat)reduceValue {
    if (_reduceValue != CircleDegreeToRadian(reduceValue)) {
        if (reduceValue>=360) {
            return;
        }
        _reduceValue = CircleDegreeToRadian(reduceValue);
        [self setNeedsDisplay];
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
        [self setNeedsDisplay];
    }
}

- (void)setPathBackColor:(UIColor *)pathBackColor {
    if (_pathBackColor != pathBackColor) {
        _pathBackColor = pathBackColor;
        [self setNeedsDisplay];
    }
}

- (void)setPathFillColor:(UIColor *)pathFillColor {
    if (_pathFillColor != pathFillColor) {
        _pathFillColor = pathFillColor;
        [self setNeedsDisplay];
    }
}

- (void)setShowPoint:(BOOL)showPoint {
    if (_showPoint != showPoint) {
        _showPoint = showPoint;
        [self setNeedsDisplay];
    }
}

-(void)setShowProgressText:(BOOL)showProgressText {
    if (_showProgressText != showProgressText) {
        _showProgressText = showProgressText;
        [self setNeedsDisplay];
    }
}
//-(void)setProgressText:(NSString *)progressText {
//    if (progressText != progressText) {
//        _showProgressText = showProgressText;
//        [self setNeedsDisplay];
//    }
//}


//画背景线、填充线、小圆点、文字
- (void)drawRect:(CGRect)rect {
//    [_progressLayer removeFromSuperlayer];
//    [_gradientLayer removeFromSuperlayer];
    [super drawRect:rect];
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置中心点 半径 起点及终点
    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0-1;//留出一像素，防止与边界相切的地方被切平
    CGFloat endA = _startAngle + (CircleDegreeToRadian(360) - _reduceValue);//圆终点位置
    CGFloat valueEndA = _startAngle + (CircleDegreeToRadian(360)-_reduceValue)*fakeProgress;  //数值终点位置
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    //线条宽度
    CGContextSetLineWidth(ctx, _strokeWidth);
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [_pathBackColor setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, basePath.CGPath);
    //渲染背景线
    CGContextStrokePath(ctx);
   
    
    /*
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0 , 0, self.frame.size.width, self.frame.size.height);
    layer.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:layer];
    
    UIBezierPath *basePath =[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 5.0f;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.999;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = basePath.CGPath;
    [layer setMask:shapeLayer];
     */
 
    //路径线
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
    /*
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = _strokeWidth;//线的宽度
    
    _progressLayer.path =[valuePath CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    _gradientLayer = [CALayer layer];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:65/255.0 blue:51/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:127/255.0 blue:64/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [_gradientLayer addSublayer:gl];

    [self.layer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
    */
    
    
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [_pathFillColor setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, valuePath.CGPath);
    //渲染数值线
    CGContextStrokePath(ctx);
    
    
    //画小圆点
    if (_showPoint) {
        CGContextDrawImage(ctx, CGRectMake(CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-_strokeWidth)/2.f-1)*cosf(valueEndA)-_strokeWidth/2.0, CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-_strokeWidth)/2.f-1)*sinf(valueEndA)-_strokeWidth/2.0, _strokeWidth, _strokeWidth), _pointImage.CGImage);
    }
    
    if (_showProgressText) {
        //画文字
//        NSString *currentText = [NSString stringWithFormat:@"%.2f%%",fakeProgress*100];
        NSString *currentText = [NSString stringWithFormat:@"%@",self.progressText ? self.progressText : @""];
        //段落格式
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;//水平居中
        //字体
//        UIFont *font = [UIFont systemFontOfSize:0.25*CircleSelfWidth];
        UIFont *font = [UIFont systemFontOfSize:13];
        if (_progressText.length > 2) {
            font = [UIFont systemFontOfSize:12];
            if (_progressText.length > 3) {
                font = [UIFont systemFontOfSize:11];
            }
        }
        //构建属性集合
        if (self.textColor == nil) {
            self.textColor = UIColorWithRGB(0x5555555);
        }
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName :self.textColor};
        //获得size
        CGSize stringSize = [currentText sizeWithAttributes:attributes];
        //垂直居中
        CGRect r = CGRectMake((CircleSelfWidth-stringSize.width)/2.0, (CircleSelfHeight - stringSize.height)/2.0,stringSize.width, stringSize.height);
        [currentText drawInRect:r withAttributes:attributes];
    }
    
}

//设置进度
- (void)setProgress:(CGFloat)progress {
    
    if ((_progress == progress && !_forceRefresh) || progress>1.0 || progress<0.0) {
        return;
    }
    
    fakeProgress = _increaseFromLast==YES?_progress:0.0;
    BOOL isReverse = progress<fakeProgress?YES:NO;
    //赋真实值
    _progress = progress;
    
    //先暂停计时器
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    //如果为0或没有动画则直接刷新
    if (_progress == 0.0 || _notAnimated) {
        fakeProgress = _progress;
        [self setNeedsDisplay];
        return;
    }
    
    //设置每次增加的数值
    CGFloat sameTimeIncreaseValue = _increaseFromLast==YES?fabs(fakeProgress-_progress):_progress;
    CGFloat defaultIncreaseValue = isReverse==YES?-0.01:0.01;
    
    __weak typeof(self) weakSelf = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.005 block:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        //反方向动画
        if (isReverse) {
            if (fakeProgress <= _progress || fakeProgress <= 0.0f) {
                [strongSelf dealWithLast];
                return;
            } else {
                //进度条动画
                [strongSelf setNeedsDisplay];
            }
        } else {
            //正方向动画
            if (fakeProgress >= _progress || fakeProgress >= 1.0f) {
                [strongSelf dealWithLast];
                return;
            } else {
                //进度条动画
                [strongSelf setNeedsDisplay];
            }
        }
        
        //数值增加或减少
        if (_animationModel == CircleIncreaseSameTime) {
            fakeProgress += defaultIncreaseValue*sameTimeIncreaseValue;//不同进度动画时间基本相同
        } else {
            fakeProgress += defaultIncreaseValue;//进度越大动画时间越长。
        }
        
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}
-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self setNeedsDisplay];
}

- (void)setProgressText:(NSString *)progressText
{
    _progressText = progressText;
    [self setNeedsDisplay];
}

//最后一次动画所做的处理
- (void)dealWithLast {
    //最后一次赋准确值
    fakeProgress = _progress;
    [self setNeedsDisplay];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
