//
//  HomeHeadCycleView.m
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "HomeHeadCycleView.h"

@interface HomeHeadCycleView()<SDCycleScrollViewDelegate>
@property(nonatomic, weak)UCFBannerViewModel *VM;
@end

@implementation HomeHeadCycleView

- (void)showView:(UCFBannerViewModel *)viewModel
{
    self.VM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"imagesArr"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"imagesArr"]) {
            NSArray *imgArr = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (imgArr.count > 0) {
                if (imgArr.count == 1) {
                    [selfWeak.adCycleScrollView removeFromSuperview];
                    selfWeak.adCycleScrollView = nil;
                    SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 0, Screen_Width - 30, ((([[UIScreen mainScreen] bounds].size.width - 30) * 9)/16)) delegate:selfWeak placeholderImage:[UIImage imageNamed:@"banner_unlogin_default"]];
                    adCycleScrollView.zoomType = NO;  // 是否使用缩放效果
                    adCycleScrollView.hidesForSinglePage = YES;
                    adCycleScrollView.autoScroll = NO;
                    adCycleScrollView.infiniteLoop = NO;
                    adCycleScrollView.isHideImageCorner = NO;
                    adCycleScrollView.imageURLStringsGroup = imgArr;
                    selfWeak.adCycleScrollView = adCycleScrollView;
                    [selfWeak addSubview:adCycleScrollView];
                    selfWeak.useFrame = YES;
                } else {
                    
                }
                selfWeak.adCycleScrollView.imageURLStringsGroup = imgArr;
            }
        }
    }];
}
- (void)createSubviews
{
    SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, ((([[UIScreen mainScreen] bounds].size.width - 54) * 9)/16)) delegate:self placeholderImage:[UIImage imageNamed:@"banner_unlogin_default"]];
    //    adCycleScrollView.backgroundColor = [UIColor blueColor];
    adCycleScrollView.zoomType = YES;  // 是否使用缩放效果
    adCycleScrollView.delegate = self;
    adCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    adCycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    adCycleScrollView.currentPageDotColor = [UIColor whiteColor];
    adCycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.5];
    adCycleScrollView.pageControlDotSize = CGSizeMake(20, 6);  // pageControl小点的大小
//    adCycleScrollView.imageURLStringsGroup = @[];
    [self addSubview:adCycleScrollView];
    self.adCycleScrollView = adCycleScrollView;
    //    adCycleScrollView.localizationImageNamesGroup = @[@"img1", @"img2", @"img3", @"img4"];  // 本地图片
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.VM) {
        [self.VM cycleViewSelectIndex:index];
    }
}


@end
