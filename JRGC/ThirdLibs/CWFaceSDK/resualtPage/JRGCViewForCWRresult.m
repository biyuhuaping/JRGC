//
//  JRGCViewForCWRresult.m
//  JRGC
//
//  Created by 秦 on 16/3/22.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "JRGCViewForCWRresult.h"

@implementation JRGCViewForCWRresult

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
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"JRGCViewForCWRresult" owner:self options:nil] lastObject];
        [view setFrame:self.bounds];
        [self addSubview:view];
    }
    
        return self;
}

@end
