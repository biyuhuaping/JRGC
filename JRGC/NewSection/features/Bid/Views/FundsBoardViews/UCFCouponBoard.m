//
//  UCFCouponBoard.m
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponBoard.h"

@interface UCFCouponBoard ()
@property(nonatomic, weak)UCFBidViewModel *myVM;
@property(nonatomic, strong) UILabel        *couponLab;
@property(nonatomic, strong) UILabel        *cashLab;

@property(nonatomic, strong) UIView         *coupleView;
@property(nonatomic, strong) UIView         *cashView;

@end

@implementation UCFCouponBoard

- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"headherIsHide",@"couponIsHide",@"cashIsHide",@"couponNum",@"repayCoupon",@"cashNum",@"repayCash"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"couponNum"]) {
            NSString *couponStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (couponStr.length > 0) {
                selfWeak.couponLab.text = couponStr;
                if ([couponStr containsString:@"张可用"]) {
                    NSString *tmpStr = [couponStr stringByReplacingOccurrencesOfString:@"张可用" withString:@""];
                 selfWeak.couponLab.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xfd4d4c) WithSectionText:tmpStr WithTotalString:couponStr];
                }
                [selfWeak.couponLab sizeToFit];
            }
        } else if ([keyPath isEqualToString:@"cashNum"]) {
            NSString *cashNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (cashNum.length > 0) {
                selfWeak.cashLab.text = cashNum;
                if ([cashNum containsString:@"张可用"]) {
                    NSString *tmpStr = [cashNum stringByReplacingOccurrencesOfString:@"张可用" withString:@""];
                    selfWeak.cashLab.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xfd4d4c) WithSectionText:tmpStr WithTotalString:cashNum];
                }
                [selfWeak.cashLab sizeToFit];
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
            } else {
                NSString *couponNum = selfWeak.myVM.couponNum;
                if (couponNum.length > 0) {
                    selfWeak.couponLab.text = couponNum;
                    if ([couponNum containsString:@"张可用"]) {
                        NSString *tmpStr = [couponNum stringByReplacingOccurrencesOfString:@"张可用" withString:@""];
                        selfWeak.couponLab.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xfd4d4c) WithSectionText:tmpStr WithTotalString:couponNum];
                    }
                    [selfWeak.couponLab sizeToFit];
                }
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
            } else {
                NSString *cashStr = selfWeak.myVM.cashNum;
                if (cashStr.length > 0) {
                    selfWeak.cashLab.text = cashStr;
                    if ([cashStr containsString:@"张可用"]) {
                        NSString *tmpStr = [cashStr stringByReplacingOccurrencesOfString:@"张可用" withString:@""];
                        selfWeak.cashLab.attributedText = [Common oneSectionOfLabelShowDifferentColor:UIColorWithRGB(0xfd4d4c) WithSectionText:tmpStr WithTotalString:cashStr];
                    }
                    [selfWeak.cashLab sizeToFit];
                }
            }
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
    view.myHeight = 37;
    view.myHorzMargin = 0;
    view.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self addSubview:view];
//    self.headView = view;
    
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
    self.cashView = cashCoupleView;
    
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
    cashCoupleView.myHeight = 44;
    cashCoupleView.myHorzMargin = 0;
    cashCoupleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cashCoupleView];
    self.coupleView = cashCoupleView;

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
