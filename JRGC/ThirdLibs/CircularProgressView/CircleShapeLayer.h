//
//  CircleShapeLayer.h
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CircleShapeLayer : CAShapeLayer

@property (nonatomic) NSTimeInterval elapsedTime;   //运行时间
@property (nonatomic) NSTimeInterval timeLimit;     //时间限制
@property (assign, nonatomic, readonly) double percent;//百分比
@property (nonatomic) UIColor *progressColor;       //进度条颜色

@property (nonatomic, assign) BOOL isAnim;          //是否动画

@end
