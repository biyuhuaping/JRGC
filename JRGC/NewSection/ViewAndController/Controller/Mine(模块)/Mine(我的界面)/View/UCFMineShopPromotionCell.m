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
#import "UCFWebViewJavascriptBridgeMallDetails.h"

@interface UCFMineShopPromotionCell ()<UCFShopHListViewDataSource,UCFShopHListViewDelegate,UCFNewHomeSectionViewDelegate>
@property(nonatomic, strong)UCFShopHListView *shopList;
@property(nonatomic, strong)UCFNewHomeSectionView *sectionView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)NSMutableArray  *cycleModelArray;
@property(nonatomic, strong)UCFMallDataModel *modelData;

@end
@implementation UCFMineShopPromotionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
//        self.rootLayout.useFrame = YES;
        [self.rootLayout addSubview:self.sectionView];
        [self.rootLayout addSubview:self.shopList];
        [self.rootLayout addSubview:self.lineView];
        
    }
    return self;
}
- (UCFNewHomeSectionView *)sectionView
{
    if (nil == _sectionView) {
        _sectionView = [[UCFNewHomeSectionView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
//        _sectionView.useFrame = YES;
        _sectionView.delegate = self;
        _sectionView.myTop = 10;
        [_sectionView showMore];
        [_sectionView titlecenterYPos];
        _sectionView.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
    }
    return _sectionView;
}
- (void)showMoreViewSection:(NSInteger)section andTitle:(NSString *)title
{
    if ([self.sectionView.titleLab.text isEqualToString:@"为您精选"])
    {
        [self pushWebViewWithUrl:self.modelData.mallRecommendsUrl Title:@"为您精选"];
        
    } else if([self.sectionView.titleLab.text isEqualToString:@"折扣专区"])
    {
        [self pushWebViewWithUrl:self.modelData.mallSaleUrl Title:@"折扣专区"];
    }
}

- (void)pushWebViewWithUrl:(NSString *)url Title:(NSString *)title
{
    UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
    web.url = url;
    web.title = title;
    web.isHidenNavigationbar = YES;
    [((UCFBaseViewController *)self.bc).rt_navigationController pushViewController:web animated:YES];
}

- (UCFShopHListView *)shopList
{
    if (nil == _shopList) {
        _shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sectionView.frame), PGScreenWidth, 165)];
        _shopList.dataSource = self;
        _shopList.delegate = self;
//        _shopList.useFrame = YES;
        _shopList.myLeft = 0;
        _shopList.topPos.equalTo(self.sectionView.bottomPos);
    }
    return _shopList;
}
- (UIView *)lineView
{
    if (nil == _lineView) {
        _lineView = [UIView new];
        _lineView.topPos.equalTo(self.sectionView.bottomPos);
        _lineView.myHeight = 0.5;
        _lineView.myLeft = 0;
        _lineView.myRight = 0;
        _lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    }
    return _lineView;
}
- (void)showInfo:(id)data
{
    self.modelData = [data copy];
    
    if ([self.cellTitleString isEqualToString:@"mallRecommends"])
    {
        self.sectionView.titleLab.text = @"为您精选";
        self.dataArray = [NSMutableArray arrayWithArray:self.modelData.mallRecommends];
    }
    else if ([self.cellTitleString isEqualToString:@"mallSale"])
    {
        self.sectionView.titleLab.text = @"折扣专区";
        self.dataArray = [NSMutableArray arrayWithArray:self.modelData.mallSale];
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
    else if ([self.cellTitleString isEqualToString:@"mallSale"])
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width -0.5, 0, 0.5, view.frame.size.height)];
    lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    [view addSubview:lineView];
    
    return view;
}

- (void)shopHListView:(UCFShopHListView *)shopListView didSelectRowAtIndex:(NSInteger)index
{
    UCFHomeMallrecommends *model = self.dataArray[index];
//    if (self.deleage && [self.deleage respondsToSelector:@selector(baseTableViewCell:buttonClick:withModel:)]) {
//        [self.deleage baseTableViewCell:self buttonClick:nil withModel:model];
//    }
    [self pushWebViewWithUrl:model.bizUrl Title:model.title];
}



@end
