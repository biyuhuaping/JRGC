//
//  UCFAssetAccountViewTotalHeaderView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAssetAccountViewTotalHeaderView.h"
#import "PieView.h"
#import "PieModel.h"
#import "UCFAccountCenterAssetsOverViewModel.h"
@interface UCFAssetAccountViewTotalHeaderView ()

@property (nonatomic, strong) MyRelativeLayout *totalAssetsLayout;// 账户

@property (nonatomic, strong) NZLabel     *totalAssetsLabel;//总资产

@property (nonatomic, strong) UIImageView *arrowImageView;//箭头

@property (nonatomic, strong) PieView      *pieView;

@end

@implementation UCFAssetAccountViewTotalHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        [self.rootLayout addSubview:self.totalAssetsLayout];
        [self.totalAssetsLayout addSubview:self.titleLabel];
        [self.totalAssetsLayout addSubview:self.totalAssetsBtn];
        [self.totalAssetsLayout addSubview:self.totalAssetsLabel];
        [self.totalAssetsLayout addSubview:self.amountShownBtn];
        [self.totalAssetsLayout addSubview:self.arrowImageView];
        [self.totalAssetsLayout addSubview:self.pieView];
        
        //        [self.rootLayout addSubview:self.accountLayout];
        //        [self.accountLayout addSubview:self.accountBalanceLabel];
        //        [self.accountLayout addSubview:self.accountBalanceMoneyLabel];
        //        [self.accountLayout addSubview:self.topUpWithdrawalLabel];
        //        [self.accountLayout addSubview:self.arrowImageView];
        //        [self.accountLayout addSubview:self.arrowBtn];
    }
    return self;
}
- (MyRelativeLayout *)totalAssetsLayout
{
    if (nil == _totalAssetsLayout) {
        _totalAssetsLayout = [MyRelativeLayout new];
        _totalAssetsLayout.backgroundColor = [UIColor whiteColor];
        _totalAssetsLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _totalAssetsLayout.myHeight = 290;
        _totalAssetsLayout.widthSize.equalTo(self.rootLayout.widthSize);
        _totalAssetsLayout.topPos.equalTo(self.rootLayout.topPos);
        _totalAssetsLayout.myLeft = 0;
    }
    return _totalAssetsLayout;
}
- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.myTop = 25;
        _titleLabel.myLeft = 25;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [Color gc_Font:16.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabel.text = @"总资产";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
    
}

- (UIButton *)totalAssetsBtn
{
    if(nil  == _totalAssetsBtn)
    {
        _totalAssetsBtn = [UIButton buttonWithType:0];
        _totalAssetsBtn.centerYPos.equalTo(self.titleLabel.centerYPos);
        _totalAssetsBtn.leftPos.equalTo(self.titleLabel.rightPos).offset(5);
        _totalAssetsBtn.widthSize.equalTo(@17);
        _totalAssetsBtn.heightSize.equalTo(@17);
        _totalAssetsBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_totalAssetsBtn setImage:[UIImage imageNamed:@"question_icon"] forState:UIControlStateNormal];
        _totalAssetsBtn.tag = 1004;
    }
    return _totalAssetsBtn;
}
    
- (NZLabel *)totalAssetsLabel
{
    if (nil == _totalAssetsLabel) {
        _totalAssetsLabel = [NZLabel new];
        _totalAssetsLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(8);
        _totalAssetsLabel.leftPos.equalTo(self.titleLabel.leftPos);
        _totalAssetsLabel.textAlignment = NSTextAlignmentLeft;
        _totalAssetsLabel.font = [Color gc_Font:27.0];
        _totalAssetsLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _totalAssetsLabel.text = @"￥0.00";
        [_totalAssetsLabel sizeToFit];
    }
    return _totalAssetsLabel;
}
- (UIButton*)amountShownBtn
{
    if(nil == _amountShownBtn)
    {
        _amountShownBtn = [UIButton buttonWithType:0];
        _amountShownBtn.centerYPos.equalTo(self.totalAssetsLabel.centerYPos);
        _amountShownBtn.rightPos.equalTo(self.arrowImageView.leftPos).offset(10);
        _amountShownBtn.widthSize.equalTo(@64);
        _amountShownBtn.heightSize.equalTo(@30);
        [_amountShownBtn setTitle:@"资产证明" forState:UIControlStateNormal];
        _amountShownBtn.titleLabel.font= [Color gc_Font:15.0];
        [_amountShownBtn setTitleColor:[Color color:PGColorOptionTitleBlack] forState:UIControlStateNormal];
        [_amountShownBtn setBackgroundColor:[Color color:PGColorOptionThemeWhite]];
        _amountShownBtn.tag = 1003;
    }
    return _amountShownBtn;
}
- (UIImageView *)arrowImageView
{
    if (nil == _arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.centerYPos.equalTo(self.totalAssetsLabel.centerYPos);
        _arrowImageView.rightPos.equalTo(@15);
        _arrowImageView.myWidth = 8;
        _arrowImageView.myHeight = 13;
        _arrowImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
    }
    return _arrowImageView;
}
- (PieView *)pieView
{
    if (nil == _pieView) {
        _pieView = [[PieView alloc]initWithFrame:CGRectMake(0, 0, 180, 180) withModels:nil];
        _pieView.backgroundColor = [UIColor whiteColor];
//        _pieView.delegete = self;
        _pieView.topPos.equalTo(self.totalAssetsLabel.bottomPos).offset(16);
        _pieView.myCenterX = 0;
    }
    return _pieView;
}

- (void)reloadPieView:(NSArray <PieModel*>*)ary andTotalAssets:(NSString *)totalAssets
{
   [self.pieView reloadWithAry:ary];
   if ([totalAssets isKindOfClass:[NSString class]] && totalAssets.length > 0) {
    self.totalAssetsLabel.text = [NSString stringWithFormat:@"¥%@",[NSString AddComma:totalAssets]];
    [self.totalAssetsLabel sizeToFit];
   }
}


@end

//if (nil == model || !model.ret) {
//    return;
//}
//else
//{
//    if (model.data.assetList.count == 0) {
//        return;
//    }
//    else if (model.data.assetList.count == 1)
//    {
//        UCFAccountCenterAssetsOverViewAssetlist *list = model.data.assetList.firstObject;
//
//        PieModel *availBalanceModel = [[PieModel alloc]init];
//        availBalanceModel.count = [list.availBalance floatValue];
//        availBalanceModel.color = PNBlue;
//
//        PieModel *waitPrincipalModel = [[PieModel alloc]init];
//        waitPrincipalModel.count = [list.waitPrincipal floatValue];
//        waitPrincipalModel.color = PNOrange;
//
//        PieModel *waitInterestModel = [[PieModel alloc]init];
//        waitInterestModel.count = [list.waitInterest floatValue];
//        waitInterestModel.color = PNYellow;
//
//        PieModel *frozenBalanceModel = [[PieModel alloc]init];
//        frozenBalanceModel.count = [list.frozenBalance floatValue];
//        frozenBalanceModel.color = PNPinkRed;
//
//        [self.pieView reloadWithAry:@[availBalanceModel,waitPrincipalModel,waitInterestModel,frozenBalanceModel]];
//    }
//    else if (model.data.assetList.count > 1)
//    {
//        NSMutableArray *pieModelArray = [NSMutableArray arrayWithCapacity:5];
//        for (UCFAccountCenterAssetsOverViewAssetlist *list in model.data.assetList) {
//
//            PieModel *accountModel = [[PieModel alloc]init];
//            accountModel.count = [list.waitInterest floatValue];
//            accountModel.color = PNYellow;
//        }
//    }
//    }
