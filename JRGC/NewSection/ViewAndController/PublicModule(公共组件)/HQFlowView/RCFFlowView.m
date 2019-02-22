//
//  RCFFlowView.m
//  HQCardFlowView
//
//  Created by zrc on 2019/2/21.
//  Copyright © 2019 HQ. All rights reserved.
//

#import "RCFFlowView.h"
#import "HQFlowView.h"
#import "HQImagePageControl.h"
#import "UIImageView+WebCache.h"
#define JkScreenHeight [UIScreen mainScreen].bounds.size.height
#define JkScreenWidth [UIScreen mainScreen].bounds.size.width
@interface RCFFlowView ()<HQFlowViewDelegate,HQFlowViewDataSource>

/**
 *  轮播图
 */
@property (nonatomic, strong) HQImagePageControl *pageC;
@property (nonatomic, strong) HQFlowView         *pageFlowView;
@property (nonatomic, strong) UIScrollView       *scrollView; // 轮播图容器
@end

@implementation RCFFlowView


- (void)reloadCycleView
{
    _pageFlowView.orginPageCount = _advArray.count;
    if (_advArray.count == 1) {
        self.pageC.hidden = YES;
    } else {
        self.pageC.hidden = NO;
    }
    [self.pageFlowView reloadData];//刷新轮播
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.pageFlowView];
        [self.pageFlowView addSubview:self.pageC];
        [self.pageFlowView reloadData];//刷新轮播
    }
    return self;
}
- (void)setAdvArray:(NSMutableArray *)advArray
{
    if (_advArray != advArray) {
        [_advArray removeAllObjects];
        _advArray = nil;
        _advArray = advArray;
    }
}
#pragma mark -- 轮播图
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
    }
    return _scrollView;
}

- (HQFlowView *)pageFlowView
{
    if (!_pageFlowView) {
        _pageFlowView = [[HQFlowView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.3;
        _pageFlowView.leftRightMargin = 28;
        _pageFlowView.topBottomMargin = 20;
        _pageFlowView.orginPageCount = _advArray.count;
        _pageFlowView.isOpenAutoScroll = YES;
        _pageFlowView.autoTime = 3.0;
        _pageFlowView.orientation = HQFlowViewOrientationHorizontal;
    }
    return _pageFlowView;
}

- (HQImagePageControl *)pageC
{
    if (!_pageC) {
        
        //初始化pageControl
        if (!_pageC) {
            _pageC = [[HQImagePageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 15, self.scrollView.frame.size.width, 7.5)];
        }
        [self.pageFlowView.pageControl setCurrentPage:0];
        self.pageFlowView.pageControl = _pageC;
        
    }
    return _pageC;
}
#pragma mark JQFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(HQFlowView *)flowView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForPageFlowView:)]) {
        return [self.delegate sizeForPageFlowView:self];
    } else {
         return CGSizeMake(JkScreenWidth-2*28, self.scrollView.frame.size.height);
    }
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRCCell:withSubViewIndex:)]) {
        [self.delegate didSelectRCCell:subView withSubViewIndex:subIndex];
    }
    NSLog(@"点击第%ld个广告",(long)subIndex);
}
#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView
{
    return self.advArray.count;
}
- (HQIndexBannerSubview *)flowView:(HQFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    HQIndexBannerSubview *bannerView = (HQIndexBannerSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[HQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, self.pageFlowView.frame.size.width, self.pageFlowView.frame.size.height)];
        if (!_isHideImageCorner) {
            bannerView.layer.cornerRadius = 5;
            bannerView.layer.masksToBounds = YES;
        }
        bannerView.coverView.backgroundColor = [UIColor darkGrayColor];
    }
    //在这里下载网络图片
        [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.advArray[index]] placeholderImage:nil];
    //加载本地图片
//    bannerView.mainImageView.image = [UIImage imageNamed:self.advArray[index]];
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView
{
    [self.pageFlowView.pageControl setCurrentPage:pageNumber];
}
#pragma mark --旋转屏幕改变JQFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [coordinator animateAlongsideTransition:^(id context) { [self.pageFlowView reloadData];
        } completion:NULL];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)dealloc
{
    self.pageFlowView.delegate = nil;
    self.pageFlowView.dataSource = nil;
    [self.pageFlowView stopTimer];
}
@end
