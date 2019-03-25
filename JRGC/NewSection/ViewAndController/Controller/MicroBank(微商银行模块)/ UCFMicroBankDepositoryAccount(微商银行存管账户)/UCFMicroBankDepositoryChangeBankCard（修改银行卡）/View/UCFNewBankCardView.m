//
//  UCFNewBankCardView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBankCardView.h"
#import "Common.h"
@interface UCFNewBankCardView ()
@property (strong, nonatomic)  UIImageView *bkImageView;
@property (strong, nonatomic)  NZLabel *bankTypeLabel;
@end

@implementation UCFNewBankCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//@property (weak, nonatomic)  UIImageView *bankCardImageView;
//@property (weak, nonatomic)  NZLabel *bankNameLabel;
//@property (weak, nonatomic)  NZLabel *userNameLabel;
//@property (weak, nonatomic)  NZLabel *cardNoLabel;
//@property (weak, nonatomic)  UIImageView *quickPayImageView;//***快捷支付图片
//@property (weak, nonatomic)  UIImageView *image_bankCardValuable;//***银行卡失效图片
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        [self.rootLayout addSubview:self.bkImageView];
        [self.rootLayout addSubview:self.bankImageView];
        [self.rootLayout addSubview:self.bankCardImageView];
        [self.rootLayout addSubview:self.bankNameLabel];
        [self.rootLayout addSubview:self.bankTypeLabel];
        [self.rootLayout addSubview:self.userNameLabel];
        [self.rootLayout addSubview:self.cardNoLabel];
        [self.rootLayout addSubview:self.quickPayImageView];
        [self.rootLayout addSubview:self.image_bankCardValuable];
        
        self.image_bankCardValuable.hidden = YES;//***“银行卡失效”文字初始化时候隐藏
    }
    return self;
}

- (UIImageView *)bkImageView
{
    if (nil == _bkImageView) {
        _bkImageView = [[UIImageView alloc] init];
        _bkImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _bkImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _bkImageView.myWidth = PGScreenWidth;
        _bkImageView.myHeight = PGScreenWidth *0.83;
        _bkImageView.image = [UIImage imageNamed:@"binding_bank_cardsbg"];
    }
    return _bkImageView;
}
- (UIImageView *)bankImageView
{
    if (nil == _bankImageView) {
        _bankImageView = [[UIImageView alloc] init];
        _bankImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _bankImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _bankImageView.myWidth = PGScreenWidth -40;
        _bankImageView.myHeight = PGScreenWidth *0.61;
        _bankImageView.image = [UIImage imageNamed:@"white_bank_bg"];
    }
    return _bankImageView;
}

- (UIImageView *)bankCardImageView
{
    if (nil == _bankCardImageView) {
        _bankCardImageView = [[UIImageView alloc] init];
        _bankCardImageView.leftPos.equalTo(self.bankImageView.leftPos).offset(39);
        _bankCardImageView.topPos.equalTo(self.bankImageView.topPos).offset(39);
        _bankCardImageView.myWidth = 20;
        _bankCardImageView.myHeight = 15;
//        _bankCardImageView.image = [UIImage imageNamed:@"white_bank_bg"];
    }
    return _bankCardImageView;
}

- (NZLabel *)bankNameLabel
{
    if (nil == _bankNameLabel) {
        _bankNameLabel = [NZLabel new];
        _bankNameLabel.leftPos.equalTo(self.bankCardImageView.rightPos).offset(11);
        _bankNameLabel.rightPos.equalTo(self.bankTypeLabel.leftPos);
        _bankNameLabel.centerYPos.equalTo(self.bankCardImageView.centerYPos);
        _bankNameLabel.textAlignment = NSTextAlignmentLeft;
        _bankNameLabel.font = [Color gc_Font:15.0];
        _bankNameLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _bankNameLabel.text = @"     ";
        [_bankNameLabel sizeToFit];
        
    }
    return _bankNameLabel;
}

- (NZLabel *)bankTypeLabel
{
    if (nil == _bankTypeLabel) {
        _bankTypeLabel = [NZLabel new];
        _bankTypeLabel.rightPos.equalTo(self.bankImageView.rightPos).offset(39);
        _bankTypeLabel.centerYPos.equalTo(self.bankCardImageView.centerYPos);
        _bankTypeLabel.textAlignment = NSTextAlignmentRight;
        _bankTypeLabel.font = [Color gc_Font:14.0];
        _bankTypeLabel.textColor = [Color color:PGColorOpttonBankTextGrayColor];
        _bankTypeLabel.text = @"借记卡";
        [_bankTypeLabel sizeToFit];
        
    }
    return _bankTypeLabel;
}

- (NZLabel *)userNameLabel
{
    if (nil == _userNameLabel) {
        _userNameLabel = [NZLabel new];
        _userNameLabel.bottomPos.equalTo(self.cardNoLabel.topPos).offset(14);
        _userNameLabel.leftPos.equalTo(self.cardNoLabel.leftPos);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.font = [Color gc_Font:14.0];
        _userNameLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _userNameLabel.text = @"     ";
        [_userNameLabel sizeToFit];
        
    }
    return _userNameLabel;
}
- (NZLabel *)cardNoLabel
{
    if (nil == _cardNoLabel) {
        _cardNoLabel = [NZLabel new];
        _cardNoLabel.leftPos.equalTo(self.bankImageView.leftPos).offset(42);
        _cardNoLabel.centerYPos.equalTo(self.quickPayImageView.centerYPos);
        _cardNoLabel.textAlignment = NSTextAlignmentLeft;
        _cardNoLabel.font = [Color gc_Font:25.0];
        _cardNoLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _cardNoLabel.text = @"     ";
        [_cardNoLabel sizeToFit];
        
    }
    return _cardNoLabel;
}

- (UIImageView *)quickPayImageView
{
    if (nil == _quickPayImageView) {
        _quickPayImageView = [[UIImageView alloc] init];
        _quickPayImageView.rightPos.equalTo(self.bankImageView.rightPos).offset(32);
        _quickPayImageView.bottomPos.equalTo(self.bankImageView.bottomPos).offset(42);
        _quickPayImageView.myWidth = 45;
        _quickPayImageView.myHeight = 22;
        _quickPayImageView.image = [UIImage imageNamed:@"bankcard_icon_fast"];
    }
    return _quickPayImageView;
}

- (UIImageView *)image_bankCardValuable
{
    if (nil == _image_bankCardValuable) {
        _image_bankCardValuable = [[UIImageView alloc] init];
        _image_bankCardValuable.centerYPos.equalTo(self.bankImageView.centerYPos);
        _image_bankCardValuable.rightPos.equalTo(self.quickPayImageView.rightPos);
        _image_bankCardValuable.myWidth = 97;
        _image_bankCardValuable.myHeight = 56;
        _image_bankCardValuable.image = [UIImage imageNamed:@"bindbankcard_invalid"];
    }
    return _image_bankCardValuable;
}
//***当银行卡失效的时候页面部分至灰色
-(void)thisBankCardInvaluable:(BOOL)_gray
{
    if(_gray==YES){
        self.quickPayImageView.image = [Common grayImage:self.quickPayImageView.image];
        self.bankCardImageView.image = [Common grayImage:self.bankCardImageView.image];
        self.image_bankCardValuable.hidden = NO;
    }
}
@end
