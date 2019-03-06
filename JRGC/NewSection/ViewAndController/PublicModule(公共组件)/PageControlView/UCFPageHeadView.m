//
//  UCFPageHeadView.m
//  JRGC
//
//  Created by zrc on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPageHeadView.h"

@interface UCFPageHeadView ()
@property(nonatomic, strong)UIView *indicateView;
@property(nonatomic, strong)NSArray *nameArray;
@end

@implementation UCFPageHeadView

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray <NSString *> *)titleArray WithType:(NSInteger)type
{
    if (self = [super initWithFrame:frame]) {
        if (type == 1) {
            for (int i = 0; i < titleArray.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitleColor:[Color color:PGColorOpttonRateNoramlTextColor] forState:UIControlStateSelected];
                [button setTitleColor:[Color color:PGColorOptionTitleBlack] forState:UIControlStateNormal];
                button.frame = CGRectMake(frame.size.width/titleArray.count * i, 0, frame.size.width/titleArray.count, frame.size.height);
                button.tag = 100 + i;
                [button setTitle:titleArray[i] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                if (i == 0) {
                    [self click:button];
                }
                [self addSubview:self.indicateView];
                button.titleLabel.font = [Color gc_Font:15];
            }
            
        }
    }
    return self;
}
- (void)pageHeadView:(UCFPageHeadView *)pageView chiliControllerSelectIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), queue, ^{
        [UIView animateWithDuration:0.25  delay:0.1 options: UIViewAnimationOptionCurveLinear animations:^{
            CGPoint  point = weakSelf.indicateView.center;
            UIView *childView = [self viewWithTag:index + 100];
            point.x = childView.center.x;
            weakSelf.indicateView.center = point;
        } completion:^(BOOL finished) {

        }];
    });
}
- (void)click:(UIButton *)button
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.selected = NO;
        }
    }
    [self pageHeadView:self chiliControllerSelectIndex:button.tag - 100];
    button.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageHeadView:noticeScroViewScrollToPoint:)]) {
        [self.delegate pageHeadView:self noticeScroViewScrollToPoint:CGPointMake(ScreenWidth * button.tag - 100, 0)];
    }
}
- (void)headViewSetSelectIndex:(NSInteger)index
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.selected = NO;
        }
    }
    UIButton *button = [self viewWithTag:index + 100];
    if (button) {
        button.selected = YES;
    }
}
- (UIView *)indicateView
{
    if (nil == _indicateView) {
        _indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 4, 36, 4)];
        _indicateView.backgroundColor = [Color color:PGColorOpttonRateNoramlTextColor];
        _indicateView.layer.cornerRadius = 2.0f;
        _indicateView.clipsToBounds = YES;
    }
    return _indicateView;
}

@end
