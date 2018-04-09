//
//  PageView.m
//  TestPageViewController
//
//  Created by njw on 2017/11/3.
//  Copyright © 2017年 njw. All rights reserved.
//

#import "PageView.h"
#import "HMSegmentedControl.h"

#define TopBarHeight 44

@interface PageView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) HMSegmentedControl *topSegmentedControl;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *controllerViews;
@end

@implementation PageView
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withControllers:(NSArray *)controllers
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.controllers = [NSMutableArray arrayWithArray:controllers];
        self.selectedIndex = 0;
        [self createUI];
//        [self createCurrentControllerView];
        [self.topSegmentedControl addTarget:self action:@selector(topSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    _topSegmentedControl.selectedSegmentIndex = selectedIndex;
    [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.bounds.size.width * selectedIndex, 0)];
    [self createCurrentControllerView];
}

- (void)createUI {
    [self addSubview:self.topSegmentedControl];
    [self addSubview:self.mainScrollView];
    self.mainScrollView.delegate = self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger selectedIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _selectedIndex = selectedIndex;
    self.topSegmentedControl.selectedSegmentIndex = selectedIndex;
    [self createCurrentControllerView];
}

- (void)createCurrentControllerView {
    NSInteger index = self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    if (self.controllers.count >0) {
        UIViewController *childVC = _controllers[index];
        if (!childVC.view.superview) {
            childVC.view.frame = CGRectMake(index * self.mainScrollView.frame.size.width, 0, self.mainScrollView.frame.size.width, self.self.mainScrollView.frame.size.height);
            [self.mainScrollView addSubview:childVC.view];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self createCurrentControllerView];
}

- (void)topSegmentedControlChangedValue:(HMSegmentedControl *)seg
{
    _selectedIndex = seg.selectedSegmentIndex;
    [self.mainScrollView setContentOffset:CGPointMake(seg.selectedSegmentIndex * self.mainScrollView.bounds.size.width, 0)];
    [self createCurrentControllerView];
}

- (HMSegmentedControl *)topSegmentedControl
{
    if (nil == _topSegmentedControl) {
        _topSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_titles];
        [_topSegmentedControl setFrame:CGRectMake(0, 0, self.bounds.size.width, TopBarHeight)];
        _topSegmentedControl.selectionIndicatorHeight = 2.0f;
        _topSegmentedControl.backgroundColor = [UIColor whiteColor];
        _topSegmentedControl.font = [UIFont systemFontOfSize:14];
        _topSegmentedControl.textColor = UIColorWithRGB(0x555555);
        _topSegmentedControl.selectedTextColor = UIColorWithRGB(0xfc8f0e);
        _topSegmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfc8f0e);
        _topSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _topSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _topSegmentedControl.shouldAnimateUserSelection = YES;
        
        for (int i = 0 ; i < _titles.count - 1 ; i++) {
            UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
            linebk.frame = CGRectMake(ScreenWidth/_titles.count * (i + 1), 16, 1, 12);
            [_topSegmentedControl addSubview:linebk];
        }
    }
    return _topSegmentedControl;
}

- (NSMutableArray *)controllers
{
    if (_controllers == nil) {
        _controllers = [[NSMutableArray alloc] init];
    }
    return _controllers;
}

- (NSArray *)controllerViews
{
    if (_controllerViews == nil) {
        _controllerViews = [[NSMutableArray alloc] init];
    }
    return _controllerViews;
}

- (UIScrollView *)mainScrollView
{
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopBarHeight, self.bounds.size.width, self.bounds.size.height - TopBarHeight)];
        _mainScrollView.contentSize = CGSizeMake(self.bounds.size.width * _titles.count, 0);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.backgroundColor = UIColorWithRGB(0xebebee);
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}
@end
