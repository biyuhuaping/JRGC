//
//  UCFAssetAccountViewTotalListView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAssetAccountViewTotalListView.h"
#import "NZLabel.h"
#import "UCFAccountCenterAssetsOverViewModel.h"
#define LabelLeft 42
@interface UCFAssetAccountViewTotalListView()

@property (nonatomic, strong) MyRelativeLayout *availBalanceLayout;// 可用余额

@property (nonatomic, strong) NZLabel     *availBalanceLabel;

@property (nonatomic, strong) NZLabel     *availBalanceContentLabel;

@property (nonatomic, strong) UIView      *availBalanceRound;

@property (nonatomic, strong) UIView      *availBalanceLinView;

@property (nonatomic, strong) MyRelativeLayout *waitPrincipalLayout;// 待收本金

@property (nonatomic, strong) NZLabel     *waitPrincipalLabel;

@property (nonatomic, strong) NZLabel     *waitPrincipalContentLabel;

@property (nonatomic, strong) UIView      *waitPrincipalRound;

@property (nonatomic, strong) UIView      *waitPrincipalLinView;

@property (nonatomic, strong) MyRelativeLayout *waitInterestLayout;// 预期利息

@property (nonatomic, strong) NZLabel     *waitInterestLabel;

@property (nonatomic, strong) NZLabel     *waitInterestContentLabel;

@property (nonatomic, strong) UIView      *waitInterestRound;

@property (nonatomic, strong) UIView      *waitInterestLinView;

@property (nonatomic, strong) MyRelativeLayout *frozenBalanceLayout;// 冻结金额

@property (nonatomic, strong) NZLabel     *frozenBalanceLabel;

@property (nonatomic, strong) NZLabel     *frozenBalanceContentLabel;

@property (nonatomic, strong) UIView      *frozenBalanceRound;

@property (nonatomic, strong) UIView      *frozenBalanceLinView;

@end

@implementation UCFAssetAccountViewTotalListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.rootLayout addSubview:self.availBalanceLayout];
        [self.availBalanceLayout addSubview:self.availBalanceRound];
        [self.availBalanceLayout addSubview:self.availBalanceLabel];
        [self.availBalanceLayout addSubview:self.availBalanceContentLabel];
        [self.availBalanceLayout addSubview:self.availBalanceLinView];
        
        [self.rootLayout addSubview:self.waitPrincipalLayout];
        [self.waitPrincipalLayout addSubview:self.waitPrincipalRound];
        [self.waitPrincipalLayout addSubview:self.waitPrincipalLabel];
        [self.waitPrincipalLayout addSubview:self.waitPrincipalContentLabel];
        [self.waitPrincipalLayout addSubview:self.waitPrincipalLinView];
        
        [self.rootLayout addSubview:self.waitInterestLayout];
        [self.waitInterestLayout addSubview:self.waitInterestRound];
        [self.waitInterestLayout addSubview:self.waitInterestLabel];
        [self.waitInterestLayout addSubview:self.waitInterestContentLabel];
        [self.waitInterestLayout addSubview:self.waitInterestLinView];
        
        [self.rootLayout addSubview:self.frozenBalanceLayout];
        [self.frozenBalanceLayout addSubview:self.frozenBalanceRound];
        [self.frozenBalanceLayout addSubview:self.frozenBalanceLabel];
        [self.frozenBalanceLayout addSubview:self.frozenBalanceContentLabel];
        [self.frozenBalanceLayout addSubview:self.frozenBalanceLinView];
        
        [self.rootLayout addSubview:self.enterButton];
    }
    return self;
}
- (UIButton*)enterButton
{
    
    if(nil == _enterButton)
    {
        _enterButton = [UIButton buttonWithType:0];
        _enterButton.myLeft = 25;
        _enterButton.myRight = 25;
        _enterButton.myHeight = 40;
        _enterButton.tag = 1000;
        _enterButton.topPos.equalTo(self.frozenBalanceLayout.bottomPos).offset(25);
        _enterButton.titleLabel.font= [Color gc_Font:15.0];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
        _enterButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _enterButton;
}
- (MyRelativeLayout *)availBalanceLayout
{
    if (nil == _availBalanceLayout){
        _availBalanceLayout = [MyRelativeLayout new];
        _availBalanceLayout.backgroundColor = [UIColor whiteColor];
        _availBalanceLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _availBalanceLayout.myWidth = PGScreenWidth;
        _availBalanceLayout.myHeight = 50;
        _availBalanceLayout.myTop = 13;
        //        _wjLayout.myCenterX = - 70;
    }
    return _availBalanceLayout;
}
- (UIView *)availBalanceRound
{
    if (nil == _availBalanceRound) {
        _availBalanceRound = [UIView new];
        _availBalanceRound.myLeft = 25;
        _availBalanceRound.myCenterY = 0;
        _availBalanceRound.myWidth = 7;
        _availBalanceRound.myHeight = 7;
        _availBalanceRound.backgroundColor = PNBlue;
        _availBalanceRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _availBalanceRound;
}

- (NZLabel *)availBalanceLabel
{
    if (nil == _availBalanceLabel) {
        _availBalanceLabel = [NZLabel new];
        _availBalanceLabel.myCenterY = 0;
        _availBalanceLabel.myLeft = LabelLeft;
        _availBalanceLabel.textAlignment = NSTextAlignmentLeft;
        _availBalanceLabel.font = [Color gc_Font:15.0];
        _availBalanceLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _availBalanceLabel.text = @"可用余额";
        [_availBalanceLabel sizeToFit];
    }
    return _availBalanceLabel;
}

- (NZLabel *)availBalanceContentLabel
{
    if (nil == _availBalanceContentLabel) {
        _availBalanceContentLabel = [NZLabel new];
        _availBalanceContentLabel.myCenterY = 0;
        _availBalanceContentLabel.myRight = 25;
        _availBalanceContentLabel.textAlignment = NSTextAlignmentRight;
        _availBalanceContentLabel.font = [Color gc_Font:14.0];
        _availBalanceContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _availBalanceContentLabel.text = @"  ";
        [_availBalanceContentLabel sizeToFit];
    }
    return _availBalanceContentLabel;
}

-(UIView *)availBalanceLinView
{
    if (nil == _availBalanceLinView) {
        _availBalanceLinView = [UIView new];
        _availBalanceLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _availBalanceLinView.myBottom = 0;
        _availBalanceLinView.myHeight = 0.5;
        _availBalanceLinView.myWidth = PGScreenWidth;
        _availBalanceLinView.myLeft = 18;
    }
    return _availBalanceLinView;
}


- (MyRelativeLayout *)waitPrincipalLayout
{
    if (nil == _waitPrincipalLayout){
        _waitPrincipalLayout = [MyRelativeLayout new];
        _waitPrincipalLayout.backgroundColor = [UIColor whiteColor];
        _waitPrincipalLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _waitPrincipalLayout.myWidth = PGScreenWidth;
        _waitPrincipalLayout.myHeight = 50;
        _waitPrincipalLayout.topPos.equalTo(self.availBalanceLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _waitPrincipalLayout;
}

- (UIView *)waitPrincipalRound
{
    if (nil == _waitPrincipalRound) {
        _waitPrincipalRound = [UIView new];
        _waitPrincipalRound.myLeft = 25;
        _waitPrincipalRound.myCenterY = 0;
        _waitPrincipalRound.myWidth = 7;
        _waitPrincipalRound.myHeight = 7;
        _waitPrincipalRound.backgroundColor = PNOrange;
        _waitPrincipalRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _waitPrincipalRound;
}

- (NZLabel *)waitPrincipalLabel
{
    if (nil == _waitPrincipalLabel) {
        _waitPrincipalLabel = [NZLabel new];
        _waitPrincipalLabel.myCenterY = 0;
        _waitPrincipalLabel.myLeft = LabelLeft;
        _waitPrincipalLabel.textAlignment = NSTextAlignmentLeft;
        _waitPrincipalLabel.font = [Color gc_Font:15.0];
        _waitPrincipalLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitPrincipalLabel.text = @"待收本金";
        [_waitPrincipalLabel sizeToFit];
    }
    return _waitPrincipalLabel;
}

- (NZLabel *)waitPrincipalContentLabel
{
    if (nil == _waitPrincipalContentLabel) {
        _waitPrincipalContentLabel = [NZLabel new];
        _waitPrincipalContentLabel.myCenterY = 0;
        _waitPrincipalContentLabel.myRight = 25;
        _waitPrincipalContentLabel.textAlignment = NSTextAlignmentRight;
        _waitPrincipalContentLabel.font = [Color gc_Font:14.0];
        _waitPrincipalContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitPrincipalContentLabel.text = @"  ";
        [_waitPrincipalContentLabel sizeToFit];
    }
    return _waitPrincipalContentLabel;
}

-(UIView *)waitPrincipalLinView
{
    if (nil == _waitPrincipalLinView) {
        _waitPrincipalLinView = [UIView new];
        _waitPrincipalLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _waitPrincipalLinView.myBottom = 0;
        _waitPrincipalLinView.myHeight = 0.5;
        _waitPrincipalLinView.myWidth = PGScreenWidth;
        _waitPrincipalLinView.myLeft = 18;
    }
    return _waitPrincipalLinView;
}
- (MyRelativeLayout *)waitInterestLayout
{
    if (nil == _waitInterestLayout){
        _waitInterestLayout = [MyRelativeLayout new];
        _waitInterestLayout.backgroundColor = [UIColor whiteColor];
        _waitInterestLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _waitInterestLayout.myWidth = PGScreenWidth;
        _waitInterestLayout.myHeight = 50;
        _waitInterestLayout.topPos.equalTo(self.waitPrincipalLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _waitInterestLayout;
}

- (UIView *)waitInterestRound
{
    if (nil == _waitInterestRound) {
        _waitInterestRound = [UIView new];
        _waitInterestRound.myLeft = 25;
        _waitInterestRound.myCenterY = 0;
        _waitInterestRound.myWidth = 7;
        _waitInterestRound.myHeight = 7;
        _waitInterestRound.backgroundColor = PNYellow;
        _waitInterestRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _waitInterestRound;
}

- (NZLabel *)waitInterestLabel
{
    if (nil == _waitInterestLabel) {
        _waitInterestLabel = [NZLabel new];
        _waitInterestLabel.myCenterY = 0;
        _waitInterestLabel.myLeft = LabelLeft;
        _waitInterestLabel.textAlignment = NSTextAlignmentLeft;
        _waitInterestLabel.font = [Color gc_Font:15.0];
        _waitInterestLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitInterestLabel.text = @"预期利息";
        [_waitInterestLabel sizeToFit];
    }
    return _waitInterestLabel;
}

- (NZLabel *)waitInterestContentLabel
{
    if (nil == _waitInterestContentLabel) {
        _waitInterestContentLabel = [NZLabel new];
        _waitInterestContentLabel.myCenterY = 0;
        _waitInterestContentLabel.myRight = 25;
        _waitInterestContentLabel.textAlignment = NSTextAlignmentRight;
        _waitInterestContentLabel.font = [Color gc_Font:14.0];
        _waitInterestContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitInterestContentLabel.text = @"  ";
        [_waitInterestContentLabel sizeToFit];
    }
    return _waitInterestContentLabel;
}

-(UIView *)waitInterestLinView
{
    if (nil == _waitInterestLinView) {
        _waitInterestLinView = [UIView new];
        _waitInterestLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _waitInterestLinView.myBottom = 0;
        _waitInterestLinView.myHeight = 0.5;
        _waitInterestLinView.myWidth = PGScreenWidth;
        _waitInterestLinView.myLeft = 18;
    }
    return _waitInterestLinView;
}
- (MyRelativeLayout *)frozenBalanceLayout
{
    if (nil == _frozenBalanceLayout){
        _frozenBalanceLayout = [MyRelativeLayout new];
        _frozenBalanceLayout.backgroundColor = [UIColor whiteColor];
        _frozenBalanceLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _frozenBalanceLayout.myWidth = PGScreenWidth;
        _frozenBalanceLayout.myHeight = 50;
        _frozenBalanceLayout.topPos.equalTo(self.waitInterestLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _frozenBalanceLayout;
}

- (UIView *)frozenBalanceRound
{
    if (nil == _frozenBalanceRound) {
        _frozenBalanceRound = [UIView new];
        _frozenBalanceRound.myLeft = 25;
        _frozenBalanceRound.myCenterY = 0;
        _frozenBalanceRound.myWidth = 7;
        _frozenBalanceRound.myHeight = 7;
        _frozenBalanceRound.backgroundColor = PNPinkRed;
        _frozenBalanceRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _frozenBalanceRound;
}

- (NZLabel *)frozenBalanceLabel
{
    if (nil == _frozenBalanceLabel) {
        _frozenBalanceLabel = [NZLabel new];
        _frozenBalanceLabel.myCenterY = 0;
        _frozenBalanceLabel.myLeft = LabelLeft;
        _frozenBalanceLabel.textAlignment = NSTextAlignmentLeft;
        _frozenBalanceLabel.font = [Color gc_Font:15.0];
        _frozenBalanceLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _frozenBalanceLabel.text = @"冻结金额";
        [_frozenBalanceLabel sizeToFit];
    }
    return _frozenBalanceLabel;
}

- (NZLabel *)frozenBalanceContentLabel
{
    if (nil == _frozenBalanceContentLabel) {
        _frozenBalanceContentLabel = [NZLabel new];
        _frozenBalanceContentLabel.myCenterY = 0;
        _frozenBalanceContentLabel.myRight = 25;
        _frozenBalanceContentLabel.textAlignment = NSTextAlignmentRight;
        _frozenBalanceContentLabel.font = [Color gc_Font:14.0];
        _frozenBalanceContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _frozenBalanceContentLabel.text = @"  ";
        [_frozenBalanceContentLabel sizeToFit];
    }
    return _frozenBalanceContentLabel;
}

-(UIView *)frozenBalanceLinView
{
    if (nil == _frozenBalanceLinView) {
        _frozenBalanceLinView = [UIView new];
        _frozenBalanceLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _frozenBalanceLinView.myBottom = 0;
        _frozenBalanceLinView.myHeight = 0.5;
        _frozenBalanceLinView.myWidth = PGScreenWidth;
        _frozenBalanceLinView.myLeft = 18;
    }
    return _frozenBalanceLinView;
}
- (void)reloadAccountContent:(UCFAccountCenterAssetsOverViewModel *)model{
    
    UCFAccountCenterAssetsOverViewAssetlist *ass = model.data.assetList.firstObject;
    self.availBalanceContentLabel.text = [NSString AddCNY:ass.availBalance];
    self.waitPrincipalContentLabel.text = [NSString AddCNY:ass.waitPrincipal];
    self.waitInterestContentLabel.text = [NSString AddCNY:ass.waitInterest];
    self.frozenBalanceContentLabel.text = [NSString AddCNY:ass.frozenBalance];
    
    [self.availBalanceContentLabel sizeToFit] ;
    [self.waitPrincipalContentLabel sizeToFit];
    [self.waitInterestContentLabel sizeToFit];
    [self.frozenBalanceContentLabel sizeToFit];
}

@end
