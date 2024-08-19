//
//  UCFBidInfoView.m
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBidInfoView.h"
#import "UILabel+Misc.h"
@interface UCFBidInfoView ()
@property(nonatomic, strong) UIView *topLine;
@property(nonatomic, strong) UILabel *rateLab;              //利率
@property(nonatomic, strong) UILabel *rateTipLab;           //利率提示标签
@property(nonatomic, strong) UILabel *timeLimitLab;         //期限
@property(nonatomic, strong) UILabel *timeLimitTipLab;      //期限提示标签
@property(nonatomic, strong) UILabel *moneyAmountLab;       //可投金额
@property(nonatomic, strong) UILabel *moneyAmountTipLab;    //可投金额
@property(nonatomic, strong) UIView  *bottomLineview;
@property(nonatomic, strong) MyRelativeLayout *centerView;
@end

@implementation UCFBidInfoView


- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.rateLab];
        [self addSubview:self.rateTipLab];
        [self addSubview:self.moneyAmountLab];
        [self addSubview:self.moneyAmountTipLab];
        [self addSubview:self.centerView];
        [self.centerView addSubview:self.timeLimitLab];
        [self.centerView addSubview:self.timeLimitTipLab];
    }
    return self;
}
- (void)blindBaseViewModel:(BaseViewModel *)viewModel
{
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"annualRate",@"timeLimitText",@"remainingMoney"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"annualRate"]) {
            selfWeak.rateLab.text =  [change objectSafeForKey:NSKeyValueChangeNewKey];
            [selfWeak.rateLab setFont:[Color gc_Font:16] string:@"%"];
            [selfWeak.rateLab sizeToFit];
        } else if ([keyPath isEqualToString:@"timeLimitText"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.timeLimitLab.text = markStr;
                if ([markStr containsString:@"天"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:14] string:@"天"];
                } else {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:14] string:@"个月"];
                }
                [selfWeak.timeLimitLab sizeToFit];
            }
        } else if ([keyPath isEqualToString:@"remainingMoney"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.moneyAmountLab.text = [change objectSafeForKey:NSKeyValueChangeNewKey];
            }
        }
    }];
}
- (void)showTransView:(UCFPureTransPageViewModel *)viewModel
{
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"annualRate",@"timeLimitText",@"remainingMoney"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"annualRate"]) {
            selfWeak.rateLab.text =  [change objectSafeForKey:NSKeyValueChangeNewKey];
            [selfWeak.rateLab setFont:[Color gc_Font:16] string:@"%"];
            [selfWeak.rateLab sizeToFit];
        } else if ([keyPath isEqualToString:@"timeLimitText"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.timeLimitLab.text = markStr;
                if ([markStr containsString:@"天"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:14] string:@"天"];
                } else {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:14] string:@"个月"];
                }
                [selfWeak.timeLimitLab sizeToFit];
            }
        } else if ([keyPath isEqualToString:@"remainingMoney"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.moneyAmountLab.text = [change objectSafeForKey:NSKeyValueChangeNewKey];
            }
        }
    }];
}
- (void)showView:(UCFBidViewModel *)viewModel
{
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"annualRate",@"timeLimitText",@"remainingMoney"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"annualRate"]) {
            selfWeak.rateLab.text =  [change objectSafeForKey:NSKeyValueChangeNewKey];
            [selfWeak.rateLab setFont:[Color gc_Font:16] string:@"%"];
            [selfWeak.rateLab sizeToFit];
        } else if ([keyPath isEqualToString:@"timeLimitText"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.timeLimitLab.text = markStr;
                if ([markStr containsString:@"天"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:14] string:@"天"];
                } else {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:14] string:@"个月"];
                }
                [selfWeak.timeLimitLab sizeToFit];
                
              
