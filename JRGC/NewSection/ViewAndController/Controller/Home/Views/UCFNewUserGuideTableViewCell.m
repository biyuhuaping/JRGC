//
//  UCFNewUserGuideTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewUserGuideTableViewCell.h"

#import "UIButton+Gradient.h"
#import "UIButton+MLSpace.h"
@interface UCFNewUserGuideTableViewCell()
@property(nonatomic, strong)UIButton    *leftTopbutton;
@property(nonatomic, strong)UIButton    *rightTopbutton;
@property(nonatomic, strong)UIButton    *leftBottombutton;
@property(nonatomic, strong)UIButton    *rightBottombutton;

@end
@implementation UCFNewUserGuideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        MyRelativeLayout *whitBaseView = [MyRelativeLayout new];
        whitBaseView.leftPos.equalTo(@15);
        whitBaseView.rightPos.equalTo(@15);
        whitBaseView.topPos.equalTo(@0);
        whitBaseView.bottomPos.equalTo(@55);
        whitBaseView.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:whitBaseView];
      
        
        [self creatContentView:whitBaseView];
        [whitBaseView setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.layer.cornerRadius = 5.0f;
            v.clipsToBounds = YES;
        }];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.leftPos.equalTo(@45);
        button.rightPos.equalTo(@45);
        button.bottomPos.equalTo(@0);
        button.heightSize.equalTo(@40);
        [button setBackgroundColor:[UIColor blueColor]];
        button.clipsToBounds = YES;
        [self.rootLayout addSubview:button];
        [button setTitle:@"注册领优惠券" forState:UIControlStateNormal];
        button.titleLabel.font = [Color gc_Font:16];
        [button setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.layer.cornerRadius = CGRectGetHeight(v.frame)/2;
            NSArray *colorArray = [NSArray arrayWithObjects:UIColorWithRGB(0xFF4133),UIColorWithRGB(0xFF7F40), nil];
            UIImage *image = [(UIButton *)v buttonImageFromColors:colorArray ByGradientType:leftToRight];
            [(UIButton *)v setBackgroundImage:image forState:UIControlStateNormal];
        }];
    }
    return self;
}
- (void)creatContentView:(MyRelativeLayout *)superView
{
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
    hLine.heightSize.equalTo(@0.5);
    hLine.myHorzMargin = 0;
    hLine.centerYPos.equalTo(superView.centerYPos);
    [superView addSubview:hLine];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
    vLine.widthSize.equalTo(@0.5);
    vLine.myVertMargin = 0;
    vLine.centerXPos.equalTo(superView.centerXPos);
    [superView addSubview:vLine];
    
    
    self.leftTopbutton.heightSize.equalTo(@65);
    self.leftTopbutton.topPos.equalTo(@0);
    self.leftTopbutton.leftPos.equalTo(@0);
    [superView addSubview:self.leftTopbutton];
    
    self.leftTopbutton.titleLabel.font = [Color gc_Font:17];
    [self.leftTopbutton setTitleColor:UIColorWithRGB(0x000000) forState:UIControlStateNormal];
    [self.leftTopbutton setImage:[UIImage imageNamed:@"regist_coupon_icon"] forState:UIControlStateNormal];
    [self.leftTopbutton setTitle:@"注册领券" forState:UIControlStateNormal];
    [self.leftTopbutton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];


    
    self.rightTopbutton.heightSize.equalTo(@65);
    self.rightTopbutton.topPos.equalTo(@0);
    self.rightTopbutton.leftPos.equalTo(self.leftTopbutton.rightPos);
    [superView addSubview:self.rightTopbutton];
//    [self.rightTopbutton setBackgroundColor:[UIColor blueColor]];
    [self.rightTopbutton setImage:[UIImage imageNamed:@"hs_account_icon"] forState:UIControlStateNormal];
    [self.rightTopbutton setTitle:@"存管开户" forState:UIControlStateNormal];
    [self.rightTopbutton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    self.rightTopbutton.titleLabel.font = [Color gc_Font:17];
    [self.rightTopbutton setTitleColor:UIColorWithRGB(0x000000) forState:UIControlStateNormal];
    
    self.leftTopbutton.widthSize.equalTo(@[self.rightTopbutton.widthSize]);
    
    self.leftBottombutton.heightSize.equalTo(@65);
    self.leftBottombutton.topPos.equalTo(self.leftTopbutton.bottomPos);
    self.leftBottombutton.leftPos.equalTo(@0);
//    [self.leftBottombutton setBackgroundColor:[UIColor purpleColor]];
    [self.leftBottombutton setImage:[UIImage imageNamed:@"risk_test_icon"] forState:UIControlStateNormal];
    [self.leftBottombutton setTitle:@"风险评测" forState:UIControlStateNormal];
    [self.leftBottombutton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    self.leftBottombutton.titleLabel.font = [Color gc_Font:17];
    [self.leftBottombutton setTitleColor:UIColorWithRGB(0x000000) forState:UIControlStateNormal];
    [superView addSubview:self.leftBottombutton];

    
    self.rightBottombutton.heightSize.equalTo(@65);
    self.rightBottombutton.topPos.equalTo(self.leftTopbutton.bottomPos);
    self.rightBottombutton.leftPos.equalTo(self.leftBottombutton.rightPos);
    [self.rightBottombutton setImage:[UIImage imageNamed:@"new_user_icon"] forState:UIControlStateNormal];
    [self.rightBottombutton setTitle:@"新人专享" forState:UIControlStateNormal];
    [self.rightBottombutton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    self.rightBottombutton.titleLabel.font = [Color gc_Font:17];
    [self.rightBottombutton setTitleColor:UIColorWithRGB(0x000000) forState:UIControlStateNormal];
    [superView addSubview:self.rightBottombutton];
    self.rightBottombutton.widthSize.equalTo(@[self.leftBottombutton.widthSize]);

}

- (UIButton *)leftTopbutton
{
    if (!_leftTopbutton) {
        _leftTopbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftTopbutton.backgroundColor = [UIColor clearColor];
    }
    return _leftTopbutton;
}
- (UIButton *)rightTopbutton
{
    if (!_rightTopbutton) {
        _rightTopbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightTopbutton.backgroundColor = [UIColor clearColor];
    }
    return _rightTopbutton;
}
- (UIButton *)leftBottombutton
{
    if (!_leftBottombutton) {
        _leftBottombutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBottombutton.backgroundColor = [UIColor clearColor];
    }
    return _leftBottombutton;
}
- (UIButton *)rightBottombutton
{
    if (!_rightBottombutton) {
        _rightBottombutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBottombutton.backgroundColor = [UIColor clearColor];
    }
    return _rightBottombutton;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
