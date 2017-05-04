//
//  MaskView.h
//  JRGC
//
//  Created by 张瑞超 on 2017/5/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView<UIGestureRecognizerDelegate>
-(instancetype)initWithFrame:(CGRect)frame;
+(instancetype)makeViewWithMask:(CGRect)frame;
-(void)block:(void(^)())block;
@end
