//
//  CircleView.m
//  YCT
//
//  Created by 余晋龙 on 16/9/21.
//  Copyright © 2016年 bzjc. All rights reserved.
//

#define CircleView_x 15
#define CircleView_y 15
#define TITLE_HEIGHT 60
#define PIE_HEIGHT 155
#define Radius 65.5 //圆形比例图的半径

#import "CircleView.h"
#import "CircleMapView.h"


@interface CircleView()
@property (nonatomic, weak) CircleMapView *circleMapView;
@end
@implementation CircleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
         [self addCirclView];  //添加饼状图底图
    }
    return self;
}

//添加饼状图底图
- (void)addCirclView
{
    CircleMapView *circleMapView = [[CircleMapView alloc]initWithFrame:CGRectMake(CircleView_x, CircleView_y, [UIScreen mainScreen].bounds.size.width - 30, PIE_HEIGHT)];
    [self addSubview:circleMapView];
    circleMapView.backgroundColor = [UIColor whiteColor];
    self.circleMapView = circleMapView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circleMapView.model = self.model;
}


@end
