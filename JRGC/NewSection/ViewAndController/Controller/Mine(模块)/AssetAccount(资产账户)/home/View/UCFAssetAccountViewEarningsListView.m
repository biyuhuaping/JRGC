//
//  UCFAssetAccountViewEarningsListView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/8.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAssetAccountViewEarningsListView.h"
#import "UCFAccountCenterAlreadyProfitModel.h"
#import "NZLabel.h"
#define LabelLeft 42

@interface UCFAssetAccountViewEarningsListView ()

@property (nonatomic, strong) MyRelativeLayout *wjProfitLayout;// 微金收益

@property (nonatomic, strong) NZLabel     *wjProfitLabel;

@property (nonatomic, strong) NZLabel     *wjProfitContentLabel;

@property (nonatomic, strong) UIView      *wjProfitRound;

@property (nonatomic, strong) UIView      *wjProfitLinView;



@property (nonatomic, strong) NZLabel     *zxProfitLabel;

@property (nonatomic, strong) NZLabel     *zxProfitContentLabel;

@property (nonatomic, strong) UIView      *zxProfitRound;

@property (nonatomic, strong) UIView      *zxProfitLinView;



@property (nonatomic, strong) NZLabel     *goldProfitLabel;

@property (nonatomic, strong) NZLabel     *goldProfitContentLabel;

@property (nonatomic, strong) UIView      *goldProfitRound;

@property (nonatomic, strong) UIView      *goldProfitLinView;

@property (nonatomic, strong) MyRelativeLayout *couponProfitLayout;// 返现券收益

@property (nonatomic, strong) NZLabel     *couponProfitLabel;

@property (nonatomic, strong) NZLabel     *couponProfitContentLabel;

@property (nonatomic, strong) UIView      *couponProfitRound;

@property (nonatomic, strong) UIView      *couponProfitLinView;


@property (nonatomic, strong) MyRelativeLayout *beanProfitLayout;// 工豆收益

@property (nonatomic, strong) NZLabel     *beanProfitLabel;

@property (nonatomic, strong) NZLabel     *beanProfitContentLabel;

@property (nonatomic, strong) UIView      *beanProfitRound;

@property (nonatomic, strong) UIView      *beanProfitLinView;


@property (nonatomic, strong) MyRelativeLayout *balanceProfitLayout;// 余额收益

@property (nonatomic, strong) NZLabel     *balanceProfitLabel;

@property (nonatomic, strong) NZLabel     *balanceProfitContentLabel;

@property (nonatomic, strong) UIView      *balanceProfitRound;

@property (nonatomic, strong) UIView      *balanceProfitLinView;

