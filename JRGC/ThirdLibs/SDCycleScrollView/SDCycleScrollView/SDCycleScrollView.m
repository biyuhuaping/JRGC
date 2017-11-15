//
//  SDCycleScrollView.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */


#import "SDCycleScrollView.h"
#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
#import "TAPageControl.h"
#import "UIImageView+WebCache.h"
#import "UCFCycleModel.h"



NSString * const ID = @"cycleCell";

@interface SDCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) TAPageControl *pageControl;

@end

@implementation SDCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _autoScrollTimeInterval = 1.0;
        [self setupMainView];
    }
    return self;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup
{
    SDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imagesGroup = imagesGroup;
    return cycleScrollView;
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _flowLayout.itemSize = self.frame.size;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [_timer invalidate];
    _timer = nil;
    [self setupTimer];
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    mainView.backgroundColor = UIColorWithRGB(0xebebee);
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[SDCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setImagesGroup:(NSArray *)imagesGroup
{
    if (_imagesGroup) {
        _imagesGroup = nil;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _imagesGroup = imagesGroup;
    
    _totalItemsCount = imagesGroup.count * 100;
    [self setupPageControl];
    [self setupTimer];
}

- (void)setupPageControl
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[TAPageControl class]]) {
            [view removeFromSuperview];
        }
    }
    if (self.imagesGroup.count > 0) {
        TAPageControl *pageControl = [[TAPageControl alloc] init];
        pageControl.dotImage = [UIImage imageNamed:@"dot_icon_02"];
        pageControl.currentDotImage = [UIImage imageNamed:@"dot_icon_01"];
        pageControl.numberOfPages = self.imagesGroup.count;
        [self addSubview:pageControl];
        _pageControl = pageControl;
        self.mainView.userInteractionEnabled = YES;
    }
    else {
        self.mainView.userInteractionEnabled = NO;
    }
}


- (void)automaticScroll
{
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    
    targetIndex = targetIndex < 0 ? 0 : targetIndex;
    
    if (targetIndex == _totalItemsCount) {
        targetIndex = _totalItemsCount * 0.5;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else   {
        
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)setupTimer
{
    if (self.imagesGroup.count>1) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
        _timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.frame = self.bounds;

    if (_mainView.contentOffset.x == 0) {
        if(_totalItemsCount <= 0){
            return;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = [_pageControl sizeForNumberOfPages:self.imagesGroup.count];
    CGFloat x = (self.sd_width - size.width) * 0.5;
    if (self.pageControlAliment == SDCycleScrollViewPageContolAlimentRight) {
        x = self.mainView.sd_width - size.width - 10;
    }
    CGFloat y = self.mainView.sd_height - size.height - 10;
    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
    [_pageControl sizeToFit];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imagesGroup.count;
    id model = [self.imagesGroup objectAtIndex:itemIndex];
//    cell.imageView.image = self.imagesGroup[itemIndex];
    if ([model isKindOfClass:[UIImage class]]) {
        cell.imageView.image = model;
    }
    else if ([model isKindOfClass:[UCFCycleModel class]]) {
        UCFCycleModel *modell = model;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:modell.thumb] placeholderImage:[UIImage imageNamed:@"banner_default.png"]];
    }
    if (_titlesGroup.count) {
        cell.title = _titlesGroup[itemIndex];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.imagesGroup.count];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.mainView.sd_width * 0.5) / self.mainView.sd_width;
    
    if (self.imagesGroup.count > 0) {
       int indexOnPageControl = itemIndex % self.imagesGroup.count;
       _pageControl.currentPage = indexOnPageControl;
    }else{
        _pageControl.currentPage = 0;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

- (void)refreshImage
{
    [self.mainView reloadData];
}

@end
