//
//  UCFBidInfoView.m
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBidInfoView.h"

@interface UCFBidInfoView ()
@property(nonatomic, strong) UIView *topLine;
@property(nonatomic, strong) UILabel *rateLab;              //利率
@property(nonatomic, strong) UILabel *rateTipLab;           //利率提示标签
@property(nonatomic, strong) UILabel *timeLimitLab;         //期限
@property(nonatomic, strong) UILabel *timeLimitTipLab;      //期限提示标签
@property(nonatomic, strong) UILabel *moneyAmountLab;       //可投金额
@property(nonatomic, strong) UILabel *moneyAmountTipLab;    //可投金额
@property(nonatomic, strong) UIView  *bottomLineview;
@end

@implementation UCFBidInfoView


- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.topLine];
        [self addSubview:self.rateLab];
        [self addSubview:self.rateTipLab];
        [self addSubview:self.timeLimitLab];
        [self addSubview:self.timeLimitTipLab];
        [self addSubview:self.moneyAmountLab];
        [self addSubview:self.moneyAmountTipLab];
        [self addSubview:self.bottomLineview];
    }
    return self;
}
- (void)showView:(UCFBidViewModel *)viewModel
{
    [self.KVOController observe:viewModel keyPaths:@[@"annualRate",@"timeLimitText",@"remainingMoney"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"annualRate"]) {
            _rateLab.text =  [change objectSafeForKey:NSKeyValueChangeNewKey];
        } else if ([keyPath isEqualToString:@"timeLimitText"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                _timeLimitLab.text = [change objectSafeForKey:NSKeyValueChangeNewKey];
            }
        } else if ([keyPath isEqualToString:@"remainingMoney"]) {
            NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                _moneyAmountLab.text = [change objectSafeForKey:NSKeyValueChangeNewKey];
            }
        }
    }];
    
}
- (void)bidLayoutSubViewsFrame
{
    self.topLine.myHeight = 1;
    self.topLine.myTop = 0;
    self.topLine.myHorzMargin = 0;
    
    self.rateLab.myLeading = 15;
    self.rateLab.myTop = 10;
    self.rateLab.myHeight = 20;
    
    self.timeLimitLab.leadingPos.equalTo(self.rateLab.trailingPos);
    self.timeLimitLab.myHeight = 15;
    self.timeLimitLab.bottomPos.equalTo(self.rateLab.bottomPos);
    
    self.moneyAmountLab.leadingPos.equalTo(self.timeLimitLab.trailingPos);
    self.moneyAmountLab.right = 15;
    self.moneyAmountLab.bottomPos.equalTo(self.rateLab.bottomPos);
    
    self.rateLab.widthSize.equalTo(@[self.timeLimitLab.widthSize, self.moneyAmountLab.widthSize]).add(-30);
        
    self.rateTipLab.myLeading = 15;
    self.rateTipLab.topPos.equalTo(self.rateLab.bottomPos).offset(8);
    self.rateTipLab.myHeight = 15;
    
    self.timeLimitTipLab.leadingPos.equalTo(self.rateTipLab.trailingPos);
    self.timeLimitTipLab.myHeight = 15;
    self.timeLimitTipLab.bottomPos.equalTo(self.rateTipLab.bottomPos);
    
    self.moneyAmountTipLab.leadingPos.equalTo(self.timeLimitTipLab.trailingPos);
    self.moneyAmountTipLab.right = 15;
    self.moneyAmountTipLab.bottomPos.equalTo(self.rateTipLab.bottomPos);
    
    self.rateTipLab.widthSize.equalTo(@[self.timeLimitTipLab.widthSize, self.moneyAmountTipLab.widthSize]).add(-30);
    
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
        _rateLab.font = [UIFont boldSystemFontOfSize:16.0f];
        _rateLab.text = @"0%";
        [_rateLab sizeToFit];
    }
    return _rateLab;
}
- (UILabel *)rateTipLab
{
    if (!_rateTipLab) {
        _rateTipLab = [[UILabel alloc] init];
        _rateTipLab.textColor = UIColorWithRGB(0x777777);
        _rateTipLab.font = [UIFont systemFontOfSize:12.0f];
        _rateTipLab.text = @"可预期年化率";
        [_rateTipLab sizeToFit];
    }
    return _rateTipLab;
}
- (UILabel *)timeLimitLab
{
    if (!_timeLimitLab) {
        _timeLimitLab = [[UILabel alloc] init];
        _timeLimitLab.textColor = UIColorWithRGB(0x333333);
        _timeLimitLab.font = [UIFont systemFontOfSize:12.0f];
        _timeLimitLab.text = @"30天";
        [_timeLimitLab sizeToFit];
    }
    return _timeLimitLab;
}
- (UILabel *)timeLimitTipLab
{
    if (!_timeLimitTipLab) {
        _timeLimitTipLab = [[UILabel alloc] init];
        _timeLimitTipLab.textColor = UIColorWithRGB(0x777777);
        _timeLimitTipLab.font = [UIFont systemFontOfSize:12.0f];
        _timeLimitTipLab.text = @"出借期限";
        [_timeLimitTipLab sizeToFit];
    }
    return _timeLimitTipLab;
}
- (UILabel *)moneyAmountLab
{
    if (!_moneyAmountLab) {
        _moneyAmountLab = [[UILabel alloc] init];
        _moneyAmountLab.textColor = UIColorWithRGB(0x333333);
        _moneyAmountLab.font = [UIFont systemFontOfSize:12.0f];
        _moneyAmountLab.text = @"¥1,000,000";
        [_moneyAmountLab sizeToFit];
    }
    return _moneyAmountLab;
}
- (UILabel *)moneyAmountTipLab
{
    if (!_moneyAmountTipLab) {
        _moneyAmountTipLab = [[UILabel alloc] init];
        _moneyAmountTipLab.textColor = UIColorWithRGB(0x777777);
        _moneyAmountTipLab.font = [UIFont systemFontOfSize:12.0f];
        _moneyAmountTipLab.text = @"可投金额";
        [_moneyAmountTipLab sizeToFit];
    }
    return _moneyAmountTipLab;
}
@end
