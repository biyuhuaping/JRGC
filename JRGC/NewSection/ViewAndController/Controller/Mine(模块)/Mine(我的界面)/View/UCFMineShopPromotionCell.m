//
//  UCFMineShopPromotionCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/29.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineShopPromotionCell.h"
#import "UCFShopHListView.h"
#import "UCFCommodityView.h"
#import "UCFCellDataModel.h"
#import "UCFHomeMallDataModel.h"
#import "UIImageView+WebCache.h"
#import "UCFNewHomeSectionView.h"

@interface UCFMineShopPromotionCell ()<UCFShopHListViewDataSource,UCFShopHListViewDelegate,UCFNewHomeSectionViewDelegate>
@property(nonatomic, strong)UCFShopHListView *shopList;
@property(nonatomic, strong)UCFNewHomeSectionView *sectionView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)NSMutableArray  *cycleModelArray;

@end
@implementation UCFMineShopPromotionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
//        self.rootLayout.useFrame = YES;
        [self.rootLayout addSubview:self.shopList];

        
    }
    return self;
}
- (UCFNewHomeSectionView *)sectionView
{
    if (nil == _sectionView) {
        UCFNewHomeSectionView *sectionView = [[UCFNewHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
        sectionView.delegate = self;
//        NSArray *sectionArr = self.dataArray[section];
//        CellConfig *data = sectionArr[0];
//        if (data) {
//            sectionView.titleLab.text = data.title;
//        }
//        if ([data.title isEqualToString:@"商城精选"] || [data.title isEqualToString:@"商城特惠"]) {
//            [sectionView showMore];
//        }
//        return sectionView;

    }
    return _sectionView;
}
- (UCFShopHListView *)shopList
{
    if (nil == _shopList) {
        _shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 165)];
        _shopList.horizontalSpace = 1.0f;
        _shopList.dataSource = self;
        _shopList.delegate = self;
        _shopList.myLeft = 0;
        _shopList.myTop = 0;
    }
    return _shopList;
}
- (void)showInfo:(id)data
{
    UCFMallDataModel *modelData = data;
    
    if ([self.cellTitleString isEqualToString:@"mallRecommends"])
    {
        self.dataArray = [NSMutableArray arrayWithArray:modelData.mallRecommends];
    }
    else if ([self.cellTitleString isEqualToString:@"mallSelected"])
    {
        self.dataArray = [NSMutableArray arrayWithArray:modelData.mallSelected];
    }
    else
    {
        return;
    }
    
    
    [self.shopList reloadView];

}

- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView
{
    return self.dataArray.count;
}
- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize
{
    return CGSizeMake(105, 165);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    NSString *img;
    NSString *title;
    NSString *score;
    NSString *price;
    
    if ([self.cellTitleString isEqualToString:@"mallRecommends"])
    {
        UCFHomeMallrecommends *model = self.dataArray[index];
        img = model.img;
        title = model.title;
        score = model.score;
        price = model.price;
    }
    else if ([self.cellTitleString isEqualToString:@"mallSelected"])
    {
        UCFHomeMallsale *model = self.dataArray[index];
        img = model.img;
        title = model.title;
        score = model.score;
        price = model.price;
    }
    
    
    UCFCommodityView *view = [[UCFCommodityView alloc] initWithFrame:CGRectMake(0, 0,105, 165 )withHeightOfCommodity:105];
    [view.shopImageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:nil];
    view.shopName.text = title;
    view.shopValue.text = [NSString stringWithFormat:@"%@工贝",score];
    NSString *showStr =  [NSString stringWithFormat:@"%@工贝",price];
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



@end
