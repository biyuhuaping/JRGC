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
                button.tag = i;
                [button setTitle:titleArray[i] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
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
            UIView *childView = [self viewWithTag:index];
            point.x = childView.center.x;
            weakSelf.indicateView.center = point;
        } completion:^(BOOL finished) {
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)view;
                    button.selected = NO;
                }
            }
            UIButton *button = [self viewWithTag:index];
            if (button) {
                button.selected = YES;
            }
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
    [self pageHeadView:self chiliControllerSelectIndex:button.tag];
    button.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageHeadView:chiliControllerSelectIndex:)]) {
        [self.delegate pageHeadView:self noticeScroViewScrollToPoint:CGPointMake(ScreenWidth * button.tag, 0)];
    }
}
- (void)headViewSetSelectIndex:(NSInteger)index
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
