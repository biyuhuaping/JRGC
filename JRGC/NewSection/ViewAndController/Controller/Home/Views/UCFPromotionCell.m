//
//  UCFPromotionCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPromotionCell.h"
#import "SDCycleScrollView.h"
#import "CellConfig.h"
@interface UCFPromotionCell()<SDCycleScrollViewDelegate>

@property(nonatomic, strong)SDCycleScrollView *adCycleScrollView;
@end
@implementation UCFPromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        self.rootLayout.useFrame = YES;
        SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 15, Screen_Width - 30, (Screen_Width - 30) * 6 /23) delegate:self placeholderImage:[UIImage imageNamed:@"banner_unlogin_default"]];
        adCycleScrollView.zoomType = NO;  // 是否使用缩放效果
        adCycleScrollView.hidesForSinglePage = YES;
        adCycleScrollView.autoScroll = NO;
        adCycleScrollView.infiniteLoop = NO;
        
//        adCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//        adCycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        adCycleScrollView.currentPageDotColor = [UIColor whiteColor];
//        adCycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.5];
//        adCycleScrollView.pageControlDotSize = CGSizeMake(20, 6);  // pageControl小点的大小
        adCycleScrollView.imageURLStringsGroup = @[@"https://fore.9888.cn/cms/uploadfile/2017/0619/20170619055317291.jpg"];
        [self.rootLayout addSubview:adCycleScrollView];
        self.adCycleScrollView = adCycleScrollView;
        
    }
    return self;
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
    self.adCycleScrollView.frame = CGRectMake(_hLeftSpace, _vTopSpace, Screen_Width - _hLeftSpace - _hRightSpace, (Screen_Width - _hLeftSpace - _hRightSpace) * 6 /23);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
