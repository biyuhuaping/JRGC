//
//  UCFMineShopDiscountCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineShopDiscountCell.h"
#import "UCFShopHListView.h"
#import "UCFCommodityView.h"
#import "UCFCellDataModel.h"
#import "UCFHomeMallDataModel.h"
#import "UIImageView+WebCache.h"
#import "UCFNewHomeSectionView.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"

#define SHOPLISTHEIGHT 155
@interface UCFMineShopDiscountCell ()<UCFShopHListViewDataSource,UCFShopHListViewDelegate,UCFNewHomeSectionViewDelegate>
@property(nonatomic, strong)UCFShopHListView *shopList;
@property(nonatomic, strong)UCFNewHomeSectionView *sectionView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)NSMutableArray  *cycleModelArray;
@property(nonatomic, strong)UCFMallDataModel *modelData;
@property(nonatomic, assign)CGFloat     shopBottomSectionHeight;

@end
@implementation UCFMineShopDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
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
        _sectionView.titleLab.font = [Color gc_Font:16.0];
        [_sectionView showMore];
        [_sectionView titlecenterYPos];
        _sectionView.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
    }
    return _sectionView;
}
- (void)showMoreViewSection:(NSInteger)section andTitle:(NSString *)title
{
    [self pushWebViewWithUrl:self.modelData.mallSaleUrl Title:@"折扣专区"];
}

- (void)pushWebViewWithUrl:(NSString *)url Title:(NSString *)title
{
    if ([url containsString:@"http"]) {
        UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
        //    web.url = [NSString stringWithFormat:@"%@&closeView=true",url];
        web.url = url;
        web.title = title;
        web.isHidenNavigationbar = YES;
        [((UCFBaseViewController *)self.bc).rt_navigationController pushViewController:web animated:YES];
        
    } else {
        [SingGlobalView.tabBarController setSelectedIndex:3];
    }
}

- (UCFShopHListView *)shopList
{
    if (nil == _shopList) {
        _shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sectionView.frame), PGScreenWidth, SHOPLISTHEIGHT)];
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
    self.sectionView.titleLab.text = @"折扣专区";
    self.dataArray = [NSMutableArray arrayWithArray:self.modelData.mallSale];
    [self.shopList reloadView];
}

- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView
{
    return self.dataArray.count;
}
- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize
{
    return CGSizeMake(105, SHOPLISTHEIGHT);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    UCFHomeMallsale *model = self.dataArray[index];

    UCFCommodityView *view = [[UCFCommodityView alloc] initWithFrame:CGRectMake(0, 0,105, SHOPLISTHEIGHT )withHeightOfCommodity:105];
//    view.shopValue.frame = CGRectMake(view.shopValue.frame.origin.x, view.shopValue.frame.origin.y +3, view.shopValue.frame.size.width, view.shopValue.frame.size.height);
    [view.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    view.shopName.text = model.title;
    [view setShopValueWithModel:model];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width -0.5, 0, 0.5, view.frame.size.height)];
    lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    [view addSubview:lineView];
//    view.shopOrginalValue.hidden = YES;
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
