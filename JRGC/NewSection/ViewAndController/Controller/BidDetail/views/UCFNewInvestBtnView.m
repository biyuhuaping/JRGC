//
//  UCFNewInvestBtnView.m
//  JRGC
//
//  Created by zrc on 2019/1/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewInvestBtnView.h"
#import "NSObject+Compression.h"
@interface UCFNewInvestBtnView()
@property(nonatomic, strong)UIButton    *investButtom;
@property(nonatomic, strong)BaseViewModel   *vm;
@end


@implementation UCFNewInvestBtnView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.leftPos.equalTo(@0);
        button.topPos.equalTo(@0);
        button.widthSize.equalTo(@(frame.size.width));
        button.heightSize.equalTo(@(frame.size.height));
        [button setBackgroundImage:[UIImage gc_styleImageSize:frame.size] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.investButtom = button;

        [self.rootLayout addSubview:button];

    }
    return self;
}
- (void)blindVM:(UVFBidDetailViewModel *)vm
{
    self.vm = vm;
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"bidInvestText"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"bidInvestText"]) {
            NSString *bidInvestText = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (bidInvestText.length > 0) {
                [selfWeak.investButtom setTitle:bidInvestText forState:UIControlStateNormal];
            }
        }
    }];
}
- (void)blindTransVM:(UCFTransBidDetailViewModel *)vm
{
    self.vm = vm;
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"bidInvestText"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"bidInvestText"]) {
            NSString *bidInvestText = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (bidInvestText.length > 0) {
                [selfWeak.investButtom setTitle:bidInvestText forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)click:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    if ([self.vm isKindOfClass:[UVFBidDetailViewModel class]]) {
        [(UVFBidDetailViewModel *)self.vm dealClickAction:title];
    } else if ([self.vm isKindOfClass:[UCFTransBidDetailViewModel class]]){
//        [(UCFTransBidDetailViewModel *)self.vm dealClickAction:title];
        if (self.delegate) {
            [self.delegate newInvestBtnView:self clickButton:button];
        }
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
