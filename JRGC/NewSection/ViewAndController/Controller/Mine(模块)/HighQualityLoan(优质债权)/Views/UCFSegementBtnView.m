//
//  UCFSegementBtnView.m
//  JRGC
//
//  Created by zrc on 2019/3/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFSegementBtnView.h"
#import "UIImage+Compression.h"
@interface UCFSegementBtnView()
{
    CGFloat preViewX;
    UIButton *preSelectBtn;
}
@property(nonatomic, strong)UIImage *normalImage;
@property(nonatomic, strong)UIImage *selectImage;
@end

@implementation UCFSegementBtnView

- (instancetype)initWithTitleArray:(NSArray *)titleArr delegate:(id<UCFSegementBtnViewDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        for (int i = 0; i < titleArr.count; i++) {
            preViewX = 15 + (80 + 15) * i;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[Color color:PGColorOptionTitleGray] forState:UIControlStateNormal];
            [button setTitleColor:[Color color:PGColorOpttonRateNoramlTextColor] forState:UIControlStateSelected];
            [button setBackgroundImage:self.normalImage forState:UIControlStateNormal];
            [button setBackgroundImage:self.selectImage forState:UIControlStateSelected];
            button.leftPos.equalTo(@(preViewX));
            button.mySize = CGSizeMake(80, 27);
            button.tag = 100 + i;
            button.centerYPos.equalTo(self.centerYPos);
            [self addSubview:button];
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

            button.titleLabel.font = [Color gc_Font:14];
            if (i == 0) {
                [self click:button];
            }
        }
        
    }
    return self;
}
- (void)click:(UIButton *)button
{
    if (preSelectBtn == button) {
        return;
    }
    
    for (UIButton *btn in self.subviews) {
        btn.selected = NO;

    }
    
    button.selected = YES;
    preSelectBtn = button;
    if (self.delegate) {
        [self.delegate segementBtnView:self selectIndex:button.tag - 100];
    }
}
- (UIImage *)normalImage
{
    if (!_normalImage) {
        _normalImage = [UIImage  imageWithUIView:[self drawNormalImage]];
    }
    return _normalImage;
}
- (UIImage *)selectImage
{
    if (!_selectImage) {
        _selectImage = [UIImage  imageWithUIView:[self drawSelectImage]];
    }
    return _selectImage;
}
- (UIView *)drawNormalImage
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 27)];
    view.backgroundColor = [Color color:PGColorOptionThemeWhite];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 13.5;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [Color color:PGColorOptionTitleGray].CGColor;
    view.layer.contentsScale = [[UIScreen mainScreen] scale];
    return view;
}
- (UIView *)drawSelectImage
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 27)];
    view.backgroundColor = [Color color:PGColorOptionThemeWhite];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 13.5;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [Color color:PGColorOpttonRateNoramlTextColor].CGColor;
    view.layer.contentsScale = [[UIScreen mainScreen] scale];
    return view;
}
@end
