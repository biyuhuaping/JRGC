//
//  NewCalculator.m
//  JRGC
//
//  Created by 金融工场 on 15/12/21.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "NewCalculator.h"

@implementation NewCalculator
- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
        [self addGestureRecognizer:frade];
        [self makeView];
    }
    return self;
}

- (void)makeView
{
    
}
- (void)fadeKeyboard
{
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
