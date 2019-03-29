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
#import "UCFHomeMallDataModel.h"
@interface UCFShopPromotionCell()<RCFFlowViewDelegate,UCFShopHListViewDataSource,UCFShopHListViewDelegate>
@property(nonatomic, strong)RCFFlowView *adCycleScrollView;
@property(nonatomic, strong)UCFShopHListView *shopList;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)NSMutableArray  *cycleModelArray;
@end
@implementation UCFShopPromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        self.rootLayout.useFrame = YES;

        UIView *whitBaseView = [UIView new];
        CGFloat shopHeight = (ScreenWidth - 30)/3.0f + 60;
        whitBaseView.frame = CGRectMake(15, 0,  ScreenWidth - 30, (ScreenWidth - 30) * 6 /23 + shopHeight);
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
    
        UCFShopHListView *shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adCycleScrollView.frame), CGRectGetWidth(whitBaseView.frame), shopHeight)];
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
    
    self.cycleModelArray = dataModel.data1;
    if ([dataModel.modelType isEqualToString:@"mall"]) {
        NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:3];
        for (UCFhomeMallbannerlist *bannerModel in dataModel.data1) {
            [imgArr addObject:bannerModel.thumb];
        }
        
        self.adCycleScrollView.advArray = [NSMutableArray arrayWithArray:imgArr];
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
    return CGSizeMake((ScreenWidth - 30)/3, (ScreenWidth - 30)/3 + 60);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    UCFHomeMallrecommends *model = self.dataArray[index];
    UCFCommodityView *view = [[UCFCommodityView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth - 30)/3, (ScreenWidth - 30)/3 + 60) withHeightOfCommodity:(ScreenWidth - 30)/3];
    [view.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    view.shopName.text = model.title;
    view.shopValue.text = [NSString stringWithFormat:@"%@工贝",model.score];
    NSString *showStr =  [NSString stringWithFormat:@"%@工贝",model.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:showStr attributes:attribtDic];
    view.shopOrginalValue.attributedText = attribtStr;
    
    return view;
}

- (void)shopHListView:(UCFShopHListView *)shopListView didSelectRowAtIndex:(NSInteger)index
{
    UCFHomeMallrecommends *model = self.dataArray[index];
    if (self.deleage && [self.deleage respondsToSelector:@selector(baseTableViewCell:buttonClick:withModel:)]) {
        [self.deleage baseTableViewCell:self buttonClick:nil withModel:model];
    }
    
}
- (void)didSelectRCCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    UCFhomeMallbannerlist *bannerModel = self.cycleModelArray[subIndex];
    if (self.deleage && [self.deleage respondsToSelector:@selector(baseTableViewCell:buttonClick:withModel:)]) {
        [self.deleage baseTableViewCell:self buttonClick:nil withModel:bannerModel];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
