//
//  UIView+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UcfLib)

#pragma mark - 属性扩展
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;

#pragma mark - 常用方法
//收键盘
- (BOOL)findAndResignFirstResponder;
//截图
- (UIImage *)exportToImage;
//截图（指定大小）
- (UIImage *)exportToImage:(CGSize)size;
//获取view所在的viewController
- (UIViewController *)viewController;
//添加点击事件
- (void)setTapActionWithBlock:(void (^)(void))block;

@end
