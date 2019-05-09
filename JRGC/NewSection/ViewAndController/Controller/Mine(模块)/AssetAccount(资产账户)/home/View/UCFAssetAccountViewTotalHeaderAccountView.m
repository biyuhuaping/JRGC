//
//  UCFAssetAccountViewTotalHeaderAccountView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAssetAccountViewTotalHeaderAccountView.h"
#import "NZLabel.h"
#import "UCFAccountCenterAssetsOverViewModel.h"
#define LabelLeft 11
#define LayoutWidth 70
@interface UCFAssetAccountViewTotalHeaderAccountView ()

@property (nonatomic, strong) MyRelativeLayout *wjLayout;// 微金

@property (nonatomic, strong) NZLabel     *wjTotalAssetsLabel;//微金

@property (nonatomic, strong) UIView      *wjTotalAssetsRound;

@property (nonatomic, strong) MyRelativeLayout *zxLayout;// 尊享

@property (nonatomic, strong) NZLabel     *zxTotalAssetsLabel;//尊享

@property (nonatomic, strong) UIView      *zxTotalAssetsRound;

@property (nonatomic, strong) MyRelativeLayout *goldLayout;// 黄金

@property (nonatomic, strong) NZLabel     *goldTotalAssetsLabel;//黄金

@property (nonatomic, strong) UIView      *goldTotalAssetsRound;

@end

@implementation UCFAssetAccountViewTotalHeaderAccountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootLayout.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:self.bottomLineView];
    }
    return self;
}
- (UIView *)bottomLineView
{
    if (nil == _bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _bottomLineView.myBottom = 0;
        _bottomLineView.myRight = 0;
        _bottomLineView.myLeft = 0;
        _bottomLineView.myHeight = 0.5;
        _bottomLineView.myVisibility = MyVisibility_Invisible;
    }
    return _bottomLineView;
}
- (MyRelativeLayout *)wjLayout
{
    if (nil == _wjLayout){
        _wjLayout = [MyRelativeLayout new];
        _wjLayout.backgroundColor = [UIColor clearColor];
        _wjLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _wjLayout.myWidth = LayoutWidth;
        _wjLayout.heightSize.equalTo(self.rootLayout.heightSize);
        _wjLayout.topPos.equalTo(self.rootLayout.topPos);
//        _wjLayout.myCenterX = - 70;
    }
    return _wjLayout;
}

