//
//  UCFFundsInvestButton.m
//  JRGC
//
//  Created by zrc on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFFundsInvestButton.h"
#import "UIImage+Compression.h"
#import "UCFCollectionViewModel.h"
@interface UCFFundsInvestButton ()
@property(nonatomic, weak)UCFBidViewModel *myVM;
@property(nonatomic, weak)UCFPureTransPageViewModel *mytransVM;
@property(nonatomic, weak)UCFCollectionViewModel    *myCollectionVM;
@property(nonatomic, strong)UIButton *investmentButton;
@end

@implementation UCFFundsInvestButton
- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    
    @PGWeakObj(self);
    
    [self.KVOController observe:viewModel keyPaths:@[@"investMoeny"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"investMoeny"]) {
            NSString *investMoney = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (investMoney.length == 0) {
                selfWeak.investmentButton.enabled = NO;
                
            } else {
                selfWeak.investmentButton.enabled = YES;
                
            }
        }
    }];
    
}
- (void)showTransView:(UCFPureTransPageViewModel *)viewModel
{
    self.mytransVM = viewModel;
    @PGWeakObj(self);
    
    [self.KVOController observe:viewModel keyPaths:@[@"investMoeny"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"investMoeny"]) {
            NSString *investMoney = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (investMoney.length == 0) {
                selfWeak.investmentButton.enabled = NO;
                
            } else {
                selfWeak.investmentButton.enabled = YES;
                
            }
        }
    }];
    
    
}
- (void)blindBaseVM:(BaseViewModel *)viewModel
{
    self.myCollectionVM = viewModel;
}
- (void)createSubviews
{
    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.myHorzMargin = 0;
    investmentButton.myTop = 0;
    investmentButton.myBottom = 0;
    investmentButton.layer.masksToBounds = YES;

    [investmentButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [investmentButton setTitle:@"立即出借" forState:UIControlStateNormal];
    [self addSubview:investmentButton];
    
    self.investmentButton = investmentButton;
    [investmentButton setBackgroundImage:[UIImage gc_styleImageSize:CGSizeMake(ScreenWidth, 50)] forState:UIControlStateNormal];
    [investmentButton setBackgroundImage:[UIImage gc_styleGrayImageSize:CGSizeMake(ScreenWidth, 50)] forState:UIControlStateDisabled];


}
- (void)click:(UIButton *)button
{
    if (self.myVM) {
        [self.myVM dealInvestLogic];
    }
    if (self.mytransVM) {
        [self.mytransVM dealInvestLogic];
    }
    if (self.myCollectionVM) {
        [self.myCollectionVM dealInvestLogic];
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
