//
//  UCFShopPromotionCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFShopPromotionCell.h"
//#import "SDCycleScrollView.h"
#import "RCFFlowView.h"
#import "UCFShopHListView.h"
#import "UCFCommodityView.h"
#import "UCFCellDataModel.h"
#import "UCFHomeMallDataModel.h"
#import "UIImageView+WebCache.h"
@interface UCFShopPromotionCell()<RCFFlowViewDelegate,UCFShopHListViewDataSource,UCFShopHListViewDelegate>
@property(nonatomic, strong)RCFFlowView *adCycleScrollView;
@property(nonatomic, strong)UCFShopHListView *shopList;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@end
@implementation UCFShopPromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        
        UIView *whitBaseView = [UIView new];
        whitBaseView.frame = CGRectMake(15, 0,  ScreenWidth - 30, (ScreenWidth - 30) * 6 /23 + 160);
        whitBaseView.layer.cornerRadius = 5.0f;
        whitBaseView.clipsToBounds = YES;
        whitBaseView.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:whitBaseView];
        
        RCFFlowView *adCycleScrollView = [[RCFFlowView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 30,([UIScreen mainScreen].bounds.size.width - 30) * 6 /23)];
        adCycleScrollView.delegate = self;
        adCycleScrollView.isHideImageCorner = YES;
       
        [whitBaseView addSubview:adCycleScrollView];
        [adCycleScrollView reloadCycleView];
        self.adCycleScrollView = adCycleScrollView;
        self.rootLayout.useFrame = YES;
    
        UCFShopHListView *shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adCycleScrollView.frame), CGRectGetWidth(whitBaseView.frame), 160)];
        shopList.horizontalSpace = 1.0f;
        shopList.dataSource = self;
        shopList.delegate = self;
        [whitBaseView addSubview:shopList];
        self.shopList = shopList;
        
    }
    return self;
}
- (void)reflectDataModel:(id)model
{
    UCFCellDataModel *dataModel = model;
    if ([dataModel.modelType isEqualToString:@"mall"]) {
        self.adCycleScrollView.advArray = dataModel.data1;
        [self.adCycleScrollView reloadCycleView];
        
        self.dataArray = dataModel.data2;
        [self.shopList reloadView];
        
    }
}
- (CGSize)sizeForPageFlowView:(RCFFlowView *)viwe
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, ([UIScreen mainScreen].bounds.size.width - 30) * 6 /23);
}
- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView
{
    return self.dataArray.count;
}
- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize
{
    return CGSizeMake(115, 160);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    UCFHomeMallrecommends *model = self.dataArray[index];
    UCFCommodityView *view = [[UCFCommodityView alloc] initWithFrame:CGRectMake(0, 0, 115, 160) withHeightOfCommodity:115];
    [view.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    view.shopName.text = model.title;
    view.shopValue.text = model.price;
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
