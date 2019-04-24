//
//  UCFMinePromotionCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/29.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMinePromotionCell.h"
#import "RCFFlowView.h"
#import "CellConfig.h"
#import "UCFCellDataModel.h"
#import "UCFNewBannerModel.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UCFQueryBannerByTypeModel.h"
@interface UCFMinePromotionCell()<RCFFlowViewDelegate>

@property(nonatomic, strong)RCFFlowView *adCycleScrollView;

@property(nonatomic, strong)NSArray  *dataArray;

@end
@implementation UCFMinePromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        self.rootLayout.useFrame = YES;
        
        RCFFlowView *view = [[RCFFlowView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth,98)];
        view.delegate = self;
        view.isHideImageCorner = YES;
        self.adCycleScrollView = view;
        [self addSubview:view];
    }
    return self;
}
- (void)didSelectRCCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
//    id obj = self.dataArray[subIndex];
//    NSString *url = @"";
//    NSString *title = @"";
//    if ([obj isKindOfClass:[CoinBanner class]]) {
//        CoinBanner *model = obj;
//        url = model.url;
//        title = model.title;
//    } else if ([obj isKindOfClass:[RecommendBanner class]]) {
//        RecommendBanner *model = obj;
//        url = model.url;
//        title = model.title;
//    }
    
    UCFhomeMallbannerlist *model = self.dataArray[subIndex];
    
    UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
    web.url = model.url;
    web.title = model.title;
    web.isHidenNavigationbar = YES;
    [((UIViewController *)self.bc).navigationController pushViewController:web animated:YES];
}
- (CGSize)sizeForPageFlowView:(RCFFlowView *)viwe
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width - 30) * 6 /23);
}
- (void)showInfo:(id)data
{
    UCFQueryBannerByTypeData *dataModel = data;
    self.dataArray = [NSArray arrayWithArray:dataModel.bannerList];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    
    for (UCFhomeMallbannerlist *model  in self.dataArray) {
        [arr addObject:model.thumb];
    }
    _adCycleScrollView.advArray = [NSMutableArray arrayWithArray:arr];
    
    
//    self.dataArray = dataModel.data1;
//    if ([dataModel.modelType isEqualToString:@"coinArray"]) {
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
//        for (CoinBanner *model  in dataModel.data1) {
//            [arr addObject:model.thumb];
//        }
//        _adCycleScrollView.advArray = [NSMutableArray arrayWithArray:arr];
//
//    } else if ([dataModel.modelType isEqualToString:@"recommend"]) {
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
//        for (RecommendBanner *model  in dataModel.data1) {
//            [arr addObject:model.thumb];
//        }
//        _adCycleScrollView.advArray =[NSMutableArray arrayWithArray:arr];
//    }
    
    [_adCycleScrollView reloadCycleView];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
