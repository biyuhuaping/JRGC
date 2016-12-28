//
//  CloudwalkLoadingView.m
//  CloudwalkFaceSDKDemo
//
//  Created by DengWuPing on 16/5/16.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import "CWLoadingView.h"

@implementation CWRotateView

{
    BOOL   stopAnimation;
}

-(id)initWithFrame:(CGRect)frame innerImage:(UIImage *)InnerImage outImage:(UIImage *)outImage{
    self = [super initWithFrame:frame];
    if(self){
        
        self.innerImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-20)];
        if (InnerImage != nil) {
            self.innerImageVIew.image = InnerImage;
        }
        [self addSubview:self.innerImageVIew];
        
        self.rotateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (outImage != nil) {
            self.rotateImageView.image = outImage;
        }
        [self addSubview:self.rotateImageView];
        
        self.showTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-20)];
        self.showTextLabel .backgroundColor = [UIColor clearColor];
        self.showTextLabel .textColor = [UIColor whiteColor];
        self.showTextLabel .font = [UIFont systemFontOfSize:40.f];
        self.showTextLabel .textAlignment = NSTextAlignmentCenter;
        [self addSubview: self.showTextLabel];
    }
    return self;
}

-(void)setProgress:(NSInteger)progress{
    _progress = progress;
    self.showTextLabel.text = [NSString stringWithFormat:@"%ld",(long)progress];
}

-(void)startAnimation{
    stopAnimation = YES;
    CABasicAnimation * rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.delegate = self;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000000;
    [_rotateImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (stopAnimation) {
        [self startAnimation];
    }
}

-(void)stopAnimation{
    stopAnimation = NO;
    [_rotateImageView.layer removeAllAnimations];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end


#define CW_DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@implementation CWLoadingView

-(id)init{
    
    self = [super init];
    if (self ) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        UIView *  backGround = [[UIView alloc]initWithFrame:self.frame];
        backGround.backgroundColor = [UIColor blackColor];
        backGround.alpha = 0.4f;
        [self addSubview:backGround];
        [self sendSubviewToBack:backGround];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-200)/2, (self.frame.size.height-100)/2, 200, 60)];
        _bgView.backgroundColor = [UIColor grayColor];
        _bgView.layer.cornerRadius = 8.f;
        _bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_bgView];
        if(CW_DEVICE_VERSION >= 8.0){
            _rotateView = [[CWRotateView alloc]initWithFrame:CGRectMake(10, (_bgView.frame.size.height-40)/2, 40, 40) innerImage:[UIImage imageNamed:[self getMyBundlePath:@"yc_logo"]] outImage:[UIImage imageNamed:[self getMyBundlePath:@"main_circle"]]];
        }else{
            _rotateView = [[CWRotateView alloc]initWithFrame:CGRectMake(10, (_bgView.frame.size.height-40)/2, 40, 40) innerImage:[self imagesNamedFromCustomBundle:@"yc_logo@2x.png"] outImage:[self imagesNamedFromCustomBundle:@"main_circle@2x.png"]];
        }
        [_bgView addSubview:_rotateView];
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(60,(_bgView.frame.size.height-50)/2,_bgView.frame.size.width-55,50)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _textLabel.textColor = [UIColor whiteColor];
#ifdef __IPHONE_6_0
        [_textLabel setTextAlignment:NSTextAlignmentLeft];
#else
        [_textLabel setTextAlignment:UITextAlignmentLeft];
#endif
        _textLabel.numberOfLines = 0;
        [_bgView addSubview:_textLabel];
        
        self.alpha =0.f;
    }
    return self;
}

#define MYBUNDLE_NAME @ "CWResource.bundle"

//获取资源的绝对路径
-(NSString *)getMyBundlePath:(NSString * )filename{
    
    NSString  * bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME];
    
    NSBundle * libBundle = [NSBundle bundleWithPath: bundlePath] ;
    
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName
{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:MYBUNDLE_NAME];
    
    NSString *img_path = [bundlePath stringByAppendingPathComponent:imgName];
    
    return [UIImage imageWithContentsOfFile:img_path];
}

-(void)showWithTitle:(NSString *)message{
    _textLabel.text = message;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
        [_rotateView startAnimation];
    } completion:^(BOOL flag){
        self.hidden = NO;
    }];
    
}

-(void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
        [_rotateView stopAnimation];
    } completion:^(BOOL flag){
        self.hidden = YES;
    }];
}

//画中间透明的图片
-(UIImage *)drawImage:(CGRect)BgRect{
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContext(BgRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0.37,0.37,0.37,1.f);
    CGRect drawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    CGContextFillRect(ctx, drawRect);
    UIImage* returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnimage;
}

@end
