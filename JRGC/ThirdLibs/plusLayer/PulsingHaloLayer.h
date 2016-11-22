//
//  PulsingHaloLayer.h
//  扩散效果-用于人脸识别页面
//
//  Created by xxxx on 12/5/13.
//
//
//

#import <QuartzCore/QuartzCore.h>


@interface PulsingHaloLayer : CALayer

@property (nonatomic, assign) CGFloat radius;                   // default:60pt
@property (nonatomic, assign) NSTimeInterval animationDuration; // default:3s
@property (nonatomic, assign) NSTimeInterval pulseInterval; // default is 0s

@end
