//
//  CycleView.m
//  Ifeng
//
//  Created by 梁 国伟 on 13-11-7.
//  Copyright (c) 2013年 梁 国伟. All rights reserved.
//

#import "CycleView.h"
#import "UIButton+WebCache.h"
#import "UCFCycleModel.h"
#import "UIButton+WebCache.h"

@interface CycleView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *cycleTimer;
@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation CycleView

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenWidth*5/16)];
        backgroundImage.backgroundColor = UIColorWithRGB(0xebebee);
        backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:backgroundImage];
        [backgroundImage setImage:[UIImage imageNamed:@"banner_default.png"]];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc]init];
        [self addSubview:_pageControl];
        
        _cycleTimer = [NSTimer scheduledTimerWithTimeInterval:7.0f target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)layoutSubviews{
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(self.frame)-15, CGRectGetWidth(self.frame), 10);
}

- (void)setContentImages:(NSArray *)arr
{
    _imageArray = arr;
    _pageControl.numberOfPages = _imageArray.count;
    [self setSelecteIndex:0];
    if ([_imageArray count] <= 1) {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _pageControl.hidden = YES;
    }
    else {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
        _pageControl.hidden = NO;
    }
}


- (void)scrollTimer {
    if (_imageArray && [_imageArray count] > 1) {
        if (_currentPageIndex < _imageArray.count) {
            if (_currentPageIndex == _imageArray.count-1) {
                [self setSelecteIndex:0];
            } else {
                [self setSelecteIndex:_currentPageIndex+1];
            }
        }
    }
    else{
        [_cycleTimer setFireDate:[NSDate distantFuture]];
    }
}


- (void)setImageBtn:(UIButton *)imageBtn dataDic:(UCFCycleModel *)item {
    [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:item.thumb] forState:UIControlStateNormal placeholderImage:nil];
}

- (void)setSelecteIndex:(NSInteger)index {
    NSArray *subViews = _scrollView.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    if (_imageArray.count < 1) {
//        //没有图片时，有默认图，所以不用管
//    }
    if (_imageArray.count == 1) {
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        if ([_imageArray[0] isKindOfClass:[UCFCycleModel class]]) {
            UCFCycleModel *item = _imageArray[0];
            [self setImageBtn:imageBtn dataDic:item];
        }
        [_scrollView addSubview:imageBtn];
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    else if(_imageArray.count > 1) {
        for (int i=0; i<3; i++)
        {
            NSInteger imageIndex = index-1+i;
            if (imageIndex == -1)
            {
                imageIndex = [_imageArray count]-1;
            }
            if (imageIndex == [_imageArray count]) {
                imageIndex = 0;
            }
            
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.frame = CGRectMake(CGRectGetWidth(self.frame)*i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([_imageArray[imageIndex] isKindOfClass:[UCFCycleModel class]]) {
                UCFCycleModel *item = _imageArray[imageIndex];
                [self setImageBtn:imageBtn dataDic:item];
            }
            
            [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
            [_scrollView addSubview:imageBtn];
        }
    }
    
    _currentPageIndex = index;
    _pageControl.currentPage = _currentPageIndex;
}

- (void)imageBtnClick:(UIButton *)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(cycleViewClickIndex:)]) {
        [_delegate cycleViewClickIndex:_currentPageIndex];
    }
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)crollView{
    float x = crollView.contentOffset.x;
    
    NSInteger shouIndex = 0;
    if(x >= 2*_scrollView.frame.size.width){ //往下翻一张
        if (_currentPageIndex+1 == [_imageArray count]) {
            shouIndex = 0;
        }
        else {
            shouIndex = _currentPageIndex+1;
        }
        [self  setSelecteIndex:shouIndex];
    }
    
    if(x <= 0) {
        if (_currentPageIndex == 0) {
            shouIndex = [_imageArray count]-1;
        }
        else {
            shouIndex = _currentPageIndex-1;
        }
        [self  setSelecteIndex:shouIndex];
    }
    _pageControl.currentPage = _currentPageIndex;
}
// 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
// 当pagingEnabled属性为YES时，不调用，该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    DDLogDebug(@"scrollViewWillEndDragging");
    if (!_cycleTimer) {
        _cycleTimer = [NSTimer scheduledTimerWithTimeInterval:7.0f target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
}
// 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    DDLogDebug(@"scrollViewWillBeginDragging");
//    [cycleTimer setFireDate:[NSDate distantFuture]];
    //取消定时器
    if (_cycleTimer) {
        [_cycleTimer invalidate];
        _cycleTimer = nil;
    }
}

@end
