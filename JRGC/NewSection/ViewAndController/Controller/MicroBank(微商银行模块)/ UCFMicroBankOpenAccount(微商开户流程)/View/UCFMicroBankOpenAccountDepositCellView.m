//
//  UCFMicroBankOpenAccountDepositCellView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountDepositCellView.h"
@interface UCFMicroBankOpenAccountDepositCellView ()

@end
@implementation UCFMicroBankOpenAccountDepositCellView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [self.rootLayout addSubview:self.titleImageView];
        [self.rootLayout addSubview:self.contentField];
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

- (UITextField *)contentField
{
    if (nil == _contentField) {
        _contentField = [UITextField new];
        _contentField.backgroundColor = [UIColor clearColor];
//        _contentField.delegate = self;
        _contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contentField.font = [Color gc_Font:15.0];
        _contentField.placeholder = @"   ";
//        _contentField.keyboardType =  UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_contentField.placeholder attributes:dict];
        [_contentField setAttributedPlaceholder:attribute];
        
//        NSString *phoneStr = [UserObeject getUserDataMobile];
//        if (phoneStr != nil && phoneStr.length > 0) {
//            _atTextField.text = phoneStr;
//        }
        UIButton *clearButton = [_contentField valueForKey:@"_clearButton"];
        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
            
            [clearButton setImage:[UIImage imageNamed:@"openAccountClose"] forState:UIControlStateNormal];
            [clearButton setImage:[UIImage imageNamed:@"openAccountClose"] forState:UIControlStateHighlighted];
            
        }
        _contentField.textColor = [Color color:PGColorOptionTitleBlack];
        _contentField.heightSize.equalTo(self.rootLayout.heightSize);
        _contentField.leftPos.equalTo(self.titleImageView.rightPos).offset(13);
        _contentField.rightPos.equalTo(@8);
        _contentField.centerYPos.equalTo(self.rootLayout.centerYPos);
        
    }
    return _contentField;
}
- (UIView *)itemLineView
{
    if (nil == _itemLineView) {
        _itemLineView = [UIView new];
        _itemLineView.myBottom = 1;
        _itemLineView.myHeight = 0.5;
        _itemLineView.leftPos.equalTo(self.contentField.leftPos);
        _itemLineView.myRight = 0;
        _itemLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _itemLineView;
}
@end
