//
//  MoreViewModel.h
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoreModel.h"
@interface MoreViewModel : NSObject
@property(nonatomic,weak)UIViewController *currentVC;
/**
 获取行高

 @return 9
 */
- (CGFloat) getSectionHeight;
/**
 获取数组组数

 @return 数组组数
 */
- (NSInteger) getSectionCount;

/**
 获取每组的行数

 @param section 组行
 @return 组数
 */
- (NSInteger)getSectionCount:(NSInteger)section;

/**
 获取指定位置的数据model

 @param indexpath 位置
 @return 数据model
 */
- (MoreModel *)getSectionData:(NSIndexPath *)indexpath;

/**
 
 cell点击事件
 @param model 点击model
 */
- (void)cellSelectedClicked:(MoreModel *)model;


/**
 赞赏button点击

 @param button button
 */
- (void)vmPraiseButtonClick:(UIButton *)button;
/**
 反馈button点击
 
 @param button button
 */
- (void)vmFeedBackButtonClick:(UIButton *)button;

/**
 获取cell所在位置

 @param indexPath cell的位置索引
 @return -1 代表首行 0代表中间行 1代表最后一行
 */
- (int)getCellPostion:(NSIndexPath *)indexPath;

@end
