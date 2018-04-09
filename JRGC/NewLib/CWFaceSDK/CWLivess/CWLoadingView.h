//
//  CloudwalkLoadingView.h
//  CloudwalkFaceSDKDemo
//
//  Created by DengWuPing on 16/5/16.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWRotateView : UIView
//里层图片
@property(nonatomic,strong)UIImageView  *  innerImageVIew;
//外层旋转的图片
@property(nonatomic,strong)UIImageView   * rotateImageView;
//进度显示
@property(nonatomic,strong)UILabel  *  showTextLabel;
//倒计时进度
@property(nonatomic)NSInteger  progress;

/**
 *  初始化
 *
 *  @param frame      大小
 *  @param InnerImage 里层的图片
 *  @param outImage   外层的图片
 *
 *  @return 实例
 */
-(id)initWithFrame:(CGRect)frame innerImage:(UIImage *)InnerImage outImage:(UIImage *)outImage;
/**
 *  开始旋转的动画
 */
-(void)startAnimation;
/**
 *  停止动画
 */
-(void)stopAnimation;

@end



@interface CWLoadingView : UIView

/**
 *  提示文字显示的label
 */
@property(nonatomic,strong)UILabel  *  textLabel;
/**
 *  背景View
 */
@property(nonatomic,strong)UIView  * bgView;
/**
 *  旋转动画View
 */
@property(nonatomic,strong)CWRotateView  *  rotateView;
/**
 *  动画显示
 *
 *  @param message 提示信息
 */
-(void)showWithTitle:(NSString *)message;
/**
 *  隐藏
 */
-(void)hide;

@end
