//
//  UCFSiteNoticeView.m
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//


#import "UCFSiteNoticeView.h"
@interface UCFSiteNoticeView ()
@end
@implementation UCFSiteNoticeView

- (instancetype)init
{
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.leftPos.equalTo(@15);
        imageView.centerYPos.equalTo(self.centerYPos);
        imageView.heightSize.equalTo(@14);
        imageView.widthSize.equalTo(@56);
        imageView.image = [UIImage imageNamed:@"home_icon_notice"];
        [self addSubview:imageView];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.centerYPos.equalTo(self.centerYPos);
        lab.leftPos.equalTo(imageView.rightPos).offset(15);
        lab.rightPos.equalTo(self.rightPos).offset(15);
        [self addSubview:lab];
        
        
        lab.font =[Color gc_Font:12];
        lab.textColor = [Color color:PGColorOptionTitleBlack];
        lab.text = @"公告公告公告公告公告公告公告公告公告公告公告";
        [lab sizeToFit];
        self.titleLab = lab;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.myHorzMargin = 0;
        button.myVertMargin = 0;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}
- (void)click:(UIButton *)btn{
    if (self.deleage && [self.deleage respondsToSelector:@selector(noticeSiteClick)]) {
        [self.deleage noticeSiteClick];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
