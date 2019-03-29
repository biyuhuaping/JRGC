//
//  UCFBoutiqueCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBoutiqueCell.h"
#import "UCFShopHListView.h"
#import "UCFCommodityView.h"
#import "UCFCellDataModel.h"
#import "UCFHomeMallDataModel.h"
#import "UIImageView+WebCache.h"
@interface UCFBoutiqueCell ()<UCFShopHListViewDataSource,UCFShopHListViewDelegate>
@property(nonatomic, strong)UCFShopHListView *shopList;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@end

@implementation UCFBoutiqueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        
        UCFShopHListView *shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(15, 0, [[UIScreen mainScreen] bounds].size.width - 30, 150)];
        shopList.horizontalSpace = 5.0f;
        shopList.dataSource = self;
        shopList.delegate = self;
        [self addSubview:shopList];
        self.shopList = shopList;
        
    }
    return self;
}
- (void)reflectDataModel:(id)model
{
    UCFCellDataModel *dataModel = model;
    if ([dataModel.modelType isEqualToString:@"mallDiscounts"]) {
        self.dataArray = dataModel.data1;
        [self.shopList reloadView];
    }
}
- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView
{
    return self.dataArray.count;
}
- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize
{
    return CGSizeMake(105, 150);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    UCFHomeMallsale *model = self.dataArray[index];
    UCFCommodityView *view = [[UCFCommodityView alloc] initWithFrame:CGRectMake(0, 0, 105, 150) withHeightOfCommodity:105];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    
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
