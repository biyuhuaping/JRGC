//
//  UCFPromotionCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPromotionCell.h"
//#import "SDCycleScrollView.h"
#import "RCFFlowView.h"
#import "CellConfig.h"
#import "UCFCellDataModel.h"
@interface UCFPromotionCell()<RCFFlowViewDelegate>

@property(nonatomic, strong)RCFFlowView *adCycleScrollView;
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
- (CGSize)sizeForPageFlowView:(RCFFlowView *)viwe
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, ([UIScreen mainScreen].bounds.size.width - 30) * 6 /23);
}
- (void)reflectDataModel:(id)model
{
    
    
//    CellConfig *mod = model;
//    if ([mod.title isEqualToString:@"新手专享"]) {
//        _cellType = HomeBeansAdType;
//    } else if ([mod.title isEqualToString:@"推荐内容"]) {
//        _cellType = HomeShopAdType;
//    }
//    switch (_cellType) {
//        case 0:
//            _vTopSpace = _hLeftSpace = _hRightSpace = 15.0f;
//            _vBottomSpace = 0;
//            break;
//        case 1:
//            _hLeftSpace = _hRightSpace = 15.0f;
//            _vTopSpace = _vBottomSpace = 0.0f;
//            break;
//        default:
//            break;
//    }
    UCFCellDataModel *dataModel = model;
    if ([dataModel.modelType isEqualToString:@"coinArray"]) {
        _adCycleScrollView.advArray = [NSMutableArray arrayWithArray:dataModel.data1];
    } else if ([dataModel.modelType isEqualToString:@"recommend"]) {
        _adCycleScrollView.advArray =[NSMutableArray arrayWithArray:dataModel.data1];
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
