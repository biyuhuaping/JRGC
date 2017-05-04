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
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
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
        [self removeView];
    }
}
- (void)initImageView
{
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView1.backgroundColor = [UIColor redColor];
    [self addSubview:self.imageView1];
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 100, 100)];
    _imageView2.backgroundColor = [UIColor blueColor];
    _imageView2.hidden = YES;
    [self addSubview:self.imageView2];
    
    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 100, 100)];
    _imageView3.backgroundColor = [UIColor greenColor];
    _imageView3.hidden = YES;
    [self addSubview:self.imageView3];
}

//蒙层添加到Window上
+(instancetype)makeViewWithMask:(CGRect)frame{
    MaskView *mview = [[self alloc]initWithFrame:frame];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:mview];
    return mview;
}
//单击蒙层取消蒙层
-(void)removeView{
    [self removeFromSuperview];
}
//通过回调取消蒙层
-(void)block:(void(^)())block{
    [self removeFromSuperview];
    block();
}

@end
