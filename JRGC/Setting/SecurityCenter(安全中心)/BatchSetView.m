//
//  BatchSetView.m
//  JRGC
//
//  Created by 金融工场 on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "BatchSetView.h"

@interface BatchSetView()
@property (strong, nonatomic)  UIImageView *iconImageView;
@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic)  UILabel *desLabe;
@end

@implementation BatchSetView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView:frame];
    }
    return self;
}

- (void)initView:(CGRect)frame
{
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (frame.size.height - 50)/2, 50, 50)];
    _iconImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_iconImageView];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, CGRectGetMinY(_iconImageView.frame) - 10, SCREEN_WIDTH - CGRectGetMaxX(_iconImageView.frame) - 10 - 10,  16)];
    _titleLab.font = [UIFont systemFontOfSize:16.0f];
    _titleLab.textColor = UIColorWithRGB(0x50627a);
    [self addSubview:_titleLab];
    
    _desLabe = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, CGRectGetMaxY(_titleLab.frame) - 10, CGRectGetWidth(_titleLab.frame), 40)];
    _desLabe.font = [UIFont systemFontOfSize:13.0f];
    _desLabe.numberOfLines = 0;
    _desLabe.textColor = [UIColor lightGrayColor];
    [self addSubview:_desLabe];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.image = [UIImage imageNamed:_iconName];
    _titleLab.text = _title;
    _desLabe.text = _des;
    
    CGFloat titleYhight = CGRectGetMinY(_iconImageView.frame) - 10;
    titleYhight = titleYhight < 15 ? 15:titleYhight;
    titleYhight = titleYhight > 20 ? 20:titleYhight;
    _titleLab.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, titleYhight, SCREEN_WIDTH - CGRectGetMaxX(_iconImageView.frame) - 10 - 10,  16);
    CGSize size = [Common getStrHeightWithStr:_des AndStrFont:13 AndWidth:CGRectGetWidth(_titleLab.frame) AndlineSpacing:1];
    CGFloat hight = size.height;
    if (hight < 40)
    {
        hight = 40;
    }
    _desLabe.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) +10, CGRectGetMaxY(_titleLab.frame), CGRectGetWidth(_titleLab.frame),hight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
