//
//  PageControlView.h
//  JRGC
//
//  Created by zrc on 2018/12/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageControlView : UIView
@property (strong, nonatomic) UIViewController  *viewController;
@property (copy, nonatomic) NSString *selectIndexStr;
@property (weak, nonatomic) id source;
@property (strong, nonatomic) UIView            *segmentView;
/**
 滑块按钮
 
 @param frame selfFrame
 @param segmentViewHeight 按钮高度
 @param titleArray 按钮名
 @param controller 主控住器
 @param lineW 选中条宽度
 @param lineH 选中条高度
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
            SegmentViewHeight:(CGFloat)segmentViewHeight
                   titleArray:(NSArray *)titleArray
                   Controller:(UIViewController *)controller
                    lineWidth:(float)lineW
                   lineHeight:(float)lineH;

- (void)setSelectIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
