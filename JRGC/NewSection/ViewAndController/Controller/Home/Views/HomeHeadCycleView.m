//
//  HomeHeadCycleView.m
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "HomeHeadCycleView.h"

@interface HomeHeadCycleView()<SDCycleScrollViewDelegate>

@end

@implementation HomeHeadCycleView

- (void)showView:(UCFHomeViewModel *)viewModel
{
    
}
- (void)createSubviews
{
    SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, ((([[UIScreen mainScreen] bounds].size.width - 54) * 9)/16)) delegate:self placeholderImage:[UIImage imageNamed:@"banner_unlogin_default"]];
    //    adCycleScrollView.backgroundColor = [UIColor blueColor];
    adCycleScrollView.zoomType = YES;  // 是否使用缩放效果
    adCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    adCycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    adCycleScrollView.currentPageDotColor = [UIColor whiteColor];
    adCycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.5];
    adCycleScrollView.pageControlDotSize = CGSizeMake(20, 6);  // pageControl小点的大小
    adCycleScrollView.imageURLStringsGroup = @[@"https://fore.9888.cn/cms/uploadfile/2017/0619/20170619055317291.jpg",@"https://fore.9888.cn/cms/uploadfile/2017/0619/20170619055317291.jpg"];
    [self addSubview:adCycleScrollView];
    self.adCycleScrollView = adCycleScrollView;
    //    adCycleScrollView.localizationImageNamesGroup = @[@"img1", @"img2", @"img3", @"img4"];  // 本地图片
}



@end
