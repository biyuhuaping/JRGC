//
//  UCFNewHomeSectionView.h
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//
@protocol UCFNewHomeSectionViewDelegate <NSObject>

- (void)showMoreViewSection:(NSInteger)section andTitle:(NSString *)title;

@end

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewHomeSectionView : BaseView

@property(nonatomic, strong)UILabel     *titleLab;

@property(nonatomic, strong)UIButton    *checkMoreBtn;

@property(nonatomic, assign)NSInteger section;

@property(nonatomic, weak)id<UCFNewHomeSectionViewDelegate>delegate;

- (void)showMore;

@end

NS_ASSUME_NONNULL_END
