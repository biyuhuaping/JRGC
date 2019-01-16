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

@interface UCFBoutiqueCell ()<UCFShopHListViewDataSource,UCFShopHListViewDelegate>

@end

@implementation UCFBoutiqueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorWithRGB(0xebebee);
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        UCFShopHListView *shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(15, 0, [[UIScreen mainScreen] bounds].size.width - 30, 150)];
        shopList.horizontalSpace = 5.0f;
        shopList.dataSource = self;
        shopList.delegate = self;
        [self addSubview:shopList];
        
    }
    return self;
}
- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView
{
    return 10;
}
- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize
{
    return CGSizeMake(105, 150);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    UCFCommodityView *view = [[UCFCommodityView alloc] initWithFrame:CGRectMake(0, 0, 105, 150) withHeightOfCommodity:105];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5.0f;
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
