//
//  UCFShopHListView.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFShopHListView.h"
@interface UCFShopHListView()
@property(nonatomic, strong)UIScrollView  *scrollView;
@property(nonatomic, assign)NSInteger      count;
@end
@implementation UCFShopHListView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.scrollView.backgroundColor = UIColorWithRGB(0xebebee);
        [self addSubview:self.scrollView];
    }
    return self;
}
- (void)setDelegate:(id<UCFShopHListViewDelegate>)delegate
{
    _delegate = delegate;
    if (_dataSource && _delegate) {
        [self reloadView];
    }
}
- (void)setDataSource:(id<UCFShopHListViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if (_dataSource && _delegate) {
        [self reloadView];
    }
}
- (void)reloadView {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfListView:)]) {
        _count = [self.dataSource numberOfListView:self];
        if (_count > 0) {
            for (int i = 0; i < _count; i++) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(shopHListView:)]) {
                    CGSize size = [self.delegate shopHListView:self];
                    if ([self.delegate respondsToSelector:@selector(shopHListView:cellForRowAtIndex:)]) {
                        
                        UIView *cellView = [self.delegate shopHListView:self cellForRowAtIndex:i];
                        cellView.frame = CGRectMake((size.width + _horizontalSpace) * i, 0, size.width, size.height);
                        [self.scrollView addSubview:cellView];
                        
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(0, 0, size.width, size.height);
                        button.tag = 1000 + i;
                        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                        [cellView addSubview:button];
                        
                        if (i == _count - 1) {
                            self.scrollView.contentSize = CGSizeMake((size.width + _horizontalSpace) * _count, size.height);
                        }
                    }
                }
            }
        }
    }
}
- (void)click:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopHListView:didSelectRowAtIndex:)]) {
        [self.delegate shopHListView:self didSelectRowAtIndex:button.tag - 1000];
    }
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
