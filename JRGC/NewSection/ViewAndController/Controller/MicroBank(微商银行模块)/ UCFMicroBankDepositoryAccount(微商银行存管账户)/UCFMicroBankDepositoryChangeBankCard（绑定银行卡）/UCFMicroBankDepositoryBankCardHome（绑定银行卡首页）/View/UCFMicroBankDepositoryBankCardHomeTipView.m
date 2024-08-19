//
//  UCFMicroBankDepositoryBankCardHomeTipView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/5/6.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryBankCardHomeTipView.h"
@interface UCFMicroBankDepositoryBankCardHomeTipView ()

@property (nonatomic, strong) UIImageView *itemImageView;//图片

@property (nonatomic, strong) UIImageView *itemArrawImageView;//图片

@end
@implementation UCFMicroBankDepositoryBankCardHomeTipView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
//        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
        layer.endPoint = CGPointMake(1, 0);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
        layer.colors = [NSArray arrayWithObjects:(id)[Color color:PGColorOptionTitlerRead].CGColor,(id)[Color color:PGColorOpttonGradientBackgroundColor].CGColor, nil];
        layer.locations = @[@0.0f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
        layer.frame = CGRectMake(0, 0, PGScreenWidth, 50);
        [self.rootLayout.layer insertSublayer:layer atIndex:0];
        
        [self.rootLayout addSubview:self.itemImageView];
        [self.rootLayout addSubview:self.itemTitleLabel];
        [self.rootLayout addSubview:self.itemArrawImageView];
    }
    return self;
}
- (UIImageView *)itemImageView
{
    if (nil == _itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        _itemImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _itemImageView.myLeft = 25;
        _itemImageView.myWidth = 25;
        _itemImageView.myHeight = 25;
        _itemImageView.image = [UIImage imageNamed:@"icon_prompt_white"];
        
    }
    return _itemImageView;
}
- (NZLabel *)itemTitleLabel
{
    if (nil == _itemTitleLabel) {
        _itemTitleLabel = [NZLabel new];
        _itemTitleLabel.centerYPos.equalTo(self.itemImageView.centerYPos);
        _itemTitleLabel.leftPos.equalTo(self.itemImageView.rightPos).offset(10);
        _itemTitleLabel.rightPos.equalTo(self.itemArrawImageView.leftPos).offset(10);
        _itemTitleLabel.adjustsFontSizeToFitWidth = YES;
        _itemTitleLabel.textAlignment = NSTextAlignmentLeft;
        _itemTitleLabel.font = [Color gc_Font:15.0];
        _itemTitleLabel.textColor = [Color color:PGColorOptionThemeWhite];
        
    }
    return _itemTitleLabel;
}

- (UIImageView *)itemArrawImageView
{
    if (nil == _itemArrawImageView) {
        _itemArrawImageView = [[UIImageView alloc] init];
        _itemArrawImageView.centerYPos.equalTo(self.itemImageView.centerYPos);
        _itemArrawImageView.myRight = 25;
        _itemArrawImageView.myWidth = 8;
        _itemArrawImageView.myHeight = 13;
        _itemArrawImageView.image = [UIImage imageNamed:@"arrow_right_white.png"];
    }
    return _itemArrawImageView;
}




@end
