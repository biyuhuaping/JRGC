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
@interface UCFPromotionCell()<RCFFlowViewDelegate>

@property(nonatomic, strong)RCFFlowView *adCycleScrollView;
@end
@implementation UCFPromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        self.rootLayout.useFrame = YES;

        RCFFlowView *view = [[RCFFlowView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30,([UIScreen mainScreen].bounds.size.width - 30) * 6 /23)];
        view.delegate = self;
        self.adCycleScrollView = view;
        view.advArray = [NSMutableArray arrayWithArray:@[@"https://fore.9888.cn/cms/uploadfile/2017/0619/20170619055317291.jpg"]];
        [self addSubview:view];
        [view reloadCycleView];
    }
    return self;
}
- (CGSize)sizeForPageFlowView:(RCFFlowView *)viwe
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, ([UIScreen mainScreen].bounds.size.width - 30) * 6 /23);
}
- (void)reflectDataModel:(id)model
{
    CellConfig *mod = model;
    if ([mod.title isEqualToString:@"新手专享"]) {
        _cellType = HomeBeansAdType;
    } else if ([mod.title isEqualToString:@"推荐内容"]) {
        _cellType = HomeShopAdType;
    }
    switch (_cellType) {
        case 0:
            _vTopSpace = _hLeftSpace = _hRightSpace = 15.0f;
            _vBottomSpace = 0;
            break;
        case 1:
            _hLeftSpace = _hRightSpace = 15.0f;
            _vTopSpace = _vBottomSpace = 0.0f;
            break;
        default:
            break;
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.adCycleScrollView.frame = CGRectMake(_hLeftSpace, _vTopSpace, Screen_Width - _hLeftSpace - _hRightSpace, (Screen_Width - _hLeftSpace - _hRightSpace) * 6 /23);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
