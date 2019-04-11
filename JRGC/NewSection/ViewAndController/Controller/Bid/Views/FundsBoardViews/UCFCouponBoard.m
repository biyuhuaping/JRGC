//
//  UCFCouponBoard.m
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponBoard.h"
#import "UIImage+Compression.h"
@interface UCFCouponBoard ()
@property(nonatomic, weak)UCFBidViewModel *myVM;
@property(nonatomic, strong) UILabel        *couponLab;
@property(nonatomic, strong) UILabel        *cashLab;

@property(nonatomic, strong) UIButton        *couponBtn;
@property(nonatomic, strong) UIButton        *cashBtn;


@property(nonatomic, strong) UIView         *coupleView;
@property(nonatomic, strong) UIView         *cashView;

@end

@implementation UCFCouponBoard

- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"headherIsHide",@"couponIsHide",@"cashIsHide",@"couponNum",@"repayCoupon",@"cashNum",@"repayCash",@"availableCouponNum",@"availableCashNum"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"couponNum"]) {
            NSString *couponStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (couponStr.length > 0) {
                [selfWeak.couponBtn setTitle:couponStr forState:UIControlStateNormal];
            }
        } else if ([keyPath isEqualToString:@"cashNum"]) {
            NSString *cashNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (cashNum.length > 0) {
                [selfWeak.cashBtn setTitle:cashNum forState:UIControlStateNormal];
            }
        } else if ([keyPath isEqualToString:@"couponIsHide"]) {
            BOOL ishide = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (ishide) {
                selfWeak.coupleView.myVisibility = MyVisibility_Gone;
            } else {
                selfWeak.coupleView.myVisibility = MyVisibility_Visible;

            }
        } else if ([keyPath isEqualToString:@"cashIsHide"]) {
            BOOL ishide = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (ishide) {
                selfWeak.cashView.myVisibility = MyVisibility_Gone;
            } else {
                selfWeak.cashView.myVisibility = MyVisibility_Visible;
            }

        } else if ([keyPath isEqualToString:@"headherIsHide"]) {
            BOOL ishide = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (ishide) {
                selfWeak.myVisibility = MyVisibility_Gone;
            } else {
                selfWeak.myVisibility = MyVisibility_Visible;
            }
        } else if ([keyPath isEqualToString:@"repayCoupon"]) {
            //返息券返的金额
            NSString *repayCoupon = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if ([repayCoupon doubleValue] > 0.01) {
                NSString *repayCoupon = [change objectSafeForKey:NSKeyValueChangeNewKey];
                NSString *repayCouponStr = [NSString stringWithFormat:@"¥%@",repayCoupon];
                NSString *allText = [NSString stringWithFormat:@"返息%@工豆，满¥%@可用",repayCouponStr,selfWeak.myVM.couponTotalcouponAmount];
                selfWeak.couponLab.text = allText;
                selfWeak.couponLab.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xfd4d4c) WithSectionText:repayCouponStr WithTotalString:allText];
                
                [selfWeak.couponLab sizeToFit];
                selfWeak.couponBtn.myVisibility = MyVisibility_Gone;

            } else {
                
            }
        } else if ([keyPath isEqualToString:@"repayCash"]) {
            //返现券返的金额
            NSString *repayCash = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if ([repayCash doubleValue] > 0.01) {
                NSString *cashStr = [NSString stringWithFormat:@"¥%@",repayCash];
                NSString *allText = [NSString stringWithFormat:@"返现%@，满¥%@可用",cashStr,selfWeak.myVM.cashTotalcouponAmount];
                selfWeak.cashLab.text = allText;
                selfWeak.cashLab.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xfd4d4c) WithSectionText:cashStr WithTotalString:allText];
                [selfWeak.cashLab sizeToFit];
                selfWeak.cashBtn.myVisibility = MyVisibility_Gone;

            } else {

            }
        } else if ([keyPath isEqualToString:@"availableCouponNum"]) {
            NSString *availableCouponNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (availableCouponNum.length > 0) {
                selfWeak.couponLab.text = availableCouponNum;
            } else {
                selfWeak.couponLab.text = @"0张可用";
            }
            selfWeak.couponBtn.myVisibility = MyVisibility_Visible;
            [selfWeak.couponLab sizeToFit];


        } else if ([keyPath isEqualToString:@"availableCashNum"]) {
            NSString *availableCashNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (availableCashNum.length > 0) {
                selfWeak.cashLab.text = availableCashNum;
            } else {
                selfWeak.cashLab.text = @"0张可用";
            }
            selfWeak.cashBtn.myVisibility = MyVisibility_Visible;
            [selfWeak.cashLab sizeToFit];

        }
    }];
    

}