//                CGFloat leftX =selfWeak.rateTipLab.rightPos ;
//                CGFloat rigtX = CGRectGetMinX(selfWeak.moneyAmountTipLab.frame);
//                CGFloat width = CGRectGetWidth(selfWeak.timeLimitTipLab.frame);
//                CGFloat benginX = ((rigtX - leftX) - width)/2.0;
//                selfWeak.timeLimitTipLab.leftPos.equalTo(@(benginX));
//                selfWeak.timeLimitTipLab.centerYPos.equalTo(selfWeak.rateTipLab.centerYPos);
//
//                selfWeak.timeLimitLab.bottomPos.equalTo(selfWeak.timeLimitTipLab.topPos).offset(-3);
                
            }
        } else if ([keyPath isEqualToString:@"remainingMoney"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.moneyAmountLab.text = [change objectSafeForKey:NSKeyValueChangeNewKey];
                [selfWeak.moneyAmountLab sizeToFit];
            }
        }
    }];
    
}
- (void)bidLayoutSubViewsFrame
{
    self.bottomLineview.myHeight = 1;
    self.bottomLineview.myBottom = 0;
    self.bottomLineview.myHorzMargin = 0;

}
- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = UIColorWithRGB(0xeff0f3);

    }
    return _topLine;
}
- (UIView *)bottomLineview
{
    if (!_bottomLineview) {
        _bottomLineview = [[UIView alloc] init];
        _bottomLineview.backgroundColor = UIColorWithRGB(0xeff0f3);
    }
    return _bottomLineview;
}
- (UILabel *)rateLab
{
    if (!_rateLab) {
        _rateLab = [[UILabel alloc] init];
        _rateLab.textColor = UIColorWithRGB(0xfd4d4c);
        _rateLab.font = [Color gc_ANC_font:32.0f];
        _rateLab.text = @"0%";
        _rateLab.myLeading = 22;
        _rateLab.myTop = 5;
    }
    return _rateLab;
}
- (UILabel *)rateTipLab
{
    if (!_rateTipLab) {
        _rateTipLab = [[UILabel alloc] init];
        _rateTipLab.textColor = [Color color:PGColorOptionTitleGray];
        _rateTipLab.font = [UIFont systemFontOfSize:11.0f];
        _rateTipLab.text = @"预期年化利率";
        _rateTipLab.myLeading = 22;
        _rateTipLab.bottomPos.equalTo(@21);
        [_rateTipLab sizeToFit];
    }
    return _rateTipLab;
}
- (UILabel *)timeLimitLab
{
    if (!_timeLimitLab) {
        _timeLimitLab = [[UILabel alloc] init];
        _timeLimitLab.textColor = [Color color:PGColorOptionTitleBlack];
        _timeLimitLab.font = [Color gc_ANC_font:20.0f];
        _timeLimitLab.leftPos.equalTo(self.timeLimitTipLab.leftPos);
        _timeLimitLab.bottomPos.equalTo(self.timeLimitTipLab.topPos).offset(0);
//        _timeLimitLab.text = @"30天";
//        [_timeLimitLab sizeToFit];
    }
    return _timeLimitLab;
}
- (UILabel *)timeLimitTipLab
{
    if (!_timeLimitTipLab) {
        _timeLimitTipLab = [[UILabel alloc] init];
        _timeLimitTipLab.textColor = [Color color:PGColorOptionTitleGray];
        _timeLimitTipLab.font = [UIFont systemFontOfSize:11.0f];
        _timeLimitTipLab.text = @"出借期限";
        _timeLimitTipLab.centerXPos.equalTo(self.centerView.centerXPos);
        _timeLimitTipLab.bottomPos.equalTo(@21);
        [_timeLimitTipLab sizeToFit];
    }
    return _timeLimitTipLab;
}
- (UILabel *)moneyAmountLab
{
    if (!_moneyAmountLab) {
        _moneyAmountLab = [[UILabel alloc] init];
        _moneyAmountLab.textColor = [Color color:PGColorOptionTitleBlack];
        _moneyAmountLab.font = [Color gc_ANC_font:20.0f];
        _moneyAmountLab.text = @"¥1,000,000";
        _moneyAmountLab.rightPos.equalTo(@22);
        _moneyAmountLab.bottomPos.equalTo(self.rateLab.bottomPos).offset(3);
        [_moneyAmountLab sizeToFit];
    }
    return _moneyAmountLab;
}
- (UILabel *)moneyAmountTipLab
{
    if (!_moneyAmountTipLab) {
        _moneyAmountTipLab = [[UILabel alloc] init];
        _moneyAmountTipLab.textColor = [Color color:PGColorOptionTitleGray];
        _moneyAmountTipLab.font = [UIFont systemFontOfSize:11.0f];
        _moneyAmountTipLab.text = @"可投金额";
        _moneyAmountTipLab.leadingPos.equalTo(self.moneyAmountLab.leadingPos);
        _moneyAmountTipLab.bottomPos.equalTo(@21);
        [_moneyAmountTipLab sizeToFit];
    }
    return _moneyAmountTipLab;
}
- (MyRelativeLayout *)centerView
{
    if (!_centerView) {
        _centerView = [MyRelativeLayout new];
        _centerView.leftPos.equalTo(self.rateTipLab.rightPos);
        _centerView.rightPos.equalTo(self.moneyAmountTipLab.leftPos);
        _centerView.topPos.equalTo(@0);
        _centerView.bottomPos.equalTo(@0);
    }
    return _centerView;
}
@end
