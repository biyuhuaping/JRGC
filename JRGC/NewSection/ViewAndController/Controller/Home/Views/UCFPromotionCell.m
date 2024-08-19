//
//  UCFPromotionCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPromotionCell.h"
#import "RCFFlowView.h"
#import "CellConfig.h"
#import "UCFCellDataModel.h"
#import "UCFNewBannerModel.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
@interface UCFPromotionCell()<RCFFlowViewDelegate>

@property(nonatomic, strong)RCFFlowView *adCycleScrollView;

@property(nonatomic, strong)NSArray  *dataArray;
@end
@implementation UCFPromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        self.rootLayout.useFrame = YES;

        RCFFlowView *view = [[RCFFlowView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30,([UIScreen mainScreen].bounds.size.width - 30) * 6 /23)];
        view.delegate = self;
        self.adCycleScrollView = view;
        [self addSubview:view];
    }
    return self;
}
- (void)didSelectRCCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    id obj = self.dataArray[subIndex];
    NSString *url = @"";
    NSString *title = @"";
    if ([obj isKindOfClass:[CoinBanner class]]) {
        CoinBanner *model = obj;
        url = model.url;
        title = model.title;
    } else if ([obj isKindOfClass:[RecommendBanner class]]) {
        RecommendBanner *model = obj;
        url = model.url;
        title = model.title;
    }
    UCFWebViewJavascriptBridgeBanner *web = [[UCFWebViewJavascriptBridgeBanner alloc] initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
    web.url = url;
    web.title = title;
    [((UIViewController *)self.bc).navigationController pushViewController:web animated:YES];
}
- (CGSize)sizeForPageFlowView:(RCFFlowView *)viwe
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, ([UIScreen mainScreen].bounds.size.width - 30) * 6 /23);
}
- (void)reflectDataModel:(id)model
{
    UCFCellDataModel *dataModel = model;
    self.dataArray = dataModel.data1;
    if ([dataModel.modelType isEqualToString:@"coinArray"]) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (CoinBanner *model  in dataModel.data1) {
            [arr addObject:model.thumb];
        }
        _adCycleScrollView.advArray = [NSMutableArray arrayWithArray:arr];
        
    } else if ([dataModel.modelType isEqualToString:@"recommend"]) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (RecommendBanner *model  in dataModel.data1) {
            [arr addObject:model.thumb];
        }
        _adCycleScrollView.advArray =[NSMutableArray arrayWithArray:arr];
    }
    
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
