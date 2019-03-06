//
//  UCFMicroBankOpenAccountDepositBankListCellView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountDepositBankListCellView.h"
@interface UCFMicroBankOpenAccountDepositBankListCellView()

@property (nonatomic, strong) UIImageView *arrawImageView;

@end

@implementation UCFMicroBankOpenAccountDepositBankListCellView

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
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        ;
        
        [self.rootLayout addSubview:self.titleImageView];//标题
        [self.rootLayout addSubview:self.oaContentLabel];//内容
        [self.rootLayout addSubview:self.bankImageView];
        [self.rootLayout addSubview:self.arrawImageView];
        [self.rootLayout addSubview:self.itemLineView];
       
    }
    return self;
}
- (UIImageView *)titleImageView
{
    if (nil == _titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _titleImageView.myLeft = 15;
        _titleImageView.myWidth = 22;
        _titleImageView.myHeight = 22;
    }
    return _titleImageView;
}

//- (UIButton *)clickButton
//{
//    if (nil == _clickButton) {
//        _clickButton= [UIButton buttonWithType:UIButtonTypeCustom];
//        _clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//        [_clickButton setTitle:@"查看支持银行" forState:UIControlStateNormal];
//        //设置标题颜色
//        [_clickButton setTitleColor:[Color color:PGColorOptionInputDefaultBlackGray] forState:UIControlStateNormal];
//        _clickButton.adjustsImageWhenHighlighted = NO;
//        _clickButton.titleLabel.font = [Color gc_Font:15.0];
//
//        _clickButton.heightSize.equalTo(self.rootLayout.heightSize);
//        _clickButton.centerYPos.equalTo(self.rootLayout.centerYPos);
//        _clickButton.leftPos.equalTo(self.titleImageView.rightPos).offset(13);
//        _clickButton.rightPos.equalTo(self.arrawImageView.leftPos).offset(5);
//    }
//    return _clickButton;
//}
- (NZLabel *)oaContentLabel
{
    if (nil == _oaContentLabel) {
        _oaContentLabel = [NZLabel new];
        _oaContentLabel.centerYPos.equalTo(self.titleImageView.centerYPos);
        _oaContentLabel.leftPos.equalTo(self.titleImageView.rightPos).offset(13);
        _oaContentLabel.textAlignment = NSTextAlignmentLeft;
        _oaContentLabel.font = [Color gc_Font:15.0];
        _oaContentLabel.textColor = [Color color:PGColorOptionTitleGray];
        _oaContentLabel.text = @"查看支持银行";
        [_oaContentLabel sizeToFit];
        
    }
    return _oaContentLabel;
}
- (UIImageView *)bankImageView
{
    if (nil == _bankImageView) {
        _bankImageView = [[UIImageView alloc] init];
        _bankImageView.centerYPos.equalTo(self.titleImageView.centerYPos);
        _bankImageView.leftPos.equalTo(self.oaContentLabel.rightPos).offset(5);
        _bankImageView.myWidth = 29;
        _bankImageView.myHeight = 29;
//        _arrawImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
    }
    return _bankImageView;
}

- (UIImageView *)arrawImageView
{
    if (nil == _arrawImageView) {
        _arrawImageView = [[UIImageView alloc] init];
        _arrawImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _arrawImageView.myRight = 15;
        _arrawImageView.myWidth = 8;
        _arrawImageView.myHeight = 13;
        _arrawImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
    }
    return _arrawImageView;
}

- (UIView *)itemLineView
{
    if (nil == _itemLineView) {
        _itemLineView = [UIView new];
        _itemLineView.myBottom = 1;
        _itemLineView.myHeight = 0.5;
        _itemLineView.leftPos.equalTo(self.oaContentLabel.leftPos);
        _itemLineView.myRight = 0;
        _itemLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
        _itemLineView.hidden = YES;
    }
    return _itemLineView;
}
@end
