//
//  UCFPageHeadView.h
//  JRGC
//
//  Created by zrc on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UCFPageHeadView;

@protocol UCFPageHeadViewDelegate <NSObject>

- (void)pageHeadView:(UCFPageHeadView *)pageView noticeScroViewScrollToPoint:(CGPoint)point;

- (void)pageHeadView:(UCFPageHeadView *)pageView selectIndex:(NSInteger)index;
@end






@interface UCFPageHeadView : UIView

@property(nonatomic, weak)id<UCFPageHeadViewDelegate>delegate;

@property(nonatomic, assign)CGFloat leftSpace;//按钮区域的左边距

@property(nonatomic, assign)CGFloat rightSpace;//按钮区域的右边距

@property(nonatomic, assign)CGFloat btnHorizontal; //按钮横向间距

@property(nonatomic, strong)NSArray *nameArray;   //按钮文字数组

@property(nonatomic, copy)NSString  *leftBackImage;

@property(nonatomic, strong)UIButton    *leftBarBtn;

@property(nonatomic, assign)BOOL        isNavBar;

@property (nonatomic, assign) BOOL  isHiddenHeadView; //当只有数组中只有一个数据的时候,是否需要隐藏头

@property(nonatomic, assign)BOOL    isSacle; //文字是否有放大缩小的效果 //默认为NO，没有 YES 有

- (void)setSelectIndex:(NSInteger)index;

- (void)pageHeadView:(UCFPageHeadView *)pageView chiliControllerSelectIndex:(CGFloat)index;

- (void)headViewSetSelectIndex:(NSInteger)index;

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray <NSString *> *)titleArray;

- (void)reloaShowView;

@end

NS_ASSUME_NONNULL_END
