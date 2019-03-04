//
//  UCFPageControlTool.h
//  JRGC
//
//  Created by zrc on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFPageHeadView.h"
NS_ASSUME_NONNULL_BEGIN
//@class UCFPageControlTool;
//
//@protocol UCFPageControlToolHeadViewDelegate <NSObject>
//
//- (UIView *)pageControlGetControllerHeadView:(UCFPageControlTool *)controller;
//
//- (CGRect)pageControlGetreactForHeadView:(UCFPageControlTool *)controller;
//
//- (void)scroViewScroToIndex:(NSInteger)index;
//
//@end



@interface UCFPageControlTool : UIView<UCFPageHeadViewDelegate>

/**
 子视图的父控制器
 */
@property (strong, nonatomic) UIViewController  *parentController;

/**
 子视图数组
 */
@property (strong, nonatomic) NSArray           *childControllers;

/**
 当前停留位置索引
 */
@property (assign, nonatomic) NSInteger          currentSelectIndex;

@property (strong, nonatomic) UCFPageHeadView             *headView;

/**
 子控制器底部的滚动视图
 */
@property (strong, nonatomic)UIScrollView *segmentScrollV;


//@property (weak, nonatomic)id<UCFPageControlToolHeadViewDelegate> delegate;



/**
 创建包含子视图的视图控制器

 @param frame 子视图展示的区域
 @param childControllers 子视图数组
 @param parentController 父视图
 @return 创建包含子视图的视图控制器
 */
- (instancetype)initWithFrame:(CGRect)frame WithChildControllers:(NSArray<UIViewController *>*)childControllers WithParentViewController:(UIViewController *)parentController WithHeadView:(UCFPageHeadView *)headView;
@end

NS_ASSUME_NONNULL_END
