//
//  UCFAssetAccountViewTotalHeaderView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "NZLabel.h"
@class PieModel;
NS_ASSUME_NONNULL_BEGIN

#define PNBlue          UIColorWithRGB(0x8A9FF9)
#define PNLightBlue     UIColorWithRGB(0x74C3FF)
#define PNOrange        UIColorWithRGB(0xFF7D51)
#define PNYellow        UIColorWithRGB(0xFFCA6D)
#define PNPinkRed       UIColorWithRGB(0xFC6992)
#define PNLightGreen    UIColorWithRGB(0x63C799)
@interface UCFAssetAccountViewTotalHeaderView : BaseView

@property (nonatomic, strong) MyRelativeLayout *accountLayout;// 账户信息

@property (nonatomic, strong) UIButton    *amountShownBtn;//资产证明按钮

@property (nonatomic, strong) UIButton    *totalAssetsBtn;//总资产说明按钮

@property (nonatomic, strong) NZLabel     *titleLabel;//标题---总资产 或者已收收益

- (void)reloadPieView:(NSArray <PieModel*>*)ary andTotalAssets:(NSString *)totalAssets;
@end

NS_ASSUME_NONNULL_END
