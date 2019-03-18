//
//  UCFRemindFlowView.m
//  JRGC
//
//  Created by zrc on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFRemindFlowView.h"
@interface UCFRemindFlowView()

@end
@implementation UCFRemindFlowView
- (instancetype)init
{
    if (self = [super init]) {


    }
    return self;
}

- (void)reloadViewContentWithTextArr:(NSArray *)textArr
{
    
    for (NSString *showStr in textArr) {
        [self createTagButton:showStr];
    }
    [self layoutAnimationWithDuration:0];
    self.leftPadding = 15.0f;
    if (textArr.count > 3) {
        self.topPadding = 3.0f;
    } else {
        self.topPadding = 12.0f;
    }
    self.rightPadding = 15.0f;
    

}
- (void)createTagButton:(NSString *)text
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    [tagButton setTitleColor:[Color color:PGColorOpttonRateNoramlTextColor] forState:UIControlStateNormal];
    tagButton.layer.borderWidth = 1;
    [tagButton setBackgroundColor:[UIColor whiteColor]];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:12];
    tagButton.layer.borderColor = [Color color:PGColorOpttonRateNoramlTextColor].CGColor;
    tagButton.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    //这里可以看到尺寸宽度等于自己的尺寸宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
    //如果没有这个设置，而是直接调用了sizeToFit则按钮的宽度就是内容的宽度。
    tagButton.widthSize.equalTo(tagButton.widthSize).add(10);
    tagButton.heightSize.equalTo(tagButton.heightSize).add(6).max(20); //高度根据自身的内容再增加10
    [tagButton sizeToFit];
    [tagButton setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
        v.layer.cornerRadius = v.frame.size.height/2;
    }];
    [self addSubview:tagButton];
}
- (void)showView:(UCFBidViewModel *)viewModel
{
    @PGWeakObj(self);

    [self.KVOController observe:viewModel keyPaths:@[@"markList"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"markList"]) {
            NSArray *markList = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (markList.count > 0) {
                [selfWeak  reloadViewContentWithTextArr:markList];
                selfWeak.heightSize.equalTo(@40);
                selfWeak.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.myVisibility = MyVisibility_Visible;
                selfWeak.heightSize.equalTo(@10);

            }
         }
    }];
}
- (void)blindVM:(UVFBidDetailViewModel *)vm
{
    @PGWeakObj(self);
    
    [self.KVOController observe:vm keyPaths:@[@"markList"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"markList"]) {
            NSArray *markList = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (markList.count > 0) {
                [selfWeak  reloadViewContentWithTextArr:markList];
                selfWeak.heightSize.equalTo(@40);
                selfWeak.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.myVisibility = MyVisibility_Visible;
                selfWeak.heightSize.equalTo(@10);
                
            }
        }
    }];
}
- (void)blindTransVM:(BaseViewModel *)vm
{
    @PGWeakObj(self);
    
    [self.KVOController observe:vm keyPaths:@[@"markList"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"markList"]) {
            NSArray *markList = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (markList.count > 0) {
                [selfWeak  reloadViewContentWithTextArr:markList];
                selfWeak.heightSize.equalTo(@40);
                selfWeak.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.myVisibility = MyVisibility_Visible;
                selfWeak.heightSize.equalTo(@10);
                
            }
        }
    }];
}
- (void)blindCollectionVM:(BaseViewModel *)vm
{
    @PGWeakObj(self);
    
    [self.KVOController observe:vm keyPaths:@[@"markList"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"markList"]) {
            NSArray *markList = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (markList.count > 0) {
                [selfWeak  reloadViewContentWithTextArr:markList];
                selfWeak.heightSize.equalTo(@40);
                selfWeak.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.myVisibility = MyVisibility_Visible;
                selfWeak.heightSize.equalTo(@10);
                
            }
        }
    }];
}
@end
