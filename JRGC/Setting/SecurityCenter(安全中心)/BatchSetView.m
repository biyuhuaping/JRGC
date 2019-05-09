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
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (frame.size.height - 65)/2, 65, 65)];
    _iconImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_iconImageView];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 12, CGRectGetMinY(_iconImageView.frame), SCREEN_WIDTH - CGRectGetMaxX(_iconImageView.frame) - 10 - 10,  18)];
    _titleLab.font = [Color gc_Font:16.0f];
    _titleLab.textColor =  [Color color:PGColorOptionTitleBlack];
    [self addSubview:_titleLab];
    
    _desLabe = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 12, CGRectGetMaxY(_titleLab.frame) + 5, CGRectGetWidth(_titleLab.frame), 55)];
    _desLabe.font = [UIFont systemFontOfSize:14.0f];
    _desLabe.numberOfLines = 0;
    _desLabe.textColor = [Color color:PGColorOptionTitleGray];
    [self addSubview:_desLabe];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.image = [UIImage imageNamed:_iconName];
    _titleLab.text = _title;
    _desLabe.text = _des;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
