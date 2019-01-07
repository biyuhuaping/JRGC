//
//  UCFSectionHeadView.m
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFSectionHeadView.h"

@interface UCFSectionHeadView ()

@property(strong ,nonatomic)UILabel *titleLab;
@property(strong, nonatomic)UIImageView *imageView1;
@property(strong, nonatomic)UIImageView *imageView2;
@property(strong, nonatomic)UIImageView *imageView3;
@property(strong, nonatomic)UIImageView *imageView4;
@end

@implementation UCFSectionHeadView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.titleLab];
        [self addSubview:self.imageView1];
        [self addSubview:self.imageView2];
        [self addSubview:self.imageView3];
        [self addSubview:self.imageView4];
        self.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    }
    return self;
}

- (void)layoutSubviewFrame
{
    self.titleLab.leadingPos.equalTo(@15);
    self.titleLab.topPos.equalTo(@0);
    self.titleLab.bottomPos.equalTo(@0);
    
    self.imageView1.centerYPos.equalTo(self.centerYPos);
    self.imageView1.leftPos.equalTo(self.titleLab.rightPos);
    self.imageView1.mySize = CGSizeMake(18, 18);
    self.imageView1.myVisibility = MyVisibility_Gone;
    
    self.imageView2.centerYPos.equalTo(self.centerYPos);
    self.imageView2.leftPos.equalTo(self.imageView1.rightPos);
    self.imageView2.mySize = CGSizeMake(18, 18);
    self.imageView2.myVisibility = MyVisibility_Gone;
    
    self.imageView3.centerYPos.equalTo(self.centerYPos);
    self.imageView3.leftPos.equalTo(self.imageView2.rightPos);
    self.imageView3.mySize = CGSizeMake(18, 18);
    self.imageView3.myVisibility = MyVisibility_Gone;

    self.imageView4.centerYPos.equalTo(self.centerYPos);
    self.imageView4.leftPos.equalTo(self.imageView3.rightPos);
    self.imageView4.mySize = CGSizeMake(18, 18);
    self.imageView4.myVisibility = MyVisibility_Gone;
}

- (void)showView:(UCFBidViewModel *)viewModel
{
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"prdName",@"prdLabelsList",@"platformSubsidyExpense",@"holdTime",@"guaranteeCompanyName",@"fixedDate"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"prdName"]) {
            selfWeak.titleLab.text =  [change objectSafeForKey:NSKeyValueChangeNewKey];
            [selfWeak.titleLab sizeToFit];
        } else if ([keyPath isEqualToString:@"platformSubsidyExpense"]) {
           NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.imageView1.myVisibility = MyVisibility_Visible;
                selfWeak.imageView1.image = [UIImage imageNamed:@"invest_icon_buletie"];
            }
        } else if ([keyPath isEqualToString:@"guaranteeCompanyName"]) {
           NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.imageView2.myVisibility = MyVisibility_Visible;
                selfWeak.imageView2.image = [UIImage imageNamed:@"particular_icon_guarantee_dark"];
            }
        } else if ([keyPath isEqualToString:@"holdTime"]) {
           NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.imageView3.myVisibility = MyVisibility_Visible;
                selfWeak.imageView3.image = [UIImage imageNamed:@"invest_icon_ling"];
            }
        } else if ([keyPath isEqualToString:@"fixedDate"]) {
           NSString *markStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markStr.length > 0) {
                selfWeak.imageView4.myVisibility = MyVisibility_Visible;
                selfWeak.imageView4.image = [UIImage imageNamed:@"invest_icon_redgu-1"];
            }
        }
    }];
}


- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14.0f];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.adjustsFontSizeToFitWidth = YES;
        _titleLab.textColor = UIColorWithRGB(0x333333);
        _titleLab.backgroundColor =  [UIColor clearColor];
        _titleLab.text = @"";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}
- (UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.backgroundColor = [UIColor clearColor];
    }
    return _imageView1;
}
- (UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.backgroundColor = [UIColor clearColor];
    }
    return _imageView2;
}
- (UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc] init];
        _imageView3.backgroundColor = [UIColor clearColor];
    }
    return _imageView3;
}
- (UIImageView *)imageView4{
    if (!_imageView4) {
        _imageView4 = [[UIImageView alloc] init];
        _imageView4.backgroundColor = [UIColor clearColor];
    }
    return _imageView4;
}
@end
