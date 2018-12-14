//
//  UCFCouponBoard.m
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponBoard.h"

@implementation UCFCouponBoard
- (void)addSubSectionViews
{
    [self addheadView];
    [self addCashCoupon];
    [self addRateCoupon];
}
- (void)addheadView
{
    UIView *view = [MyRelativeLayout new];
    view.myHeight = 37;
    view.myHorzMargin = 0;
    view.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self addSubview:view];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    topLineView.myTop = 0;
    topLineView.myHorzMargin = 0;
    topLineView.heightSize.equalTo(@0.5);
    [view addSubview:topLineView];
    
    UILabel  *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"使用优惠券";
    titleLab.textColor = UIColorWithRGB(0x333333);
    titleLab.backgroundColor =  [UIColor clearColor];
    [titleLab sizeToFit];
    titleLab.myLeft = 15;
    titleLab.centerYPos.equalTo(view.centerYPos);
    [view addSubview:titleLab];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xeff0f3);
    endLineView.myBottom = 0;
    endLineView.myLeft = 0;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [view addSubview:endLineView];
    
}
- (void)addCashCoupon
{
    UIView *cashCoupleView = [MyRelativeLayout new];
    cashCoupleView.myTop = 0;
    cashCoupleView.myHeight = 44;
    cashCoupleView.myHorzMargin = 0;
    cashCoupleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cashCoupleView];
    
    UILabel  *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"返现券";
    titleLab.textColor = UIColorWithRGB(0x555555);
    titleLab.backgroundColor =  [UIColor clearColor];
    [titleLab sizeToFit];
    titleLab.myLeft = 15;
    titleLab.centerYPos.equalTo(cashCoupleView.centerYPos);
    [cashCoupleView addSubview:titleLab];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
    arrowImageView.myWidth = 8;
    arrowImageView.myHeight = 13;
    arrowImageView.rightPos.equalTo(@15);
    arrowImageView.centerYPos.equalTo(cashCoupleView.centerYPos);
    [cashCoupleView addSubview:arrowImageView];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont systemFontOfSize:14.0f];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.adjustsFontSizeToFitWidth = YES;
    numLabel.text = @"返现¥10.00";
    numLabel.centerYPos.equalTo(arrowImageView.centerYPos);
    numLabel.textColor = UIColorWithRGB(0x555555);
    numLabel.backgroundColor =  [UIColor clearColor];
    [numLabel sizeToFit];
    numLabel.rightPos.equalTo(arrowImageView.leftPos).offset(10);
    [cashCoupleView addSubview:numLabel];

    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
//    endLineView.backgroundColor = [UIColor redColor];
    endLineView.myBottom = 0;
    endLineView.myLeft = 15;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [cashCoupleView addSubview:endLineView];
}
- (void)addRateCoupon
{
    UIView *cashCoupleView = [MyRelativeLayout new];
    cashCoupleView.myTop = 0;
    cashCoupleView.myHeight = 44;
    cashCoupleView.myHorzMargin = 0;
    cashCoupleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cashCoupleView];
    
    UILabel  *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"返息券";
    titleLab.textColor = UIColorWithRGB(0x555555);
    titleLab.backgroundColor =  [UIColor clearColor];
    [titleLab sizeToFit];
    titleLab.myLeft = 15;
    titleLab.centerYPos.equalTo(cashCoupleView.centerYPos);
    [cashCoupleView addSubview:titleLab];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
    arrowImageView.myWidth = 8;
    arrowImageView.myHeight = 13;
    arrowImageView.rightPos.equalTo(@15);
    arrowImageView.centerYPos.equalTo(cashCoupleView.centerYPos);
    [cashCoupleView addSubview:arrowImageView];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont systemFontOfSize:14.0f];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.adjustsFontSizeToFitWidth = YES;
    numLabel.text = @"返现¥10.00";
    numLabel.textColor = UIColorWithRGB(0x555555);
    numLabel.backgroundColor =  [UIColor clearColor];
    numLabel.rightPos.equalTo(arrowImageView.leftPos).offset(10);
    numLabel.centerYPos.equalTo(arrowImageView.centerYPos);
    [numLabel sizeToFit];
    numLabel.rightPos.equalTo(arrowImageView.leftPos);
    [cashCoupleView addSubview:numLabel];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myLeft = 0;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [cashCoupleView addSubview:endLineView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
