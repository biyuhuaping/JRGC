//
//  UCFPageHeadView.m
//  JRGC
//
//  Created by zrc on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPageHeadView.h"

@interface UCFPageHeadView ()
{
    CGFloat buttonWidth;
}
@property(nonatomic, strong)UIView *indicateView;

@end

@implementation UCFPageHeadView

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray <NSString *> *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _leftSpace = 0;
        _rightSpace = 0;
        _btnHorizontal = 0;
        _leftBackImage = @"";
        self.nameArray = titleArray;
    }
    return self;
}
- (void)reloaShowView
{
    if (self.nameArray.count == 0) {
        return;
    }
    buttonWidth = (self.frame.size.width - _leftSpace -_rightSpace - (_btnHorizontal * (self.nameArray.count - 1)))/self.nameArray.count;
    CGFloat buttonY  = _leftBackImage.length > 0 ? StatusBarHeight1 : 0;
    for (int i = 0; i < self.nameArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[Color color:PGColorOpttonRateNoramlTextColor] forState:UIControlStateSelected];
        [button setTitleColor:[Color color:PGColorOptionTitleBlack] forState:UIControlStateNormal];
        button.frame = CGRectMake(_leftSpace + (buttonWidth + _btnHorizontal) * i, buttonY , buttonWidth, self.frame.size.height - buttonY);
        button.tag = 100 + i;
        [button setTitle:self.nameArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == 0) {
            [self click:button];
        }
        [self addSubview:self.indicateView];
        button.titleLabel.font = [Color gc_Font:15];
    }
    
    if (_leftBackImage.length > 0) {
        UIImage *image = [UIImage imageNamed:_leftBackImage];
        if (image) {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.frame = CGRectMake(0, StatusBarHeight1, 45, 44);
            [leftButton setImage:image forState:UIControlStateNormal];
            [leftButton setImage:image forState:UIControlStateHighlighted];
            [self addSubview:leftButton];
            self.leftBarBtn = leftButton;
        }
    }
}

- (void)pageHeadView:(UCFPageHeadView *)pageView chiliControllerSelectIndex:(CGFloat )index
{
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), queue, ^{
        [UIView animateWithDuration:0.25  delay:0.1 options: UIViewAnimationOptionCurveLinear animations:^{
            CGPoint  point = weakSelf.indicateView.center;
            point.x = _leftSpace + (buttonWidth + _btnHorizontal) * index + buttonWidth/2;
            weakSelf.indicateView.center = point;
            NSLog(@"%lf  index = %lf",point.x,index);
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
        [self.delegate pageHeadView:self noticeScroViewScrollToPoint:CGPointMake(ScreenWidth * (button.tag - 100), 0)];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageHeadView:selectIndex:)]) {
        [self.delegate pageHeadView:self selectIndex:button.tag - 100];
    }
}
- (void)setSelectIndex:(NSInteger)index
{
    UIButton *button = [self viewWithTag:100 +index];
    if (button) {
        [self click:button];
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
