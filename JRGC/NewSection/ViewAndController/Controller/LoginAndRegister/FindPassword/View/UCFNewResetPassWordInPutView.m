//
//  UCFNewResetPassWordInPutView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewResetPassWordInPutView.h"
@interface UCFNewResetPassWordInPutView()
@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UIView *itemLineView;//下划线

@property (nonatomic, strong) UIButton *showPassWordBtn;
@end
@implementation UCFNewResetPassWordInPutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [self.rootLayout addSubview:self.titleImageView];
        [self.rootLayout addSubview:self.contentField];
        [self.rootLayout addSubview:self.showPassWordBtn];
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
        _titleImageView.image = [UIImage imageNamed:@"sign_icon_password.png"];
    }
    return _titleImageView;
}

- (UITextField *)contentField
{
    if (nil == _contentField) {
        _contentField = [UITextField new];
        _contentField.backgroundColor = [UIColor clearColor];
        _contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contentField.font = [Color font:15.0 andFontName:nil];
        _contentField.textAlignment = NSTextAlignmentLeft;
        _contentField.placeholder = @"6-16位密码，数字、字母组合";
        _contentField.secureTextEntry = YES;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_contentField.placeholder attributes:dict];
        [_contentField setAttributedPlaceholder:attribute];
        _contentField.textColor = [Color color:PGColorOptionTitleBlack];
        _contentField.heightSize.equalTo(@25);
        _contentField.leftPos.equalTo(self.titleImageView.rightPos).offset(9);
        _contentField.rightPos.equalTo(self.showPassWordBtn.leftPos);
        _contentField.centerYPos.equalTo(self.titleImageView.centerYPos);
        _contentField.userInteractionEnabled = YES;
        UIButton *clearButton = [_contentField valueForKey:@"_clearButton"];
        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
            
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateHighlighted];
            
        }
    }
    return _contentField;
}

- (UIButton*)showPassWordBtn{
    
    if(nil == _showPassWordBtn)
    {
        _showPassWordBtn = [UIButton buttonWithType:0];
        _showPassWordBtn.centerYPos.equalTo(self.titleImageView.centerYPos);
        _showPassWordBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _showPassWordBtn.rightPos.equalTo(@12.5);
        _showPassWordBtn.widthSize.equalTo(@50);
        _showPassWordBtn.heightSize.equalTo(@50);
        [_showPassWordBtn setImage:[UIImage imageNamed:@"icon_invisible_bule.png"] forState:UIControlStateNormal];
        [_showPassWordBtn addTarget:self action:@selector(setSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPassWordBtn;
}
-(void)setSelectedButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"mine_icon_ exhibition"] forState:UIControlStateNormal];
        self.contentField.secureTextEntry = NO;
        
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"icon_invisible_bule"] forState:UIControlStateNormal];
        self.contentField.secureTextEntry = YES;
    }
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
