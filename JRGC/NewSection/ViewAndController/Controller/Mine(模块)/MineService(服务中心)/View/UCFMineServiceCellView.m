//
//  UCFMineServiceCellView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineServiceCellView.h"


@interface UCFMineServiceCellView ()

@property (nonatomic, strong) UIImageView *arrawImageView;//箭头

@end
@implementation UCFMineServiceCellView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        // 初始化视图对象
        [self.rootLayout addSubview:self.serviceTitleLabel];
        [self.rootLayout addSubview:self.serviceContentLabel];
        [self.rootLayout addSubview:self.arrawImageView];
        [self.rootLayout addSubview:self.horizontalLineView];
    }
    return self;
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
- (NZLabel *)serviceTitleLabel
{
    if (nil == _serviceTitleLabel) {
        _serviceTitleLabel = [NZLabel new];
        _serviceTitleLabel.myLeft = 15;
        _serviceTitleLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _serviceTitleLabel.textAlignment = NSTextAlignmentLeft;
        _serviceTitleLabel.font = [Color gc_Font:15.0];
        _serviceTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
    }
    return _serviceTitleLabel;
}

- (NZLabel *)serviceContentLabel
{
    if (nil == _serviceContentLabel) {
        _serviceContentLabel = [NZLabel new];
        _serviceContentLabel.rightPos.equalTo(self.arrawImageView.leftPos).offset(10);
        _serviceContentLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _serviceContentLabel.textAlignment = NSTextAlignmentRight;
        _serviceContentLabel.font = [Color gc_Font:14.0];
        _serviceContentLabel.textColor = [Color color:PGColorOptionTitleGray];
    }
    return _serviceContentLabel;
}

- (UIView *)horizontalLineView
{
    if (nil == _horizontalLineView) {
        _horizontalLineView = [UIView new];
        _horizontalLineView.myBottom = 0;
        _horizontalLineView.myHeight = 0.5;
        _horizontalLineView.myRight = 0;
        _horizontalLineView.myLeft = 15;
        _horizontalLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
        
    }
    return _horizontalLineView;
}

@end
