//
//  UCFMicroBankDepositoryAccountHomeHeadView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryAccountHomeHeadView.h"

@interface UCFMicroBankDepositoryAccountHomeHeadView()
@property (nonatomic, strong) UIImageView *bankCardBKImageView;

@property (nonatomic, strong) NZLabel     *openAccountLabel;//开户名

@property (nonatomic, strong) NZLabel     *bankDepositLabel;//开户行

@end
@implementation UCFMicroBankDepositoryAccountHomeHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        [self.rootLayout addSubview:self.bankCardBKImageView];
        [self.rootLayout addSubview:self.bankCardNumberLabel];
        [self.rootLayout addSubview:self.openAccountLabel];
        [self.rootLayout addSubview:self.openAccountNameLabel];
        [self.rootLayout addSubview:self.bankDepositLabel];
        [self.rootLayout addSubview:self.bankDepositNameLabel];
    }
    return self;
}

- (UIImageView *)bankCardBKImageView
{
    if (nil == _bankCardBKImageView) {
        _bankCardBKImageView = [[UIImageView alloc] init];
        _bankCardBKImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _bankCardBKImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _bankCardBKImageView.myWidth = PGScreenWidth -20;
        _bankCardBKImageView.myHeight = PGScreenWidth *0.573;
        _bankCardBKImageView.image = [UIImage imageNamed:@"weishangbank_card_bg"];
    }
    return _bankCardBKImageView;
}
- (NZLabel *)bankCardNumberLabel
{
    if (nil == _bankCardNumberLabel) {
        _bankCardNumberLabel = [NZLabel new];
        _bankCardNumberLabel.leftPos.equalTo(self.bankCardBKImageView.leftPos).offset(29);
        _bankCardNumberLabel.rightPos.equalTo(self.bankCardBKImageView.rightPos).offset(29);
        _bankCardNumberLabel.topPos.equalTo(self.bankCardBKImageView.topPos).offset(PGScreenWidth *0.573*0.437);
        _bankCardNumberLabel.textAlignment = NSTextAlignmentLeft;
        _bankCardNumberLabel.font = [Color gc_Font:25.0];
        _bankCardNumberLabel.textColor = [Color color:PGColorOptionThemeWhite];
        _bankCardNumberLabel.text = @"     ";
        _bankCardNumberLabel.adjustsFontSizeToFitWidth = YES;
        [_bankCardNumberLabel sizeToFit];
        
    }
    return _bankCardNumberLabel;
}
- (NZLabel *)bankDepositLabel
{
    if (nil == _bankDepositLabel) {
        _bankDepositLabel = [NZLabel new];
        _bankDepositLabel.bottomPos.equalTo(self.bankCardBKImageView.bottomPos).offset(40);
        _bankDepositLabel.leftPos.equalTo(self.bankCardNumberLabel.leftPos);
        _bankDepositLabel.textAlignment = NSTextAlignmentLeft;
        _bankDepositLabel.font = [Color gc_Font:12.0];
        _bankDepositLabel.textColor = [Color color:PGColorOpttonBankCardTextColor];
        _bankDepositLabel.text = @"开户行：";
        [_bankDepositLabel sizeToFit];
        
    }
    return _bankDepositLabel;
}
- (NZLabel *)bankDepositNameLabel
{
    if (nil == _bankDepositNameLabel) {
        _bankDepositNameLabel = [NZLabel new];
        _bankDepositNameLabel.centerYPos.equalTo(self.bankDepositLabel.centerYPos);
        _bankDepositNameLabel.leftPos.equalTo(self.bankDepositLabel.rightPos).offset(3);
        _bankDepositNameLabel.rightPos.equalTo(self.bankCardBKImageView.rightPos).offset(29);
        _bankDepositNameLabel.textAlignment = NSTextAlignmentLeft;
        _bankDepositNameLabel.font = self.bankDepositLabel.font;
        _bankDepositNameLabel.textColor = self.bankDepositLabel.textColor;
        _bankDepositNameLabel.text = @" ";
        _bankDepositNameLabel.adjustsFontSizeToFitWidth = YES;
        [_bankDepositNameLabel sizeToFit];
        
    }
    return _bankDepositNameLabel;
}

- (NZLabel *)openAccountLabel
{
    if (nil == _openAccountLabel) {
        _openAccountLabel = [NZLabel new];
        _openAccountLabel.bottomPos.equalTo(self.bankDepositLabel.topPos);
        _openAccountLabel.leftPos.equalTo(self.bankCardNumberLabel.leftPos);
        _openAccountLabel.textAlignment = NSTextAlignmentLeft;
        _openAccountLabel.font = self.bankDepositLabel.font;
        _openAccountLabel.textColor = self.bankDepositLabel.textColor;
        _openAccountLabel.text = @"开户名：";
        [_openAccountLabel sizeToFit];
        
    }
    return _openAccountLabel;
}
- (NZLabel *)openAccountNameLabel
{
    if (nil == _openAccountNameLabel) {
        _openAccountNameLabel = [NZLabel new];
        _openAccountNameLabel.centerYPos.equalTo(self.openAccountLabel.centerYPos);
        _openAccountNameLabel.leftPos.equalTo(self.openAccountLabel.rightPos).offset(3);
        _openAccountNameLabel.textAlignment = NSTextAlignmentLeft;
        _openAccountNameLabel.font = self.bankDepositLabel.font;
        _openAccountNameLabel.textColor = self.bankDepositLabel.textColor;
        _openAccountNameLabel.text = @"   ";
        [_openAccountNameLabel sizeToFit];
        
    }
    return _openAccountNameLabel;
}
@end
