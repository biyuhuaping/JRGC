//
//  CircleProgressView.h
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIControl

@property (nonatomic) NSTimeInterval elapsedTime;   //运行时间
@property (nonatomic) NSTimeInterval timeLimit;     //时间限制
@property (retain, nonatomic) NSString *status;     //状态
@property (assign, nonatomic) double percent;       //百分比
@property (strong, nonatomic) NSString *textStr;    //文字
@property (strong, nonatomic) UILabel *progressLabel;//投资/满标
@property (assign, nonatomic) BOOL isAnim;          //是否动画

@end
