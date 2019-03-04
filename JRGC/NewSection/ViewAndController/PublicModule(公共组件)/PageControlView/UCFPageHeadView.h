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

@end






@interface UCFPageHeadView : UIView

@property(nonatomic, weak)id<UCFPageHeadViewDelegate>delegate;

- (void)pageHeadView:(UCFPageHeadView *)pageView chiliControllerSelectIndex:(NSInteger)index;


- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray <NSString *> *)titleArray WithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
