//
//  UCFPullDownButton.m
//  JRGC
//
//  Created by njw on 2017/1/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPullDownButton.h"

@implementation UCFPullDownButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor greenColor]];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width * 0.73, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 0.75, contentRect.size.height*0.34, contentRect.size.width* 0.25, contentRect.size.height*0.36);
}


@end
