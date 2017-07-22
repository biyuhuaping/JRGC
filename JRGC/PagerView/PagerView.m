//
//  PagerView.m
//  PagerViewController
//
//  Created by 曾涛 on 2017/6/12.
//  Copyright © 2017年 曾涛. All rights reserved.
//

#import "PagerView.h"
#define DefalutColor UIColorWithRGB(0x555555)
#define SelectedColor UIColorWithRGB(0xfd4d4c)
#define ButtonWidth   60
@interface PagerView ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray           *nameArray;
@property (strong, nonatomic) NSMutableArray    *buttonArray;

@property (strong, nonatomic) UIView            *indicateView;
@property (strong, nonatomic) UIView            *segmentView;
@property (strong, nonatomic) UIView            *bottomLine;
@property (strong, nonatomic) UIScrollView      *segmentScrollV;


@end

@implementation PagerView

- (instancetype)initWithFrame:(CGRect)frame SegmentViewHeight:(CGFloat)segmentViewHeight titleArray:(NSArray *)titleArray Controller:(UIViewController *)controller lineWidth:(float)lineW lineHeight:(float)lineH{
    
    if (self = [super initWithFrame:frame]){
        
        _viewController = controller;
        self.nameArray = titleArray;
        _buttonArray = [NSMutableArray array]; //按钮数组
        
        //添加标题视图
        self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, segmentViewHeight)];
        self.segmentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.segmentView];
        
        CGFloat offX = (ScreenWidth - ButtonWidth * self.nameArray.count)/2.0f;
        //添加按钮
        for (int i = 0; i < self.nameArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  100 + i;
            button.frame = CGRectMake(offX + ButtonWidth * i, 0, ButtonWidth, segmentViewHeight);
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitle:self.nameArray[i] forState:UIControlStateNormal];
            [button setTitleColor:DefalutColor forState:UIControlStateNormal];
            [button setTitleColor:SelectedColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.segmentView addSubview:button];
            [_buttonArray addObject:button];   //添加顶部按钮
        }
        
        self.indicateView = [[UILabel alloc]initWithFrame:CGRectMake(offX + (ButtonWidth - lineW)/2,segmentViewHeight-lineH, lineW, lineH)];
        self.indicateView.backgroundColor = SelectedColor;
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
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag - 100)*self.frame.size.width, 0) animated:YES ];
}

#pragma UIScorllerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint  frame = self.indicateView.center;
    CGFloat offX = (ScreenWidth - ButtonWidth * self.nameArray.count)/2.0f;
    frame.x = offX + ButtonWidth/2 + ButtonWidth *(self.segmentScrollV.contentOffset.x/self.frame.size.width);
    self.indicateView.center = frame;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self initChildViewController];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int pageNum = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    for (UIButton * btn in self.buttonArray) {
        (btn.tag - 100 == pageNum )
        ?([btn setTitleColor:SelectedColor forState:UIControlStateNormal])
        :([btn setTitleColor:DefalutColor forState:UIControlStateNormal]);
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

@end
