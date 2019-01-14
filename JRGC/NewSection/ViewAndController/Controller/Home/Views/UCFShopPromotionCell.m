//
//  UCFShopPromotionCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFShopPromotionCell.h"
#import "SDCycleScrollView.h"
#import "UCFShopHListView.h"
#import "UCFCommodityView.h"
@interface UCFShopPromotionCell()<SDCycleScrollViewDelegate,UCFShopHListViewDataSource,UCFShopHListViewDelegate>

@end
@implementation UCFShopPromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        
        UIView *whitBaseView = [UIView new];
        whitBaseView.frame = CGRectMake(15, 0,  Screen_Width - 30, (Screen_Width - 30) * 6 /23 + 160);
        whitBaseView.layer.cornerRadius = 5.0f;
        whitBaseView.clipsToBounds = YES;
        whitBaseView.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:whitBaseView];
        
        SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width - 30, (Screen_Width - 30) * 6 /23) delegate:self placeholderImage:[UIImage imageNamed:@"banner_unlogin_default"]];
        adCycleScrollView.zoomType = NO;  // 是否使用缩放效果
        adCycleScrollView.hidesForSinglePage = YES;
        adCycleScrollView.autoScroll = NO;
        adCycleScrollView.infiniteLoop = NO;
        adCycleScrollView.isHideImageCorner = YES;
        adCycleScrollView.imageURLStringsGroup = @[@"https://fore.9888.cn/cms/uploadfile/2017/0619/20170619055317291.jpg"];
        [whitBaseView addSubview:adCycleScrollView];
        self.rootLayout.useFrame = YES;
    
        UCFShopHListView *shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adCycleScrollView.frame), CGRectGetWidth(whitBaseView.frame), 160)];
        shopList.horizontalSpace = 1.0f;
        shopList.dataSource = self;
        shopList.delegate = self;
        [whitBaseView addSubview:shopList];        
    }
    return self;
}
- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView
{
    return 10;
}
- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize
{
    return CGSizeMake(115, 160);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    UCFCommodityView *view = [[UCFCommodityView alloc] initWithFrame:CGRectMake(0, 0, 115, 160) withHeightOfCommodity:115];
    return view;
}

- (void)shopHListView:(UCFShopHListView *)shopListView didSelectRowAtIndex:(NSInteger)index
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
