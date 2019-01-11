//
//  UIButton+Gradient.h
//  ZXB
//
//  Created by zrc on 2018/3/6.
//  Copyright © 2018年 UCFGROUP. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;
@interface UIButton (Gradient)
- (UIImage*) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType;
@end
