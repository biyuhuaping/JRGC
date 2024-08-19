//
//  UCFSegementBtnView.h
//  JRGC
//
//  Created by zrc on 2019/3/25.
//  Copyright © 2019 JRGC. All rights reserved.
//
@class UCFSegementBtnView;
@protocol UCFSegementBtnViewDelegate <NSObject>

- (void)segementBtnView:(UCFSegementBtnView *)segeView selectIndex:(NSInteger)index;

@end

#import "MyRelativeLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFSegementBtnView : MyRelativeLayout
@property(nonatomic, weak)id<UCFSegementBtnViewDelegate> delegate;
- (instancetype)initWithTitleArray:(NSArray *)titleArr delegate:(id<UCFSegementBtnViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