- (UIView *)wjTotalAssetsRound
{
    if (nil == _wjTotalAssetsRound) {
        _wjTotalAssetsRound = [UIView new];
        _wjTotalAssetsRound.myLeft = 0;
        _wjTotalAssetsRound.myCenterY = 0;
        _wjTotalAssetsRound.myWidth = 7;
        _wjTotalAssetsRound.myHeight = 7;
        _wjTotalAssetsRound.backgroundColor = PNBlue;
        _wjTotalAssetsRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _wjTotalAssetsRound;
}
- (NZLabel *)wjTotalAssetsLabel
{
    if (nil == _wjTotalAssetsLabel) {
        _wjTotalAssetsLabel = [NZLabel new];
        _wjTotalAssetsLabel.myCenterY = 0;
        _wjTotalAssetsLabel.myLeft = LabelLeft;
        _wjTotalAssetsLabel.textAlignment = NSTextAlignmentLeft;
        _wjTotalAssetsLabel.font = [Color gc_Font:14.0];
        _wjTotalAssetsLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _wjTotalAssetsLabel.text = @"微金账户";
        [_wjTotalAssetsLabel sizeToFit];
    }
    return _wjTotalAssetsLabel;
}


- (MyRelativeLayout *)zxLayout
{
    if (nil == _zxLayout){
        _zxLayout = [MyRelativeLayout new];
        _zxLayout.backgroundColor = [UIColor clearColor];
        _zxLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _zxLayout.myWidth = LayoutWidth;
        _zxLayout.heightSize.equalTo(self.rootLayout.heightSize);
        _zxLayout.topPos.equalTo(self.rootLayout.topPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _zxLayout;
}

- (UIView *)zxTotalAssetsRound
{
    if (nil == _zxTotalAssetsRound) {
        _zxTotalAssetsRound = [UIView new];
        _zxTotalAssetsRound.myLeft = 0;
        _zxTotalAssetsRound.myCenterY = 0;
        _zxTotalAssetsRound.myWidth = 7;
        _zxTotalAssetsRound.myHeight = 7;
        _zxTotalAssetsRound.backgroundColor = PNOrange;
        _zxTotalAssetsRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _zxTotalAssetsRound;
}
- (NZLabel *)zxTotalAssetsLabel
{
    if (nil == _zxTotalAssetsLabel) {
        _zxTotalAssetsLabel = [NZLabel new];
        _zxTotalAssetsLabel.myCenterY = 0;
        _zxTotalAssetsLabel.myLeft = LabelLeft;
        _zxTotalAssetsLabel.textAlignment = NSTextAlignmentLeft;
        _zxTotalAssetsLabel.font = [Color gc_Font:14.0];
        _zxTotalAssetsLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _zxTotalAssetsLabel.text = @"尊享账户";
        [_zxTotalAssetsLabel sizeToFit];
    }
    return _zxTotalAssetsLabel;
}


- (MyRelativeLayout *)goldLayout
{
    if (nil == _goldLayout){
        _goldLayout = [MyRelativeLayout new];
        _goldLayout.backgroundColor = [UIColor clearColor];
        _goldLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _goldLayout.myWidth = LayoutWidth;
        _goldLayout.heightSize.equalTo(self.rootLayout.heightSize);
        _goldLayout.topPos.equalTo(self.rootLayout.topPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _goldLayout;
}

- (UIView *)goldTotalAssetsRound
{
    if (nil == _goldTotalAssetsRound) {
        _goldTotalAssetsRound = [UIView new];
        _goldTotalAssetsRound.myLeft = 0;
        _goldTotalAssetsRound.myCenterY = 0;
        _goldTotalAssetsRound.myWidth = 7;
        _goldTotalAssetsRound.myHeight = 7;
        _goldTotalAssetsRound.backgroundColor = PNYellow;
        _goldTotalAssetsRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _goldTotalAssetsRound;
}
- (NZLabel *)goldTotalAssetsLabel
{
    if (nil == _goldTotalAssetsLabel) {
        _goldTotalAssetsLabel = [NZLabel new];
        _goldTotalAssetsLabel.myCenterY = 0;
        _goldTotalAssetsLabel.myLeft = LabelLeft;
        _goldTotalAssetsLabel.textAlignment = NSTextAlignmentLeft;
        _goldTotalAssetsLabel.font = [Color gc_Font:14.0];
        _goldTotalAssetsLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _goldTotalAssetsLabel.text = @"黄金账户";
        [_goldTotalAssetsLabel sizeToFit];
    }
    return _goldTotalAssetsLabel;
}

- (void)reloadAccountLayout:(UCFAccountCenterAssetsOverViewModel *)model
{
    if (nil == model || !model.ret) {
        return;
    }
    else{
        [self.rootLayout addSubview:self.wjLayout];
        [self.wjLayout addSubview:self.wjTotalAssetsLabel];
        [self.wjLayout addSubview:self.wjTotalAssetsRound];
    
        [self.rootLayout addSubview:self.zxLayout];
        [self.zxLayout addSubview:self.zxTotalAssetsLabel];
        [self.zxLayout addSubview:self.zxTotalAssetsRound];
        
        if (model.data.assetList.count == 2)
        {
            self.wjLayout.myCenterX = - 70;
            self.zxLayout.myCenterX = 70;
        }
        else if (model.data.assetList.count == 3){
            
            [self.rootLayout addSubview:self.goldLayout];
            [self.goldLayout addSubview:self.goldTotalAssetsLabel];
            [self.goldLayout addSubview:self.goldTotalAssetsRound];
            
            self.goldLayout.myRight = 50;
            self.wjLayout.myLeft = 50;
            self.zxLayout.myCenterX = 0;
            
        }
    }
}

@end
