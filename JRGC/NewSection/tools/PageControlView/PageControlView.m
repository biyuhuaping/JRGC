//
//  PageControlView.m
//  JRGC
//
//  Created by zrc on 2018/12/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "PageControlView.h"
#define DefalutColor UIColorWithRGB(0x555555)
#define SelectedColor UIColorWithRGB(0xfd4d4c)
#define ButtonWidth   80
#define Button_OFFX   50 //butoon与左边的距离

@interface PageControlView()<UIScrollViewDelegate>
@property (strong, nonatomic) NSArray           *nameArray;
@property (strong, nonatomic) NSMutableArray    *buttonArray;

@property (strong, nonatomic) UIView            *indicateView;

@property (strong, nonatomic) UIView            *bottomLine;
@property (strong, nonatomic) UIScrollView      *segmentScrollV;
@property (strong, nonatomic) UIScrollView      *titleBaseScrollView;
@property (assign, nonatomic) float      lineSeparation;
@end

@implementation PageControlView

- (instancetype)initWithFrame:(CGRect)frame SegmentViewHeight:(CGFloat)segmentViewHeight titleArray:(NSArray *)titleArray Controller:(UIViewController *)controller lineWidth:(float)lineW lineHeight:(float)lineH{
    
    if (self = [super initWithFrame:frame]){
        
        _viewController = controller;
        self.nameArray = titleArray;
        _buttonArray = [NSMutableArray array]; //按钮数组
        
        //添加标题视图
        self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, segmentViewHeight)];
        self.segmentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.segmentView];
        
        
        self.lineSeparation = 60;
        
        CGFloat leftSpace = (ScreenWidth - ((titleArray.count * Button_OFFX) + 60))/2;
        
        
        //添加按钮
        for (int i = 0; i < self.nameArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  100 + i;
            button.frame = CGRectMake(leftSpace + (Button_OFFX + self.lineSeparation)  * i, 0, Button_OFFX, segmentViewHeight);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:self.nameArray[i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
            [button setTitleColor:UIColorWithRGB(0xfd4d4c) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.segmentView addSubview:button];
            [_buttonArray addObject:button];   //添加顶部按钮
        }
        self.indicateView = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace + (Button_OFFX - lineW)/2,segmentViewHeight-lineH, lineW, lineH)];
        self.indicateView.backgroundColor = UIColorWithRGB(0xfd4d4c);
        [self.segmentView addSubview:self.indicateView];
        
        self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, segmentViewHeight - 1, frame.size.width, 1)];
        self.bottomLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self.segmentView addSubview:self.bottomLine];
        
        //添加scrollView
        self.segmentScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, segmentViewHeight, frame.size.width, frame.size.height-segmentViewHeight)];
        self.segmentScrollV.bounces = NO;
        self.segmentScrollV.delegate = self;
        self.segmentScrollV.pagingEnabled = YES;
        self.segmentScrollV.showsHorizontalScrollIndicator = NO;
        self.segmentScrollV.contentSize = CGSizeMake(frame.size.width * _viewController.childViewControllers.count, 0);
        self.segmentScrollV.backgroundColor = [UIColor redColor];
        [self addSubview:self.segmentScrollV];
        
        //添加、取出ControllerView
        [self initChildViewController];
    }
    
    return self;
}
- (void)setSelectIndex:(NSInteger)index
{
    UIButton *button = [self.segmentView viewWithTag: 100 + index];
    [self Click:button];
}

- (void)Click:(UIButton *)sender {
    
    UIButton *button = sender;
    [button setTitleColor:SelectedColor forState:UIControlStateNormal];
    for (UIButton * btn in _buttonArray) {
        if (button != btn ) {
            [btn setTitleColor:DefalutColor forState:UIControlStateNormal];
        }
    }
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag - 100) * self.frame.size.width, 0) animated:YES ];
    
    //    __weak typeof(self) weakSelf = self;
    //    dispatch_queue_t queue= dispatch_get_main_queue();
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), queue, ^{
    //        [UIView animateWithDuration:0.25  delay:0.1 options: UIViewAnimationOptionCurveLinear animations:^{
    //            CGPoint  frame = weakSelf.indicateView.center;
    //            frame.x = button.center.x;
    //            weakSelf.indicateView.center = frame;
    //
    //        } completion:^(BOOL finished) {
    //        }];
    //    });
    
    
}

#pragma UIScorllerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), queue, ^{
        [UIView animateWithDuration:0.25  delay:0.1 options: UIViewAnimationOptionCurveLinear animations:^{
            CGPoint  frame = weakSelf.indicateView.center;
            CGFloat leftSpace = (ScreenWidth - ((_nameArray.count * Button_OFFX) + 60))/2;

            frame.x = leftSpace + Button_OFFX / 2 + (weakSelf.lineSeparation + Button_OFFX) * (weakSelf.segmentScrollV.contentOffset.x/self.frame.size.width);
            weakSelf.indicateView.center = frame;
        } completion:^(BOOL finished) {
        }];
    });
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self initChildViewController];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int pageNum = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    for (UIButton * btn in self.buttonArray) {
        (btn.tag - 100 == pageNum )
        ?([btn setTitleColor:UIColorWithRGB(0xfd4d4c) forState:UIControlStateNormal])
        :([btn setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal]);
    }
    [self initChildViewController];
}

//添加、取出ControllerView
- (void)initChildViewController{
    
    NSInteger index = self.segmentScrollV.contentOffset.x / self.segmentScrollV.frame.size.width;
    if (self.viewController.childViewControllers.count >0) {
        UIViewController *childVC = _viewController.childViewControllers[index];
        self.selectIndexStr = [NSString stringWithFormat:@"%ld",index];
        if (!childVC.view.superview) {
            
            childVC.view.frame = CGRectMake(index * self.segmentScrollV.frame.size.width, 0, self.segmentScrollV.frame.size.width, self.self.segmentScrollV.frame.size.height);
            [self.segmentScrollV addSubview:childVC.view];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
