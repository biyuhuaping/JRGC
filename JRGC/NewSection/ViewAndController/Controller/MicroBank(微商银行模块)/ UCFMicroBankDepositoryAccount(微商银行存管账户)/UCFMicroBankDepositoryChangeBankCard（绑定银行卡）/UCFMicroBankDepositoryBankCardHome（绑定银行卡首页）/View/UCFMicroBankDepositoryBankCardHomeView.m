//
//  UCFMicroBankDepositoryBankCardHomeView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/5/6.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryBankCardHomeView.h"
@interface UCFMicroBankDepositoryBankCardHomeView ()

@property (nonatomic, strong) UIImageView *itemArrawImageView;//图片

@end
@implementation UCFMicroBankDepositoryBankCardHomeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [self.rootLayout addSubview:self.itemTitleLabel];
        [self.rootLayout addSubview:self.itemContentLabel];
        [self.rootLayout addSubview:self.itemArrawImageView];
        [self.rootLayout addSubview:self.itemLineView];
    }
    return self;
}

- (NZLabel *)itemTitleLabel
{
    if (nil == _itemTitleLabel) {
        _itemTitleLabel = [NZLabel new];
        _itemTitleLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _itemTitleLabel.myLeft = 25;
        _itemTitleLabel.textAlignment = NSTextAlignmentLeft;
        _itemTitleLabel.rightPos.equalTo(self.itemContentLabel.leftPos).offset(10);
        _itemTitleLabel.font = [Color gc_Font:15.0];
        _itemTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        
    }
    return _itemTitleLabel;
}

- (NZLabel *)itemContentLabel
{
    if (nil == _itemContentLabel) {
        _itemContentLabel = [NZLabel new];
        _itemContentLabel.centerYPos.equalTo(self.itemTitleLabel.centerYPos);
        _itemContentLabel.rightPos.equalTo(self.itemArrawImageView.leftPos).offset(6);
        _itemContentLabel.myWidth = 55;
        _itemContentLabel.textAlignment = NSTextAlignmentRight;
        _itemContentLabel.font = [Color gc_Font:13.0];
        _itemContentLabel.textColor = [Color color:PGColorOpttonBankTextGrayColor];
//        _itemContentLabel.myVisibility = MyVisibility_Gone;
    }
    return _itemContentLabel;
}

- (UIImageView *)itemArrawImageView
{
    if (nil == _itemArrawImageView) {
        _itemArrawImageView = [[UIImageView alloc] init];
        _itemArrawImageView.centerYPos.equalTo(self.itemTitleLabel.centerYPos);
        _itemArrawImageView.myRight = 25;
        _itemArrawImageView.myWidth = 8;
        _itemArrawImageView.myHeight = 13;
        _itemArrawImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
    }
    return _itemArrawImageView;
}

- (UIView *)itemLineView
{
    if (nil == _itemLineView) {
        _itemLineView = [UIView new];
        _itemLineView.myBottom = 1;
        _itemLineView.myHeight = 0.5;
        _itemLineView.myLeft = 25;
        _itemLineView.myRight = 0;
        _itemLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _itemLineView;
}
@end
