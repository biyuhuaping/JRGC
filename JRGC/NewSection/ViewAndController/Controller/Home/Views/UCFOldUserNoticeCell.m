//
//  UCFOldUserNoticeCell.m
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFOldUserNoticeCell.h"
#import "SDCycleScrollView.h"
#import "UCFShopHListView.h"
#import "UIButton+MLSpace.h"
#import "UCFSiteNoticeView.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFNewBannerModel.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
@interface UCFOldUserNoticeCell()<UCFShopHListViewDataSource,UCFShopHListViewDelegate,UCFSiteNoticeViewDelegate>
@property(nonatomic, strong)NSMutableArray  *showImagesDataArr;
@property(nonatomic, strong)UCFSiteNoticeView *notiView;
@property(nonatomic, strong)Sitenoticemap      *mapModel;
@end

@implementation UCFOldUserNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.showImagesDataArr = [NSMutableArray arrayWithCapacity:4];
        NSDictionary *dict0 = @{@"img":@"home_icon_shop",@"title":@"豆哥商城"};
        NSDictionary *dict1 = @{@"img":@"mine_icon_coupon",@"title":@"领券中心"};
        NSDictionary *dict2 = @{@"img":@"home_icon_rebate",@"title":@"邀请返利"};
        NSDictionary *dict3 = @{@"img":@"home_icon_shell",@"title":@"工力工贝"};
        [self.showImagesDataArr addObject:dict0];
        [self.showImagesDataArr addObject:dict1];
        [self.showImagesDataArr addObject:dict2];
        [self.showImagesDataArr addObject:dict3];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
//        self.rootLayout.backgroundColor = [UIColor yellowColor];
        self.rootLayout.useFrame = YES;
        
        UIView *whitBaseView = [UIView new];
        whitBaseView.frame = CGRectMake(15, 15,  ScreenWidth - 30, 125);
        whitBaseView.layer.cornerRadius = 5.0f;
        whitBaseView.clipsToBounds = YES;
        whitBaseView.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:whitBaseView];
        whitBaseView.useFrame = YES;
        
        UCFShopHListView *shopList = [[UCFShopHListView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth - 30, 75)];
        shopList.horizontalSpace = 0;
        shopList.dataSource = self;
        shopList.delegate = self;
        [whitBaseView addSubview:shopList];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 75, ScreenWidth - 30, 1);
        lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        [whitBaseView addSubview:lineView];
        
        
        UCFSiteNoticeView *notiView = [[UCFSiteNoticeView alloc] init];
        notiView.frame = CGRectMake(0, CGRectGetMaxY(shopList.frame), ScreenWidth - 30, 50);
        [whitBaseView addSubview:notiView];
        notiView.deleage = self;
        self.notiView = notiView;
    }
    return self;
}
- (void)reflectDataModel:(id)dataModel
{
    if ([dataModel isKindOfClass:[Sitenoticemap class]]) {
        self.mapModel = dataModel;
        self.notiView.titleLab.text = self.mapModel.siteNotice;
    }
}
- (void)noticeSiteClick
{
    UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
    web.url = self.mapModel.noticeUrl;
    web.title = @"公告";
    web.isHidenNavigationbar = YES;
    [((UIViewController *)self.bc).navigationController pushViewController:web animated:YES];
}
- (NSInteger)numberOfListView:(UCFShopHListView *)shopListView
{
    return 4;
}
- (CGSize)shopHListView:(UCFShopHListView *)shopListViewCommodityImageSize
{
    return CGSizeMake((ScreenWidth - 30)/4.0f, 75);
}

- (UIView *)shopHListView:(UCFShopHListView *)shopListView cellForRowAtIndex:(NSInteger)index
{
    UIButton *showBtn = [self getShowButton];
    NSDictionary *showDict = self.showImagesDataArr[index];
    UIImage *img = [UIImage imageNamed:showDict[@"img"]];
    NSString *title = showDict[@"title"];
    [showBtn setImage:img forState:UIControlStateNormal];
    [showBtn setTitle:title forState:UIControlStateNormal];
    [showBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    

    return showBtn;
}
- (void)shopHListView:(UCFShopHListView *)shopListView didSelectRowAtIndex:(NSInteger)index
{
    
    
    NSDictionary *dataDict = [self.showImagesDataArr objectAtIndex:index];
    NSString *title = dataDict[@"title"];
    
    if ([self.deleage respondsToSelector:@selector(baseTableViewCell:buttonClick:withModel:)]) {
        [self.deleage baseTableViewCell:self buttonClick:nil withModel:title];
    }
    

}
- (UIButton *)getShowButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,(ScreenWidth - 30)/4.0f, 75);
    [button setBackgroundColor:[Color color:PGColorOptionThemeWhite]];
    button.titleLabel.font = [Color gc_Font:12];
    [button setTitleColor:[Color color:PGColorOptionTitleBlackGray] forState:UIControlStateNormal];
    return button;
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
