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

@end

@implementation UCFSectionHeadView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.titleLab];
        self.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];

    }
    return self;
}
- (void)setShowLabelText:(NSString *)text
{
    self.titleLab.leadingPos.equalTo(@15);
    self.titleLab.trailingPos.equalTo(@0);
    self.titleLab.topPos.equalTo(@0);
    self.titleLab.bottomPos.equalTo(@0);
    self.titleLab.text = text;
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
        [_titleLab sizeToFit];
    }
    return _titleLab;
}
@end