@end
@implementation UCFAssetAccountViewEarningsListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootLayout.backgroundColor = [UIColor whiteColor];
        
        [self.rootLayout addSubview:self.wjProfitLayout];
        [self.wjProfitLayout addSubview:self.wjProfitLabel];
        [self.wjProfitLayout addSubview:self.wjProfitContentLabel];
        [self.wjProfitLayout addSubview:self.wjProfitRound];
        [self.wjProfitLayout addSubview:self.wjProfitLinView];
        
        [self.rootLayout addSubview:self.zxProfitLayout];
        [self.zxProfitLayout addSubview:self.zxProfitLabel];
        [self.zxProfitLayout addSubview:self.zxProfitContentLabel];
        [self.zxProfitLayout addSubview:self.zxProfitRound];
        [self.zxProfitLayout addSubview:self.zxProfitLinView];
        
        [self.rootLayout addSubview:self.goldProfitLayout];
        [self.goldProfitLayout addSubview:self.goldProfitLabel];
        [self.goldProfitLayout addSubview:self.goldProfitContentLabel];
        [self.goldProfitLayout addSubview:self.goldProfitRound];
        [self.goldProfitLayout addSubview:self.goldProfitLinView];
        
        [self.rootLayout addSubview:self.couponProfitLayout];
        [self.couponProfitLayout addSubview:self.couponProfitLabel];
        [self.couponProfitLayout addSubview:self.couponProfitContentLabel];
        [self.couponProfitLayout addSubview:self.couponProfitRound];
        [self.couponProfitLayout addSubview:self.couponProfitLinView];
        
        [self.rootLayout addSubview:self.beanProfitLayout];
        [self.beanProfitLayout addSubview:self.beanProfitLabel];
        [self.beanProfitLayout addSubview:self.beanProfitContentLabel];
        [self.beanProfitLayout addSubview:self.beanProfitRound];
        [self.beanProfitLayout addSubview:self.beanProfitLinView];
        
        [self.rootLayout addSubview:self.balanceProfitLayout];
        [self.balanceProfitLayout addSubview:self.balanceProfitLabel];
        [self.balanceProfitLayout addSubview:self.balanceProfitContentLabel];
        [self.balanceProfitLayout addSubview:self.balanceProfitRound];
        [self.balanceProfitLayout addSubview:self.balanceProfitLinView];
        
    }
    return self;
}
- (MyRelativeLayout *)wjProfitLayout
{
    if (nil == _wjProfitLayout){
        _wjProfitLayout = [MyRelativeLayout new];
        _wjProfitLayout.backgroundColor = [UIColor whiteColor];
        _wjProfitLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _wjProfitLayout.myWidth = PGScreenWidth;
        _wjProfitLayout.myHeight = 50;
        _wjProfitLayout.myTop = 13;
        //        _wjLayout.myCenterX = - 70;
    }
    return _wjProfitLayout;
}
- (UIView *)wjProfitRound
{
    if (nil == _wjProfitRound) {
        _wjProfitRound = [UIView new];
        _wjProfitRound.myLeft = 25;
        _wjProfitRound.myCenterY = 0;
        _wjProfitRound.myWidth = 7;
        _wjProfitRound.myHeight = 7;
        _wjProfitRound.backgroundColor = PNBlue;
        _wjProfitRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _wjProfitRound;
}

- (NZLabel *)wjProfitLabel
{
    if (nil == _wjProfitLabel) {
        _wjProfitLabel = [NZLabel new];
        _wjProfitLabel.myCenterY = 0;
        _wjProfitLabel.myLeft = LabelLeft;
        _wjProfitLabel.textAlignment = NSTextAlignmentLeft;
        _wjProfitLabel.font = [Color gc_Font:15.0];
        _wjProfitLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _wjProfitLabel.text = @"微金";
        [_wjProfitLabel sizeToFit];
    }
    return _wjProfitLabel;
}

- (NZLabel *)wjProfitContentLabel
{
    if (nil == _wjProfitContentLabel) {
        _wjProfitContentLabel = [NZLabel new];
        _wjProfitContentLabel.myCenterY = 0;
        _wjProfitContentLabel.myRight = 25;
        _wjProfitContentLabel.textAlignment = NSTextAlignmentRight;
        _wjProfitContentLabel.font = [Color gc_Font:14.0];
        _wjProfitContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _wjProfitContentLabel.text = @"  ";
        [_wjProfitContentLabel sizeToFit];
    }
    return _wjProfitContentLabel;
}

-(UIView *)wjProfitLinView
{
    if (nil == _wjProfitLinView) {
        _wjProfitLinView = [UIView new];
        _wjProfitLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _wjProfitLinView.myBottom = 0;
        _wjProfitLinView.myHeight = 0.5;
        _wjProfitLinView.myWidth = PGScreenWidth;
        _wjProfitLinView.myLeft = 18;
    }
    return _wjProfitLinView;
}

- (MyRelativeLayout *)zxProfitLayout
{
    if (nil == _zxProfitLayout){
        _zxProfitLayout = [MyRelativeLayout new];
        _zxProfitLayout.backgroundColor = [UIColor whiteColor];
        _zxProfitLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _zxProfitLayout.myWidth = PGScreenWidth;
        _zxProfitLayout.myHeight = 50;
        _zxProfitLayout.topPos.equalTo(self.wjProfitLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _zxProfitLayout;
}
- (UIView *)zxProfitRound
{
    if (nil == _zxProfitRound) {
        _zxProfitRound = [UIView new];
        _zxProfitRound.myLeft = 25;
        _zxProfitRound.myCenterY = 0;
        _zxProfitRound.myWidth = 7;
        _zxProfitRound.myHeight = 7;
        _zxProfitRound.backgroundColor = PNOrange;
        _zxProfitRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _zxProfitRound;
}

- (NZLabel *)zxProfitLabel
{
    if (nil == _zxProfitLabel) {
        _zxProfitLabel = [NZLabel new];
        _zxProfitLabel.myCenterY = 0;
        _zxProfitLabel.myLeft = LabelLeft;
        _zxProfitLabel.textAlignment = NSTextAlignmentLeft;
        _zxProfitLabel.font = [Color gc_Font:15.0];
        _zxProfitLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _zxProfitLabel.text = @"尊享";
        [_zxProfitLabel sizeToFit];
    }
    return _zxProfitLabel;
}

- (NZLabel *)zxProfitContentLabel
{
    if (nil == _zxProfitContentLabel) {
        _zxProfitContentLabel = [NZLabel new];
        _zxProfitContentLabel.myCenterY = 0;
        _zxProfitContentLabel.myRight = 25;
        _zxProfitContentLabel.textAlignment = NSTextAlignmentRight;
        _zxProfitContentLabel.font = [Color gc_Font:14.0];
        _zxProfitContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _zxProfitContentLabel.text = @"  ";
        [_zxProfitContentLabel sizeToFit];
    }
    return _zxProfitContentLabel;
}

-(UIView *)zxProfitLinView
{
    if (nil == _zxProfitLinView) {
        _zxProfitLinView = [UIView new];
        _zxProfitLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _zxProfitLinView.myBottom = 0;
        _zxProfitLinView.myHeight = 0.5;
        _zxProfitLinView.myWidth = PGScreenWidth;
        _zxProfitLinView.myLeft = 18;
    }
    return _zxProfitLinView;
}

- (MyRelativeLayout *)goldProfitLayout
{
    if (nil == _goldProfitLayout){
        _goldProfitLayout = [MyRelativeLayout new];
        _goldProfitLayout.backgroundColor = [UIColor whiteColor];
        _goldProfitLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _goldProfitLayout.myWidth = PGScreenWidth;
        _goldProfitLayout.myHeight = 50;
        _goldProfitLayout.topPos.equalTo(self.zxProfitLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _goldProfitLayout;
}
- (UIView *)goldProfitRound
{
    if (nil == _goldProfitRound) {
        _goldProfitRound = [UIView new];
        _goldProfitRound.myLeft = 25;
        _goldProfitRound.myCenterY = 0;
        _goldProfitRound.myWidth = 7;
        _goldProfitRound.myHeight = 7;
        _goldProfitRound.backgroundColor = PNYellow;
        _goldProfitRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _goldProfitRound;
}

- (NZLabel *)goldProfitLabel
{
    if (nil == _goldProfitLabel) {
        _goldProfitLabel = [NZLabel new];
        _goldProfitLabel.myCenterY = 0;
        _goldProfitLabel.myLeft = LabelLeft;
        _goldProfitLabel.textAlignment = NSTextAlignmentLeft;
        _goldProfitLabel.font = [Color gc_Font:15.0];
        _goldProfitLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _goldProfitLabel.text = @"黄金";
        [_goldProfitLabel sizeToFit];
    }
    return _goldProfitLabel;
}

- (NZLabel *)goldProfitContentLabel
{
    if (nil == _goldProfitContentLabel) {
        _goldProfitContentLabel = [NZLabel new];
        _goldProfitContentLabel.myCenterY = 0;
        _goldProfitContentLabel.myRight = 25;
        _goldProfitContentLabel.textAlignment = NSTextAlignmentRight;
        _goldProfitContentLabel.font = [Color gc_Font:14.0];
        _goldProfitContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _goldProfitContentLabel.text = @"  ";
        [_goldProfitContentLabel sizeToFit];
    }
    return _goldProfitContentLabel;
}

-(UIView *)goldProfitLinView
{
    if (nil == _goldProfitLinView) {
        _goldProfitLinView = [UIView new];
        _goldProfitLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _goldProfitLinView.myBottom = 0;
        _goldProfitLinView.myHeight = 0.5;
        _goldProfitLinView.myWidth = PGScreenWidth;
        _goldProfitLinView.myLeft = 18;
    }
    return _goldProfitLinView;
}

- (MyRelativeLayout *)couponProfitLayout
{
    if (nil == _couponProfitLayout){
        _couponProfitLayout = [MyRelativeLayout new];
        _couponProfitLayout.backgroundColor = [UIColor whiteColor];
        _couponProfitLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _couponProfitLayout.myWidth = PGScreenWidth;
        _couponProfitLayout.myHeight = 50;
        _couponProfitLayout.topPos.equalTo(self.goldProfitLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _couponProfitLayout;
}
- (UIView *)couponProfitRound
{
    if (nil == _couponProfitRound) {
        _couponProfitRound = [UIView new];
        _couponProfitRound.myLeft = 25;
        _couponProfitRound.myCenterY = 0;
        _couponProfitRound.myWidth = 7;
        _couponProfitRound.myHeight = 7;
        _couponProfitRound.backgroundColor = PNPinkRed;
        _couponProfitRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _couponProfitRound;
}

- (NZLabel *)couponProfitLabel
{
    if (nil == _couponProfitLabel) {
        _couponProfitLabel = [NZLabel new];
        _couponProfitLabel.myCenterY = 0;
        _couponProfitLabel.myLeft = LabelLeft;
        _couponProfitLabel.textAlignment = NSTextAlignmentLeft;
        _couponProfitLabel.font = [Color gc_Font:15.0];
        _couponProfitLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _couponProfitLabel.text = @"已用返现券";
        [_couponProfitLabel sizeToFit];
    }
    return _couponProfitLabel;
}

- (NZLabel *)couponProfitContentLabel
{
    if (nil == _couponProfitContentLabel) {
        _couponProfitContentLabel = [NZLabel new];
        _couponProfitContentLabel.myCenterY = 0;
        _couponProfitContentLabel.myRight = 25;
        _couponProfitContentLabel.textAlignment = NSTextAlignmentRight;
        _couponProfitContentLabel.font = [Color gc_Font:14.0];
        _couponProfitContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _couponProfitContentLabel.text = @"  ";
        [_couponProfitContentLabel sizeToFit];
    }
    return _couponProfitContentLabel;
}

-(UIView *)couponProfitLinView
{
    if (nil == _couponProfitLinView) {
        _couponProfitLinView = [UIView new];
        _couponProfitLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _couponProfitLinView.myBottom = 0;
        _couponProfitLinView.myHeight = 0.5;
        _couponProfitLinView.myWidth = PGScreenWidth;
        _couponProfitLinView.myLeft = 18;
    }
    return _couponProfitLinView;
}

- (MyRelativeLayout *)beanProfitLayout
{
    if (nil == _beanProfitLayout){
        _beanProfitLayout = [MyRelativeLayout new];
        _beanProfitLayout.backgroundColor = [UIColor whiteColor];
        _beanProfitLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _beanProfitLayout.myWidth = PGScreenWidth;
        _beanProfitLayout.myHeight = 50;
        _beanProfitLayout.topPos.equalTo(self.couponProfitLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _beanProfitLayout;
}
- (UIView *)beanProfitRound
{
    if (nil == _beanProfitRound) {
        _beanProfitRound = [UIView new];
        _beanProfitRound.myLeft = 25;
        _beanProfitRound.myCenterY = 0;
        _beanProfitRound.myWidth = 7;
        _beanProfitRound.myHeight = 7;
        _beanProfitRound.backgroundColor = PNLightBlue;
        _beanProfitRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _beanProfitRound;
}

- (NZLabel *)beanProfitLabel
{
    if (nil == _beanProfitLabel) {
        _beanProfitLabel = [NZLabel new];
        _beanProfitLabel.myCenterY = 0;
        _beanProfitLabel.myLeft = LabelLeft;
        _beanProfitLabel.textAlignment = NSTextAlignmentLeft;
        _beanProfitLabel.font = [Color gc_Font:15.0];
        _beanProfitLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _beanProfitLabel.text = @"已用工豆";
        [_beanProfitLabel sizeToFit];
    }
    return _beanProfitLabel;
}

- (NZLabel *)beanProfitContentLabel
{
    if (nil == _beanProfitContentLabel) {
        _beanProfitContentLabel = [NZLabel new];
        _beanProfitContentLabel.myCenterY = 0;
        _beanProfitContentLabel.myRight = 25;
        _beanProfitContentLabel.textAlignment = NSTextAlignmentRight;
        _beanProfitContentLabel.font = [Color gc_Font:14.0];
        _beanProfitContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _beanProfitContentLabel.text = @"  ";
        [_beanProfitContentLabel sizeToFit];
    }
    return _beanProfitContentLabel;
}

-(UIView *)beanProfitLinView
{
    if (nil == _beanProfitLinView) {
        _beanProfitLinView = [UIView new];
        _beanProfitLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _beanProfitLinView.myBottom = 0;
        _beanProfitLinView.myHeight = 0.5;
        _beanProfitLinView.myWidth = PGScreenWidth;
        _beanProfitLinView.myLeft = 18;
    }
    return _beanProfitLinView;
}

- (MyRelativeLayout *)balanceProfitLayout
{
    if (nil == _balanceProfitLayout){
        _balanceProfitLayout = [MyRelativeLayout new];
        _balanceProfitLayout.backgroundColor = [UIColor whiteColor];
        _balanceProfitLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _balanceProfitLayout.myWidth = PGScreenWidth;
        _balanceProfitLayout.myHeight = 50;
        _balanceProfitLayout.topPos.equalTo(self.beanProfitLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _balanceProfitLayout;
}
- (UIView *)balanceProfitRound
{
    if (nil == _balanceProfitRound) {
        _balanceProfitRound = [UIView new];
        _balanceProfitRound.myLeft = 25;
        _balanceProfitRound.myCenterY = 0;
        _balanceProfitRound.myWidth = 7;
        _balanceProfitRound.myHeight = 7;
        _balanceProfitRound.backgroundColor = PNLightGreen;
        _balanceProfitRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _balanceProfitRound;
}

- (NZLabel *)balanceProfitLabel
{
    if (nil == _balanceProfitLabel) {
        _balanceProfitLabel = [NZLabel new];
        _balanceProfitLabel.myCenterY = 0;
        _balanceProfitLabel.myLeft = LabelLeft;
        _balanceProfitLabel.textAlignment = NSTextAlignmentLeft;
        _balanceProfitLabel.font = [Color gc_Font:15.0];
        _balanceProfitLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _balanceProfitLabel.text = @"余额生息";
        [_balanceProfitLabel sizeToFit];
    }
    return _balanceProfitLabel;
}

- (NZLabel *)balanceProfitContentLabel
{
    if (nil == _balanceProfitContentLabel) {
        _balanceProfitContentLabel = [NZLabel new];
        _balanceProfitContentLabel.myCenterY = 0;
        _balanceProfitContentLabel.myRight = 25;
        _balanceProfitContentLabel.textAlignment = NSTextAlignmentRight;
        _balanceProfitContentLabel.font = [Color gc_Font:14.0];
        _balanceProfitContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _balanceProfitContentLabel.text = @"  ";
        [_balanceProfitContentLabel sizeToFit];
    }
    return _balanceProfitContentLabel;
}

-(UIView *)balanceProfitLinView
{
    if (nil == _balanceProfitLinView) {
        _balanceProfitLinView = [UIView new];
        _balanceProfitLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _balanceProfitLinView.myBottom = 0;
        _balanceProfitLinView.myHeight = 0.5;
        _balanceProfitLinView.myWidth = PGScreenWidth;
        _balanceProfitLinView.myLeft = 18;
    }
    return _balanceProfitLinView;
}
- (void)reloadAccountContent:(UCFAccountCenterAlreadyProfitModel *)model
{
    self.wjProfitContentLabel.text = [NSString stringWithFormat:@"¥%@",[NSString AddComma:model.data.wjProfit]];
    if ([model.data.zxProfit floatValue] == 0) {
        self.zxProfitContentLabel.myVisibility = MyVisibility_Gone;
    }
    else
    {
        self.zxProfitContentLabel.text =[NSString stringWithFormat:@"¥%@",[NSString AddComma:model.data.zxProfit]];
        self.zxProfitContentLabel.myVisibility = MyVisibility_Visible;
    }
    if ([model.data.goldProfit floatValue] == 0) {
         self.goldProfitContentLabel.myVisibility = MyVisibility_Gone;
    }
    else
    {
        self.goldProfitContentLabel.text = [NSString stringWithFormat:@"¥%@",[NSString AddComma:model.data.goldProfit]];
         self.goldProfitContentLabel.myVisibility = MyVisibility_Visible;
    }
    
    self.couponProfitContentLabel.text = [NSString stringWithFormat:@"¥%@",[NSString AddComma:model.data.couponProfit]];
    self.beanProfitContentLabel.text = [NSString stringWithFormat:@"¥%@",[NSString AddComma:model.data.beanProfit]];
    self.balanceProfitContentLabel.text = [NSString stringWithFormat:@"¥%@",[NSString AddComma:model.data.balanceProfit]];
    
    [self.wjProfitContentLabel sizeToFit];
    [self.zxProfitContentLabel sizeToFit];
    [self.goldProfitContentLabel sizeToFit];
    [self.couponProfitContentLabel sizeToFit];
    [self.beanProfitContentLabel sizeToFit];
    [self.balanceProfitContentLabel sizeToFit];
}
@end
