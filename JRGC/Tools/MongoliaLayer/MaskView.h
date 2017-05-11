//
//  MaskView.h
//  JRGC
//
//  Created by 张瑞超 on 2017/5/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//
@class MaskView;
@protocol MaskViewDelegate <NSObject>

- (void)viewWillRemove:(MaskView *)view;

@end
#import <UIKit/UIKit.h>

@interface MaskView : UIView<UIGestureRecognizerDelegate>
typedef void (^MaskViewFinished)();
@property(weak, nonatomic) id<MaskViewDelegate>delegate;
@property(copy,nonatomic) MaskViewFinished finished;
-(instancetype)initWithFrame:(CGRect)frame;
+(instancetype)makeViewWithMask:(CGRect)frame;
- (void)show;
-(void)block:(void(^)())block;
- (void)setCallBack:(MaskViewFinished)call;
@end
