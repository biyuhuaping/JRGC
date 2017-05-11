//
//  MaskView.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "MaskView.h"
#import "AppDelegate.h"

@interface MaskView ()
{
    NSInteger num;
}
@property (nonatomic, strong)    UIImageView *imageView1;
@property (nonatomic, strong)    UIImageView *imageView2;
@property (nonatomic, strong)    UIImageView *imageView3;
@end

@implementation MaskView

//初始化View以及添加单击蒙层逻辑
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        num = 1;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CHECK_ISSHOW_MASKVIEW];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(step)];
        [self addGestureRecognizer:pan];
        [self initImageView];
        
    }
    return self;
}
- (void)step
{
    num++;
    if (num == 2) {
        _imageView1.hidden = YES;
        _imageView2.hidden = NO;
        _imageView3.hidden = YES;
    } else if (num == 3) {
        _imageView1.hidden = YES;
        _imageView2.hidden = YES;
        _imageView3.hidden = NO;
    } else if (num > 3) {
        //        self.finished();
        if ([self.delegate respondsToSelector:@selector(viewWillRemove:)]) {
            [self.delegate viewWillRemove:self];
        }
    }
}
- (void)initImageView
{
    CGFloat height = 0;
    if (ScreenHeight < 481) {
        height = 185;
    } else if (ScreenHeight < 569.0) {
        height = 185;
    } else if (ScreenHeight < 668) {
        height = 170;
    } else if (ScreenHeight < 737) {
        height = 161;
    }
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, ScreenWidth,(ScreenWidth * 497.0f)/960.0f )];
    _imageView1.backgroundColor = [UIColor clearColor];
    _imageView1.image = [UIImage imageNamed:@"zhezhao1"];
    [self addSubview:self.imageView1];
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - (ScreenWidth * 280.0f)/960.0f, ScreenWidth, (ScreenWidth * 280.0f)/960.0f)];
    _imageView2.backgroundColor = [UIColor clearColor];
    _imageView2.image = [UIImage imageNamed:@"zhezhao2"];
    _imageView2.hidden = YES;
    [self addSubview:self.imageView2];
    //
    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - (ScreenWidth * 435.0f)/960.0f, ScreenWidth, (ScreenWidth * 435.0f)/960.0f)];
    _imageView3.backgroundColor = [UIColor clearColor];
    _imageView3.hidden = YES;
    _imageView3.image = [UIImage imageNamed:@"zhezhao3"];
    [self addSubview:self.imageView3];
}

//蒙层添加到Window上
+(instancetype)makeViewWithMask:(CGRect)frame{
    MaskView *mview = [[self alloc]initWithFrame:frame];
    return mview;
}
- (void)show {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
}
//单击蒙层取消蒙层
-(void)removeView{
    [self removeFromSuperview];
}

- (void)setCallBack:(MaskViewFinished)call
{
    self.finished = call;
}

@end