- (void)addSubSectionViews
{
    [self addheadView];
    [self addCashCoupon];
    [self addRateCoupon];
}
- (void)pushSelectPayBack:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponBoard:SelectPayBackButtonClick:)]) {
        [self.delegate couponBoard:self SelectPayBackButtonClick:button];
    }
}
- (void)addheadView
{
    UIView *view = [MyRelativeLayout new];
    view.myHeight = 50;
    view.myHorzMargin = 0;
    view.backgroundColor = [Color color:PGColorOptionThemeWhite];
    [self addSubview:view];
//    self.headView = view;
    
//    UIView *topLineView = [[UIView alloc] init];
//    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    topLineView.myTop = 0;
//    topLineView.myHorzMargin = 0;
//    topLineView.heightSize.equalTo(@0.5);
//    [view addSubview:topLineView];
    
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = UIColorWithRGB(0xFF4133);
    iconView.clipsToBounds = YES;
    iconView.layer.cornerRadius = 2;
    [view addSubview:iconView];
    
    iconView.myHeight = 16;
    iconView.myWidth = 3;
    iconView.leftPos.equalTo(@15);
    iconView.centerYPos.equalTo(view.centerYPos);
    
    UILabel  *titleLab = [UILabel new];
    titleLab.font = [Color gc_Font:16.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"使用优惠券";
    titleLab.textColor = [Color color:PGColorOptionTitleBlack];
    titleLab.backgroundColor =  [UIColor clearColor];
    [titleLab sizeToFit];
    titleLab.leftPos.equalTo(iconView.rightPos).offset(5);
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
    cashCoupleView.myHeight = 50;
    cashCoupleView.myHorzMargin = 0;
    cashCoupleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cashCoupleView];
    self.cashView = cashCoupleView;
    
    UILabel  *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:16.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"返现券";
    titleLab.textColor = [Color color:PGColorOptionTitleBlack];
    titleLab.backgroundColor =  [UIColor clearColor];
    [titleLab sizeToFit];
    titleLab.myLeft = 15;
    titleLab.centerYPos.equalTo(cashCoupleView.centerYPos);
    [cashCoupleView addSubview:titleLab];
    
    UIButton *totalCashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalCashBtn.leftPos.equalTo(titleLab.rightPos).offset(10);
    totalCashBtn.heightSize.equalTo(@22);
    totalCashBtn.widthSize.equalTo(@40);
    totalCashBtn.titleLabel.font = [Color gc_Font:13];
    UIImage *image = [UIImage gc_styleImageSize:CGSizeMake(40, 22)];
    [totalCashBtn setBackgroundImage:image forState:UIControlStateNormal];
    totalCashBtn.centerYPos.equalTo(titleLab.centerYPos);
    totalCashBtn.clipsToBounds = YES;
    totalCashBtn.layer.cornerRadius = 11;
    [cashCoupleView addSubview:totalCashBtn];
    self.cashBtn = totalCashBtn;
    
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
    self.cashLab = numLabel;
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    endLineView.myBottom = 0;
    endLineView.myLeft = 15;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [cashCoupleView addSubview:endLineView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.myTop = 0;
    button.myLeading = 0;
    button.myTrailing = 0;
    button.myBottom = 0;
    button.tag = 100;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(pushSelectPayBack:) forControlEvents:UIControlEventTouchUpInside];
    [cashCoupleView addSubview:button];
}
- (void)addRateCoupon
{
    UIView *cashCoupleView = [MyRelativeLayout new];
    cashCoupleView.myTop = 0;
    cashCoupleView.myHeight = 50;
    cashCoupleView.myHorzMargin = 0;
    cashCoupleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cashCoupleView];
    self.coupleView = cashCoupleView;

    UILabel  *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:16.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"返息券";
    titleLab.textColor = [Color color:PGColorOptionTitleBlack];
    titleLab.backgroundColor =  [UIColor clearColor];
    [titleLab sizeToFit];
    titleLab.myLeft = 15;
    titleLab.centerYPos.equalTo(cashCoupleView.centerYPos);
    [cashCoupleView addSubview:titleLab];
    
    UIButton *totalCashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalCashBtn.leftPos.equalTo(titleLab.rightPos).offset(10);
    totalCashBtn.heightSize.equalTo(@22);
    totalCashBtn.widthSize.equalTo(@40);
    totalCashBtn.clipsToBounds = YES;
    totalCashBtn.layer.cornerRadius = 11;
    totalCashBtn.titleLabel.font = [Color gc_Font:13];
    UIImage *image = [UIImage gc_styleImageSize:CGSizeMake(40, 22)];
    [totalCashBtn setBackgroundImage:image forState:UIControlStateNormal];
    totalCashBtn.centerYPos.equalTo(titleLab.centerYPos);
    [cashCoupleView addSubview:totalCashBtn];
    self.couponBtn = totalCashBtn;
    
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
    self.couponLab = numLabel;
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myLeft = 0;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [cashCoupleView addSubview:endLineView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.myTop = 0;
    button.myLeading = 0;
    button.myTrailing = 0;
    button.myBottom = 0;
    button.tag = 101;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(pushSelectPayBack:) forControlEvents:UIControlEventTouchUpInside];
    [cashCoupleView addSubview:button];
}


@end
