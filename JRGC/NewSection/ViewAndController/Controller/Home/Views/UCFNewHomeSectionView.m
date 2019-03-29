//
//  UCFNewHomeSectionView.m
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewHomeSectionView.h"
@interface UCFNewHomeSectionView()
@property(nonatomic, strong)UIImageView *arrowView;
@end
@implementation UCFNewHomeSectionView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
//        self.backgroundColor = [UIColor redColor];
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.myHeight = 18;
        iconView.myWidth = 3;
        iconView.leftPos.equalTo(@15);
        iconView.myBottom = 10;
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 2;
        [self.rootLayout addSubview:iconView];
        
        UILabel *label = [[UILabel alloc] init];
        label.leftPos.equalTo(iconView.rightPos).offset(8);
        label.myBottom = 10;
        label.text = @"新手专享";
        [self.rootLayout addSubview:label];
        [label sizeToFit];
        self.titleLab = label;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.rightPos.equalTo(@27);
        button.heightSize.equalTo(@40);
        button.centerYPos.equalTo(label.centerYPos);
        [button setTitleColor:[Color color:PGColorOptionTitleGray] forState:UIControlStateNormal];
        button.titleLabel.font = [Color gc_Font:13];
        [button setTitle:@"查看更多" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(checkMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.rootLayout addSubview:button];
        self.checkMoreBtn = button;
        button.hidden = YES;
        
        UIImageView *accessImageView = [[UIImageView alloc] init];
        accessImageView.mySize = CGSizeMake(7, 11);
        accessImageView.leftPos.equalTo(button.rightPos);
        accessImageView.centerYPos.equalTo(button.centerYPos);
        accessImageView.image = [UIImage imageNamed:@"list_icon_arrow"];
        [self.rootLayout addSubview:accessImageView];
        self.arrowView = accessImageView;
        accessImageView.hidden = YES;

    }
    return self;
}
- (void)showMore
{
    self.arrowView.hidden = NO;
    self.checkMoreBtn.hidden = NO;
}
- (void)checkMore:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMoreViewSection:andTitle:)]) {
        [self.delegate showMoreViewSection:_section andTitle:self.titleLab.text];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
