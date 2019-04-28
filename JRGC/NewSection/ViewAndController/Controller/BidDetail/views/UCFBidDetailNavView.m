//
//  UCFBidDetailNavView.m
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBidDetailNavView.h"
#import "UIImage+Compression.h"
@interface UCFBidDetailNavView()
@property(nonatomic, strong)MyRelativeLayout *titleBaseView;
@property(nonatomic, strong)UILabel *prdNameLab;
@property(nonatomic, strong)UILabel *childNameLab;
@end

@implementation UCFBidDetailNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *baseView = [[UIImageView alloc] init];
        baseView.myMargin = 0;
        [self.rootLayout addSubview:baseView];
        baseView.image = [UIImage gc_styleImageSize:frame.size];
        baseView.userInteractionEnabled = YES;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.mySize = CGSizeMake(60, 44);
        leftButton.bottomPos.equalTo(@0);
        leftButton.leftPos.equalTo(@0);
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:@"btn_whiteback"]forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"btn_whiteback"]forState:UIControlStateHighlighted];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [self.rootLayout addSubview:leftButton];
        
        MyRelativeLayout *titleBaseView = [MyRelativeLayout new];
        titleBaseView.heightSize.equalTo(@44);
        titleBaseView.centerXPos.equalTo(self.rootLayout.centerXPos);
        titleBaseView.bottomPos.equalTo(@0);
        [self.rootLayout addSubview:titleBaseView];
        
        self.titleBaseView = titleBaseView;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.leftPos.equalTo(titleBaseView.leftPos);
        titleLab.centerYPos.equalTo(titleBaseView.centerYPos);
        titleLab.font = [Color gc_Font:18];
//        titleLab.text = @"产融通";
        titleLab.textColor = [Color color:PGColorOptionThemeWhite];
        [titleBaseView addSubview:titleLab];
        [titleLab sizeToFit];
        self.prdNameLab = titleLab;
        
        UILabel *childTitleLab = [[UILabel alloc] init];
        childTitleLab.centerYPos.equalTo(titleBaseView.centerYPos);
        childTitleLab.leftPos.equalTo(titleLab.rightPos).offset(3);
        childTitleLab.font = [Color gc_Font:12];
        childTitleLab.layer.borderWidth = 1.0;
        childTitleLab.layer.cornerRadius = 2.0;
//        childTitleLab.text = @"BBBB";
        childTitleLab.textColor = [Color color:PGColorOptionThemeWhite];
        childTitleLab.layer.borderColor = [UIColor whiteColor].CGColor;
        childTitleLab.textAlignment = NSTextAlignmentCenter;
        [childTitleLab sizeToFit];
        childTitleLab.myWidth = childTitleLab.size.width + 10;
        
        [titleBaseView addSubview:childTitleLab];
        
        titleBaseView.myWidth = titleLab.size.width + childTitleLab.size.width;
        
        
        self.childNameLab = childTitleLab;

    
    }
    return self;
}
- (void)click:(UIButton *)button
{
    if (self.delegate) {
        [self.delegate topLeftButtonClick:button];
    }
}
- (void)blindVM:(BaseViewModel *)vm
{
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"prdName",@"childName",@"navFinish"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"prdName"]) {
            NSString *prdName = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (prdName.length > 0) {
                selfWeak.prdNameLab.text = prdName;
                [selfWeak.prdNameLab sizeToFit];
            }
        } else if ([keyPath isEqualToString:@"childName"]) {
            NSString *childName = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (childName.length > 0) {
                selfWeak.childNameLab.text = childName;
                [selfWeak.childNameLab sizeToFit];
                selfWeak.childNameLab.myWidth = selfWeak.childNameLab.size.width + 10;
            }
        } else if ([keyPath isEqualToString:@"navFinish"]) {
            NSString *navFinish = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if ([navFinish isEqualToString:@"1"]) {
                selfWeak.titleBaseView.myWidth = selfWeak.prdNameLab.size.width + selfWeak.childNameLab.size.width;
            }
        }
    }];
}
- (void)blindCollectionVM:(BaseViewModel *)vm
{
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"prdName"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"prdName"]) {
            NSString *prdName = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (prdName.length > 0) {
                selfWeak.prdNameLab.text = prdName;
                [selfWeak.prdNameLab sizeToFit];
                selfWeak.titleBaseView.myWidth = selfWeak.prdNameLab.size.width;
            }
        }
    }];
}
- (void)blindTransVM:(BaseViewModel *)vm
{
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"prdName"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"prdName"]) {
            NSString *prdName = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (prdName.length > 0) {
                selfWeak.prdNameLab.text = prdName;
                [selfWeak.prdNameLab sizeToFit];
                selfWeak.titleBaseView.myWidth = selfWeak.prdNameLab.size.width;
            }
        }
    }];
}
@end
